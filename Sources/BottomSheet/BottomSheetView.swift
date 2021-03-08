//
//  BottomSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

fileprivate struct BottomSheetView<hContent: View, mContent: View, bottomSheetPositionEnum: RawRepresentable>: View where bottomSheetPositionEnum.RawValue == CGFloat, bottomSheetPositionEnum: CaseIterable {
    
    @State private var translation: CGFloat = 0
    @Binding private var bottomSheetPosition: bottomSheetPositionEnum
    
    private let hasBottomPosition: Bool
    private let resizeable: Bool
    private let showCancelButton: Bool
    private let headerContent: hContent?
    private let mainContent: mContent
    private let closeAction: () -> ()
    
    private let allCases = bottomSheetPositionEnum.allCases.sorted(by: { $0.rawValue < $1.rawValue })
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if self.resizeable {
                    Capsule()
                        .fill(Color.tertiaryLabel)
                        .frame(width: 40, height: 6)
                        .padding(.top, 10)
                        .contentShape(Capsule())
                        .onTapGesture {
                            self.switchPositionIndicator()
                            
                            UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                        }
                }
                if self.headerContent != nil || self.showCancelButton {
                    HStack(alignment: .top, spacing: 0) {
                        if self.headerContent != nil {
                            self.headerContent!
                        }
                        
                        Spacer()
                        
                        if self.showCancelButton {
                            Button(action: {
                                if let hidden = bottomSheetPositionEnum(rawValue: 0) {
                                    self.bottomSheetPosition = hidden
                                }
                                
                                self.closeAction()
                                
                                UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.tertiaryLabel)
                            }
                            .font(.title)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if resizeable {
                                    self.translation = value.translation.height
                                    
                                    UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                                }
                            }
                            .onEnded { value in
                                if resizeable {
                                    let height: CGFloat = value.translation.height / geometry.size.height
                                    self.switchPosition(with: height)

                                    self.translation = 0
                                    
                                    UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                                }
                            }
                    )
                    .padding(.horizontal)
                    .padding(.top, self.resizeable ? 10 : 20)
                    .padding(.bottom, self.isBottomPosition() ? geometry.safeAreaInsets.bottom + 25 : 0)
                }
                
                self.mainContent
                    .transition(.move(edge: .bottom))
                    .animation(Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(
                EffectView(effect: UIBlurEffect(style: .systemMaterial))
                    .cornerRadius(10, corners: [.topRight, .topLeft])
                    .edgesIgnoringSafeArea(.bottom)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if resizeable {
                                    self.translation = value.translation.height
                                    
                                    UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                                }
                            }
                            .onEnded { value in
                                if resizeable {
                                    let height: CGFloat = value.translation.height / geometry.size.height
                                    self.switchPosition(with: height)

                                    self.translation = 0
                                    
                                    UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                                }
                            }
                    )
            )
            .frame(width: geometry.size.width, height: max((geometry.size.height * self.bottomSheetPosition.rawValue) - self.translation, 0), alignment: .top)
            .offset(y: self.bottomSheetPosition.rawValue == 0 ? geometry.size.height + geometry.safeAreaInsets.bottom : self.isBottomPosition() ? geometry.size.height - (geometry.size.height * self.bottomSheetPosition.rawValue) + self.translation + geometry.safeAreaInsets.bottom : geometry.size.height - (geometry.size.height * self.bottomSheetPosition.rawValue) + self.translation)
            .transition(.move(edge: .bottom))
            .animation(Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1))
        }
    }
    
    
    private func switchPositionIndicator() -> Void {
        if self.bottomSheetPosition.rawValue != 0 {
            
            if let currentIndex = self.allCases.firstIndex(where: { $0 == self.bottomSheetPosition }), self.allCases.count > 1 {
                if currentIndex == self.allCases.endIndex - 1 {
                    if self.allCases[currentIndex - 1].rawValue != 0 {
                        self.bottomSheetPosition = self.allCases[currentIndex - 1]
                    }
                } else {
                    self.bottomSheetPosition = self.allCases[currentIndex + 1]
                }
            }
        }
    }
    
    private func switchPosition(with height: CGFloat) -> Void {
        if self.bottomSheetPosition.rawValue != 0 {
            
            if let currentIndex = self.allCases.firstIndex(where: { $0 == self.bottomSheetPosition }), self.allCases.count > 1 {
                
                if height <= -0.1 && height > -0.3 {
                    if currentIndex < self.allCases.endIndex - 1 {
                        self.bottomSheetPosition = self.allCases[currentIndex + 1]
                    }
                } else if height <= -0.3 {
                    self.bottomSheetPosition = self.allCases[self.allCases.endIndex - 1]
                } else if height >= 0.1 && height < 0.3 {
                    if currentIndex > self.allCases.startIndex, self.allCases[currentIndex - 1].rawValue != 0 {
                        self.bottomSheetPosition = self.allCases[currentIndex - 1]
                    }
                } else if height >= 0.3 {
                    if self.allCases[self.allCases.startIndex].rawValue != 0 {
                        self.bottomSheetPosition = self.allCases[self.allCases.startIndex]
                    } else {
                        self.bottomSheetPosition = self.allCases[self.allCases.startIndex + 1]
                    }
                }
                
            }
        }
    }
    
    private func isBottomPosition() -> Bool {
        if self.hasBottomPosition, let bottomPositionRawValue = self.allCases.first(where: { $0.rawValue != 0})?.rawValue {
            return self.bottomSheetPosition.rawValue == bottomPositionRawValue
        } else {
            return false
        }
    }
    
    
    fileprivate init(bottomSheetPosition: Binding<bottomSheetPositionEnum>, hasBottomPosition: Bool = true, resizeable: Bool = true, showCancelButton: Bool = false, @ViewBuilder headerContent: () -> hContent?, @ViewBuilder mainContent: () -> mContent, closeAction: @escaping () -> () = {}) {
        self._bottomSheetPosition = bottomSheetPosition
        self.hasBottomPosition = hasBottomPosition
        self.resizeable = resizeable
        self.showCancelButton = showCancelButton
        self.headerContent = headerContent()
        self.mainContent = mainContent()
        self.closeAction = closeAction
    }
}

fileprivate extension BottomSheetView where hContent == ModifiedContent<ModifiedContent<Text, _EnvironmentKeyWritingModifier<Optional<Int>>>, _PaddingLayout> {
    init(bottomSheetPosition: Binding<bottomSheetPositionEnum>, hasBottomPosition: Bool = true, resizeable: Bool = true, showCancelButton: Bool = false, title: String? = nil, @ViewBuilder content: () -> mContent, closeAction: @escaping () -> () = {}) {
        if title == nil {
            self.init(bottomSheetPosition: bottomSheetPosition, hasBottomPosition: hasBottomPosition, resizeable: resizeable, showCancelButton: showCancelButton, headerContent: { return nil }, mainContent: content, closeAction: closeAction)
        } else {
            self.init(bottomSheetPosition: bottomSheetPosition, hasBottomPosition: hasBottomPosition, resizeable: resizeable, showCancelButton: showCancelButton, headerContent: { return Text(title!)
                        .font(.title).bold().lineLimit(1).padding(.bottom) as? hContent }, mainContent: content, closeAction: closeAction)
        }
    }
}

public extension View {
    func bottomSheet<hContent: View, mContent: View, bottomSheetPositionEnum: RawRepresentable>(bottomSheetPosition: Binding<bottomSheetPositionEnum>, hasBottomPosition: Bool = true, resizeable: Bool = true, showCancelButton: Bool = false, @ViewBuilder headerContent: () -> hContent?, @ViewBuilder mainContent: () -> mContent, closeAction: @escaping () -> () = {}) -> some View where bottomSheetPositionEnum.RawValue == CGFloat, bottomSheetPositionEnum: CaseIterable {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, hasBottomPosition: hasBottomPosition, resizeable: resizeable, showCancelButton: showCancelButton, headerContent: headerContent, mainContent: mainContent, closeAction: closeAction)
        }
    }
    
    func bottomSheet<mContent: View, bottomSheetPositionEnum: RawRepresentable>(bottomSheetPosition: Binding<bottomSheetPositionEnum>, hasBottomPosition: Bool = true, resizeable: Bool = true, showCancelButton: Bool = false, title: String? = nil, @ViewBuilder content: () -> mContent, closeAction: @escaping () -> () = {}) -> some View where bottomSheetPositionEnum.RawValue == CGFloat, bottomSheetPositionEnum: CaseIterable {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, hasBottomPosition: hasBottomPosition, resizeable: resizeable, showCancelButton: showCancelButton, title: title, content: content, closeAction: closeAction)
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
    }
    
    struct PreviewView: View {

        @State var bottomSheetPosition: BottomSheetPosition = .middle
        
        var body: some View {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, resizeable: true, showCancelButton: true, title: "nil", content: {
                    ScrollView {
                        ForEach(0..<150) { index in
                            Text(String(index))
                        }
                        .frame(maxWidth: .infinity)
                    }
                })
        }
    }
}

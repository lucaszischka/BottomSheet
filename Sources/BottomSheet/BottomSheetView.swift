//
//  BottomSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

internal struct BottomSheetView<hContent: View, mContent: View, bottomSheetPositionEnum: RawRepresentable>: View where bottomSheetPositionEnum.RawValue == CGFloat, bottomSheetPositionEnum: CaseIterable {
    
    @State private var translation: CGFloat = 0
    @Binding private var bottomSheetPosition: bottomSheetPositionEnum
    
    private let options: [BottomSheet.Options]
    private let headerContent: hContent?
    private let mainContent: mContent
    
    private let allCases = bottomSheetPositionEnum.allCases.sorted(by: { $0.rawValue < $1.rawValue })
    
    internal var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if !self.options.contains(BottomSheet.Options.notResizeable) && !self.options.contains(BottomSheet.Options.noDragIndicator) {
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
                if self.headerContent != nil || self.options.contains(BottomSheet.Options.showCloseButton()) {
                    HStack(alignment: .top, spacing: 0) {
                        if self.headerContent != nil {
                            self.headerContent!
                        }
                        
                        Spacer()
                        
                        if self.options.contains(BottomSheet.Options.showCloseButton()) {
                            Button(action: {
                                if let hidden = bottomSheetPositionEnum(rawValue: 0) {
                                    self.bottomSheetPosition = hidden
                                }
                                
                                self.options.forEach { item in
                                    switch item {
                                    case .showCloseButton(action: let closeAction):
                                        closeAction()
                                    default:
                                        return
                                    }
                                }
                                
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
                                if !self.options.contains(BottomSheet.Options.notResizeable) {
                                    self.translation = value.translation.height
                                    
                                    UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                                }
                            }
                            .onEnded { value in
                                if !self.options.contains(BottomSheet.Options.notResizeable) {
                                    let height: CGFloat = value.translation.height / geometry.size.height
                                    self.switchPosition(with: height)
                                    
                                    self.translation = 0
                                    
                                    UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                                }
                            }
                    )
                    .padding(.horizontal)
                    .padding(.top, !self.options.contains(BottomSheet.Options.notResizeable) ? 10 : 20)
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
                                if !self.options.contains(BottomSheet.Options.notResizeable) {
                                    self.translation = value.translation.height
                                    
                                    UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                                }
                            }
                            .onEnded { value in
                                if !self.options.contains(BottomSheet.Options.notResizeable) {
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
        if !self.options.contains(BottomSheet.Options.noBottomPosition), let bottomPositionRawValue = self.allCases.first(where: { $0.rawValue != 0})?.rawValue {
            return self.bottomSheetPosition.rawValue == bottomPositionRawValue
        } else {
            return false
        }
    }
    
    
    internal init(bottomSheetPosition: Binding<bottomSheetPositionEnum>, options: [BottomSheet.Options], @ViewBuilder headerContent: () -> hContent?, @ViewBuilder mainContent: () -> mContent) {
        self._bottomSheetPosition = bottomSheetPosition
        self.options = options
        self.headerContent = headerContent()
        self.mainContent = mainContent()
    }
}

internal extension BottomSheetView where hContent == ModifiedContent<ModifiedContent<Text, _EnvironmentKeyWritingModifier<Optional<Int>>>, _PaddingLayout> {
    init(bottomSheetPosition: Binding<bottomSheetPositionEnum>, options: [BottomSheet.Options], title: String? = nil, @ViewBuilder content: () -> mContent) {
        if title == nil {
            self.init(bottomSheetPosition: bottomSheetPosition, options: options, headerContent: { return nil }, mainContent: content)
        } else {
            self.init(bottomSheetPosition: bottomSheetPosition, options: options, headerContent: { return Text(title!)
                        .font(.title).bold().lineLimit(1).padding(.bottom) as? hContent }, mainContent: content)
        }
    }
}

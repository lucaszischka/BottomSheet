//
//  BottomSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

fileprivate struct BottomSheetView<hContent: View, mContent: View, bottomSheetPosition: BottomSheetPosition>: View {
    
    @State private var translation: CGFloat = 0
    @Binding private var bottomSheetPosition: bottomSheetPosition
    
    private let resizeable: Bool
    private let showCancelButton: Bool
    private let headerContent: hContent?
    private let mainContent: mContent
    private let closeAction: () -> ()
    
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
                            self.bottomSheetPosition.switchPositionIndicator()
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
                                self.closeAction()
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
                                }
                                        
                                UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                            }
                            .onEnded { value in
                                if resizeable {
                                    let height: CGFloat = value.translation.height / geometry.size.height
                                    self.bottomSheetPosition.switchPosition(with: height)

                                    self.translation = 0
                                }
                            }
                    )
                    .padding(.horizontal)
                    .padding(.top, self.resizeable ? 10 : 20)
                    .padding(.bottom, self.bottomSheetPosition.isBottom() ? geometry.safeAreaInsets.bottom + 25 : 0)
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
                                }
                                        
                                UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
                            }
                            .onEnded { value in
                                if resizeable {
                                    let height: CGFloat = value.translation.height / geometry.size.height
                                    self.bottomSheetPosition.switchPosition(with: height)
                                    
                                    self.translation = 0
                                }
                            }
                    )
            )
            .frame(width: geometry.size.width, height: max((geometry.size.height * self.bottomSheetPosition.bottomSheetPosition.rawValue) - self.translation, 0), alignment: .top)
            .offset(y: self.bottomSheetPosition.isHidden() ? geometry.size.height + geometry.safeAreaInsets.bottom : self.bottomSheetPosition.isBottom() ? geometry.size.height - (geometry.size.height * self.bottomSheetPosition.bottomSheetPosition.rawValue) + self.translation + geometry.safeAreaInsets.bottom : geometry.size.height - (geometry.size.height * self.bottomSheetPosition.bottomSheetPosition.rawValue) + self.translation)
            .transition(.move(edge: .bottom))
            .animation(Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1))
        }
    }
    
    
    fileprivate init(bottomSheetPosition: Binding<bottomSheetPosition>, resizeable: Bool = true, showCancelButton: Bool = false, @ViewBuilder headerContent: () -> hContent?, @ViewBuilder mainContent: () -> mContent, closeAction: @escaping () -> () = {}) {
        self._bottomSheetPosition = bottomSheetPosition
        self.resizeable = resizeable
        self.showCancelButton = showCancelButton
        self.headerContent = headerContent()
        self.mainContent = mainContent()
        self.closeAction = closeAction
    }
}

fileprivate extension BottomSheetView where hContent == ModifiedContent<ModifiedContent<Text, _EnvironmentKeyWritingModifier<Optional<Int>>>, _PaddingLayout> {
    init(bottomSheetPosition: Binding<bottomSheetPosition>, resizeable: Bool = true, showCancelButton: Bool = false, title: String? = nil, @ViewBuilder content: () -> mContent, closeAction: @escaping () -> () = {}) {
        if title == nil {
            self.init(bottomSheetPosition: bottomSheetPosition, resizeable: resizeable, showCancelButton: showCancelButton, headerContent: { return nil }, mainContent: content, closeAction: closeAction)
        } else {
            self.init(bottomSheetPosition: bottomSheetPosition, resizeable: resizeable, showCancelButton: showCancelButton, headerContent: { return Text(title!)
                        .font(.title).bold().lineLimit(1).padding(.bottom) as? hContent }, mainContent: content, closeAction: closeAction)
        }
    }
}

public extension View {
    func bottomSheet<hContent: View, mContent: View, bottomSheetPosition: BottomSheetPosition>(bottomSheetPosition: Binding<bottomSheetPosition>, resizeable: Bool = true, showCancelButton: Bool = false, @ViewBuilder headerContent: () -> hContent?, @ViewBuilder mainContent: () -> mContent, closeAction: @escaping () -> () = {}) -> some View {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, resizeable: resizeable, showCancelButton: showCancelButton, headerContent: headerContent, mainContent: mainContent, closeAction: closeAction)
        }
    }
    
    func bottomSheet<mContent: View, bottomSheetPosition: BottomSheetPosition>(bottomSheetPosition: Binding<bottomSheetPosition>, resizeable: Bool = true, showCancelButton: Bool = false, title: String? = nil, @ViewBuilder content: () -> mContent, closeAction: @escaping () -> () = {}) -> some View {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, resizeable: resizeable, showCancelButton: showCancelButton, title: title, content: content, closeAction: closeAction)
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
    }
    
    struct PreviewView: View {

        @State var bottomSheetPosition: HBMTBottomSheetPosition = HBMTBottomSheetPosition(bottomSheetPosition: .middle)
        
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

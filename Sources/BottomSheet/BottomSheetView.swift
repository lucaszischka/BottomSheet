//
//  BottomSheetView.swift
//
//  Created by Lucas Zischka.
//  Copyright © 2021 Lucas Zischka. All rights reserved.
//

import SwiftUI

fileprivate struct BottomSheetView<hContent: View, mContent: View>: View {
    
    @State private var translation: CGFloat = 0
    @Binding private var bottomSheetPosition: BottomSheetPosition
    
    private let resizeable: Bool
    private let showCancelButton: Bool
    private let headerContent: hContent?
    private let mainContent: mContent
    private let closeAction: () -> ()
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if self.resizeable {
                    Button(action: {
                        self.switchPositionIndicator()
                    }) {
                        Capsule()
                            .fill(Color.tertiaryLabel)
                            .frame(width: 40, height: 6)
                    }
                    .padding(.top, 10)
                    .contentShape(Capsule())
                }
                if self.headerContent != nil || self.showCancelButton {
                    HStack(spacing: 0) {
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
                    .padding(.horizontal)
                    .padding(.top, self.resizeable ? 10 : 20)
                }
                
                self.mainContent
            }
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
                            }
                            .onEnded { value in
                                if resizeable {
                                    if abs(self.translation) > geometry.size.height * 0.1 {
                                        if value.translation.height < 0 {
                                            self.switchPositionUp()
                                        } else if value.translation.height > 0 {
                                            self.switchPositionDown()
                                        }
                                    }
                                    
                                    self.translation = 0
                                }
                            }
                    )
            )
            .frame(width: geometry.size.width, height: max((geometry.size.height * self.bottomSheetPosition.rawValue) - self.translation, 0), alignment: .top)
            .offset(y: self.bottomSheetPosition == .hidden ? geometry.size.height + geometry.safeAreaInsets.bottom : geometry.size.height - (geometry.size.height * self.bottomSheetPosition.rawValue) + self.translation)
            .animation(.linear)
        }
    }
    
    
    private func switchPositionUp() {
        switch self.bottomSheetPosition {
        case .top:
            self.bottomSheetPosition = .top
        case .middle:
            self.bottomSheetPosition = .top
        case .bottom:
            self.bottomSheetPosition = .middle
        case .hidden:
            self.bottomSheetPosition = .hidden
        }
    }
    
    private func switchPositionDown() {
        switch self.bottomSheetPosition {
        case .top:
            self.bottomSheetPosition = .middle
        case .middle:
            self.bottomSheetPosition = .bottom
        case .bottom:
            self.bottomSheetPosition = .bottom
        case .hidden:
            self.bottomSheetPosition = .hidden
        }
    }
    
    private func switchPositionIndicator() {
        switch self.bottomSheetPosition {
        case .top:
            self.bottomSheetPosition = .middle
        case .middle:
            self.bottomSheetPosition = .top
        case .bottom:
            self.bottomSheetPosition = .middle
        case .hidden:
            self.bottomSheetPosition = .hidden
        }
    }
    
    
    fileprivate init(bottomSheetPosition: Binding<BottomSheetPosition>, resizeable: Bool = true, showCancelButton: Bool = false, @ViewBuilder headerContent: () -> hContent?, @ViewBuilder mainContent: () -> mContent, closeAction: @escaping () -> () = {}) {
        self._bottomSheetPosition = bottomSheetPosition
        self.resizeable = resizeable
        self.showCancelButton = showCancelButton
        self.headerContent = headerContent()
        self.mainContent = mainContent()
        self.closeAction = closeAction
    }
}

fileprivate extension BottomSheetView where hContent == ModifiedContent<Text, _EnvironmentKeyWritingModifier<Optional<Int>>> {
    init(bottomSheetPosition: Binding<BottomSheetPosition>, resizeable: Bool = true, showCancelButton: Bool = false, title: String? = nil, @ViewBuilder content: () -> mContent, closeAction: @escaping () -> () = {}) {
        if title == nil {
            self.init(bottomSheetPosition: bottomSheetPosition, resizeable: resizeable, showCancelButton: showCancelButton, headerContent: { return nil }, mainContent: content, closeAction: closeAction)
        } else {
            self.init(bottomSheetPosition: bottomSheetPosition, resizeable: resizeable, showCancelButton: showCancelButton, headerContent: { return Text(title!)
                        .font(.title).bold().lineLimit(1) as? hContent }, mainContent: content, closeAction: closeAction)
        }
    }
}

public extension View {
    func bottomSheet<hContent: View, mContent: View>(bottomSheetPosition: Binding<BottomSheetPosition>, resizeable: Bool = true, showCancelButton: Bool = false, @ViewBuilder headerContent: () -> hContent?, @ViewBuilder mainContent: () -> mContent, closeAction: @escaping () -> () = {}) -> some View {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, resizeable: resizeable, showCancelButton: showCancelButton, headerContent: headerContent, mainContent: mainContent, closeAction: closeAction)
        }
    }
    
    func bottomSheet<mContent: View>(bottomSheetPosition: Binding<BottomSheetPosition>, resizeable: Bool = true, showCancelButton: Bool = false, title: String? = nil, @ViewBuilder content: () -> mContent, closeAction: @escaping () -> () = {}) -> some View {
        ZStack {
            self
            BottomSheetView(bottomSheetPosition: bottomSheetPosition, resizeable: resizeable, showCancelButton: showCancelButton, title: title, content: content, closeAction: closeAction)
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Color.black
            .edgesIgnoringSafeArea(.all)
            .bottomSheet(bottomSheetPosition: .constant(.middle), resizeable: true, showCancelButton: true, title: "nil", content: {
                ScrollView {
                    ForEach(0..<150) { index in
                        Text(String(index))
                    }
                    .frame(maxWidth: .infinity)
                }
            })
    }
}

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
    
    private var capsuleColor: Color {
        var capsuleColor = Color.tertiaryLabel
        
        if self.options.dragIndicatorColor {
            self.options.forEach { item in
                switch item {
                case .dragIndicatorColor(let color):
                    capsuleColor = color
                default:
                    return
                }
            }
        }
        
        return capsuleColor
    }
    
    internal var body: some View {
        GeometryReader { geometry in
            if (self.options.backgroundBlur || self.options.tapToDismiss) && !self.isHiddenPosition() {
                EffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                    .opacity(self.options.backgroundBlur ? Double((self.bottomSheetPosition.rawValue * geometry.size.height - self.translation) / geometry.size.height) : 0)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .transition(.opacity)
                    .animation(.linear)
                    .onTapGesture(perform: self.tapToDismiss)
            }
            VStack(spacing: 0) {
                if !self.options.notResizeable && !self.options.noDragIndicator {
                    Button(action: self.switchPositionIndicator, label: {
                        Capsule()
                            .fill(self.capsuleColor)
                            .frame(width: 40, height: 6)
                            .padding(.top, 10)
                            .padding(.bottom, !self.options.notResizeable && !self.options.noDragIndicator ? 10 : 20)
                    })
                }
                if self.headerContent != nil || self.options.showCloseButton {
                    HStack(alignment: .top, spacing: 0) {
                        if self.headerContent != nil {
                            self.headerContent!
                        }
                        
                        Spacer(minLength: 0)
                        
                        if self.options.showCloseButton {
                            Button(action: closeButton) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.tertiaryLabel)
                            }
                            .font(.title)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if !self.options.notResizeable {
                                    self.translation = value.translation.height
                                    
                                    self.endEditing()
                                }
                            }
                            .onEnded { value in
                                if !self.options.notResizeable {
                                    let height: CGFloat = value.translation.height / geometry.size.height
                                    self.switchPosition(with: height)
                                }
                            }
                    )
                    .padding(.horizontal)
                    .padding(.bottom, self.isBottomPosition() ? geometry.safeAreaInsets.bottom + 25 : self.headerContent == nil ? 20 : 0)
                }
                
                self.mainContent
                    .transition(.move(edge: .bottom))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(
                EffectView(effect: UIBlurEffect(style: .systemMaterial))
                    .cornerRadius(15, corners: [.topRight, .topLeft])
                    .edgesIgnoringSafeArea(.bottom)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if !self.options.notResizeable {
                                    self.translation = value.translation.height
                                    
                                    self.endEditing()
                                }
                            }
                            .onEnded { value in
                                if !self.options.notResizeable {
                                    let height: CGFloat = value.translation.height / geometry.size.height
                                    self.switchPosition(with: height)
                                }
                            }
                    )
            )
            .frame(width: geometry.size.width, height: max((geometry.size.height * self.bottomSheetPosition.rawValue) - self.translation, 0), alignment: .top)
            .offset(y: self.isHiddenPosition() ? geometry.size.height + geometry.safeAreaInsets.bottom : self.isBottomPosition() ? geometry.size.height - (geometry.size.height * self.bottomSheetPosition.rawValue) + self.translation + geometry.safeAreaInsets.bottom : geometry.size.height - (geometry.size.height * self.bottomSheetPosition.rawValue) + self.translation)
            .transition(.move(edge: .bottom))
            .animation(Animation.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 1))
        }
    }
    
    private func endEditing() -> Void {
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.endEditing(true)
    }
    
    private func tapToDismiss() -> Void {
        if self.options.tapToDismiss {
            self.closeSheet()
        }
    }
    
    private func closeButton() -> Void {
        self.options.closeAction()
        
        self.closeSheet()
    }
    
    private func closeSheet() -> Void {
        if let hidden = bottomSheetPositionEnum(rawValue: 0) {
            self.bottomSheetPosition = hidden
        }
        
        self.endEditing()
    }
    
    private func switchPositionIndicator() -> Void {
        if !self.isHiddenPosition() {
            
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
        
        self.endEditing()
    }
    
    private func switchPosition(with height: CGFloat) -> Void {
        if !self.isHiddenPosition() {
            
            if let currentIndex = self.allCases.firstIndex(where: { $0 == self.bottomSheetPosition }), self.allCases.count > 1 {
                
                if height <= -0.1 && height > -0.3 {
                    if currentIndex < self.allCases.endIndex - 1 {
                        self.bottomSheetPosition = self.allCases[currentIndex + 1]
                    }
                } else if height <= -0.3 {
                    self.bottomSheetPosition = self.allCases[self.allCases.endIndex - 1]
                } else if height >= 0.1 && height < 0.3 {
                    if currentIndex > self.allCases.startIndex && (self.allCases[currentIndex - 1].rawValue != 0 || (self.allCases[currentIndex - 1].rawValue == 0 && self.options.swipeToDismiss))  {
                        self.bottomSheetPosition = self.allCases[currentIndex - 1]
                    }
                } else if height >= 0.3 {
                    if (self.allCases[self.allCases.startIndex].rawValue == 0 && self.options.swipeToDismiss) || self.allCases[self.allCases.startIndex].rawValue != 0 {
                        self.bottomSheetPosition = self.allCases[self.allCases.startIndex]
                    } else {
                        self.bottomSheetPosition = self.allCases[self.allCases.startIndex + 1]
                    }
                }
                
            }
        }
        
        self.translation = 0
        self.endEditing()
    }
    
    private func isHiddenPosition() -> Bool {
        return self.bottomSheetPosition.rawValue == 0
    }
    
    private func isBottomPosition() -> Bool {
        if !self.options.noBottomPosition, let bottomPositionRawValue = self.allCases.first(where: { $0.rawValue != 0})?.rawValue {
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
    init(bottomSheetPosition: Binding<bottomSheetPositionEnum>, options: [BottomSheet.Options], title: String?, @ViewBuilder content: () -> mContent) {
        if title == nil {
            self.init(bottomSheetPosition: bottomSheetPosition, options: options, headerContent: { return nil }, mainContent: content)
        } else {
            self.init(bottomSheetPosition: bottomSheetPosition, options: options, headerContent: { return Text(title!)
                        .font(.title).bold().lineLimit(1).padding(.bottom) as? hContent }, mainContent: content)
        }
    }
}

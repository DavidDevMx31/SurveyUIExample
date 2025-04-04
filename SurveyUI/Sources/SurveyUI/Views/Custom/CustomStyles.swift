//
//  CustomStyles.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import SwiftUI

//MARK: TextField styles
struct OutlinedTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay(content: {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.gray, lineWidth: 2)
            })
    }
    
}

struct RoundedTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical)
            .padding(.horizontal, 12)
            .background(Color(uiColor: UIColor.systemGray6))
            .clipShape(Capsule(style: .continuous))
    }
}

//MARK: View modifiers
struct RoundedBorder: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .overlay(content: {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.gray, lineWidth: 2)
                    .padding(.horizontal, 4)
            })
    }
}

struct KeyboardToolbar: ViewModifier {
    
    let leftButtonTitle: String
    let rightButtonTitle: String
    
    let leftButtonAction: () -> ()
    let rightButtonAction: () -> ()
    
    func body(content: Content) -> some View {
        return content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(leftButtonTitle) {
                        leftButtonAction()
                    }
                    
                    Spacer()
                    
                    Button(rightButtonTitle) {
                        rightButtonAction()
                    }
                }
            }
    }
}

struct HideBackgroundModifier<Background>: ViewModifier where Background: View {
    private let newBackground: Background
    
    init(newBackground: Background) {
        self.newBackground = newBackground
    }
    
    @ViewBuilder func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
                .background(newBackground)
        } else {
            content
        }
    }
}

//MARK: View extensions
extension View {
    
    func roundedBorderStyle() -> some View {
        modifier(RoundedBorder())
    }
    
    func keyboardToolbar(leftButtonTitle: String,
                         rightButtonTitle: String,
                         leftButtonAction: @escaping () -> Void,
                         rightButtonAction: @escaping () -> Void) -> some View {
        modifier(KeyboardToolbar(leftButtonTitle: leftButtonTitle,
                                 rightButtonTitle: rightButtonTitle,
                                 leftButtonAction: leftButtonAction,
                                 rightButtonAction: rightButtonAction))
    }
    
    func setBackground<Background>(_ background: Background) -> some View where Background: View {
        modifier(HideBackgroundModifier(newBackground: background))
    }
}

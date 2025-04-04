//
//  CommentTextField.swift
//  
//
//  Created by David Ali on 03/04/25.
//

import SwiftUI
import Combine

struct CommentTextField: View {
    let placeholder: String
    @Binding var commentText: String
    
    private let maxChars: Int = 100
    private var remainingChars: Int {
        return maxChars - commentText.count
    }
    
    private var remainingCharTextColor: Color {
        if remainingChars > 20 { return Color(uiColor: UIColor.systemGray3) }
        else if remainingChars <= 20 && remainingChars >= 10 { return Color.yellow }
        else { return Color.red}
    }
    
    let onSubmitHandler: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            TextField(placeholder, text: $commentText)
                .frame(minHeight: 40)
                .padding(.horizontal, 8)
                .textFieldStyle(OutlinedTextFieldStyle())
                .font(SurveyThemeManager.shared.bodyFont)
                .onReceive(Just(commentText)) { _ in limitText(maxChars) }
                .onSubmit {
                    onSubmitHandler()
                }
            
            Text("\(remainingChars)/\(maxChars)")
                .font(.callout)
                .foregroundColor(remainingCharTextColor)
        }
    }
    
    private func limitText(_ limit: Int) {
        if commentText.count > limit {
            commentText = String(commentText.prefix(limit))
        }
    }

}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CommentTextField(placeholder: "Ejemplo", commentText: .constant("")) { debugPrint(("onSubmit"))
        }
    }
}

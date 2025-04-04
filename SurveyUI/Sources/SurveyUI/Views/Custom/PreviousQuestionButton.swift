//
//  BackButton.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import SwiftUI

struct PreviousQuestionButton: View {
    @Environment(\.isEnabled) var isEnabled
    var onTappedCompletion: (() -> Void)
    
    init(_ onTappedCompletion: @escaping () -> Void) {
        self.onTappedCompletion = onTappedCompletion
    }
    
    var body: some View {
        Button {
            onTappedCompletion()
        } label: {
            Label("Atrás", systemImage: "arrow.left.circle")
                .foregroundColor(isEnabled ? Color.blue : Color(uiColor: UIColor.systemGray5))
        }
    }
    
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        PreviousQuestionButton(){ debugPrint("Tapped back button")}
    }
}

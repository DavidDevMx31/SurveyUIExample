//
//  NextQuestionButton.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import SwiftUI

struct NextQuestionButton: View {
    @Environment(\.isEnabled) var isEnabled
        
    private var onTappedCompletion: () -> Void
    
    init(_ onTappedCompletion: @escaping () -> Void) {
        self.onTappedCompletion = onTappedCompletion
    }
    
    var body: some View {
        Button {
            onTappedCompletion()
        }
        label: {
            Label("Continuar",
                  systemImage: "arrow.right.circle")
            .foregroundColor(isEnabled ? Color.blue : Color(uiColor: UIColor.systemGray5))
        }
    }
}

struct NextQuestionButton_Previews: PreviewProvider {
    static var previews: some View {
        NextQuestionButton { debugPrint("Tapped NextQuestionButton") }
    }
}

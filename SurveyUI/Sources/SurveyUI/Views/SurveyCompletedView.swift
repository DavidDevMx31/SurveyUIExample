//
//  SurveyCompletedView.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import SwiftUI

struct SurveyCompletedView: View {
    let acknowledgments: AttributedString
    var onFinishTapped: () -> Void
    
    init(acknowledgments: AttributedString, _ completion: @escaping () -> Void) {
        self.acknowledgments = acknowledgments
        self.onFinishTapped = completion
    }
    
    var body: some View {
        Group {
            Text(acknowledgments)
                .font(SurveyThemeManager.shared.surveyIntroFont)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .transition(.slide)
            
            Button {
                onFinishTapped()
            } label: {
                Label("Terminar", systemImage: "checkmark.circle")
                    .foregroundColor(Color.blue)
            }
            //.padding(.vertical, 36)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}


struct SurveyCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyCompletedView(acknowledgments: "Ejemplo") { debugPrint("Completed survey tapped") }
    }
}

//
//  SurveyFooterView.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import SwiftUI

struct SurveyFooterView: View {
    @ObservedObject var viewModel: SurveyViewModel
    
    private var disableNextButton: Bool {
        guard let selectedOptions = viewModel.currentResponse.selectedOptionsId,
              !selectedOptions.isEmpty else {
            return true
        }

        if let allowsTextOption = viewModel.currentQuestion.allowTextOption {
            if selectedOptions.contains(allowsTextOption.id) {
                guard let comment = viewModel.currentResponse.comments,
                      !comment.isEmpty else {
                    return true
                }
            } //else { return true }
        }
        
        return false
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 96) {
            PreviousQuestionButton {
                viewModel.previousQuestion()
            }
            .disabled(viewModel.currentQuestionIndex == 0)
            
            NextQuestionButton {
                viewModel.nextQuestion()
            }
            .disabled(disableNextButton)
            
        }
        .padding(.vertical, 16)
    }
}

/*
struct SurveyFooterView_Previews: PreviewProvider {
    
    static var previews: some View {
        SurveyFooterView(viewModel: <#T##SurveyViewModel#>)
    }
}
*/

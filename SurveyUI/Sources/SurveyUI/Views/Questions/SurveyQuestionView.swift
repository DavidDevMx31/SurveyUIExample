//
//  SurveyQuestionView.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import SwiftUI

struct SurveyQuestionView: View {
    @ObservedObject var viewModel: SurveyViewModel
    
    var body: some View {
        ScrollView {
            Text(viewModel.currentQuestion.prompt)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .font(SurveyThemeManager.shared.questionFont)
                .padding(.vertical, 24)
                .padding(.horizontal, 8)
                .animation(.linear, value: viewModel.currentQuestionIndex)
            
            switch viewModel.currentQuestion.type {
            case .singleSelection(options: _):
                SingleSelectionQuestionView(viewModel: viewModel)
            case .multipleSelection(options: _):
                MultipleSelectionQuestionView(viewModel: viewModel)
            case .open(placeholder: let placeholder):
                OpenQuestionView(placeholder: placeholder, viewModel: viewModel)
            }
        
        }
        .animation(.default, value: viewModel.currentQuestionIndex)
    }
}

/*
struct SurveyQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyQuestionView(viewModel: _)
    }
}
*/

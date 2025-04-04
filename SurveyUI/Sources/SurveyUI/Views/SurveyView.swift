//
//  SurveyView.swift
//  
//
//  Created by David Ali on 21/03/25.
//

import SwiftUI

public struct SurveyView: View {
    @StateObject private var viewModel: SurveyViewModel
    private var onCompletedSurvey: (SurveyResult) -> Void
    
    public init(survey: Survey,
                onCompleted: @escaping (SurveyResult)->Void) {
        _viewModel = StateObject(wrappedValue: SurveyViewModel(survey: survey))
        self.onCompletedSurvey = onCompleted
    }
    
    public var body: some View {
        
        VStack(alignment: .center, spacing: 24) {
            if viewModel.surveyCompleted {
                
                SurveyCompletedView(acknowledgments: viewModel.survey.acknowledgments) {
                    let results = viewModel.getSurveyResults()
                    onCompletedSurvey(results)
                }
                //.animation(.easeIn, value: viewModel.surveyCompleted)
                
            } else {
                SurveyHeaderView(currentQuestion: viewModel.currentQuestionIndex + 1, totalQuestions: viewModel.survey.questions.count)
                    .animation(.linear, value: viewModel.currentQuestionIndex)
                
                if viewModel.currentQuestionIndex == 0 {
                    SurveyIntroView(introText: viewModel.survey.intro)
                }
                
                SurveyQuestionView(viewModel: viewModel)
                    .alert(isPresented: viewModel.foundError, error: viewModel.errorDetails, actions: { _ in
                        Text("Ok")
                    }, message: { error in
                        Text(error.recoverySuggestion ?? "")
                    })
                
                SurveyFooterView(viewModel: viewModel)
            }
            
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .foregroundColor(SurveyThemeManager.shared.foregroundColor)
        .background {
            if SurveyThemeManager.shared.backgroundColor == nil {
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
            } else {
                SurveyThemeManager.shared.backgroundColor
                    .edgesIgnoringSafeArea(.all)
            }
        }
        
    }
    
}

struct SurveyHeaderView: View {
    let currentQuestion: Int
    let totalQuestions: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Divider()
                .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                
            
            Text("Pregunta \(currentQuestion) de \(totalQuestions)")
                .lineLimit(1)
                .layoutPriority(1)
                .animation(.default, value: currentQuestion)
            
            Divider()
                .stroke(.gray, style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
        .frame(height: 40)
        .font(SurveyThemeManager.shared.calloutFont)
        .padding(.horizontal)
    }
    
}

struct SurveyIntroView: View {
    let introText: AttributedString
    
    var body: some View {
        Text(introText)
            .layoutPriority(1)
            .font(SurveyThemeManager.shared.surveyIntroFont)
            .lineLimit(nil)
            .multilineTextAlignment(.center)
    }
}

/*
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
*/

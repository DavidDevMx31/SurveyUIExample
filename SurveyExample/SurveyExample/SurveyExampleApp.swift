//
//  SurveyExampleApp.swift
//  SurveyExample
//
//  Created by David Ali on 05/03/25.
//

import SwiftUI
import SurveyUI

@main
struct SurveyExampleApp: App {
    let userSurvey = SurveyFactory.getSurveyExample() //Container.createSurvey()
    
    init() {
        //configureCustomTheme()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(survey: userSurvey)
        }
    }
    
    private func configureCustomTheme() {
        SurveyThemeManager.shared = MyAppTheme()
    }
}

struct Container {
    static func createSurvey() -> Survey {
        let questionOneOptions: [QuestionOption] = [
            QuestionOption(id: "option1-a", description: "No Poseo Idea"),
            QuestionOption(id: "option1-b", description: "Washa washeo"),
            QuestionOption(id: "option1-c", description: "Me defiendo"),
            QuestionOption(id: "option1-d", description: "La duda ofende, papi")
        ]
        let questionType = QuestionType.singleSelection(options: questionOneOptions)
        
        guard let questionOne = SurveyFactory.createQuestion(withId: "question-1", prompt: "¿Cuál es tu nivel actual de inglés?", type: questionType) else { fatalError() }
        
        let survey = SurveyFactory.createSurvey(withId: "survey-1", prompt: "Esta es una encuesta de usuario muy importante", questions: [questionOne], acknowledgments: "¡Gracias por tus comentarios!")
        return survey
    }
}

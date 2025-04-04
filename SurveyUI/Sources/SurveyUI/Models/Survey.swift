//
//  Question.swift
//  
//
//  Created by David Ali on 06/03/25.
//

import Foundation

public enum QuestionError: Error {
    case tooManyOptionsAllowText
}

public enum QuestionType {
    case singleSelection(options: [QuestionOption])
    case multipleSelection(options: [QuestionOption])
    case open(placeholder: String)
}

public struct Survey: Identifiable {
    public var id: String
    var intro: AttributedString
    var acknowledgments: AttributedString
    var questions: [Question]
    
    init(id: String, intro: String, questions: [Question], acknowledgments: String) {
        self.id = id
        self.intro = AttributedString(intro)
        self.questions = questions
        self.acknowledgments = AttributedString(acknowledgments)
    }
    
    init(id: String, intro: AttributedString, questions: [Question], acknowledgments: AttributedString) {
        self.id = id
        self.intro = intro
        self.questions = questions
        self.acknowledgments = acknowledgments
    }
}

public struct Question: Identifiable {
    public let id: String
    let prompt: String
    let options: [QuestionOption]
    var type: QuestionType
    
    init?(id: ID, prompt: String, type: QuestionType) {
        self.id = id
        self.prompt = prompt
        self.type = type
        
        /*
        if case let QuestionType.singleSelection(options) = type {
            let allowsTextOptions = options.filter { $0.allowsText == true }
            if allowsTextOptions.count > 1 { throw QuestionError.tooManyAllowsTextOptions }
        }
         */
        
        switch type {
        case .multipleSelection(let associatedOptions),
                .singleSelection(options: let associatedOptions):
            
            let allowsTextOptions = associatedOptions.filter { $0.allowsText == true }
            if allowsTextOptions.count > 1 { return nil }
            
            self.options = associatedOptions
        default:
            self.options = []
        }
    }
    
    var allowTextOption: QuestionOption? {
        options.first(where: { $0.allowsText == true })
    }
}

public struct QuestionOption: Identifiable {
    public let id: String
    let description: String
    let allowsText: Bool
    
    public init(id: String, description: String, allowsText: Bool = false) {
        self.id = id
        self.description = description
        self.allowsText = allowsText
    }
}

public struct SurveyFactory {
    
    public static func getSurveyExample() -> Survey {
        let questionOneOptions = [
            QuestionOption(id: "1", description: "Principiante"),
            QuestionOption(id: "2", description: "Básico"),
            QuestionOption(id: "3", description: "Intermedio"),
            QuestionOption(id: "4", description: "Avanzado")
        ]
        
        let questionTwoOptions = [
            QuestionOption(id: "5", description: "Comenzar mi aprendizaje"),
            QuestionOption(id: "6", description: "Incrementar mi vocabulario"),
            QuestionOption(id: "7", description: "Perfeccionar mi inglés"),
            //QuestionOption(id: "8", description: "Practicar y mantener mi nivel")
            QuestionOption(id: "8", description: "Otro", allowsText: true)
        ]
        
        let questionThreeOptions = [
            QuestionOption(id: "9", description: "Académico"),
            QuestionOption(id: "10", description: "Trabajo o negocios"),
            QuestionOption(id: "11", description: "Conversación informal"),
            QuestionOption(id: "13", description: "Otro", allowsText: true)
        ]
        
        do {
            
        }
        let questions = [Question(id: "1", prompt: "¿Cuál es tu nivel actual de inglés?",
                                  type: .singleSelection(options: questionOneOptions)),
                         Question(id: "2", prompt: "¿Cuál es tu objetivo al usar la aplicación?",
                                                   type: .singleSelection(options: questionTwoOptions)),
                         Question(id: "3", prompt: "¿En qué contexto utilizas el inglés?",
                                                   type: .multipleSelection(options: questionThreeOptions)),
                         
                         ]
        
        let markdownIntro: AttributedString = try! AttributedString(
            markdown: "**¡Nos importa tu opinión!**\n\nAyúdanos a crear una mejor app para ti."
            , options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )
        
        let acknowledgments: AttributedString = try! AttributedString(
            markdown: "**¡Gracias por tus comentarios!**\n\nCon ellos podremos crear una mejor aplicación para ti."
            , options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )
        
        return Survey(id: UUID().uuidString, intro: markdownIntro,
                      questions: questions.compactMap({ $0 }), acknowledgments: acknowledgments)
    }
    
    public static func createQuestion(withId questionId: String, prompt: String,
                                      type: QuestionType) -> Question? {
        Question(id: questionId, prompt: prompt, type: type)
    }
    
    public static func createSurvey(withId surveyId: String, prompt: String,
                                    questions: [Question], acknowledgments: String) -> Survey {
        Survey(id: surveyId, intro: prompt, questions: questions, acknowledgments: acknowledgments)
    }
    
    //MARK: To-do, add a simple way to create questions
}


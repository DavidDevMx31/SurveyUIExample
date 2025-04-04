//
//  SurveyViewModelProtocols.swift
//  
//
//  Created by David Ali on 10/03/25.
//

import Foundation

protocol SurveyVMProtocol: ObservableObject {
    var currentQuestionIndex: Int { get }
    var currentQuestion: Question { get }
    var responses: [String:QuestionResult] { get }
    var currentResponse: QuestionResult { get }
    var errorDetails: SurveyError? { get }
}

protocol SingleSelectionVMProtocol: SurveyVMProtocol {
    func selectOption(_ id: String)
    func addComment(_ comment: String)
}

protocol MultipleSelectionVMProtocol: SurveyVMProtocol {
    func toogleOption(_ id: String)
    func appendComment(_ comment: String)
}

protocol OpenQuestionVMProtocol: SurveyVMProtocol {
    func saveUserComment(_ comment: String)
}

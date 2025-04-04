//
//  SurveyResult.swift
//  
//
//  Created by David Ali on 10/03/25.
//

import Foundation

//MARK: Respuestas
public struct SurveyResult {
    let surveyId: String
    var answers: [QuestionResult]
    
    init(surveyId: String, answers: [QuestionResult]) {
        self.surveyId = surveyId
        self.answers = answers
    }
}

public struct QuestionResult {
    let questionId: String
    var selectedOptionsId: [String]?
    var comments: String?
    
    internal init(questionId: String) {
        self.questionId = questionId
        self.selectedOptionsId = nil
        self.comments = nil
    }
    
    internal init(questionId: String, selectedId: String) {
        self.questionId = questionId
        self.selectedOptionsId = [selectedId]
        self.comments = nil
    }
    
    internal init(questionId: String, comment: String) {
        self.questionId = questionId
        self.selectedOptionsId = nil
        self.comments = comment
    }
    
    internal mutating func setResponse(selectedOptionsId: [String]?, comments: String?) {
        self.selectedOptionsId = selectedOptionsId
        self.comments = comments
        debugPrint(self)
    }
}

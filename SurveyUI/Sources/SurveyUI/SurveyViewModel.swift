//
//  SurveyViewModel.swift
//  
//
//  Created by David Ali on 08/03/25.
//

import SwiftUI

// ObservableObject para manejar el estado de la encuesta
class SurveyViewModel: ObservableObject {
    @Published var currentQuestionIndex: Int = 0
    @Published var currentResponse = QuestionResult(questionId: "")
    @Published var surveyCompleted = false
    @Published private(set) var errorDetails: SurveyError?
    
    let survey: Survey
    var responses: [String:QuestionResult] = [:]
    var currentQuestion: Question {
        survey.questions[currentQuestionIndex]
    }
    
    var foundError: Binding<Bool> {
        return Binding<Bool>(
            get: { return self.errorDetails != nil},
            set: { newValue in guard !newValue else { return }
                self.errorDetails = nil
            }
        )
    }
    
    init(survey: Survey) {
        self.survey = survey
        survey.questions.forEach { question in
            responses[question.id] = QuestionResult(questionId: question.id)
        }
    }
    
    func nextQuestion() {
        if let error = validateCurrentResponse() {
            errorDetails = error
            return
        }
        
        guard currentQuestionIndex < survey.questions.count - 1 else {
            surveyCompleted = true
            return
        }
        
        errorDetails = nil
        currentQuestionIndex += 1
        currentResponse = responses[currentQuestion.id] ?? QuestionResult(questionId: currentQuestion.id)
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
        currentResponse = responses[currentQuestion.id] ?? QuestionResult(questionId: currentQuestion.id)
    }
    
    func getSurveyResults() -> SurveyResult {
        SurveyResult(surveyId: survey.id, answers: Array(responses.values))
    }
    
    private func validateCurrentResponse() -> SurveyError? {
        guard let selectedOptions = currentResponse.selectedOptionsId,
              !selectedOptions.isEmpty else { return SurveyError.noSelection }
        
        if let textOption = currentQuestion.allowTextOption {
            if selectedOptions.contains(textOption.id) {
                guard let comments = currentResponse.comments,
                      !comments.isEmpty else { return SurveyError.textIsEmpty }
            }
        }
        
        return nil
    }
    
    private func limitComment(_ comment: String, maxChars: Int = 100) -> String {
        String(comment.trimmingCharacters(in: .whitespacesAndNewlines).prefix(100))
    }
}

extension SurveyViewModel: SingleSelectionVMProtocol {
    func selectOption(_ id: String) {
        let newResponse = QuestionResult(questionId: currentQuestion.id, selectedId: id)
        responses[currentQuestion.id] = newResponse
        currentResponse = newResponse
    }
    
    func addComment(_ comment: String) {
        guard let allowsTextOption = currentQuestion.allowTextOption else {
            return
        }
        
        let userComment = limitComment(comment)
        guard !userComment.isEmpty else {
            errorDetails = SurveyError.textIsEmpty
            return
        }

        var newResponse = QuestionResult(questionId: currentQuestion.id)
        if let selectedOptions = currentResponse.selectedOptionsId {
            if selectedOptions.contains(allowsTextOption.id) {
                newResponse.setResponse(selectedOptionsId: selectedOptions, comments: userComment)
                responses[currentQuestion.id] = newResponse
                currentResponse = newResponse
            }
        }
    }
    
}

extension SurveyViewModel: MultipleSelectionVMProtocol {

    func toogleOption(_ id: String) {
        guard let response = responses[currentQuestion.id] else { return }
        
        guard let selectedOptions = response.selectedOptionsId else {
            let result = QuestionResult(questionId: currentQuestion.id, selectedId: id)
            responses[currentQuestion.id] = result
            currentResponse = result
            return
        }
        
        var shouldDeleteComment = false
        var newResponse = QuestionResult(questionId: currentQuestion.id)
        var selectedIds = selectedOptions
        
        if selectedOptions.contains(id) {
            //Checar si es la opcion que permite comentarios
            if let allowsTextOption = currentQuestion.options.first(where: { $0.allowsText == true }) {
                if allowsTextOption.id == id {
                    //Eliminar tambien el comentario
                    shouldDeleteComment = true
                }
            }
            //Quitarlo porque lo deselecciono
            selectedIds = selectedOptions.filter { $0 != id }
        } else {
            //Agregarlo
            selectedIds.append(id)
        }
        
        newResponse.setResponse(selectedOptionsId: selectedIds, comments: shouldDeleteComment ? nil : currentResponse.comments)
        responses[currentQuestion.id] = newResponse
        currentResponse = newResponse
    }
    
    func appendComment(_ comment: String) {
        guard let allowsTextOption = currentQuestion.allowTextOption else {
            return
        }
        
        let userComment = limitComment(comment)
        guard !userComment.isEmpty else {
            //Error: el comentario es requerido
            errorDetails = SurveyError.textIsEmpty
            return
        }

        var newResponse = QuestionResult(questionId: currentQuestion.id)
        if let selectedOptions = currentResponse.selectedOptionsId {
            if selectedOptions.contains(allowsTextOption.id) {
                newResponse.setResponse(selectedOptionsId: selectedOptions, comments: userComment)
                responses[currentQuestion.id] = newResponse
                currentResponse = newResponse
            }
        }
    }
    
}

extension SurveyViewModel: OpenQuestionVMProtocol {
    
    func saveUserComment(_ comment: String) {
        let result = QuestionResult(questionId: currentQuestion.id, comment: comment)
        responses[currentQuestion.id] = result
        currentResponse = result
    }
    
}

/*
extension SurveyViewModel {
    
    @ViewBuilder
    func questionView(for question: Question) -> some View {
        switch question.type {
        case .multipleOption(let options):
            MultipleOptionQuestionView(options: options)
        //case .multipleSelection(let options):
            //MultipleSelectionQuestionView(options: options)
        case .openText(let placeholder):
            OpenQuestionView(placeholder: placeholder)
        }
    }
    
}
*/

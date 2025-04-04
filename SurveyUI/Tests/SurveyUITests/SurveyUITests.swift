import XCTest
@testable import SurveyUI

final class SurveyUITests: XCTestCase {
    
    func test_surveyViewModelInit() {
        let surveyStub = SurveyFactory.getSurveyExample()
        let sut = SurveyViewModel(survey: surveyStub)
        
        XCTAssertEqual(surveyStub.id, sut.survey.id)
    }
    
    func test_surveyViewModelInitialState() {
        let stub = SurveyFactory.getSurveyExample()
        let sut = SurveyViewModel(survey: SurveyFactory.getSurveyExample())
        
        XCTAssertEqual(sut.responses.count, stub.questions.count,
                       "Responses count must be equal to \(stub.questions.count)")
        XCTAssertEqual(sut.currentQuestionIndex, 0, "currentQuestionIndex must be 0 on initialization")
    }
    
    func test_surveyViewModel_initsOneResponsePerQuestion() {
        let stub = SurveyFactory.getSurveyExample()
        let sut = SurveyViewModel(survey: SurveyFactory.getSurveyExample())
        
        for question in stub.questions {
            let record = sut.responses.first(where: { $0.key == question.id })
            XCTAssertNotNil(record, "There is no key with id \(question.id)")
        }
    }
    
    func test_surveyViewModel_initsEmptyCurrentResponse() {
        let sut = SurveyViewModel(survey: SurveyFactory.getSurveyExample())
        
        XCTAssertTrue(sut.currentResponse.questionId.isEmpty,
                      "CurrentResponse questionI must be empty on initialization")
        XCTAssertNil(sut.currentResponse.selectedOptionsId,
                     "CurrentResponse selectedOptionsId must be nil on initialization")
        XCTAssertNil(sut.currentResponse.comments,
                     "CurrentResponse comments must be nil on initialization")
    }
    
    func test_surveyViewModel_saveSelectedIdForQuestion() {
        let stub = SurveyFactory.getSurveyExample()
        let sut = SurveyViewModel(survey: stub)
        
        let firstQuestion = stub.questions.first!
        let selectedId = firstQuestion.options.first!.id
        
        sut.selectOption(selectedId)
        
        let result = sut.responses[firstQuestion.id]!
        
        XCTAssertNotNil(result, "Result must not be nil")
        XCTAssertEqual(result.selectedOptionsId?.count, 1,
                       "SelectedOptionsId count must be equal to 1")
    }
    
    func test_surveyViewModel_saveCommentForQuestion() {
        let stub = SurveyFactory.getSurveyExample()
        let sut = SurveyViewModel(survey: stub)
        
        let firstQuestion = stub.questions.first!

        let comment = "Test comment"
        sut.saveUserComment(comment)
        
        let result = sut.responses[firstQuestion.id]!
        
        XCTAssertNotNil(result, "Result must not be nil")
        XCTAssertEqual(result.comments, comment,
                       "Result comments must be equal to comment")
    }
    
    func test_surveyViewModel_setCurrentResponseOnSaveSelectedId() {
        let stub = SurveyFactory.getSurveyExample()
        let sut = SurveyViewModel(survey: stub)
        
        let firstQuestion = stub.questions.first!
        let selectedId = firstQuestion.options.first!.id
        
        sut.selectOption(selectedId)
        
        XCTAssertFalse(sut.currentResponse.questionId.isEmpty,
                       "CurresntResponse questionId should not be empty")
        XCTAssertNotNil(sut.currentResponse.selectedOptionsId,
                        "SelectedOptionsId should not be nil because it was set previously")
        XCTAssertEqual(sut.currentResponse.selectedOptionsId!.count, 1,
                       "SelectedOptionsId count must be equal to 1")
    }
    
    func test_surveyViewModel_setCurrentResponseOnNextTapped() {
        let stub = SurveyFactory.getSurveyExample()
        let sut = SurveyViewModel(survey: stub)
        
        let firstQuestion = stub.questions.first!
        let selectedId = firstQuestion.options.first!.id
        
        sut.selectOption(selectedId)
        sut.nextQuestion()
        
        XCTAssertFalse(sut.currentResponse.questionId.isEmpty,
                       "CurresntResponse questionId should not be empty")
        XCTAssertNil(sut.currentResponse.selectedOptionsId,
                        "SelectedOptionsId should be nil because it was not set previously")
        XCTAssertNil(sut.currentResponse.comments,
                       "Comments should be nil because it was not set previously")
    }
    
    func test_surveyViewModel_loadPreviousResponseSelectedIds_OnBackTapped() {
        let stub = SurveyFactory.getSurveyExample()
        let sut = SurveyViewModel(survey: stub)
        
        let firstQuestion = stub.questions.first!
        let selectedId = firstQuestion.options.last!.id
        
        sut.selectOption(selectedId)
        sut.nextQuestion()
        sut.previousQuestion()
        
        XCTAssertEqual(sut.currentResponse.selectedOptionsId, [selectedId],
                       "The selectedId array should be equal")
    }
    //MARK: Select option with no text
    func test_surveyVM_selectOptionWithNoText() {
        let openTextQuestion = SurveyFactory.createQuestionWithOpenText()
        let stub = SurveyFactory.getSurveyIncluding(question: openTextQuestion, totalQuestions: 2)
        let sut = SurveyViewModel(survey: stub)
        
        let optionToSelect = stub.questions.first!.options.first { $0.id != openTextQuestion.allowTextOption?.id
        }!
        
        sut.selectOption(optionToSelect.id)
        sut.nextQuestion()
        
        XCTAssertEqual(sut.currentQuestionIndex, 1)
    }
    
    func test_surveyVM_selectOption_changeSelection() {
        let openTextQuestion = SurveyFactory.createQuestionWithOpenText()
        let stub = SurveyFactory.getSurveyIncluding(question: openTextQuestion, totalQuestions: 3)
        let sut = SurveyViewModel(survey: stub)
        
        let optionToSelect = stub.questions.first!.options.first { $0.id != openTextQuestion.allowTextOption?.id
        }!
        let secondOptionToSelect = stub.questions.first!.options.first { $0.id != openTextQuestion.allowTextOption?.id && $0.id != optionToSelect.id
        }!
        
        sut.selectOption(optionToSelect.id)
        sut.selectOption(secondOptionToSelect.id)
        XCTAssertTrue(sut.currentResponse.selectedOptionsId!.contains(secondOptionToSelect.id),
                      "Incorrect option selected")
        
        sut.nextQuestion()
        XCTAssertEqual(sut.currentQuestionIndex, 1)
        
    }
    //MARK: Select option with text
    func test_surveyVM_selectOptionWithText_addText() {
        let openTextQuestion = SurveyFactory.createQuestionWithOpenText()
        let stub = SurveyFactory.getSurveyIncluding(question: openTextQuestion, totalQuestions: 2)
        let sut = SurveyViewModel(survey: stub)
        let comment = "Comentario"
        let selectedOption = openTextQuestion.options.last!
        
        sut.selectOption(selectedOption.id)
        sut.addComment(comment)

        XCTAssertEqual(sut.currentResponse.selectedOptionsId!.first, selectedOption.id,
                      "Incorrect option selected")
        XCTAssertEqual(sut.currentResponse.comments!, comment, "Comment not equal")
    }
    
    func test_surveyVM_selectOptionWithText_addText_updateText() {
        let openTextQuestion = SurveyFactory.createQuestionWithOpenText()
        let stubSurvey = SurveyFactory.getSurveyIncluding(question: openTextQuestion)
        let sut = SurveyViewModel(survey: stubSurvey)
        let firstComment = "Comentario 1"
        let secondComment = "Comentario 2"
        let selectedOption = openTextQuestion.options.last!
        
        sut.selectOption(selectedOption.id)
        sut.addComment(firstComment)
        sut.addComment(secondComment)
        
        XCTAssertEqual(sut.currentResponse.selectedOptionsId!.first, selectedOption.id,
                       "Incorrect option selected")
        XCTAssertEqual(sut.currentResponse.comments!, secondComment, "Comments are not equal")
    }
    
    func test_surveyVM_selectOptionWithText_addText_changeOption() {
        let openTextQuestion = SurveyFactory.createQuestionWithOpenText()
        let stubSurvey = SurveyFactory.getSurveyIncluding(question: openTextQuestion)
        let sut = SurveyViewModel(survey: stubSurvey)
        let firstComment = "Comentario 1"
        
        let firstSelectedOption = openTextQuestion.options.last!
        let secondSelectedOption = stubSurvey.questions.first!.options.first { $0.id != openTextQuestion.allowTextOption?.id
        }!
        
        sut.selectOption(firstSelectedOption.id)
        sut.addComment(firstComment)
        sut.selectOption(secondSelectedOption.id)
        
        XCTAssertEqual(sut.currentResponse.selectedOptionsId!.first, secondSelectedOption.id,
                       "Incorrect option selected")
        XCTAssertNil(sut.currentResponse.comments,"Comments must be nil")
    }
    
    func test_surveyVM_selectOptionWithText_noTextAdded() {
        let openTextQuestion = SurveyFactory.createQuestionWithOpenText()
        let stubSurvey = SurveyFactory.getSurveyIncluding(question: openTextQuestion, totalQuestions: 2)
        let sut = SurveyViewModel(survey: stubSurvey)
        
        let optionToSelect = openTextQuestion.options.last!

        sut.selectOption(optionToSelect.id)
        
        sut.nextQuestion()
        XCTAssertEqual(sut.currentQuestionIndex, 0,
                       "Current index must be 0 because comments are required")
        XCTAssertEqual(sut.errorDetails, SurveyViewModelError.textIsEmpty,
                       "Error should be textIsEmpty")
    }
    
    func test_surveyVM_selectOptionWithText_addEmptyText() {
        let openTextQuestion = SurveyFactory.createQuestionWithOpenText()
        let stubSurvey = SurveyFactory.getSurveyIncluding(question: openTextQuestion, totalQuestions: 2)
        let sut = SurveyViewModel(survey: stubSurvey)
        
        let optionToSelect = openTextQuestion.options.last!

        sut.selectOption(optionToSelect.id)
        sut.addComment("")
        
        XCTAssertEqual(sut.errorDetails, SurveyViewModelError.textIsEmpty,
                       "Error should be textIsEmpty")
    }
}

extension SurveyFactory {
    
    static func createQuestionWithOpenText() -> Question {
        let optionA = QuestionOption(id: UUID().uuidString, description: "Opcion A")
        let optionB = QuestionOption(id: UUID().uuidString, description: "Opcion B")
        let optionC = QuestionOption(id: UUID().uuidString, description: "Opcion C")
        let optionWithText = QuestionOption(id: UUID().uuidString, description: "Opción con texto", allowsText: true)
        
        let question = Question(id: UUID().uuidString, prompt: "Pregunta que contiene una opción con texto", type: .singleSelection(options: [optionA, optionB, optionC, optionWithText]))
        return question!
    }
    
    static func getSurveyIncluding(question: Question, totalQuestions: Int = 1) -> Survey {
        if totalQuestions < 1 {
            return Survey(id: UUID().uuidString, intro: "Por favor responde la siguiente encuesta.",
                                              questions: [question])
        }
        
        let dummyData = createDummyQuestions(num: totalQuestions - 1)
        return Survey(id: UUID().uuidString, intro: "Por favor responde la siguiente encuesta.",
                                          questions: [question] + dummyData)
    }
    
    static func createDummyQuestions(num: Int) -> [Question] {
        var questions = [Question]()
        for i in 0..<num {
            questions.append(Question(id: UUID().uuidString, prompt: "Pregunta \(i + 1)",
                                      type: .open(placeholder: "Escribe tus comentarios"))!)
        }
        return questions
    }
}

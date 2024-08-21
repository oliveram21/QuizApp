//
//  iOSViewControllerFactoryTests.swift
//  QuizAppTests
//
//  Created by Olivera Miatovici on 20.08.2024.
//

import Foundation
import XCTest
@testable import QuizApp
import QuizEngine1

public class iOSViewControllerFactoryTests: XCTestCase {
    
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswersQuestion = Question.multipleAnswers("Q1")
    let questionOptions = ["A1", "A2"]
    
    let userCorrectAnswers = [Question.singleAnswer("Q1"): ["A1"], Question.multipleAnswers("Q2"): ["A1", "A2"]]
    let userWrongAnswers = [Question.singleAnswer("Q1"): ["A2"], Question.multipleAnswers("Q2"): ["A1", "A3"]]
    let correctAnswers = [Question.singleAnswer("Q1"): ["A1"], Question.multipleAnswers("Q2"): ["A1", "A2"]]
    let questions = [Question.singleAnswer("Q1"), Question.multipleAnswers("Q2")]
    
    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let questionViewController = createQuestionViewController(question: singleAnswerQuestion)
        let presenter = QuestionPresenter(question: singleAnswerQuestion, questions: questions)
        XCTAssertEqual(questionViewController.title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        let questionViewController = createQuestionViewController(question: singleAnswerQuestion)
        XCTAssertEqual(questionViewController.question, "Q1")
    }
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        let questionViewController =  createQuestionViewController(question: singleAnswerQuestion)
        XCTAssertEqual(questionViewController.options, questionOptions)
    }
    func test_questionViewController_singleAnswer_createsControllerWithCallback() {
        var toggle = false
        let questionViewController = createQuestionViewController(question: singleAnswerQuestion) { _ in  toggle = true}
        questionViewController.selection!([])
        XCTAssertEqual(toggle, true)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        let questionViewController = createQuestionViewController(question: singleAnswerQuestion)
        XCTAssertEqual(questionViewController.isMultipleSelection, false)
    }
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let questionViewController = createQuestionViewController(question: multipleAnswersQuestion)
        let presenter = QuestionPresenter(question: multipleAnswersQuestion, questions: questions)
        XCTAssertEqual(questionViewController.title, presenter.title)
    }
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        let questionViewController = createQuestionViewController(question: multipleAnswersQuestion)
         XCTAssertEqual(questionViewController.question, "Q1")
    }
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        let questionViewController = createQuestionViewController(question: multipleAnswersQuestion)
        XCTAssertEqual(questionViewController.options, questionOptions)
    }
    func test_questionViewController_multipleAnswers_createsControllerWithCallback() {
        var toggle = false
        let questionViewController = createQuestionViewController(question: multipleAnswersQuestion) { _ in toggle = true }
        questionViewController.selection!([])
        XCTAssertEqual(toggle, true)
    }
    
    func test_questionViewController_multipleAnswers_createsControllerWithMultipleSelection() {
        let questionViewController = createQuestionViewController(question: multipleAnswersQuestion, isMultipleAnswersAllowed: true)
        XCTAssertEqual(questionViewController.isMultipleSelection, true)
    }
    
    func test_resultViewController_withResult_createsResultController() {
        let sut = createSut()
        let result = Result(answers: userCorrectAnswers, score: 0)
        XCTAssertNotNil(sut.resultViewController(result: result))
    }
    
    func test_resultViewController_withResult_createsControllerWithSummary() {
        let result = createResults()
        XCTAssertEqual(result.0.summary , result.1.summary)
    }
    func test_resultViewController_withResult_createsControllerWithTitle() {
        let result = createResults()
        XCTAssertEqual(result.0.title , result.1.title)
    }
    func test_resultViewController_withResult_createsControllerWithAnswers() {
        
        let result = createResults()
        XCTAssertTrue(result.0.answers.count == result.1.answers.count)
    }
    
    //MARK: Helpers
    func createSut(options: [Question<String>: [String]] = [Question.singleAnswer("Q1"): ["A1"]]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(options: options, 
                                        correctAnswers: correctAnswers,
                                        questions: questions)
    }
    
    func createQuestionViewController(question: Question<String>, isMultipleAnswersAllowed: Bool = false, callBack: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        return createSut(options: [question: questionOptions])
            .questionViewController(question: question, answerCallback: callBack) as! QuestionViewController
    }
    
    func createResults() -> (ResultViewController, ResultsPresenter) {
        let sut = createSut()
        let answers =  [Question.singleAnswer("Q1"): ["A1"],
                        Question.multipleAnswers("Q2"): ["A2","A3"]]
        let result = Result(answers: answers, score: 0)
        let resultPresenter = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: questions)
        let controller = sut.resultViewController(result: result) as? ResultViewController
        return (controller!, resultPresenter)
    }
}

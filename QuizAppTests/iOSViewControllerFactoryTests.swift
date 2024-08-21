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
        _ = questionViewController.view
        XCTAssertEqual(questionViewController.tableView.allowsMultipleSelection, false)
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
        let questionViewController = createQuestionViewController(question: multipleAnswersQuestion)
        _ = questionViewController.view
        XCTAssertEqual(questionViewController.tableView.allowsMultipleSelection, true)
    }
    
    //MARK: Helpers
    func createSut(options: [Question<String>: [String]] = [Question.singleAnswer("Q1"): ["A1"]]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(options: options)
    }
    
    func createQuestionViewController(question: Question<String>, callBack: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        return createSut(options: [question: questionOptions])
            .questionViewController(question: question, answerCallback: callBack) as! QuestionViewController
    }
}

//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 19.08.2024.
//

import Foundation
@testable import QuizApp
import XCTest
import QuizEngine1

class NavigationControllerRouterTests: XCTestCase {
    private let navigationController = NoPushAnimationViewController()
    private let factory = ViewControllerFactoryStub()
    private lazy var sut = NavigationControllerRouter(navigationController: navigationController, factory: factory)
    private let singleAnswerQuestion = Question.singleAnswer("Q1")
    private let multipleAnswersQuestion = Question.multipleAnswers("Q1")
    
    func test_answerForTwoQuestions_presentQuestionViewController() {
        let firstViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q1"), with: firstViewController)
        
        let secondViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q12"), with: secondViewController)
        
        sut.answer(for: Question.singleAnswer("Q1")) { _ in }
        sut.answer(for: Question.singleAnswer("Q12")) { _ in }
        
        XCTAssertEqual(navigationController.viewControllers.count , 2)
        XCTAssertEqual(navigationController.viewControllers.first! , firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last! , secondViewController)
    }
    
    func test_answerForOneQuestion_singleAnswer_answerCallBack_progressToNextQuestion() {
       
        var calledAnswerCallback = false
        sut.answer(for: singleAnswerQuestion) { _ in calledAnswerCallback = true}
        factory.answerCallback[singleAnswerQuestion]!(["A1"])
        XCTAssertEqual(calledAnswerCallback , true)
    }
    
    func test_answerForOneQuestion_singleAnswer_doesNotConfigureControllerWithSubmit() {
        let firstViewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: firstViewController)
      
        sut.answer(for: singleAnswerQuestion, completion: { _ in })
        XCTAssertNil(firstViewController.navigationItem.rightBarButtonItem)
    }
    func test_answerForOneQuestion_multipleAnswer_answerCallBack_doesNotProgressToNextQuestion() {
        var calledAnswerCallback = false
        sut.answer(for: multipleAnswersQuestion) { _ in calledAnswerCallback = true}
        factory.answerCallback[multipleAnswersQuestion]!(["anything"])
        XCTAssertEqual(calledAnswerCallback , false)
    }
    
    func test_answerForOneQuestion_multipleAnswer_configureSubmitButton() {
        let firstViewController = UIViewController()
        factory.stub(question: multipleAnswersQuestion, with: firstViewController)
      
        sut.answer(for: multipleAnswersQuestion, completion: { _ in })
        XCTAssertNotNil(firstViewController.navigationItem.rightBarButtonItem)
    }
    func test_answerForOneQuestion_multipleAnswerSubmit_isDisabledWhenZeroAnswersSelected() {
        
        let firstViewController = UIViewController()
        factory.stub(question: multipleAnswersQuestion, with: firstViewController)
        sut.answer(for: multipleAnswersQuestion, completion: { _ in })
        XCTAssertFalse(firstViewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswersQuestion]!(["A1"])
        XCTAssertTrue(firstViewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswersQuestion]!([])
        XCTAssertFalse(firstViewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_answerForOneQuestion_multipleAnswerSubmit_progressesToNextQuestion() {
        let firstViewController = UIViewController()
        factory.stub(question: multipleAnswersQuestion, with: firstViewController)
        
        var calledAnswerCallback = false
        sut.answer(for: multipleAnswersQuestion, completion: { _ in calledAnswerCallback = true })
        XCTAssertFalse(firstViewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswersQuestion]!(["A1"])
        let submitButton = firstViewController.navigationItem.rightBarButtonItem!
        XCTAssertTrue(submitButton.isEnabled)
        submitButton.simulateTap()
        XCTAssertTrue(calledAnswerCallback)
    }
    
    func test_didcompleteQuiz_presentResultviewController() {
        let firstViewController = UIViewController()
        factory.stub(resultForQuestions: [multipleAnswersQuestion], with: firstViewController)
        
        sut.didCompleteQuiz(with: [(multipleAnswersQuestion,["A1","A2"])])
        let secondViewController = UIViewController()
        factory.stub(resultForQuestions: [singleAnswerQuestion], with: secondViewController)
        
        sut.didCompleteQuiz(with: [(singleAnswerQuestion,["A1"])])
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first!, firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last!, secondViewController)
    }
    
}

private class NoPushAnimationViewController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
}

private class ViewControllerFactoryStub: ViewControllerFactory {
    typealias QuestionType = Question<String>
   
    private var stubbedQuestion: [QuestionType: UIViewController] = [:]
    private var stubbedResults: [[QuestionType]: UIViewController] = [:]
    var answerCallback = [Question<String>: ([String]) -> Void]()
    var summary = ""
    var answers: [PresentableAnswer] = []
    
    func stub(question: QuestionType, with viewController: UIViewController) {
        stubbedQuestion[question] = viewController
    }
    
    func stub(resultForQuestions: [QuestionType], with viewController: UIViewController) {
        stubbedResults[resultForQuestions] = viewController
    }
    func questionViewController(question:  QuestionType, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        self.answerCallback[question] = answerCallback
        return stubbedQuestion[question] ?? UIViewController()
    }
    
    func resultViewController(for answers: Answers) -> UIViewController {
        return stubbedResults[answers.map({$0.question})] ?? UIViewController()
    }
}

extension UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: self.action!, with: nil, waitUntilDone: true)
    }
}

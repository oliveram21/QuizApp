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
    let navigationController = NoPushAnimationViewController()
    let factory = ViewControllerFactoryStub()
    lazy var sut = NavigationControllerRouter(navigationController: navigationController, factory: factory)
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswersQuestion = Question.multipleAnswers("Q1")
    
    func test_routeTwoQuestions_presentQuestionViewController() {
        let firstViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q1"), with: firstViewController)
        
        let secondViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q12"), with: secondViewController)
        
        sut.routeTo(question: Question.singleAnswer("Q1")) { _ in }
        sut.routeTo(question: Question.singleAnswer("Q12")) { _ in }
        
        XCTAssertEqual(navigationController.viewControllers.count , 2)
        XCTAssertEqual(navigationController.viewControllers.first! , firstViewController)
        XCTAssertEqual(navigationController.viewControllers.last! , secondViewController)
    }
    
    func test_routeOneQuestion_singleAnswer_answerCallBack_progressToNextQuestion() {
       
        var calledAnswerCallback = false
        sut.routeTo(question: singleAnswerQuestion) { _ in calledAnswerCallback = true}
        factory.answerCallback[singleAnswerQuestion]!(["A1"])
        XCTAssertEqual(calledAnswerCallback , true)
    }
    
    func test_routeOneQuestion_singleAnswer_doesNotConfigureControllerWithSubmit() {
        let firstViewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: firstViewController)
      
        sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in })
        XCTAssertNil(firstViewController.navigationItem.rightBarButtonItem)
    }
    func test_routeOneQuestion_multipleAnswer_answerCallBack_doesNotProgressToNextQuestion() {
        var calledAnswerCallback = false
        sut.routeTo(question: multipleAnswersQuestion) { _ in calledAnswerCallback = true}
        factory.answerCallback[multipleAnswersQuestion]!(["anything"])
        XCTAssertEqual(calledAnswerCallback , false)
    }
    
    func test_routeOneQuestion_multipleAnswer_configureSubmitButton() {
        let firstViewController = UIViewController()
        factory.stub(question: multipleAnswersQuestion, with: firstViewController)
      
        sut.routeTo(question: multipleAnswersQuestion, answerCallback: { _ in })
        XCTAssertNotNil(firstViewController.navigationItem.rightBarButtonItem)
    }
    func test_routeOneQuestion_multipleAnswerSubmit_isDisabledWhenZeroAnswersSelected() {
        
        let firstViewController = UIViewController()
        factory.stub(question: multipleAnswersQuestion, with: firstViewController)
        sut.routeTo(question: multipleAnswersQuestion, answerCallback: { _ in })
        XCTAssertFalse(firstViewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswersQuestion]!(["A1"])
        XCTAssertTrue(firstViewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswersQuestion]!([])
        XCTAssertFalse(firstViewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_routeOneQuestion_multipleAnswerSubmit_progressesToNextQuestion() {
        let firstViewController = UIViewController()
        factory.stub(question: multipleAnswersQuestion, with: firstViewController)
        
        var calledAnswerCallback = false
        sut.routeTo(question: multipleAnswersQuestion, answerCallback: { _ in calledAnswerCallback = true })
        XCTAssertFalse(firstViewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswersQuestion]!(["A1"])
        let submitButton = firstViewController.navigationItem.rightBarButtonItem!
        XCTAssertTrue(submitButton.isEnabled)
        submitButton.simulateTap()
        XCTAssertTrue(calledAnswerCallback)
    }
    
}

class NoPushAnimationViewController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }
}

class ViewControllerFactoryStub: ViewControllerFactory {
    typealias QuestionType = Question<String>
    
    private var stubbedQuestion: [QuestionType: UIViewController] = [:]
    var answerCallback = [Question<String>: ([String]) -> Void]()
    var summary = ""
    var answers: [PresentableAnswer] = []
    
    func stub(question: QuestionType, with viewController: UIViewController) {
        stubbedQuestion[question] = viewController
    }
    
    func questionViewController(question:  QuestionType, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        self.answerCallback[question] = answerCallback
        return stubbedQuestion[question] ?? UIViewController()
    }
    //Result hasn't public initiliazer
    func resultViewController(result: Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
    func resultViewController(for answers: Answers) -> UIViewController {
        return UIViewController()
    }
}

extension UIBarButtonItem {
    func simulateTap() {
        target!.performSelector(onMainThread: self.action!, with: nil, waitUntilDone: true)
    }
}

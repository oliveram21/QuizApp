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
    
    func test_routeOneQuestion_presentQuestionViewControllerWithRightcallback() {
        factory.stub(question: Question.singleAnswer("Q1"), with: UIViewController())
        var calledAnswerCallback = false
        sut.routeTo(question: Question.singleAnswer("Q1")) { _ in calledAnswerCallback = true}
        factory.answerCallback!([""])
        XCTAssertEqual(calledAnswerCallback , true)
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
    var answerCallback: (([String]) -> Void)? = nil
    var summary = ""
    var answers: [PresentableAnswer] = []
    
    func stub(question: QuestionType, with viewController: UIViewController) {
        stubbedQuestion[question] = viewController
    }
    
    func questionViewController(question:  QuestionType, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        self.answerCallback = answerCallback
        return stubbedQuestion[question] ?? UIViewController()
    }
    //Result hasn't public initiliazer
    func resultViewController(result: Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
}

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
        factory.answerCallback!("")
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
    private var stubbedResult: [Result<QuestionType,String>: UIViewController] = [:]
    var answerCallback: ((String) -> Void)? = nil
    var summary = ""
    var answers: [PresentableAnswer] = []
    
    func stub(question: QuestionType, with viewController: UIViewController) {
        stubbedQuestion[question] = viewController
    }
    func stub(result: Result<QuestionType,String>, with viewController: UIViewController) {
        stubbedResult[result] = viewController
    }
    func questionViewController(question:  QuestionType, answerCallback: @escaping (String) -> Void) -> UIViewController {
        self.answerCallback = answerCallback
        return stubbedQuestion[question] ?? UIViewController()
    }
    
    func resultViewController(result: Result<QuestionType,String>) -> UIViewController {
        return stubbedResult[result] ?? UIViewController()
    }
}

extension QuizEngine1.Result: Hashable {
   
    public func hash(into hasher: inout Hasher) {
        self.score.hash(into: &hasher)
       // self.answers.keys.hash(into: &hasher)
    }
    public static func == (lhs: QuizEngine1.Result<Question, Answer>, rhs: QuizEngine1.Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
      // Writing in the extension of class, whose private methods we want to access
    public    var testHooks: TestHooks {      // Instance of testHooks, through which we will access the private methods in unit tests
            TestHooks(target: self)      // Init with self to access self's private methods
        }
    public  struct TestHooks {    // TestHooks struct which contains hooks for all the properties methods and properties we want to access
            var target: QuizEngine1.Result<Question, Answer>    // Target whose private methods needs to be accessed
            func somePrivateMethod() -> QuizEngine1.Result<Question, Answer>    {    // Hook through which method will be exposed
               // target.score = 2 // Exposing the method
                return target
            }
        }
    
    
}

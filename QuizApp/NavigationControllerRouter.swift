//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 19.08.2024.
//

import Foundation
import QuizEngine1
import UIKit

class NavigationControllerRouter: Router {
    private let navigationController: UINavigationController
    private let viewControllerFactory: ViewControllerFactory
    
    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.viewControllerFactory = factory
    }
    
    func routeTo(question: Question<String>, answerCallback: @escaping ([String]) -> Void) {
        let questionVC = viewControllerFactory.questionViewController(question: question, answerCallback: answerCallback)
        self.navigationController.pushViewController(questionVC, animated: true)
    }
    
    func routeTo(result: Result<Question<String>, [String]>) {
        let resultVC = viewControllerFactory.resultViewController(result: result)
        self.navigationController.pushViewController(resultVC, animated: true)
    }
}

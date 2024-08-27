//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 19.08.2024.
//

import Foundation
import QuizEngine1
import UIKit

class NavigationControllerRouter: QuizDelegate {
    private let navigationController: UINavigationController
    private let viewControllerFactory: ViewControllerFactory
    
    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.viewControllerFactory = factory
    }
   
    private func show(_ viewController: UIViewController) {
        self.navigationController.pushViewController(viewController, animated: true)
    }
    func answer(for question: QuizEngine1.Question<String>, completion: @escaping ([String]) -> Void) {
        switch question {
        case .singleAnswer(_):
            show(viewControllerFactory.questionViewController(question: question, answerCallback: completion))
        case .multipleAnswers(_):
            let button = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
            let buttonController = SubmitButtonController(button, completion)
            button.isEnabled = false
            let questionVC = viewControllerFactory.questionViewController(question: question, answerCallback: { selection in
                buttonController.updateModel(selection)
            })
            questionVC.navigationItem.rightBarButtonItem = button
            show(questionVC)
        @unknown default: break
            
        }
    }
    
    func didCompleteQuiz(with answers: [(question: QuizEngine1.Question<String>, answer: [String])]) {
        show(viewControllerFactory.resultViewController(for: answers))
    }
}

private class SubmitButtonController: NSObject {
    private let button: UIBarButtonItem
    private let submitCallBack: ([String]) -> Void
    private var model: [String] = []
    
    init(_ button: UIBarButtonItem, _ submitCallBack: @escaping ([String]) -> Void) {
        self.button = button
        self.submitCallBack = submitCallBack
        super.init()
        setupButton()
        updateButtonState()
    }
    
    func updateModel(_ model: [String]) {
        self.model = model
        updateButtonState()
    }
    
    func updateButtonState() {
        button.isEnabled = !self.model.isEmpty
    }
    
    func setupButton() {
        button.target = self
        button.action = #selector(submit)
    }
    
    @objc func submit() {
        submitCallBack(model)
    }
}

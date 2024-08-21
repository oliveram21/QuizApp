//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 20.08.2024.
//

import Foundation
import UIKit
import QuizEngine1

struct iOSViewControllerFactory: ViewControllerFactory {
    private var options: [Question<String>:[String]]
    
    init(options: [Question<String> : [String]]) {
        self.options = options
    }
    
    func questionViewController(question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("No options for question:\(question)")
        }
        switch question {
            case .singleAnswer(let questionValue):
                return QuestionViewController(question: questionValue , options: options, selection: answerCallback)
            case .multipleAnswers(let questionValue):
                let questionViewController = QuestionViewController(question: questionValue, options: options, selection: answerCallback)
                _ = questionViewController.view
            questionViewController.tableView.allowsMultipleSelection = true
            return questionViewController
        }
    }
    
    func resultViewController(result: Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
    
    
}

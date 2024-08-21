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
    private var correctAnswers:  [Question<String>:[String]]
    private var questions: [Question<String>]
    
    init(options: [Question<String> : [String]], correctAnswers: [Question<String> : [String]], questions: [Question<String>]) {
        self.options = options
        self.correctAnswers = correctAnswers
        self.questions = questions
    }
    
    func questionViewController(question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
       
        switch question {
            case .singleAnswer(let questionValue):
                let questionViewController = questionViewController(question: question, value: questionValue, answerCallback: answerCallback)
                return questionViewController
            case .multipleAnswers(let questionValue):
            let questionViewController = questionViewController(question: question, value: questionValue, isMultipleSelection: true, answerCallback: answerCallback)
                return questionViewController
        @unknown default: 
            fatalError("Missing question case")
        }
    }
    
    func resultViewController(result: Result<Question<String>, [String]>) -> UIViewController {
        let presentableResult = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: questions)
        return ResultViewController(summary: presentableResult.summary, answers: presentableResult.answers)
    }
    
    private func questionViewController(question: Question<String>, value: String, isMultipleSelection: Bool = false, answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
        guard let options = options[question] else {
            fatalError("No options for question:\(question)")
        }
        let questionPresenter = QuestionPresenter(question: question, questions: questions)
        let questionViewController = QuestionViewController(question: value, options: options, isMultipleSelection: isMultipleSelection, selection: answerCallback)
        questionViewController.title = questionPresenter.title
        return questionViewController
    }
    
}

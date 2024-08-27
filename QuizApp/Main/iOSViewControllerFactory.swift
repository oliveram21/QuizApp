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
    typealias Answers = [(question: Question<String>, answers: [String])]
    
    private var options: [Question<String>:[String]]
    private var correctAnswers: Answers
    private var questions: [Question<String>]
    
    init(options:  [Question<String>:[String]], correctAnswers: Answers) {
        self.correctAnswers = correctAnswers
        self.options = options
        self.questions = correctAnswers.map({ $0.question })
    }
    
    init(options: [Question<String> : [String]], correctAnswers: [Question<String> : [String]], questions: [Question<String>]) {
        self.options = options
        self.correctAnswers = questions.map({ (question: $0, answers: correctAnswers[$0]!)})
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
        let presentableResult = ResultsPresenter(
            userAnswers: questions.map({ (question: $0, answers: result.answers[$0]!) }),
            correctAnswers: correctAnswers,
            scorer: {_, _ in result.score})
       
        let resultsVC = ResultViewController(summary: presentableResult.summary, answers: presentableResult.answers)
        resultsVC.title = presentableResult.title
        return resultsVC
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

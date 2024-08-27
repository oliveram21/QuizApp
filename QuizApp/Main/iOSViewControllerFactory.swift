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
    private var correctAnswers: Answers
    private var questions: [Question<String>] {
        return correctAnswers.map({ $0.question })
    }
    
    init(options: [Question<String>:[String]], correctAnswers: Answers) {
        self.correctAnswers = correctAnswers
        self.options = options
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
    
    func resultViewController(for answers: Answers) -> UIViewController {
        let presentableResult = ResultsPresenter(
            userAnswers: answers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score)
       
        let resultsVC = ResultViewController(summary: presentableResult.summary, answers: presentableResult.answers)
        resultsVC.title = presentableResult.title
        return resultsVC
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

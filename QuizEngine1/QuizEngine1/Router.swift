//
//  Router.swift
//  QuizEngine1
//
//  Created by Olivera Miatovici on 17.08.2024.
//

import Foundation

public protocol QuizDelegate<Question, Answer> where Question: Hashable {
    associatedtype Question
    associatedtype Answer
    typealias AnswerCallback = (Answer) -> Void
    
    func handle(question: Question, answerCallback: @escaping AnswerCallback)
    func handle(result: Result<Question, Answer>)
}

@available(*, deprecated)
public protocol Router<Question, Answer> where Question: Hashable {
    associatedtype Question
    associatedtype Answer
    typealias AnswerCallback = (Answer) -> Void
    func routeTo(question: Question, answerCallback: @escaping AnswerCallback)
    func routeTo(result: Result<Question, Answer>)
}

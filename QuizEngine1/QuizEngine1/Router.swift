//
//  Router.swift
//  QuizEngine1
//
//  Created by Olivera Miatovici on 17.08.2024.
//

import Foundation

@available(*, deprecated)
public protocol Router<Question, Answer> where Question: Hashable {
    associatedtype Question
    associatedtype Answer
    typealias AnswerCallback = (Answer) -> Void
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}

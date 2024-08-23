//
//  QuizDelegate.swift
//  QuizEngine1
//
//  Created by Olivera Miatovici on 23.08.2024.
//

import Foundation

public protocol QuizDelegate<Question, Answer> where Question: Hashable {
    associatedtype Question
    associatedtype Answer
    typealias AnswerCallback = (Answer) -> Void
    
    func handle(question: Question, answerCallback: @escaping AnswerCallback)
    func handle(result: Result<Question, Answer>)
}

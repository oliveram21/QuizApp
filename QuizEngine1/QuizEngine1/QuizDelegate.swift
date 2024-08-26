//
//  QuizDelegate.swift
//  QuizEngine1
//
//  Created by Olivera Miatovici on 23.08.2024.
//

import Foundation

public protocol QuizDelegate <Question, Answer> {
    associatedtype Question
    associatedtype Answer
    
    func answer(for question: Question, completion:@escaping (Answer) -> Void)
    func didCompleteQuiz(with answers: [(question: Question, answer: Answer)])
}

//
//  QuizDelegate.swift
//  QuizEngine1
//
//  Created by Olivera Miatovici on 23.08.2024.
//

import Foundation

public protocol QuizDelegate{//<Question, Answer> where Question: Hashable {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func answer(for question: Question, completion:@escaping (Answer) -> Void)
    func didCompleteQuiz(with answers: [(question: Question, answer: Answer)])
    
    @available(*, deprecated, message: "use didCompleteQuiz(wit answers)")
    func handle(result: Result<Question, Answer>)

}

public extension QuizDelegate {
    func didCompleteQuiz(with answers: [(question: Question, answer: Answer)]) {
        
    }
}

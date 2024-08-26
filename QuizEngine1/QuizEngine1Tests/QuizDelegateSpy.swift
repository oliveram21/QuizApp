//
//  QuizDelegateSpy.swift
//  QuizEngine1Tests
//
//  Created by Olivera Miatovici on 26.08.2024.
//

import Foundation
import QuizEngine1

class DelegateSpy: QuizDelegate {
    var questionsAsked: [String] = []
    var completedQuizes: [[(question: String, answer: String)]] = []
   
    var answerCompletions: [((String) -> Void)] = []
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        self.answerCompletions.append(completion)
    }
    
    func didCompleteQuiz(with answers: [(question: String, answer: String)]) {
        completedQuizes.append(answers)
    }
}

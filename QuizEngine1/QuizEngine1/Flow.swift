//
//  Flow.swift
//  QuizEngine
//
//  Created by Olivera Miatovici on 13.08.2024.
//

import Foundation

class Flow<Question, Answer, Delegate: QuizDelegate> where Delegate.Answer == Answer, Delegate.Question == Question {
    private let delegate: Delegate
    private let questions: [Question]
    private var newAnswers: [(Question, Answer)] = []
   
    init(questions: [Question], delegate: Delegate) {
        self.questions = questions
        self.delegate = delegate
    }
    
    func start() {
        delegateQuestionHandling(at: questions.startIndex)
    }
    
    private func delegateQuestionHandling(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            delegate.answer(for: question, completion: answer(for: question, at: index))
        } else {
            delegate.didCompleteQuiz(with: newAnswers)
        }
    }
    private func answer(for question: Question, at index: Int) -> (Answer) -> Void {
        return { [weak self] answer in
            self?.newAnswers.replaceOrInsert((question, answer), at: index)
            self?.delegateQuestionHandling(after: index)
        }
    }
    private func delegateQuestionHandling(after index: Int) {
       delegateQuestionHandling(at: questions.index(after: index))
    }
}

extension Array {
    mutating func  replaceOrInsert(_ element: Element, at index: Int) {
        if index < self.endIndex {
            self.remove(at: index)
        }
        self.insert(element, at: index)
    }
}

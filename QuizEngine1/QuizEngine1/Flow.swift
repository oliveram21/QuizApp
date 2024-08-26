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
    private var answers: [Question: Answer] = [:]
    private let scoring: ([Question: Answer]) -> Int
    
   
    init(questions: [Question], delegate: Delegate, scoring: @escaping ([Question: Answer]) -> Int = { _ in 0}) {
        self.questions = questions
        self.delegate = delegate
        self.scoring = scoring
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
           // delegate.handle(result: createResult())
        }
    }
    private func answer(for question: Question, at index: Int) -> (Answer) -> Void {
        return { [weak self] answer in
            self?.newAnswers.replaceOrInsert((question, answer), at: index)
            self?.answers[question] = answer
            self?.delegateQuestionHandling(after: index)
        }
    }
    private func delegateQuestionHandling(after index: Int) {
       delegateQuestionHandling(at: questions.index(after: index))
    }
   
    private func createResult() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
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

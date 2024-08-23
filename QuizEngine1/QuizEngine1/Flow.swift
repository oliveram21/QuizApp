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
    private var answers: [Question: Answer] = [:]
    private let scoring: ([Question: Answer]) -> Int
    
    init(questions: [Question], delegate: Delegate, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.delegate = delegate
        self.scoring = scoring
    }
    
    func start() {
        if let firstQuestion = questions.first {
            delegate.handle(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            delegate.handle(result: createResult())
        }
    }
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        return { [weak self] in self?.delegateQuestionHandling(question, $0) }
    }
    
    private func delegateQuestionHandling(_ question: Question, _ answer: Answer) {
        guard let currentIndex = questions.firstIndex(of: question) else { return }
        answers[question] = answer
        let nextQuestionIndex = questions.index(after: currentIndex)
        if nextQuestionIndex != questions.endIndex {
            let nextQuestion = questions[nextQuestionIndex]
            delegate.handle(question: nextQuestion,
                                    answerCallback: nextCallback(from: nextQuestion))
        } else {
            delegate.handle(result: createResult())
        }
    }
    private func createResult() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
    }
}

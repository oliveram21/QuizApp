//
//  Flow.swift
//  QuizEngine
//
//  Created by Olivera Miatovici on 13.08.2024.
//

import Foundation

class Flow<Question: Hashable, Answer, R: Router> where R.Answer == Answer, R.Question == Question {
    private let router: R
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private let scoring: ([Question: Answer]) -> Int
    
    init(questions: [Question], router: R, scoring: @escaping ([Question: Answer]) -> Int) {
        self.questions = questions
        self.router = router
        self.scoring = scoring
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion, answerCallback: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: createResult())
        }
    }
    
    private func nextCallback(from question: Question) -> (Answer) -> Void {
        return { [weak self] in self?.routeNext(question, $0) }
    }
    
    private func routeNext(_ question: Question, _ answer: Answer) {
        guard let currentIndex = questions.firstIndex(of: question) else { return }
        answers[question] = answer
        let nextQuestionIndex = questions.index(after: currentIndex)
        if nextQuestionIndex != questions.endIndex {
            let nextQuestion = questions[nextQuestionIndex]
            router.routeTo(question: nextQuestion,
                                    answerCallback: nextCallback(from: nextQuestion))
        } else {
            router.routeTo(result: createResult())
        }
    }
    private func createResult() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
    }
}

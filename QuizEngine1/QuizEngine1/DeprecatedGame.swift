//
//  Game.swift
//  QuizEngine1
//
//  Created by Olivera Miatovici on 17.08.2024.
//

import Foundation

public protocol Game {
}
extension Flow: Game {
}

@available(*, deprecated)
public protocol Router<Question, Answer> where Question: Hashable {
    associatedtype Question
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}

@available(*, deprecated)
public func startGame<Question, Answer: Equatable, R: Router>(_ questions: [Question], router: R, correctAnswers: [Question: Answer])  -> some Game where R.Answer == Answer, R.Question == Question {
    let flow = Flow(questions: questions, delegate: QuizDelegateAdapter(router: router), scoring: scoring(correctAnswers: correctAnswers))
    flow.start()
    return flow
}

func scoring<Question, Answer: Equatable>(correctAnswers: [Question: Answer]) -> ([Question: Answer]) -> Int {
    return { answers in
        return correctAnswers.reduce(0) { score, tuple in
            return score + (answers[tuple.key] == tuple.value ? 1 : 0)
        }
    }
}

@available(*, deprecated)
private class QuizDelegateAdapter<R: Router>: QuizDelegate {
    
    private var router: R
    
    init(router: R) {
        self.router = router
    }
    
    func handle(question: R.Question, answerCallback: @escaping AnswerCallback) {
        router.routeTo(question: question, answerCallback: answerCallback)
    }
    
    func handle(result: Result<R.Question, R.Answer>) {
        router.routeTo(result: result)
    }
}

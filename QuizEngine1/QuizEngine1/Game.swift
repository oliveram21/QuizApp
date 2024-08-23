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
public func startGame<Question, Answer: Equatable, R: Router>(_ questions: [Question], router: R, correctAnswers: [Question: Answer])  -> some Game where R.Answer == Answer, R.Question == Question {
    let flow = Flow(questions: questions, router: router, scoring: scoring(correctAnswers: correctAnswers))
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

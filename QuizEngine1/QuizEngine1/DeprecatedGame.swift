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
public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
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
    let flow = Flow(questions: questions, delegate: QuizDelegateAdapter(router: router, correctAnswers))
    flow.start()
    return flow
}

@available(*, deprecated)
private class QuizDelegateAdapter<R: Router>: QuizDelegate where R.Answer: Equatable {
  
    private var router: R
    private var correctAnswers: [R.Question: R.Answer]
    
    init(router: R, _ correctAnswers:  [R.Question: R.Answer]) {
        self.router = router
        self.correctAnswers = correctAnswers
    }
    
    func answer(for question: R.Question, completion:@escaping (R.Answer) -> Void) {
        router.routeTo(question: question, answerCallback: completion)
    }
    
    func didCompleteQuiz(with answers: [(question: R.Question, answer: R.Answer)]) {
        let answers: [Question: Answer] = answers.reduce([:]) { partialResult, answer in
            var partialResult =  partialResult
            partialResult[answer.question] = answer.answer
            return partialResult
        }
        let score = scoring(correctAnswers: correctAnswers)(answers)
        let result = Result(answers: answers, score: score)
        router.routeTo(result: result)
    }
    
    func handle(result: Result<R.Question, R.Answer>) {}
    
    private func scoring(correctAnswers: [R.Question: R.Answer]) -> ([R.Question: R.Answer]) -> Int {
        return { answers in
            return correctAnswers.reduce(0) { score, tuple in
                return score + (answers[tuple.key] == tuple.value ? 1 : 0)
            }
        }
    }
}

//
//  Game.swift
//  QuizEngine1
//
//  Created by Olivera Miatovici on 17.08.2024.
//

import Foundation

public protocol Game {
}
extension Quiz: Game {
}

@available(*, deprecated, message:"Scoring won't be supported in the future")
public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}

@available(*, deprecated, message: "Use QuizDelegate instead")
public protocol Router<Question, Answer> where Question: Hashable {
    associatedtype Question
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}

@available(*, deprecated, message: "Use Quiz.start instead")
public func startGame<Question, Answer: Equatable, R: Router>(_ questions: [Question], router: R, correctAnswers: [Question: Answer])  -> some Game where R.Answer == Answer, R.Question == Question {
    let adapter = QuizDelegateAdapter(router: router, correctAnswers)
    let quiz = Quiz.start(questions, delegate: adapter)
    return quiz
}

@available(*, deprecated, message: "Remove alongside deperecated Game types")
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

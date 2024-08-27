//
//  ResultPresenter.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 21.08.2024.
//

import QuizEngine1

final class ResultsPresenter {
    typealias QuestionAnswers = [(question: Question<String>, answer: [String])]
    typealias Scorer = ([String], [String]) -> Int
    let userAnswers: QuestionAnswers
    let correctAnswers: QuestionAnswers
    let scorer: Scorer
    
    init(userAnswers: QuestionAnswers, correctAnswers: QuestionAnswers, scorer: @escaping Scorer) {
        self.userAnswers = userAnswers
        self.correctAnswers = correctAnswers
        self.scorer = scorer
    }
    
    var summary: String {
        return "You have scored \(score) out of \(userAnswers.count)"
    }
    var title: String {
        return "Results"
    }
    
    var score: Int {
        return scorer(userAnswers.flatMap({ $0.answer}), correctAnswers.flatMap({ $0.answer}))
    }
    
    var answers: [PresentableAnswer] {
        return zip(userAnswers, correctAnswers).map { (questionAnswers, questionCorrectAnswers) in
            let correctAnswer = questionCorrectAnswers.answer == questionAnswers.answer ? nil : questionCorrectAnswers.answer
            return presentableAnswer(questionAnswers.question, questionAnswers.answer, correctAnswer)
        }
    }
    
    private func presentableAnswer(_ question: Question<String>, _ answers: [String], _ correctAnswer: [String]?) -> PresentableAnswer{
        switch question {
            case .singleAnswer(let question), .multipleAnswers(let question):
                   return PresentableAnswer(question: question,
                                      answer: formattedAnswers(answers),
                                      correctAnswer: formattedWrongAnswers(correctAnswer))
        @unknown default:
            fatalError()
        }
    }
    
    private func formattedAnswers(_ answers: [String]) -> String {
        return answers.joined(separator: "\n")
    }
    
    private func formattedWrongAnswers(_ answers: [String]?) -> String? {
        return answers?.joined(separator: "\n")
    }
}

//
//  ResultPresenter.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 21.08.2024.
//

import QuizEngine1

struct ResultsPresenter {
    let result:  Result<Question<String>, [String]>
    let correctAnswers: [Question<String>: [String]]
    let questions: [Question<String>]
    var summary: String {
        return "You have scored \(result.score) out of \(result.answers.count)"
    }
    var title: String {
        return "Results"
    }
    var answers: [PresentableAnswer] {
        return questions.map { question in
            guard let answers = result.answers[question],
                  let correctAnswers = correctAnswers[question] else {
                fatalError("Missing answers for question:\(question)")
            }
            let correctAnswer = correctAnswers == answers ? nil : correctAnswers
            return presentableAnswer(question, answers, correctAnswer)
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

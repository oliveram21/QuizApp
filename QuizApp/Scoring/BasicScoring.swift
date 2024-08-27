//
//  BasicScoring.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 27.08.2024.
//

import Foundation

class BasicScore {
    static func score(for answers: [String], correctAnswers: [String]) -> Int {
        return zip(answers, correctAnswers).reduce(0) {score, tuple in
            return score + (tuple.0 == tuple.1 ? 1 : 0)
        }
    }
}

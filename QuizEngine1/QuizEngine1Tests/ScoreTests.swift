//
//  ScoreTests.swift
//  QuizEngine1Tests
//
//  Created by Olivera Miatovici on 26.08.2024.
//

import Foundation
import XCTest

class ScoreTests: XCTestCase {
    
    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [], correctAnswers: []), 0)
    }
    func test_matchingOneAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["not a match"], correctAnswers: ["answer"]), 0)
    }
    func test_matchingtOneAnswer_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: ["answer"], correctAnswers: ["answer"]), 1)
    }
    func test_oneMatchOneUnmatch_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: ["answer","not a match"], correctAnswers: ["answer","another answer"]), 1)
    }
    func test_twoMatchingAnswers_scoresTwo() {
        XCTAssertEqual(BasicScore.score(for: ["answer","another answer"], correctAnswers: ["answer","another answer"]), 2)
    }
    func test_withTooManyAnswers_twoMatchingAnswers_scoresTwo() {
        XCTAssertEqual(BasicScore.score(for: ["answer","another answer", "extra answer"], correctAnswers: ["answer","another answer"]), 2)
    }
    class BasicScore {
        static func score(for answers: [String], correctAnswers: [String]) -> Int {
            var score = 0
            for (index, answer) in answers.enumerated() {
                if index < correctAnswers.endIndex {
                    score += (answer == correctAnswers[index]) ? 1 : 0
                }
            }
            return score
        }
    }
}

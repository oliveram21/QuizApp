//
//  GameTest.swift
//  QuizEngine1Tests
//
//  Created by Olivera Miatovici on 17.08.2024.
//

import XCTest
import QuizEngine1

final class GameTest: XCTestCase {
    let router = RouterSpy()
    var game: Game!
    func test_startGame_withAnswerZeroOutOfTwoCorrecly_scoresZero() {
        let router = RouterSpy()
        game = startGame(["Q1","Q2"], router: router, correctAnswers: ["Q1": "A1",
                                                 "Q2": "A2"])
        
        router.answerCallback("C")
        router.answerCallback("B")
        XCTAssertEqual(router.routedResult!.score, 0)
    }
    func test_startGame_withAnswerOneOutOfTwoCorrecly_scoresOne() {
        let router = RouterSpy()
        game = startGame(["Q1","Q2"], router: router, correctAnswers: ["Q1": "A1",
                                                 "Q2": "A2"])
        
        router.answerCallback("A1")
        router.answerCallback("B")
        XCTAssertEqual(router.routedResult!.score, 1)
    }
    func test_startGame_withAnswerTwoCorrecly_scoresTwo() {
        let router = RouterSpy()
        game = startGame(["Q1","Q2"], router: router, correctAnswers: ["Q1": "A1",
                                                 "Q2": "A2"])
        
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedResult!.score, 2)
    }
}

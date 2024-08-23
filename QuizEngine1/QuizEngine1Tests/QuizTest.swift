//
//  QuizTest.swift
//  QuizEngine1Tests
//
//  Created by Olivera Miatovici on 23.08.2024.
//

import Foundation

import XCTest
@testable import QuizEngine1

final class QuizTest: XCTestCase {
    private let delegate = DelegateSpy()
    var quiz: Quiz!
    func test_startQuiz_withAnswerZeroOutOfTwoCorrecly_scoresZero() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(["Q1","Q2"], delegate: delegate, correctAnswers: ["Q1": "A1",
                                                 "Q2": "A2"])
        
        delegate.answerCallback("C")
        delegate.answerCallback("B")
        XCTAssertEqual(delegate.handledResult!.score, 0)
    }
    func test_startQuiz_withAnswerOneOutOfTwoCorrecly_scoresOne() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(["Q1","Q2"], delegate: delegate, correctAnswers: ["Q1": "A1",
                                                 "Q2": "A2"])
        
        delegate.answerCallback("A1")
        delegate.answerCallback("B")
        XCTAssertEqual(delegate.handledResult!.score, 1)
    }
    func test_startQuiz_withAnswerTwoCorrecly_scoresTwo() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(["Q1","Q2"], delegate: delegate, correctAnswers: ["Q1": "A1",
                                                 "Q2": "A2"])
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(delegate.handledResult!.score, 2)
    }
    
    private class DelegateSpy: QuizDelegate {
        var handledQuestions: [String] = []
        var handledResult: Result<String, String>?
        var answerCallback: ((String) -> Void) = {_ in}
        
        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            handledQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func handle(result: QuizEngine1.Result<String, String>) {
            handledResult = result
        }
    }
}

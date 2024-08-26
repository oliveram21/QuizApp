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
    
    func test_startQuiz_answersAllQuestions_completesQuiz() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(["Q1","Q2"], delegate: delegate)
        
        delegate.answerCompletions[0]("C")
        delegate.answerCompletions[1]("B")
        XCTAssertEqual(delegate.completedQuizes.count, 1)
        assertEqual(delegate.completedQuizes[0], [("Q1","C"),("Q2","B")])
    }
    
    func test_startQuiz_answersAllQuestionsTwice_completesQuizWithNewAnswers() {
        let delegate = DelegateSpy()
        quiz = Quiz.start(["Q1","Q2"], delegate: delegate)
        
        delegate.answerCompletions[0]("C")
        delegate.answerCompletions[1]("B")
        
        delegate.answerCompletions[0]("D")
        delegate.answerCompletions[1]("E")
        
        XCTAssertEqual(delegate.completedQuizes.count, 2)
        assertEqual(delegate.completedQuizes[0], [("Q1","C"),("Q2","B")])
        assertEqual(delegate.completedQuizes[1], [("Q1","D"),("Q2","E")])
    }
}

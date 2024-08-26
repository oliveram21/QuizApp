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
    func assertEqual(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #file,line: UInt = #line) {
        XCTAssertEqual(a1.elementsEqual(a2, by: ==), true, file: file, line: line)
    }
    
    private class DelegateSpy: QuizDelegate {
        var completedQuizes: [[(String, String)]] = []
        var answerCompletions: [((String) -> Void)] = []
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletions.append(completion)
        }
        
        func didCompleteQuiz(with answers: [(question: String, answer: String)]) {
            completedQuizes.append(answers)
        }
        
        func handle(result: QuizEngine1.Result<String, String>) {
           
        }
    }
}

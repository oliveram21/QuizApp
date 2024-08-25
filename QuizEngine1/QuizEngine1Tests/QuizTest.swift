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
        
        delegate.answerCompletion("C")
        delegate.answerCompletion("B")
        XCTAssertEqual(delegate.completedQuizes.count, 1)
        assertEqual(delegate.completedQuizes[0], [("Q1","C"),("Q2","B")])
    }
    
    func assertEqual(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #file,line: UInt = #line) {
        XCTAssertEqual(a1.elementsEqual(a2, by: ==), true, file: file, line: line)
    }
    
    private class DelegateSpy: QuizDelegate {
        var completedQuizes: [[(String, String)]] = []
        var answerCompletion: ((String) -> Void) = {_ in}
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            self.answerCompletion = completion
        }
        
        func didCompleteQuiz(with answers: [(question: String, answer: String)]) {
            completedQuizes.append(answers)
        }
        
        func handle(result: QuizEngine1.Result<String, String>) {
           
        }
    }
}

//
//  QuestionTests.swift
//  QuizAppTests
//
//  Created by Olivera Miatovici on 20.08.2024.
//

import Foundation
import XCTest
import QuizEngine1

class QuestionTests: XCTestCase {
   
    func test_equal_singleAnswers() {
        let value = UUID()
        XCTAssertEqual(Question.singleAnswer(value), Question.singleAnswer(value))
    }
   
    func test_equal_multipleAnswers() {
        let value = UUID()
        XCTAssertEqual(Question.multipleAnswers(value), Question.multipleAnswers(value))
    }
    
    func test_notEqual_isNotEqual() {
        let value = UUID()
        let anotherValue = UUID()
        XCTAssertNotEqual(Question.multipleAnswers(value), Question.singleAnswer(anotherValue))
        XCTAssertNotEqual(Question.multipleAnswers(value), Question.multipleAnswers(anotherValue))
        XCTAssertNotEqual(Question.singleAnswer(value), Question.singleAnswer(anotherValue))
        XCTAssertNotEqual(Question.singleAnswer(value), Question.multipleAnswers(value))
    }
}

//
//  QuestionTests.swift
//  QuizAppTests
//
//  Created by Olivera Miatovici on 20.08.2024.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionTests: XCTestCase {
    func test_hashValue_singleAnswer_equalTypeHashValue() {
        XCTAssertEqual(Question.singleAnswer("question").hashValue, "question".hashValue)
    }
    func test_hashValue_MultipleAnswer_equalTypeHashValue() {
        XCTAssertEqual(Question.multipleAnswers("question").hashValue, "question".hashValue)
    }
    func test_equal_singleAnswers_equalQuestion() {
        XCTAssertEqual(Question.singleAnswer("question"), Question.singleAnswer("question"))
    }
   
    func test_equal_multipleAnswers_equalQuestion() {
        XCTAssertEqual(Question.multipleAnswers("question"), Question.multipleAnswers("question"))
    }
    
    func test_notEqual_isNotEqual() {
        XCTAssertNotEqual(Question.multipleAnswers("question"), Question.singleAnswer("question1"))
        XCTAssertNotEqual(Question.multipleAnswers("question"), Question.multipleAnswers("question1"))
        XCTAssertNotEqual(Question.singleAnswer("question"), Question.singleAnswer("question1"))
        XCTAssertNotEqual(Question.singleAnswer("question"), Question.multipleAnswers("question1"))
    }
}

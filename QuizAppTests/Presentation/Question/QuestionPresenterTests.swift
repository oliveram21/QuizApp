//
//  QuestionPresenterTests.swift
//  QuizAppTests
//
//  Created by Olivera Miatovici on 21.08.2024.
//

import XCTest
@testable import QuizApp
import QuizEngine1

final class QuestionPresenterTests: XCTestCase {
    let question = Question.singleAnswer("Q1")
    let missingQuestion = Question.singleAnswer("Q3")
    let questions = [Question.singleAnswer("Q1"), Question.multipleAnswers("Q2")]
    
    func test_title_forFirstQuestion() {
        let sut = QuestionPresenter(question: question, questions: questions)
        XCTAssertEqual(sut.title, "Question #1")
    }
    
    func test_title_withMissingQuestion_emptyTitle() {
        let sut = QuestionPresenter(question: missingQuestion, questions: [])
        XCTAssertEqual(sut.title, "")
    }
    func test_question_questionText() {
        let sut = QuestionPresenter(question: question, questions: questions)
        XCTAssertEqual(sut.text, "Q1")
    }
}

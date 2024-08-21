//
//  ResultsPresenterTests.swift
//  QuizAppTests
//
//  Created by Olivera Miatovici on 21.08.2024.
//

import XCTest
@testable import QuizApp
import QuizEngine1

class ResultsPresenterTests: XCTestCase {
    let userCorrectAnswers = [Question.singleAnswer("Q1"): ["A1"], Question.multipleAnswers("Q2"): ["A1", "A2"]]
    let userWrongAnswers = [Question.singleAnswer("Q1"): ["A2"], Question.multipleAnswers("Q2"): ["A1", "A3"]]
    let correctAnswers = [Question.singleAnswer("Q1"): ["A1"], Question.multipleAnswers("Q2"): ["A1", "A2"]]
    let questions = [Question.singleAnswer("Q1"), Question.multipleAnswers("Q2")]
    
    func test_title_returnFormattedTitle() {
        XCTAssertEqual( makeSut(userWrongAnswers, correctAnswers: correctAnswers).title, "Results")
    }
    func test_summary_withTwoQuestionsAndScoreZero_returnsSummary() {
        let sut = makeSut(userWrongAnswers, correctAnswers: correctAnswers)
        XCTAssertTrue(sut.summary == "You have scored 0 out of 2")
    }
    
    func test_answers_withWrongSingleAnswer_mapAnswers() {
        let sut = makeSut(userWrongAnswers, correctAnswers: correctAnswers)
        XCTAssertTrue(sut.answers.count == 2)
        XCTAssertEqual(sut.answers.first!.isCorrectAnswer,false)
        XCTAssertEqual(sut.answers.first!.correctAnswer,"A1")
        XCTAssertEqual(sut.answers.first!.answer,"A2")
    }
    
    func test_answers_withWrongMultipleAnswer_mapAnswers() {
        let sut = makeSut(userWrongAnswers, correctAnswers: correctAnswers)
        XCTAssertTrue(sut.answers.count == 2)
        XCTAssertEqual(sut.answers.last!.isCorrectAnswer,false)
        XCTAssertEqual(sut.answers.last!.correctAnswer,"A1\nA2")
        XCTAssertEqual(sut.answers.last!.answer,"A1\nA3")
    }
    func test_answers_withRightSingleAnswer_mapAnswers() {
        let sut = makeSut(userCorrectAnswers, correctAnswers: correctAnswers)
        XCTAssertTrue(sut.answers.count == 2)
        XCTAssertTrue(sut.answers.first!.isCorrectAnswer == true)
        XCTAssertTrue(sut.answers.first!.correctAnswer == nil)
        XCTAssertEqual(sut.answers.first!.answer,"A1")
    }
    
    func test_answers_withRightMultipleAnswer_mapAnswers() {
        let sut = makeSut(userCorrectAnswers, correctAnswers: correctAnswers)
        XCTAssertTrue(sut.answers.count == 2)
        XCTAssertTrue(sut.answers.last!.isCorrectAnswer == true)
        XCTAssertTrue(sut.answers.last!.correctAnswer == nil)
        XCTAssertEqual(sut.answers.last!.answer,"A1\nA2")
    }
    //MARK: helpers
    func makeSut(_ userAnswers: [Question<String>: [String]], correctAnswers: [Question<String>: [String]], score: Int = 0) -> ResultsPresenter {
        
        let result = Result(answers: userAnswers, score: score)
        return ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: questions)
    }
}

//
//  ResultViewControllerTests.swift
//  QuizAppTests
//
//  Created by Olivera Miatovici on 16.08.2024.
//

import Foundation
import XCTest
@testable import QuizApp

class ResultViewControllerTests: XCTestCase {
    
    func test_didLoad_rendersSummary() {
        let sut = makeSut(summary: "This is a summary")
        XCTAssertEqual(sut.headerLabel.text, "This is a summary")
    }
    
    func test_didLoad_rendersAnswers() {
        var sut = makeSut(answers: [makeAnswer(),makeAnswer()])
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 2)
        sut = makeSut(answers: [])
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_didLoad_withCorrectAnswer_rendersCorrectAnswerCell() {
        let sut = makeSut(answers: [makeAnswer()])
        let cell = sut.tableView.cell(for: 0) as? CorrectAnswerCell
    
        XCTAssertNotNil(cell)
    }
    func test_didLoad_withCorrectAnswer_configuresCorrectAnswerCell() {
        let sut = makeSut(answers: [makeAnswer(question: "Q1", answer: "A1")])
        let cell = sut.tableView.cell(for: 0) as? CorrectAnswerCell
    
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.answerLabel.text, "A1")
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
    }
    func test_didLoad_withIncorrectAnswer_rendersIncorrectAnswerCell() {
        let sut = makeSut(answers: [makeAnswer(correctAnswer: "Correct answer")])
        let cell = sut.tableView.cell(for: 0) as? IncorrectAnswerCell
        
        XCTAssertNotNil(cell)
    }
    func test_didLoad_withIncorrectAnswer_configuresIncorrectAnswerCell() {
        let sut = makeSut(answers: [makeAnswer(question: "Q1", answer: "A1", correctAnswer: "A2")])
        let cell = sut.tableView.cell(for: 0) as? IncorrectAnswerCell
    
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.answerLabel.text, "A1")
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A2")
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
    }
    //MARK: helpers
    func makeAnswer(question: String = "", answer: String = "", correctAnswer: String? = nil) -> PresentableAnswer {
        return PresentableAnswer(question: question, answer: answer, correctAnswer: correctAnswer)
    }
    
    private func makeSut(summary: String = "",
                         answers: [PresentableAnswer] = []) -> ResultViewController {
        let sut = ResultViewController(summary: summary, answers: answers)
        _ = sut.view
        return sut
    }
}

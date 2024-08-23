//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Olivera Miatovici on 13.08.2024.
//

import Foundation
import XCTest
@testable import QuizEngine1

class FlowTest: XCTestCase {
    private let delegate = DelegateSpy()
   
    func test_start_withNoQuestion_doesNotDelegateQuestionHandling() {
      
        makeSut(questions: []).start()
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_delegateQuestionHandling() {
        makeSut(questions: ["Q1"]).start()
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    func test_start_withOneQuestion_delegateCorrectQuestionHandling() {
       
        makeSut(questions: ["Q2"]).start()
        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }
    func test_start_withTwoQuestion_delegateCorrectQuestionHandling() {
       let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    func test_startTwice_withTwoQuestion_delegateCorrectQuestionHandling() {
      
        let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(delegate.handledQuestions, ["Q1","Q1"])
    }
    
    func test_startAndAnswer_withTwoQuestion_delegateSecondQuestionHandling() {
       
       let sut = makeSut(questions: ["Q1","Q2"])
            sut.start()
        delegate.answerCallback("A1")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1","Q2"])
    }
    func test_startAndAnswerFirstAndSecondQuestions_withThreeQuestions_delegateSecondQuestionAndThirdHandling() {
       
        let sut = makeSut(questions: ["Q1","Q2","Q3"])
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1","Q2","Q3"])
    }
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesDelegateNextQuestionHandling() {
       
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    func test_start_withNoQuestion_delegateResultHandling() {
      
        makeSut(questions: []).start()
        XCTAssertEqual(delegate.handledResult!.answers, [:])
    }
    func test_start_withOneQuestion_doesDelegateResultHandling() {
      
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        XCTAssertNil(delegate.handledResult)
    }
    func test_start_withOneQuestion_delegateResultHandling() {
      
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        delegate.answerCallback("A1")
        XCTAssertEqual(delegate.handledResult!.answers, ["Q1":"A1"])
    }
    func test_startAndAsnwerFirst_withTwoQuestions_doesNotDelegateToResultHandling() {
        let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        delegate.answerCallback("A1")
        XCTAssertNil(delegate.handledResult)
    }
    func test_startAndAsnwerFirstAndSecond_withTwoQuestions_handleResult() {
        let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(delegate.handledResult!.answers, ["Q1":"A1","Q2":"A2"])
    }
    func test_startAndAsnwerFirstAndSecond_withTwoQuestions_scores() {
        var result: [String: String] = [:]
        let sut = makeSut(questions: ["Q1","Q2"], scoring: { answers in
            result = answers
            return 10
        })
        sut.start()
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        XCTAssertEqual(result,  ["Q1":"A1","Q2":"A2"])
        XCTAssertEqual(delegate.handledResult?.score,  10)
    }
    //MARK: Helpers
    private func makeSut(questions: [String], 
                 scoring: @escaping ([String: String]) -> Int = { _ in 0 }) -> Flow<String, String, DelegateSpy> {
        return Flow(questions: questions, router: delegate, scoring: scoring)
    }
    
    private class DelegateSpy: Router, QuizDelegate {
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
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
           handle(question: question, answerCallback: answerCallback)
        }
        
        func routeTo(result: Result<String, String>) {
            handle(result: result)
        }
    }
}


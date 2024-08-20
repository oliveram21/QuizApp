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
    let router = RouterSpy()
   
    func test_start_withNoQuestion_doesNotRouteToQuestion() {
      
        makeSut(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routesToQuestion() {
        makeSut(questions: ["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    func test_start_withOneQuestion_routesToCorrectQuestion_2() {
       
        makeSut(questions: ["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    func test_start_withTwoQuestion_routesToCorrectQuestion() {
       let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    func test_startTwice_withTwoQuestion_routesToCorrectQuestion() {
      
        let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1","Q1"])
    }
    
    func test_startAndAnswer_withTwoQuestion_routesToSecondQuestion() {
       
       let sut = makeSut(questions: ["Q1","Q2"])
            sut.start()
        router.answerCallback("A1")
        
        XCTAssertEqual(router.routedQuestions, ["Q1","Q2"])
    }
    func test_startAndAnswerFirstAndSecondQuestions_withThreeQuestions_routesToSecondQuestionAndThird() {
       
        let sut = makeSut(questions: ["Q1","Q2","Q3"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedQuestions, ["Q1","Q2","Q3"])
    }
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToNext() {
       
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    func test_start_withNoQuestion_routeToResult() {
      
        makeSut(questions: []).start()
        XCTAssertEqual(router.routedResult!.answers, [:])
    }
    func test_start_withOneQuestion_doesNotRouteToResult() {
      
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        XCTAssertNil(router.routedResult)
    }
    func test_start_withOneQuestion_routeToResult() {
      
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedResult!.answers, ["Q1":"A1"])
    }
    func test_startAndAsnwerFirst_withTwoQuestions_doesNotRouteToResult() {
        let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertNil(router.routedResult)
    }
    func test_startAndAsnwerFirstAndSecond_withTwoQuestions_routeToResult() {
        let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedResult!.answers, ["Q1":"A1","Q2":"A2"])
    }
    func test_startAndAsnwerFirstAndSecond_withTwoQuestions_scores() {
        var result: [String: String] = [:]
        let sut = makeSut(questions: ["Q1","Q2"], scoring: { answers in
            result = answers
            return 10
        })
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(result,  ["Q1":"A1","Q2":"A2"])
        XCTAssertEqual(router.routedResult?.score,  10)
    }
    //MARK: Helpers
    func makeSut(questions: [String], 
                 scoring: @escaping ([String: String]) -> Int = { _ in 0 }) -> Flow<String, String, RouterSpy> {
        return Flow(questions: questions, router: router, scoring: scoring)
    }
}


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
        XCTAssertTrue(delegate.questionsAsked.isEmpty)
    }
    
    func test_start_withOneQuestion_delegateQuestionHandling() {
        makeSut(questions: ["Q1"]).start()
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    func test_start_withOneQuestion_delegateCorrectQuestionHandling() {
       
        makeSut(questions: ["Q2"]).start()
        XCTAssertEqual(delegate.questionsAsked, ["Q2"])
    }
    func test_start_withTwoQuestion_delegateCorrectQuestionHandling() {
       let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    func test_startTwice_withTwoQuestion_delegateCorrectQuestionHandling() {
      
        let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(delegate.questionsAsked, ["Q1","Q1"])
    }
    
    func test_startAndAnswer_withTwoQuestion_delegateSecondQuestionHandling() {
       
       let sut = makeSut(questions: ["Q1","Q2"])
            sut.start()
        delegate.answerCallback[0]("A1")
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1","Q2"])
    }
    func test_startAndAnswerFirstAndSecondQuestions_withThreeQuestions_delegateSecondQuestionAndThirdHandling() {
       
        let sut = makeSut(questions: ["Q1","Q2","Q3"])
        sut.start()
        delegate.answerCallback[0]("A1")
        delegate.answerCallback[1]("A2")
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1","Q2","Q3"])
    }
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesDelegateNextQuestionHandling() {
       
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        delegate.answerCallback[0]("A1")
        delegate.answerCallback[0]("A2")
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    func test_start_withNoQuestion_completeWithEmptyQuiz() {
      
        makeSut(questions: []).start()
        XCTAssertEqual(delegate.completedQuizes.count,1)
        XCTAssertTrue(delegate.completedQuizes[0].isEmpty)
    }
    func test_start_withOneQuestion_doesNotCompleteQuiz() {
      
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        XCTAssertEqual(delegate.completedQuizes.count,0)
    }
    func test_start_withOneQuestion_completeQuiz() {
      
        let sut = makeSut(questions: ["Q1"])
        sut.start()
        delegate.answerCallback[0]("A1")
        assertEqual(delegate.completedQuizes[0], [("Q1","A1")])
    }
    
    func test_startAndAsnwerFirst_withTwoQuestions_doesNotCompleteQuiz() {
        let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        delegate.answerCallback[0]("A1")
        XCTAssertTrue(delegate.completedQuizes.isEmpty)
    }
    func test_startAndAsnwerFirstAndSecond_withTwoQuestions_completesQuiz() {
        let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        delegate.answerCallback[0]("A1")
        delegate.answerCallback[1]("A2")
        assertEqual(delegate.completedQuizes[0], [("Q1","A1"),("Q2","A2")])
    }
    func test_startAndAsnwerFirstAndSecondTwice_withTwoQuestions_completesQuizTwice() {
        let sut = makeSut(questions: ["Q1","Q2"])
        sut.start()
        delegate.answerCallback[0]("A1")
        delegate.answerCallback[1]("A2")
        
        delegate.answerCallback[0]("A1-1")
        delegate.answerCallback[1]("A2-2")
        assertEqual(delegate.completedQuizes[1], [("Q1","A1-1"),("Q2","A2-2")])
    }
    //MARK: Helpers
    private func makeSut(questions: [String]) -> Flow<String, String, DelegateSpy> {
        return Flow(questions: questions, delegate: delegate)
    }
    
    func assertEqual(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #file,line: UInt = #line) {
        XCTAssertEqual(a1.elementsEqual(a2, by: ==), true, file: file, line: line)
    }
    
    private class DelegateSpy: QuizDelegate {
        var questionsAsked: [String] = []
        var completedQuizes: [[(question: Question, answer: Answer)]] = []
       
        var answerCallback: [((String) -> Void)] = []
        
        func answer(for question: String, completion: @escaping (String) -> Void) {
            questionsAsked.append(question)
            self.answerCallback.append(completion)
        }
        
        func didCompleteQuiz(with answers: [(question: Question, answer:Answer)]) {
            completedQuizes.append(answers)
        }
    }
}


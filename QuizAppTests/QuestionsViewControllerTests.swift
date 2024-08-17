//
//  QuestionsViewControllerTests.swift
//  QuizAppTests
//
//  Created by Olivera Miatovici on 15.08.2024.
//

import Foundation
import XCTest
@testable import QuizApp
class QuestionsViewControllerTests: XCTestCase {
    func test_viewDidLoad_rendersQuestionHeaderText() {
        let sut = makeSut(question: "Q1")
        XCTAssertEqual(sut.headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_withOptions_rendersOptions() {
        var sut = makeSut(options: [])
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
        sut = makeSut(options: ["A1"])
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
        sut = makeSut(options: ["A1","A2"])
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_witOptions_rendersOptionText() {
        let sut = makeSut(options: ["A1", "A2"])
        XCTAssertEqual(sut.tableView.title(of: 0), "A1")
        XCTAssertEqual(sut.tableView.title(of: 1), "A2")
    }
    
    func test_optionSelected_withTwoOptionsEnabled_notifiesDelegateWithLastSelection() {
        var selectedOption = [String]()
        let sut = makeSut(options: ["A1", "A2"]) { selectedOption = $0 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(selectedOption, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(selectedOption, ["A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionDisabled_doesNotNotifieDelegateWithEmptySelection() {
        var selectedOption = [String]()
        let sut = makeSut(options: ["A1", "A2"]) { selectedOption = $0 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(selectedOption, ["A1"])
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(selectedOption, ["A1"])
    }
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateSelection() {
        var selectedOption = [String]()
        let sut = makeSut(options: ["A1", "A2"]) { selectedOption = $0 }
        sut.tableView.allowsMultipleSelection = true
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(selectedOption, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(selectedOption, ["A1","A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegate() {
        var selectedOption = [String]()
        let sut = makeSut(options: ["A1", "A2"]) { selectedOption = $0 }
        sut.tableView.allowsMultipleSelection = true
      
        sut.tableView.select(row: 0)
        XCTAssertEqual(selectedOption, ["A1"])
       
        sut.tableView.select(row: 1)
        XCTAssertEqual(selectedOption, ["A1","A2"])
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(selectedOption, ["A2"])
    }
    //MArk: Helpers
    private func makeSut(question: String = "",
                         options: [String] = [],
                         selection: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, selection: selection)
        _ = sut.view
        return sut
    }
}


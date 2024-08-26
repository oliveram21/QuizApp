//
//  Assertions.swift
//  QuizEngine1Tests
//
//  Created by Olivera Miatovici on 26.08.2024.
//

import Foundation
import XCTest

func assertEqual(_ a1: [(String, String)], _ a2: [(String, String)], file: StaticString = #file,line: UInt = #line) {
    XCTAssertEqual(a1.elementsEqual(a2, by: ==), true, file: file, line: line)
}

//
//  RouterSpy.swift
//  QuizEngine1Tests
//
//  Created by Olivera Miatovici on 17.08.2024.
//

import Foundation
import QuizEngine1

class RouterSpy: Router {
    var routedQuestions: [String] = []
    var routedResult: Result<String, String>?
    var answerCallback: ((String) -> Void) = {_ in}
    
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    func routeTo(result: Result<String, String>) {
        routedResult = result
    }
}

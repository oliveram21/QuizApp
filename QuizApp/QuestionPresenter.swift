//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 21.08.2024.
//

import Foundation
import QuizEngine1

struct QuestionPresenter {
    var question: Question<String>
    var questions: [Question<String>]
    
    var title: String {
        guard let questionIndex = questions.firstIndex(of: question) else { return "" }
        return "Question #\(questionIndex + 1)"
    }
    var text: String {
        switch question {
            case .singleAnswer(let questionValue), .multipleAnswers(let questionValue):
            return questionValue
        @unknown default:
            return ""
        }
    }
}

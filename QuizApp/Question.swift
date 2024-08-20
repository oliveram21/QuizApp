//
//  Question.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 20.08.2024.
//

import Foundation

enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswers(T)
    func hash(into hasher: inout Hasher) {
        switch self {
            case .multipleAnswers(let a): a.hash(into: &hasher)
            case .singleAnswer(let a): a.hash(into: &hasher)
        }
    }
}

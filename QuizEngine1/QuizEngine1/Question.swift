//
//  Question.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 20.08.2024.
//

import Foundation

public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswers(T)
}

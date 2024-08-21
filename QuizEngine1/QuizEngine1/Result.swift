//
//  Result.swift
//  QuizEngine1
//
//  Created by Olivera Miatovici on 17.08.2024.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int  
    
    public init(answers: [Question : Answer], score: Int) {
        self.answers = answers
        self.score = score
    }
}

//
//  Result+Extensions.swift
//  QuizAppTests
//
//  Created by Olivera Miatovici on 22.08.2024.
//

//testable import allows to access private module initialiazer
@testable import QuizEngine1

extension Result {
    static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result<Question,Answer> {
        return Result(answers: answers, score: score)
    }
}

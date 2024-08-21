//
//  ResultPresenter.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 21.08.2024.
//

import QuizEngine1

struct ResultPresenter {
    
    let summary = ""
    let answers: [PresentableAnswer]
    
    init(result: Result<Question<String>, [String]>) {
        self.answers = result.answers.map({(question, answers) in
            return PresentableAnswer(question: question, answer: <#T##String#>)
        })
    }
}

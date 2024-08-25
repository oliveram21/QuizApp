//
//  Quiz.swift
//  QuizEngine1
//
//  Created by Olivera Miatovici on 23.08.2024.
//

import Foundation
public final class Quiz {
    private let flow: Any
   
    private init(flow: Any) {
        self.flow = flow
    }
    
    static public func start<Delegate: QuizDelegate>(_ questions: [Delegate.Question], delegate: Delegate)  -> Quiz where Delegate.Answer: Hashable {
        let flow = Flow(questions: questions, delegate: delegate)
        flow.start()
        return Quiz(flow: flow)
    }
}

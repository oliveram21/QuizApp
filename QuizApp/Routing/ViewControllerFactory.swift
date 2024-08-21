//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 20.08.2024.
//

import Foundation
import QuizEngine1
import UIKit

protocol ViewControllerFactory {
    func questionViewController(question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    func resultViewController(result: Result<Question<String>, [String]>) -> UIViewController
}

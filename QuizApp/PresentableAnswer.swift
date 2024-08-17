//  Created by Olivera Miatovici on 17.08.2024.
//

import Foundation

struct PresentableAnswer {
    var question: String
    var answer: String
    var correctAnswer: String?
    var isCorrectAnswer: Bool {
        return correctAnswer == nil
    }
}

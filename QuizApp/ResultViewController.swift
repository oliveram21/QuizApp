//
//  ResultViewController.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 16.08.2024.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
    var summary = ""
    var answers = [PresentableAnswer]()
   
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLabel.text = summary
        self.tableView.register(cell: CorrectAnswerCell.self)
        self.tableView.register(cell: IncorrectAnswerCell.self)
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
       
        return answer.isCorrectAnswer  ? makeCorrectAnswerCell(for: tableView, answer: answer) : makeIncorrectAnswerCell(for: tableView, answer: answer)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    private func makeCorrectAnswerCell(for tableView: UITableView, answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeue(cell: CorrectAnswerCell.self)
        cell!.answerLabel.text = answer.answer
        cell!.questionLabel.text = answer.question
        return cell!
    }
    
    private func makeIncorrectAnswerCell(for tableView: UITableView, answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeue(cell: IncorrectAnswerCell.self)
        cell!.answerLabel.text = answer.answer
        cell!.questionLabel.text = answer.question
        cell!.correctAnswerLabel.text = answer.correctAnswer
        return cell!
    }
}


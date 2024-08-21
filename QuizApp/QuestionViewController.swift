//
//  QuestionViewController.swift
//  QuizAppTests
//
//  Created by Olivera Miatovici on 15.08.2024.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {
    private(set) var question = ""
    private(set) var options: [String] = []
    var isMultipleSelection = false
    var selection: (([String]) -> Void)? = nil
    let reuseCellIdentifier = "Cell"
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    convenience init(question: String, options: [String], isMultipleSelection: Bool = false, selection: @escaping ([String]) -> Void) {
        self.init()
        self.question = question
        self.options = options
        self.selection = selection
        self.isMultipleSelection = isMultipleSelection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerLabel.text = question
        self.tableView.allowsMultipleSelection = isMultipleSelection
    }
}

extension QuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCell(in: tableView)
        var cellConfiguration = cell.defaultContentConfiguration()
        cellConfiguration.text = options[indexPath.row]
        cell.contentConfiguration = cellConfiguration
        return cell
    }
    
    private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: reuseCellIdentifier)
    }
}

extension QuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection?(selectedOption(in: tableView))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            selection?(selectedOption(in: tableView))
        }
    }
    
    private func selectedOption(in tableView: UITableView) -> [String] {
        guard let options = tableView.indexPathsForSelectedRows?.map({ options[$0.row] }) else { return [] }
           
        return options
    }
}

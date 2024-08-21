//
//  UITableView+Extension.swift
//  QuizAppTests
//
//  Created by Olivera Miatovici on 16.08.2024.
//

import Foundation
import UIKit

extension UITableView {
    func title(of row: Int) -> String? {
        if let cell = self.dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0)) {
            return (cell.contentConfiguration as! UIListContentConfiguration).text
        }
        return nil
    }
    
    func select(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
        self.delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
    
    func deselect(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        deselectRow(at: indexPath, animated: false)
        self.delegate?.tableView?(self, didDeselectRowAt: indexPath)
    }
    
    func cell(for row: Int) -> UITableViewCell? {
        return dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 1))
    }
    
    func rowsCount() -> Int {
        return self.dataSource?.tableView(self, numberOfRowsInSection: 0) ?? 0
    }
}

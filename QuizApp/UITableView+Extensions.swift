//
//  UITableView+Extensions.swift
//  QuizApp
//
//  Created by Olivera Miatovici on 17.08.2024.
//

import Foundation
import UIKit

extension UITableView {
    func register(cell type: UITableViewCell.Type) {
        let className = String(describing: type)
        register(UINib(nibName: className, bundle: nil),
                               forCellReuseIdentifier: className)
    }
    
    func dequeue<T: UITableViewCell>(cell type: T.Type) -> T? {
        let cellIdentifier = String(describing: T.self)
        var cell = dequeueReusableCell(withIdentifier: cellIdentifier) as? T
        if cell == nil {
            cell = T(style: .default, reuseIdentifier: cellIdentifier)
        }
        return cell
    }
}


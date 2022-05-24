//
//  UItableView.swift
//  Note
//
//  Created by Toi Nguyen on 23/05/2022.
//

import Foundation
import UIKit

extension UITableView {
    func register<T: UITableViewCell> (cell: T.Type) {
        self.register(UINib(nibName: String(describing: cell), bundle: nil), forCellReuseIdentifier: String(describing: cell))
    }
    
    func dequeueCell<T: UITableViewCell>(customClass: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: String(describing: customClass), for: indexPath) as! T
        return cell
    }
}


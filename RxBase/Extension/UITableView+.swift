//
//  UITableView+.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

extension UITableView {
    func indexPathExists(indexPath: IndexPath) -> Bool {
        if indexPath.section >= self.numberOfSections {
            return false
        }
        if indexPath.row >= self.numberOfRows(inSection: indexPath.section) {
            return false
        }
        return true
    }
}

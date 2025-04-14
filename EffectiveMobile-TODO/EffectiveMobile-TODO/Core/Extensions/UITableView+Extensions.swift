//
//  UITableView+Extensions.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 12.04.2025.
//

import UIKit

// MARK: - ReuseIdentifiable

protocol ReuseIdentifiable {
    static var reuseID: String { get }
}

extension ReuseIdentifiable {
    static var reuseID: String {
        String(describing: self)
    }
}

// MARK: - Extensions

extension UITableViewCell: ReuseIdentifiable {}

extension UICollectionReusableView: ReuseIdentifiable {}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as! T
        return cell
    }

    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseID)
    }
}

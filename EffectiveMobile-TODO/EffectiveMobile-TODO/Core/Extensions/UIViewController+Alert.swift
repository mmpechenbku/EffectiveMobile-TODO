//
//  UIViewController+Alert.swift
//  EffectiveMobile-TODO
//
//  Created by mm pechenbku on 15.04.2025.
//

import UIKit

extension UIViewController {

    func showFlashAlert(with message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: Strings.back, style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func deleteAlertController(with message: String, title: String = "", deleteAction: @escaping (() -> Void)) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: Strings.back, style: .default)
        let deleteAction = UIAlertAction(
            title: Strings.delete,
            style: .destructive
        ) { _ in
            deleteAction()
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
}

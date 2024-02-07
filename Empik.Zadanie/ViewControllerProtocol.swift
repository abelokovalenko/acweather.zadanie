//
//  ViewControllerProtocol.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 05/02/2024.
//

import UIKit

protocol ViewControllerProtocol: UIViewController {
    var viewModel: ViewModelProtocol! { get set }
    func set(title: String?)
    func show(error: Error)
}

extension ViewControllerProtocol {
    func set(title: String?) {
        self.title = title
    }

    func dialogue(title: String,
                  description: String,
                  actionTitle: String,
                  action: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title,
                                                message: description,
                                                preferredStyle: .alert)
            
        let alertAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            action?()
        }
        alertController.addAction(alertAction)

        present(alertController, animated: true, completion: nil)
    }
}

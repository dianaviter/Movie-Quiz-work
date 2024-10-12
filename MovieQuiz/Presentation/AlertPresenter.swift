//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Diana Viter on 21.09.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    func showAlert(quiz: AlertModel) {
        if let delegate = delegate {
            let alert = UIAlertController (
                title: quiz.title,
                message: quiz.message,
                preferredStyle: .alert)
            
        let action = UIAlertAction(
            title: quiz.buttonText,
            style: .default) { _ in
                quiz.completion ()
            }
            alert.addAction(action)
            delegate.present(alert, animated: true, completion: nil)
        }
    }
}

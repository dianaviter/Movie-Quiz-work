//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Diana Viter on 21.09.2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    func showResult(result: String, numberOfQuizes: Int, record: String, averageAccuracy: Double, from viewController: UIViewController, completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "Этот раунд окончен!",
                                      message: """
                                        Ваш результат \(result)
                                        Количество сыгранных квизов: \(numberOfQuizes)
                                        Рекорд: \(record)
                                        Средняя точность: \(String(format: "%.2f", averageAccuracy * 100))%
                                        """,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { _ in
            completion ()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }

}


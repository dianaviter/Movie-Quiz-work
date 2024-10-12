//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Diana Viter on 21.09.2024.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: UIViewController {
    func showAlert (quiz: AlertModel)
}

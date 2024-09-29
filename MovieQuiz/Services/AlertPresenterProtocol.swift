//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Diana Viter on 21.09.2024.
//

import Foundation
import UIKit

protocol AlertPresenterProtocol {
    func showResult (result: String, numberOfQuizes: Int, record: String, averageAccuracy: Double, from viewController: UIViewController, completion: @escaping () -> Void)
}

//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Diana Viter on 20.09.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get }

    func requestNextQuestion ()
    func loadData()
}

//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Diana Viter on 22.09.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get set }
    var bestGame: GameResult? { get set }
    var correctAnswers: Int { get }
    var totalAccuracy: Double { get }
    
    func store (correct: Int, total: Int)
}

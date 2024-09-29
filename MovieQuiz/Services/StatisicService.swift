//
//  StatisicService.swift
//  MovieQuiz
//
//  Created by Diana Viter on 22.09.2024.
//

import Foundation
import UIKit

final class StatisicService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private enum Keys: String {
        case correct = "correctScore"
        case gamesCount = "gamesCount"
        case totalInGame = "totalScore"
        case date = "dateOfBestScore"
        case totalCorrect = "totalCorrectScore"
        case bestGame = "bestGame"
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set (newValue) {
            storage.set (newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult? {
        get {
            guard let data = storage.data(forKey: Keys.bestGame.rawValue),
                  let decodedResult = try? decoder.decode(GameResult.self, from: data) else {
                return nil
            }
            return decodedResult
        }
        set {
            if let newValue = newValue,
               let data = try? encoder.encode(newValue) {
                storage.set(data, forKey: Keys.bestGame.rawValue)
            } else {
                storage.removeObject(forKey: Keys.bestGame.rawValue)
            }
        }
    }
    
    
    var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrect.rawValue)
        }
        set (newValue) {
            storage.set(newValue, forKey: Keys.totalCorrect.rawValue)
            
        }
    }
    
    var totalAccuracy: Double {
        let totalQuestions = storage.integer(forKey: Keys.totalInGame.rawValue)
        if totalQuestions == 0 { return 0 }
        return Double(correctAnswers) / Double(totalQuestions)
    }
    
    func store(correct: Int, total: Int) {
        let currentResult = GameResult(correct: correct, total: total, date: Date ())
        
        if let bestResult = bestGame {
            if currentResult.correct > bestResult.correct || (currentResult.correct == bestResult.correct && currentResult.date < bestResult.date) {
                bestGame = currentResult
            }
        } else {
            bestGame = currentResult
        }
        
        correctAnswers += correct
        storage.set(storage.integer(forKey: Keys.totalInGame.rawValue) + total, forKey: Keys.totalInGame.rawValue)
        
        gamesCount += 1
    }
}





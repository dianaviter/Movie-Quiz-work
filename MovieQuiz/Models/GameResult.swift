//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Diana Viter on 22.09.2024.
//

import Foundation

struct GameResult: Codable {
    var correct: Int
    let total: Int
    let date: Date

}

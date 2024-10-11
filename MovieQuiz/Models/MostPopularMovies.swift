//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Diana Viter on 10.10.2024.
//

import Foundation

struct MostPopularMovies: Codable {
    let error: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let rating: String
    let imageURL: URL
    let title: String
    
    private enum CodingKeys: String, CodingKey {
        case rating = "imDbRating"
        case title = "fullTitle"
        case imageURL = "image"
    }
}


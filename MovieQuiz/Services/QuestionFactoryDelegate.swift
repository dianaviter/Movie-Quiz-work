//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Diana Viter on 20.09.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {              
    func didReceiveNextQuestion(question: QuizQuestion?)
}

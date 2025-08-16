//
//  TriviaResponse.swift
//  DailyTrivia
//
//  Created by Robert Woodward on 8/16/25.
//


import Foundation

struct TriviaResponse: Codable {
    let responseCode: Int
    let results: [TriviaQuestion]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

struct TriviaQuestion: Codable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

extension TriviaQuestion {
    // Combine and shuffle correct and incorrect answers
    func shuffledAnswers() -> [String] {
        var allAnswers = incorrectAnswers + [correctAnswer]
        return allAnswers.shuffled() // Randomize order
    }
}

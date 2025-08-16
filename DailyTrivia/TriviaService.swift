//
//  TriviaService.swift
//  DailyTrivia
//
//  Created by Robert Woodward on 8/16/25.
//

import Foundation

class TriviaService: ObservableObject {
    @Published var currentQuestion: TriviaQuestion?
    @Published var errorMessage: String?
    @Published var selectedAnswer: String? // Track user's selection
    @Published var isCorrect: Bool? // Track if selection is correct
    
    private let apiUrl = "https://opentdb.com/api.php?amount=1&type=multiple"
    private let lastFetchKey = "lastTriviaFetchDate"
    private let questionKey = "currentTriviaQuestion"
    
    func fetchDailyTrivia() {
        // Check if a question was already fetched today
        if let lastFetchDate = UserDefaults.standard.object(forKey: lastFetchKey) as? Date,
           Calendar.current.isDateInToday(lastFetchDate),
           let savedQuestionData = UserDefaults.standard.data(forKey: questionKey),
           let savedQuestion = try? JSONDecoder().decode(TriviaQuestion.self, from: savedQuestionData) {
            self.currentQuestion = savedQuestion
            return
        }
        
        // Fetch new question
        guard let url = URL(string: apiUrl) else {
            self.errorMessage = "Invalid API URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let triviaResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
                    if triviaResponse.responseCode == 0, let question = triviaResponse.results.first {
                        self?.currentQuestion = question
                        self?.selectedAnswer = nil // Reset selection
                        self?.isCorrect = nil // Reset correctness
                        // Save question and fetch date
                        UserDefaults.standard.set(Date(), forKey: self?.lastFetchKey ?? "")
                        if let questionData = try? JSONEncoder().encode(question) {
                            UserDefaults.standard.set(questionData, forKey: self?.questionKey ?? "")
                        }
                    } else {
                        self?.errorMessage = "Invalid API response"
                    }
                } catch {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func selectAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }
        selectedAnswer = answer
        isCorrect = (answer == question.correctAnswer)
    }
}

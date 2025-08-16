//
//  ContentView.swift
//  DailyTrivia
//
//  Created by Robert Woodward on 8/16/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var triviaService = TriviaService()
    @State private var showAnswer = false
    
    var body: some View {
        ZStack {
            // Art Deco background with gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(hex: "#2E8B57")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Title
                Text("Daily Trivia")
                    .font(.custom("Futura-Bold", size: 40))
                    .foregroundColor(Color(hex: "#FFD700"))
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                
                // Trivia card
                if let question = triviaService.currentQuestion {
                    VStack(spacing: 15) {
                        Text(question.question)
                            .font(.custom("Futura", size: 20))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        // Answer buttons
                        VStack(spacing: 10) {
                            ForEach(question.shuffledAnswers(), id: \.self) { answer in
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        triviaService.selectAnswer(answer)
                                    }
                                }) {
                                    Text(answer)
                                        .font(.custom("Futura", size: 16))
                                        .foregroundColor(.black)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(buttonColor(for: answer))
                                                .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                                        )
                                }
                                .disabled(triviaService.selectedAnswer != nil && !showAnswer) // Disable after selection
                            }
                        }
                        .padding(.horizontal)
                        
                        // Feedback text
                        if let isCorrect = triviaService.isCorrect, let selected = triviaService.selectedAnswer {
                            Text(isCorrect ? "Correct!" : "Incorrect, try again!")
                                .font(.custom("Futura", size: 18))
                                .foregroundColor(isCorrect ? Color(hex: "#2E8B57") : .red)
                                .padding(.top, 10)
                                .transition(.opacity)
                        }
                        
                        // Reveal Answer button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showAnswer.toggle()
                            }
                        }) {
                            Text(showAnswer ? "Hide Answer" : "Reveal Answer")
                                .font(.custom("Futura", size: 16))
                                .foregroundColor(.black)
                                .padding()
                                .frame(width: 200)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(hex: "#FFD700"))
                                        .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                                )
                        }
                        
                        // Correct answer display
                        if showAnswer {
                            Text("Correct Answer: \(question.correctAnswer)")
                                .font(.custom("Futura", size: 18))
                                .foregroundColor(Color(hex: "#FFD700"))
                                .padding()
                                .transition(.opacity)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(hex: "#FFD700"), lineWidth: 3)
                            )
                    )
                    .padding(.horizontal, 40)
                } else if let error = triviaService.errorMessage {
                    Text("Error: \(error)")
                        .font(.custom("Futura", size: 18))
                        .foregroundColor(.red)
                } else {
                    Text("Loading...")
                        .font(.custom("Futura", size: 18))
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
        .onAppear {
            triviaService.fetchDailyTrivia()
        }
    }
    
    // Determine button color based on selection and correctness
    private func buttonColor(for answer: String) -> Color {
        guard let selected = triviaService.selectedAnswer else {
            return Color(hex: "#FFD700") // Default gold
        }
        if showAnswer {
            // Show correct answer in green, incorrect in red
            return answer == triviaService.currentQuestion?.correctAnswer ? Color(hex: "#2E8B57") : (answer == selected ? .red : Color(hex: "#FFD700"))
        }
        // Highlight selected answer before revealing
        return answer == selected ? Color(hex: "#FFD700").opacity(0.7) : Color(hex: "#FFD700")
    }
}

// Extension for hex color support
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanString("#", into: nil)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}

# DailyTrivia

A stylish Art Deco-inspired trivia app that delivers a new multiple-choice question daily, built with Swift and SwiftUI for macOS and iOS.

## Overview

DailyTrivia fetches a random trivia question from the Open Trivia Database API and presents it with an elegant Art Deco user interface featuring gold, black, and emerald green colors. Users can select an answer from multiple-choice options and reveal the correct answer, with visual feedback for correctness. The app is designed to work seamlessly on both macOS and iOS, adapting its layout for different screen sizes.

## Features
- Fetches a new trivia question daily from [Open Trivia Database](https://opentdb.com).
- Displays multiple-choice answers with randomized order.
- Provides visual feedback (green for correct, red for incorrect) on answer selection.
- Art Deco-themed UI with gradient backgrounds, Futura font, and geometric styling.
- Cross-platform support for macOS 15.0+ and iOS 15.0+.
- Persistent storage of the daily question using UserDefaults.

## Screenshots
[macOS Screenshot](./screenshots/macos_dailytrivia.png)

## Requirements
- Xcode 15.0 or later
- macOS 15.0+ (Sequoia) or iOS 15.0+ (e.g., iPhone, iPad)
- Internet connection for API calls

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/dailytrivia.git
   cd dailytrivia

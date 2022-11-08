//
//  Question.swift
//  Quiz
//
//  Created by Kurbatov Artem on 26.04.2022.
//

import Foundation

struct Question: Decodable {
    
    var question: String?
    var answers: [String]?
    var correctAnswerIndex: Int?
    var feedback: String?
}

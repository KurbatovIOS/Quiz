//
//  QuizModel.swift
//  Quiz
//
//  Created by Kurbatov Artem on 26.04.2022.
//

import Foundation

protocol QuizProtocol {
    
    func questionsRetrieved(_ questions: [Question])
}

class QuizModel {
    
    var delegate: QuizProtocol?
    
    func getQuestions() {
        
        getRemoteJsonFile()
    }
    
    func getLocalJsonFile() {
        
        let path = Bundle.main.path(forResource: "QuestionData", ofType: "json")
        
        guard path != nil else {
            print("Path error")
            return
        }
        
        let url = URL(fileURLWithPath: path!)
                
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            let array = try decoder.decode([Question].self, from: data)
            
            delegate?.questionsRetrieved(array)
        }
        catch {
            print(error)
        }
       
    }
    
    func getRemoteJsonFile() {
        
        let url = URL(string: "https://codewithchris.com/code/QuestionData.json")
        
        guard url != nil else {
            
            print("Url error")
            return
        }
        
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, request, error in
            
            guard data != nil && error == nil else {
                print("Data task error")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let array = try decoder.decode([Question].self, from: data!)
                
                DispatchQueue.main.async {
                    self.delegate?.questionsRetrieved(array)
                }
            }
            catch {
                print(error)
            }
                  
        }
        dataTask.resume()
    }
}

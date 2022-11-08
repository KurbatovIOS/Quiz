//
//  ViewController.swift
//  Quiz
//
//  Created by Kurbatov Artem on 26.04.2022.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, ResultViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    var numCorrect = 0
    
    var resultDialog: ResultViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultDialog = storyboard?.instantiateViewController(withIdentifier: "ResultVC") as? ResultViewController
        
        resultDialog?.modalPresentationStyle = .overCurrentContext
        
        resultDialog?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        model.delegate = self
        model.getQuestions()
    }
    
    
    func slideInQuestion() {
        
        stackViewLeadingConstraint.constant = 1000
        stackViewTrailingConstraint.constant = -1000
        stackView.alpha = 0
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            
            self.stackViewLeadingConstraint.constant = 0
            self.stackViewTrailingConstraint.constant = 0
            self.stackView.alpha = 1
            self.view.layoutIfNeeded()
        } completion: { _ in
            
        }

        
        
    }
    
    func slideOutQuestion() {
        
        stackViewLeadingConstraint.constant = 0
        stackViewTrailingConstraint.constant = 0
        stackView.alpha = 1
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            
            self.stackViewLeadingConstraint.constant = -1000
            self.stackViewTrailingConstraint.constant = 1000
            self.stackView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            
        }

        
    }
    
    func displayQuestion() {
        
        guard questions.count > 0 && currentQuestionIndex < questions.count else {
            return
        }
        
        questionLabel.text = questions[currentQuestionIndex].question
        
        tableView.reloadData()
        
        slideInQuestion()
    }
    
    
    func questionsRetrieved(_ questions: [Question]) {
        
        self.questions = questions
        
        let savedIndex = StateManager.retrieveValue(key: StateManager.questionIndexKey) as? Int
        
        if savedIndex != nil && savedIndex! < self.questions.count {
            
            currentQuestionIndex = savedIndex!
            
            let savedNumCorrect = StateManager.retrieveValue(key: StateManager.numCorrectKey) as? Int
            
            if savedNumCorrect != nil {
                
                numCorrect = savedNumCorrect!
            }
        }
        
        displayQuestion()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard questions.count > 0 else {
            return 0
        }
        
        let currentQuestion = questions[currentQuestionIndex]
        
        if currentQuestion.answers != nil {
            return currentQuestion.answers!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        let label = cell.viewWithTag(1) as? UILabel
        
        if label != nil {
            
            let question = questions[currentQuestionIndex]
            
            if question.answers != nil && indexPath.row < question.answers!.count {
                
                label!.text = question.answers![indexPath.row]
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var titleText = ""
        
        
        let question = questions[currentQuestionIndex] // ERROR
        
        if question.correctAnswerIndex == indexPath.row {
            titleText = "Correct"
            numCorrect += 1
        }
        else {
            titleText = "Wrong"
        }
        
        DispatchQueue.main.async {
            self.slideOutQuestion()
        }
        
        if resultDialog != nil {
                        
            resultDialog!.titleText = titleText
            resultDialog!.feedbackText = question.feedback!
            resultDialog!.buttonText = "Next"
            
            DispatchQueue.main.async {
                
                self.present(self.resultDialog!, animated: true, completion: nil)
            }
        }
    }
    
    func dialogDismissed() {
        
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            
            if resultDialog != nil {
                            
                resultDialog!.titleText = "Summary"
                resultDialog!.feedbackText = "You got \(numCorrect) out of \(questions.count) questions"
                resultDialog!.buttonText = "Restart"
                
                present(resultDialog!, animated: true, completion: nil)
                
                StateManager.clearState()
            }
            
        }
        else if currentQuestionIndex > questions.count {
            numCorrect = 0
            currentQuestionIndex = 0
            displayQuestion()
        }
        else if currentQuestionIndex < questions.count {
         
            displayQuestion()
                
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
    }
}


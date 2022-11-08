//
//  ResultViewController.swift
//  Quiz
//
//  Created by Kurbatov Artem on 27.04.2022.
//

import UIKit

protocol ResultViewControllerProtocol {
    
    func dialogDismissed()
    
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    var delegate: ResultViewControllerProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {

        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)
        
        
        dimView.alpha = 0
        titleLabel.alpha = 0
        feedbackLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.dimView.alpha = 1
            self.titleLabel.alpha = 1
            self.feedbackLabel.alpha = 1
        }, completion: nil)
    }
    

    @IBAction func dismissTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            
            self.dimView.alpha = 0
        } completion: { completed in
            self.dismiss(animated: true, completion: nil)
            
            self.delegate?.dialogDismissed()
        }
    }
}

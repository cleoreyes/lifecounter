//
//  ViewController.swift
//  lifecounteragain
//
//  Created by Cleo Reyes on 4/21/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playerTwoLifePoints: UILabel!
    @IBOutlet weak var playerOneLifePoints: UILabel!
    var playerOneLifeScore = 20
    var playerTwoLifeScore = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playerOneLifePoints.text = String(playerOneLifeScore)
        playerTwoLifePoints.text = String(playerTwoLifeScore)
    }

    @IBOutlet weak var playerOneAnyAmountBtn: UIButton!
    
    @IBOutlet weak var player1StepperOutlet: UIStepper!
    @IBAction func player1Stepper(_ sender: UIStepper) {
        sender.maximumValue = Double.greatestFiniteMagnitude
        sender.minimumValue = -Double.greatestFiniteMagnitude
        let newAmount = Int(sender.value)
        playerOneAnyAmountBtn.setTitle(String(newAmount), for: .normal)
    }
    
    
    @IBOutlet weak var playerTwoAnyAmountBtn: UIButton!
    
    @IBOutlet weak var player2StepperOutlet: UIStepper!
    @IBAction func player2Stepper(_ sender: UIStepper) {
        sender.maximumValue = Double.greatestFiniteMagnitude
        sender.minimumValue = -Double.greatestFiniteMagnitude
        let newAmount = Int(sender.value)
        playerTwoAnyAmountBtn.setTitle(String(newAmount), for: .normal)
    }
    
    
    @IBAction func playerOneButtons(_ sender: UIButton) {
        let title = sender.titleLabel?.text ?? ""
        if (title == "+") {
            playerOneLifeScore += 1
        } else if (title == "-") {
            playerOneLifeScore -= 1
        } else if let customAmount = Int(title) {
            playerOneLifeScore += customAmount
            player1StepperOutlet.value = 0
            playerOneAnyAmountBtn.setTitle(String(0), for: .normal)
        }
        isThereALoser()
    }
    
    @IBAction func playerTwoButtons(_ sender: UIButton) {
        let title = sender.titleLabel?.text ?? ""
        if (title == "+") {
            playerTwoLifeScore += 1
        } else if (title == "-") {
            playerTwoLifeScore -= 1
        } else if let customAmount = Int(title) {
            playerTwoLifeScore += customAmount
            player2StepperOutlet.value = 0
            playerTwoAnyAmountBtn.setTitle(String(0), for: .normal)
        }
        isThereALoser()
    }
    
    @IBOutlet weak var whoIsLoser: UILabel!
    var loser = "Game is on!"
    
    func isThereALoser () {
        playerOneLifePoints.text = String(playerOneLifeScore)
        playerTwoLifePoints.text = String(playerTwoLifeScore)
        
        var isLoser = false
        
        if (playerOneLifeScore <= 0) {
            loser = "Player 1 loses!"
            isLoser = true
        } else if (playerTwoLifeScore <= 0) {
            loser = "Player 2 loses!"
            isLoser = true
        }
        
        whoIsLoser.text = loser
        
        if (isLoser) {
            view.isUserInteractionEnabled = false
        }
        
    }
    
    
    
}


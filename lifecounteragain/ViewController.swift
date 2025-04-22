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


    @IBAction func playerOneButtons(_ sender: UIButton) {
        let title = (sender.titleLabel!.text!)
        if (title == "+") {
            playerOneLifeScore += 1
        } else if (title == "+5") {
            playerOneLifeScore += 5
        } else if (title == "-") {
            playerOneLifeScore -= 1
        } else if (title == "-5") {
            playerOneLifeScore -= 5
        }
        isThereALoser()
    }
    
    @IBAction func playerTwoButtons(_ sender: UIButton) {
        let title = (sender.titleLabel!.text!)
        if (title == "+") {
            playerTwoLifeScore += 1
        } else if (title == "+5") {
            playerTwoLifeScore += 5
        } else if (title == "-") {
            playerTwoLifeScore -= 1
        } else if (title == "-5") {
            playerTwoLifeScore -= 5
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


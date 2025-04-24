//
//  ViewController.swift
//  lifecounteragain
//
//  Created by Cleo Reyes on 4/21/25.
//

import UIKit

struct Player {
    var lifeTotal: Int = 20
    var label: UILabel?
    var plusButton: UIButton?
    var minusButton: UIButton?
    var customButton: UIButton?
    var stepper: UIStepper?
}

class GameHistory {
    static var events = [GameEvent]()
    
    static func addEvent(_ message: String) {
        events.append(GameEvent(message: message))
    }
}

class ViewController: UIViewController {
    
    var players: [Player] = []
    let maxPlayers = 8
    var gameStarted = false
    
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var whoIsLoser: UILabel!
    var loser = "Game is on!"
    
    @IBOutlet weak var playerTwoLifePoints: UILabel!
    @IBOutlet weak var playerOneLifePoints: UILabel!
    @IBOutlet weak var playerOneAnyAmountBtn: UIButton!
    @IBOutlet weak var player1StepperOutlet: UIStepper!
    @IBOutlet weak var playerTwoAnyAmountBtn: UIButton!
    @IBOutlet weak var player2StepperOutlet: UIStepper!
    @IBOutlet weak var historyButton: UIButton!
    
    @objc func playerButtonTapped(_ sender: UIButton) {
            gameStarted = true
            addPlayerButton.isEnabled = false
            
            let playerIndex = sender.tag
            let title = sender.titleLabel?.text ?? ""
            
            if (title == "+") {
                players[playerIndex].lifeTotal += 1
                GameHistory.addEvent("Player \(playerIndex + 1) gained one life.")
            } else if (title == "-") {
                players[playerIndex].lifeTotal -= 1
                GameHistory.addEvent("Player \(playerIndex + 1) lost one life.")
            } else if let customAmount = Int(title) {
                players[playerIndex].lifeTotal += customAmount
                
                if customAmount != 0 {
                    let gainOrLost = customAmount > 0 ? "gained" : "lost"
                    let absAmount = abs(customAmount)
                    GameHistory.addEvent("Player \(playerIndex + 1) \(gainOrLost) \(absAmount) life.")
                }
                
                players[playerIndex].stepper?.value = 0
                players[playerIndex].customButton?.setTitle("0", for: .normal)
            }
            
            updateAllPlayerViews()
            checkForGameOver()
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialPlayers()
    }
    
    func setupInitialPlayers() {
        let player1 = Player(lifeTotal: 20, label: playerOneLifePoints, plusButton: nil, minusButton: nil, 
                            customButton: playerOneAnyAmountBtn, stepper: player1StepperOutlet)
        let player2 = Player(lifeTotal: 20, label: playerTwoLifePoints, plusButton: nil, minusButton: nil, 
                            customButton: playerTwoAnyAmountBtn, stepper: player2StepperOutlet)
        
        players.append(player1)
        players.append(player2)
        
        addPlayer()
        addPlayer()
        
        updateAllPlayerViews()
    }
    
    @IBAction func addPlayerButtonTapped(_ sender: UIButton) {
        if players.count < maxPlayers && !gameStarted {
            addPlayer()
        }
    }
    
    func addPlayer() {
        if players.count < maxPlayers {
            let newPlayer = Player(lifeTotal: 20)
            players.append(newPlayer)
            
            createPlayerView(for: players.count - 1)
            
            updatePlayerCountDisplay()
        }
        
        addPlayerButton.isEnabled = players.count < maxPlayers
    }
    
    @IBOutlet weak var playersStackView: UIStackView!
    func createPlayerView(for index: Int) {
        let playerView = UIView()
        playerView.tag = 1000 + index
        
        let nameLabel = UILabel()
        nameLabel.text = "Player \(index + 1)"
        nameLabel.textAlignment = .center
        
        let lifeLabel = UILabel()
        lifeLabel.text = "20"
        lifeLabel.textAlignment = .center
        lifeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        players[index].label = lifeLabel
        
        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.tag = index
        plusButton.addTarget(self, action: #selector(playerButtonTapped(_:)), for: .touchUpInside)
        
        let minusButton = UIButton(type: .system)
        minusButton.setTitle("-", for: .normal)
        minusButton.tag = index
        minusButton.addTarget(self, action: #selector(playerButtonTapped(_:)), for: .touchUpInside)
        
        let customButton = UIButton(type: .system)
        customButton.setTitle("0", for: .normal)
        customButton.tag = index
        customButton.addTarget(self, action: #selector(playerButtonTapped(_:)), for: .touchUpInside)
        
        let stepper = UIStepper()
        stepper.tag = index
        stepper.maximumValue = Double.greatestFiniteMagnitude
        stepper.minimumValue = -Double.greatestFiniteMagnitude
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        players[index].plusButton = plusButton
        players[index].minusButton = minusButton
        players[index].customButton = customButton
        players[index].stepper = stepper
        
        let buttonStack = UIStackView(arrangedSubviews: [plusButton, minusButton, customButton, stepper])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 8
        
        let playerStack = UIStackView(arrangedSubviews: [nameLabel, lifeLabel, buttonStack])
        playerStack.axis = .vertical
        playerStack.spacing = 8
        playerStack.alignment = .center
        
        playersStackView.addArrangedSubview(playerStack)
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        let playerIndex = sender.tag
        let newAmount = Int(sender.value)
        players[playerIndex].customButton?.setTitle(String(newAmount), for: .normal)
    }
    
    func updateAllPlayerViews() {
        if players.count >= 1 {
            playerOneLifePoints.text = String(players[0].lifeTotal)
        }
        
        if players.count >= 2 {
            playerTwoLifePoints.text = String(players[1].lifeTotal)
        }
        
        for (index, player) in players.enumerated() {
            player.label?.text = String(player.lifeTotal)
        }
    }
    
    func updatePlayerCountDisplay() {
    }
    
    func checkForGameOver() {
            var isGameOver = false
            
            for (index, player) in players.enumerated() {
                if player.lifeTotal <= 0 {
                    loser = "Player \(index + 1) loses!"
                    GameHistory.addEvent("Player \(index + 1) lost the game.")
                    isGameOver = true
                    break
                }
            }
            
            whoIsLoser.text = isGameOver ? loser : "Game is on!"
            
            if isGameOver {
                view.isUserInteractionEnabled = false
            }
        }
    
    @IBAction func player1Stepper(_ sender: UIStepper) {
        sender.maximumValue = Double.greatestFiniteMagnitude
        sender.minimumValue = -Double.greatestFiniteMagnitude
        let newAmount = Int(sender.value)
        playerOneAnyAmountBtn.setTitle(String(newAmount), for: .normal)
    }
    
    @IBAction func player2Stepper(_ sender: UIStepper) {
        sender.maximumValue = Double.greatestFiniteMagnitude
        sender.minimumValue = -Double.greatestFiniteMagnitude
        let newAmount = Int(sender.value)
        playerTwoAnyAmountBtn.setTitle(String(newAmount), for: .normal)
    }
    
    @IBAction func playerOneButtons(_ sender: UIButton) {
            gameStarted = true
            addPlayerButton.isEnabled = false
            
            let title = sender.titleLabel?.text ?? ""
            if (title == "+") {
                players[0].lifeTotal += 1
                GameHistory.addEvent("Player 1 gained one life.")
            } else if (title == "-") {
                players[0].lifeTotal -= 1
                GameHistory.addEvent("Player 1 lost one life.")
            } else if let customAmount = Int(title) {
                players[0].lifeTotal += customAmount
                
                if customAmount != 0 {
                    let gainOrLost = customAmount > 0 ? "gained" : "lost"
                    let absAmount = abs(customAmount)
                    GameHistory.addEvent("Player 1 \(gainOrLost) \(absAmount) life.")
                }
                
                player1StepperOutlet.value = 0
                playerOneAnyAmountBtn.setTitle(String(0), for: .normal)
            }
            updateAllPlayerViews()
            checkForGameOver()
        }
    
    
    @IBAction func playerTwoButtons(_ sender: UIButton) {
            gameStarted = true
            addPlayerButton.isEnabled = false
            
            let title = sender.titleLabel?.text ?? ""
            if (title == "+") {
                players[1].lifeTotal += 1
                GameHistory.addEvent("Player 2 gained one life.")
            } else if (title == "-") {
                players[1].lifeTotal -= 1
                GameHistory.addEvent("Player 2 lost one life.")
            } else if let customAmount = Int(title) {
                players[1].lifeTotal += customAmount
                
                if customAmount != 0 {
                    let gainOrLost = customAmount > 0 ? "gained" : "lost"
                    let absAmount = abs(customAmount)
                    GameHistory.addEvent("Player 2 \(gainOrLost) \(absAmount) life.")
                }
                
                player2StepperOutlet.value = 0
                playerTwoAnyAmountBtn.setTitle(String(0), for: .normal)
            }
            updateAllPlayerViews()
            checkForGameOver()
        }
    
    @IBAction func showHistoryTapped(_ sender: UIButton) {
            performSegue(withIdentifier: "showHistory", sender: self)
        }
}

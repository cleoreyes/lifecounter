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

class ViewController: UIViewController {
    
    // Collection to hold all players
    var players: [Player] = []
    let maxPlayers = 8
    var gameStarted = false
    
    // Container for player views
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var whoIsLoser: UILabel!
    var loser = "Game is on!"
    
    // Keep existing outlets for backward compatibility
    @IBOutlet weak var playerTwoLifePoints: UILabel!
    @IBOutlet weak var playerOneLifePoints: UILabel!
    @IBOutlet weak var playerOneAnyAmountBtn: UIButton!
    @IBOutlet weak var player1StepperOutlet: UIStepper!
    @IBOutlet weak var playerTwoAnyAmountBtn: UIButton!
    @IBOutlet weak var player2StepperOutlet: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize with 4 players
        setupInitialPlayers()
    }
    
    func setupInitialPlayers() {
        // Add first two players using existing UI elements
        let player1 = Player(lifeTotal: 20, label: playerOneLifePoints, plusButton: nil, minusButton: nil, 
                            customButton: playerOneAnyAmountBtn, stepper: player1StepperOutlet)
        let player2 = Player(lifeTotal: 20, label: playerTwoLifePoints, plusButton: nil, minusButton: nil, 
                            customButton: playerTwoAnyAmountBtn, stepper: player2StepperOutlet)
        
        players.append(player1)
        players.append(player2)
        
        // Add two more players programmatically
        addPlayer()
        addPlayer()
        
        // Update all UI
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
            
            // Create UI for new player
            createPlayerView(for: players.count - 1)
            
            // Update player count label if you have one
            updatePlayerCountDisplay()
        }
        
        // Disable add button if max is reached
        addPlayerButton.isEnabled = players.count < maxPlayers
    }
    
    @IBOutlet weak var playersStackView: UIStackView!
    func createPlayerView(for index: Int) {
        // Create a container for this player
        let playerView = UIView()
        playerView.tag = 1000 + index // Tag for identification
        
        // Create player label
        let nameLabel = UILabel()
        nameLabel.text = "Player \(index + 1)"
        nameLabel.textAlignment = .center
        
        // Create life total label
        let lifeLabel = UILabel()
        lifeLabel.text = "20"
        lifeLabel.textAlignment = .center
        lifeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // Store the label reference
        players[index].label = lifeLabel
        
        // Create buttons
        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.tag = index
        plusButton.addTarget(self, action: #selector(playerButtonTapped(_:)), for: .touchUpInside)
        
        let minusButton = UIButton(type: .system)
        minusButton.setTitle("-", for: .normal)
        minusButton.tag = index
        minusButton.addTarget(self, action: #selector(playerButtonTapped(_:)), for: .touchUpInside)
        
        // Create custom amount button and stepper
        let customButton = UIButton(type: .system)
        customButton.setTitle("0", for: .normal)
        customButton.tag = index
        customButton.addTarget(self, action: #selector(playerButtonTapped(_:)), for: .touchUpInside)
        
        let stepper = UIStepper()
        stepper.tag = index
        stepper.maximumValue = Double.greatestFiniteMagnitude
        stepper.minimumValue = -Double.greatestFiniteMagnitude
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        // Store references
        players[index].plusButton = plusButton
        players[index].minusButton = minusButton
        players[index].customButton = customButton
        players[index].stepper = stepper
        
        // Create horizontal stack for buttons
        let buttonStack = UIStackView(arrangedSubviews: [plusButton, minusButton, customButton, stepper])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 8
        
        // Create vertical stack for the player
        let playerStack = UIStackView(arrangedSubviews: [nameLabel, lifeLabel, buttonStack])
        playerStack.axis = .vertical
        playerStack.spacing = 8
        playerStack.alignment = .center
        
        // Add to main stack view
        playersStackView.addArrangedSubview(playerStack)
    }
    
    @objc func playerButtonTapped(_ sender: UIButton) {
        gameStarted = true
        addPlayerButton.isEnabled = false
        
        let playerIndex = sender.tag
        let title = sender.titleLabel?.text ?? ""
        
        if (title == "+") {
            players[playerIndex].lifeTotal += 1
        } else if (title == "-") {
            players[playerIndex].lifeTotal -= 1
        } else if let customAmount = Int(title) {
            players[playerIndex].lifeTotal += customAmount
            
            // Reset stepper and button
            players[playerIndex].stepper?.value = 0
            players[playerIndex].customButton?.setTitle("0", for: .normal)
        }
        
        updateAllPlayerViews()
        checkForGameOver()
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        let playerIndex = sender.tag
        let newAmount = Int(sender.value)
        players[playerIndex].customButton?.setTitle(String(newAmount), for: .normal)
    }
    
    func updateAllPlayerViews() {
        // Update the first two players using existing UI elements
        if players.count >= 1 {
            playerOneLifePoints.text = String(players[0].lifeTotal)
        }
        
        if players.count >= 2 {
            playerTwoLifePoints.text = String(players[1].lifeTotal)
        }
        
        // Update all player labels
        for (index, player) in players.enumerated() {
            player.label?.text = String(player.lifeTotal)
        }
    }
    
    func updatePlayerCountDisplay() {
        // If you have a label showing player count, update it here
    }
    
    func checkForGameOver() {
        var isGameOver = false
        
        for (index, player) in players.enumerated() {
            if player.lifeTotal <= 0 {
                loser = "Player \(index + 1) loses!"
                isGameOver = true
                break
            }
        }
        
        whoIsLoser.text = isGameOver ? loser : "Game is on!"
        
        if isGameOver {
            view.isUserInteractionEnabled = false
        }
    }
    
    // Keep existing IBAction methods for backward compatibility
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
        } else if (title == "-") {
            players[0].lifeTotal -= 1
        } else if let customAmount = Int(title) {
            players[0].lifeTotal += customAmount
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
        } else if (title == "-") {
            players[1].lifeTotal -= 1
        } else if let customAmount = Int(title) {
            players[1].lifeTotal += customAmount
            player2StepperOutlet.value = 0
            playerTwoAnyAmountBtn.setTitle(String(0), for: .normal)
        }
        updateAllPlayerViews()
        checkForGameOver()
    }
}

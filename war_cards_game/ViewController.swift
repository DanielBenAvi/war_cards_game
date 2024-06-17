//
//  ViewController.swift
//  war_cards_game
//
//  Created by דניאל בן אבי on 17/06/2024.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var rightPlayerImage: UIImageView!

    @IBOutlet weak var leftPlayerImage: UIImageView!
    
    @IBOutlet weak var gameLabel: UILabel!
    
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var leftLabel: UILabel!
        
    @IBOutlet weak var rightDeck: UIImageView!
    
    @IBOutlet weak var leftDeck: UIImageView!
    
    @IBOutlet weak var counterLabel: UILabel!
    
    var gameManager = GameManager()
    var turnStatus = 0
    
    var originalRightPlayerCenter: CGPoint = CGPoint()
    var originalLeftPlayerCenter: CGPoint = CGPoint()
    var originalRightDeckCenter: CGPoint = CGPoint()
    var originalLeftDeckCenter: CGPoint = CGPoint()
    
    var timer: Timer?
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalRightPlayerCenter = rightPlayerImage.center
        originalLeftPlayerCenter = leftPlayerImage.center
        originalRightDeckCenter = rightDeck.center
        originalLeftDeckCenter = leftDeck.center
        
        updateLabels(gameLabelText: "Press Start Turn to begin")
        
        timer?.invalidate() // stop the timer
        timer = Timer.scheduledTimer(timeInterval: TIME_COUNT, target: self, selector: #selector(updateTimerUI), userInfo: nil, repeats: true)
        
        timer = Timer.scheduledTimer(timeInterval: TIME_INTERVAL_ACTION, target: self, selector: #selector(autoPlayer), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTimerUI() {
        counter += 1
        counterLabel.text = "\(counter)"
    }
    
    
    @objc func autoPlayer() {
        if turnStatus % NUBER_OF_PLAYERS == 0{
            startTurn()
        } else {
            endTurn()
        }
    }
    
    
    
    deinit {
        timer?.invalidate()
    }

    @IBAction func makeTurn(_ sender: Any) {
        if turnStatus % NUBER_OF_PLAYERS == 0{
            startTurn()
        } else {
            endTurn()
        }
        
    }
    
    func updateLabels(gameLabelText: String){
        leftLabel.text = "\(self.gameManager.leftPlayer.name) \(gameManager.leftPlayer.getScore())"
        rightLabel.text = "\(self.gameManager.rightPlayer.name) \(gameManager.rightPlayer.getScore())"
        gameLabel.text = gameLabelText
    }
    
    
       
    func startTurn() {
        updateLabels(gameLabelText: "Press End Turn to finish")

        animateStartTurn()
        turnStatus += 1
    }
       
    func endTurn() {
        if !gameManager.isGameOver() {
            animateEndTurn()
        }
        updateLabels(gameLabelText: gameManager.getGameStatus())
        turnStatus += 1
    }
    
    func animateStartTurn() {
        // Set the rightPlayerImage to the center of the rightDeck initially
        rightPlayerImage.center = rightDeck.center
        // Set the leftPlayerImage to the center of the leftDeck initially
        leftPlayerImage.center = leftDeck.center
        
        // Set the initial scale to a very small value
        rightPlayerImage.transform = CGAffineTransform(scaleX: SMALL_SCALE, y: SMALL_SCALE)
        leftPlayerImage.transform = CGAffineTransform(scaleX: SMALL_SCALE, y: SMALL_SCALE)
        
        // Set the images for the players
        leftPlayerImage.image = UIImage(named: gameManager.leftPlayer.getCardName())
        rightPlayerImage.image = UIImage(named: gameManager.rightPlayer.getCardName())
        
        leftPlayerImage.layer.zPosition = Z_POSITION
        rightPlayerImage.layer.zPosition = Z_POSITION
        
        // Animate the position and scale
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            self.rightPlayerImage.center = self.originalRightPlayerCenter
            self.rightPlayerImage.transform = CGAffineTransform.identity // Reset scale to original
            
            self.leftPlayerImage.center = self.originalLeftPlayerCenter
            self.leftPlayerImage.transform = CGAffineTransform.identity // Reset scale to original
        })
    }
    
    func animateEndTurn() {
        var animationCenter: CGPoint
        var targetDeckCenter: CGPoint
        
        // Determine which player won the turn
        if gameManager.makeTurn() == Direction.player_left_direction {
            animationCenter = self.originalLeftDeckCenter
            targetDeckCenter = self.originalRightDeckCenter
        } else {
            animationCenter = self.originalRightDeckCenter
            targetDeckCenter = self.originalLeftDeckCenter
        }
        
        // Animate both player images to the target deck center and scale down
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            self.rightPlayerImage.center = animationCenter
            self.rightPlayerImage.transform = CGAffineTransform(scaleX: SMALL_SCALE, y: SMALL_SCALE)
            
            self.leftPlayerImage.center = animationCenter
            self.leftPlayerImage.transform = CGAffineTransform(scaleX: SMALL_SCALE, y: SMALL_SCALE)
        }, completion: { _ in
            // Set images to empty after animation
            self.leftPlayerImage.image = EMPTY_IMAGE
            self.rightPlayerImage.image = EMPTY_IMAGE
            
            // Reset positions to original deck centers
            self.rightPlayerImage.center = targetDeckCenter
            self.leftPlayerImage.center = targetDeckCenter
            
            // Reset scale to original
            self.rightPlayerImage.transform = CGAffineTransform.identity
            self.leftPlayerImage.transform = CGAffineTransform.identity
        })
    }

    
}


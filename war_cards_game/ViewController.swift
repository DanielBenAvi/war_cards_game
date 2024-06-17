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
    
    @IBOutlet weak var turnButton: UIButton!
    
    @IBOutlet weak var rightDeck: UIImageView!
    
    @IBOutlet weak var leftDeck: UIImageView!
    
    var gameManager = GameManager()
    var turnStatus = 0
    
    var originalRightPlayerCenter: CGPoint = CGPoint()
    var originalLeftPlayerCenter: CGPoint = CGPoint()
    var originalRightDeckCenter: CGPoint = CGPoint()
    var originalLeftDeckCenter: CGPoint = CGPoint()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        originalRightPlayerCenter = rightPlayerImage.center
        originalLeftPlayerCenter = leftPlayerImage.center
        originalRightDeckCenter = rightDeck.center
        originalLeftDeckCenter = leftDeck.center
        
        updateLabels(gameLabelText: "Press Start Turn to begin")
        
    }

    @IBAction func makeTurn(_ sender: Any) {
        if turnStatus % 2 == 0{
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

        // Set the rightPlayerImage to the center of the rightDeck initially
        rightPlayerImage.center = rightDeck.center
        // Set the leftPlayerImage to the center of the leftDeck initially
        leftPlayerImage.center = leftDeck.center

        // Set the initial scale to a very small value
        rightPlayerImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        leftPlayerImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        // Set the images for the players
        leftPlayerImage.image = UIImage(named: gameManager.leftPlayer.getCardName())
        rightPlayerImage.image = UIImage(named: gameManager.rightPlayer.getCardName())
        
        leftPlayerImage.layer.zPosition = 1
        rightPlayerImage.layer.zPosition = 1

        // Animate the position and scale
        UIView.animate(withDuration: 1.0, animations: {
            self.rightPlayerImage.center = self.originalRightPlayerCenter
            self.rightPlayerImage.transform = CGAffineTransform.identity // Reset scale to original

            self.leftPlayerImage.center = self.originalLeftPlayerCenter
            self.leftPlayerImage.transform = CGAffineTransform.identity // Reset scale to original
        })

        turnStatus += 1
        turnButton.setTitle("End Turn", for: .normal)
    }
    
    func endTurn() {
        if !gameManager.isGameOver() {
            
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
            UIView.animate(withDuration: 1.0, animations: {
                self.rightPlayerImage.center = animationCenter
                self.rightPlayerImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
                self.leftPlayerImage.center = animationCenter
                self.leftPlayerImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { _ in
                // Set images to empty after animation
                self.leftPlayerImage.image = UIImage(named: "empty")
                self.rightPlayerImage.image = UIImage(named: "empty")
                
                // Reset positions to original deck centers
                self.rightPlayerImage.center = targetDeckCenter
                self.leftPlayerImage.center = targetDeckCenter
                
                // Reset scale to original
                self.rightPlayerImage.transform = CGAffineTransform.identity
                self.leftPlayerImage.transform = CGAffineTransform.identity
            })
        }
        updateLabels(gameLabelText: gameManager.getGameStatus())
        turnStatus += 1
        turnButton.setTitle("Start Turn", for: .normal)
    }

    
}


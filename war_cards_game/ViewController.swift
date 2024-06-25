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
    
    @IBOutlet weak var play_pause_btn: UIButton!
    
    var gameManager = GameManager()
    var turnStatus = 0
    
    var originalRightPlayerCenter: CGPoint = CGPoint()
    var originalLeftPlayerCenter: CGPoint = CGPoint()
    var originalRightDeckCenter: CGPoint = CGPoint()
    var originalLeftDeckCenter: CGPoint = CGPoint()
    
    
    var counterManager = Counter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalRightPlayerCenter = rightPlayerImage.center
        originalLeftPlayerCenter = leftPlayerImage.center
        originalRightDeckCenter = rightDeck.center
        originalLeftDeckCenter = leftDeck.center
        
        updateLabels()
        
        counterManager.delegate = self
        counterManager.startCounter()
        
        leftDeck.layer.zPosition = 0
        rightDeck.layer.zPosition = 0
        
    }
    
    
    
    deinit {
        counterManager.stopCounter()
    }

    
    func updateLabels(){
        leftLabel.text = "\(self.gameManager.leftPlayer.name) \(gameManager.leftPlayer.getScore())"
        rightLabel.text = "\(self.gameManager.rightPlayer.name) \(gameManager.rightPlayer.getScore())"
    }
    
    
       
    func startTurn() {
        updateLabels()
        animateStartTurn()
        turnStatus += 1
    }
       
    func endTurn() {
        if !gameManager.isGameOver() {
            animateEndTurn()
        }
        updateLabels()
        turnStatus += 1
    }
    
    
    @IBAction func pauseGame(_ sender: Any) {
        if counterManager.isPaused {
            counterManager.resumeCounter()
            play_pause_btn.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            counterManager.pauseCounter()
            play_pause_btn.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    func animateStartTurn() {
        // Set the rightPlayerImage to the center of the rightDeck initially
        rightPlayerImage.center = rightDeck.center
        // Set the leftPlayerImage to the center of the leftDeck initially
        leftPlayerImage.center = leftDeck.center
        
        // Set the initial scale to a very small value
        rightPlayerImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        leftPlayerImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        // Set the initial images to the card decks
        leftPlayerImage.image = UIImage(named: "card-deck-left")
        rightPlayerImage.image = UIImage(named: "card-deck-right")
        
        leftPlayerImage.layer.zPosition = Z_POSITION
        rightPlayerImage.layer.zPosition = Z_POSITION
        
        // Animate the position and scale
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            self.rightPlayerImage.center = self.originalRightPlayerCenter
            self.rightPlayerImage.transform = CGAffineTransform.identity // Reset scale to original
            
            self.leftPlayerImage.center = self.originalLeftPlayerCenter
            self.leftPlayerImage.transform = CGAffineTransform.identity // Reset scale to original
        }) { _ in
            // Flip animation after position and scale animation
            UIView.transition(with: self.rightPlayerImage, duration: FLIP_ANIMATION_DURATION, options: .transitionFlipFromRight, animations: {
                self.rightPlayerImage.image = UIImage(named: self.gameManager.rightPlayer.getCardName())
            }, completion: nil)
            UIView.transition(with: self.leftPlayerImage, duration: FLIP_ANIMATION_DURATION, options: .transitionFlipFromLeft, animations: {
                self.leftPlayerImage.image = UIImage(named: self.gameManager.leftPlayer.getCardName())
            }, completion: nil)
        }
    }

    
    func animateEndTurn() {
        var animationCenter: CGPoint
        var targetDeckCenter: CGPoint
        
        // Move cards behind the deck by adjusting zPosition
        self.rightPlayerImage.layer.zPosition = -1
        self.leftPlayerImage.layer.zPosition = -1
        
        // Determine which player won the turn
        if gameManager.makeTurn() == Direction.player_left_direction {
            animationCenter = self.originalLeftDeckCenter
            targetDeckCenter = self.originalRightDeckCenter
        } else {
            animationCenter = self.originalRightDeckCenter
            targetDeckCenter = self.originalLeftDeckCenter
        }
        
        // Flip the cards before moving them
        UIView.transition(with: self.rightPlayerImage, duration: FLIP_ANIMATION_DURATION, options: .transitionFlipFromLeft, animations: {
            self.rightPlayerImage.image = UIImage(named: "card-deck-right")
        }, completion: nil)
        
        UIView.transition(with: self.leftPlayerImage, duration: FLIP_ANIMATION_DURATION, options: .transitionFlipFromRight, animations: {
            self.leftPlayerImage.image = UIImage(named: "card-deck-left")
        }) { _ in
            // Animate both player images to the target deck center and scale down
            UIView.animate(withDuration: ANIMATION_DURATION, animations: {
                self.rightPlayerImage.center = animationCenter
                self.rightPlayerImage.transform = CGAffineTransform(scaleX: SMALL_SCALE, y: SMALL_SCALE)
                
                self.leftPlayerImage.center = animationCenter
                self.leftPlayerImage.transform = CGAffineTransform(scaleX: SMALL_SCALE, y: SMALL_SCALE)
            }) { _ in
                // Reset images to empty after animation
                self.leftPlayerImage.image = EMPTY_IMAGE
                self.rightPlayerImage.image = EMPTY_IMAGE
                
                // Reset positions to original deck centers
                self.rightPlayerImage.center = targetDeckCenter
                self.leftPlayerImage.center = targetDeckCenter
                
                // Reset scale to original
                self.rightPlayerImage.transform = CGAffineTransform.identity
                self.leftPlayerImage.transform = CGAffineTransform.identity
                

            }
        }
    }





    
}

extension ViewController: CounterDelegate {
    func cb_autoPlayer() {
        if turnStatus % NUBER_OF_PLAYERS == 0{
            startTurn()
        } else {
            endTurn()
        }
    }
    
    
    func cb_updateCounterLabel(with count: Int) {
        counterLabel.text = "\(count)"
    }
}


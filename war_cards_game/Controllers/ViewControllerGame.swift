//
//  ViewController.swift
//  war_cards_game
//
//  Created by דניאל בן אבי on 17/06/2024.
//

import UIKit

class ViewControllerGame: UIViewController {
    
    
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
        
        // load the name of the player
        let name = UserDefaults.standard.string(forKey: "name")
        let _longitude = UserDefaults.standard.double(forKey: "longitude")
        
        
        if _longitude >= CENTER_Y_CONSTRAINT {
            gameManager.rightPlayer.setName(name: name!)
            gameManager.leftPlayer.setName(name: "Computer")
        }else{
            gameManager.leftPlayer.setName(name: name!)
            gameManager.rightPlayer.setName(name: "Computer")
        }
        
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
        if gameManager.isGameOver() {
            // End the game
            counterManager.stopCounter()
            
            // save the score of the winner
            let winner = gameManager.getWinner()
            UserDefaults.standard.set(winner.getScore(), forKey: "WinnerScore")
            UserDefaults.standard.set(winner.name, forKey: "WinnerName")
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let ViewControllerEnd = storyboard.instantiateViewController(withIdentifier: "ViewControllerEnd") as? ViewControllerEnd {
                self.present(ViewControllerEnd, animated: true, completion: nil)
            }
        }

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
        gameManager.turnNumber += 1
        

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
    

}

extension ViewControllerGame: CounterDelegate {
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




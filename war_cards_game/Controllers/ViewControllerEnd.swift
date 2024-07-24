//
//  ViewControllerEnd.swift
//  war_cards_game
//
//  Created by דניאל בן אבי on 24/07/2024.
//

import Foundation
import UIKit

class ViewControllerEnd: UIViewController {
    
    
    @IBOutlet weak var UILabel_winner: UILabel!
    
    @IBOutlet weak var UILabel_score: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let winner = UserDefaults.standard.string(forKey: "WinnerName")
        let score = UserDefaults.standard.integer(forKey: "WinnerScore")
        
        UILabel_winner.text = "The winner is: \(winner!)"
        UILabel_score.text = "With a score of: \(score)"
        
    }
    
    @IBAction func ReturnToStart(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let ViewControllerStart = storyboard.instantiateViewController(withIdentifier: "ViewControllerStart") as? ViewControllerStart {
            self.present(ViewControllerStart, animated: true, completion: nil)
        }
        
    }
}

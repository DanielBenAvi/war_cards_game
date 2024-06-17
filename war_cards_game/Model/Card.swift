//
//  Card.swift
//  war_cards_game
//
//  Created by דניאל בן אבי on 17/06/2024.
//

import Foundation

class Card{
    let power: Int
    let image: String
    
    init(power: Int, image: String){
        self.power = power
        self.image = image
    }
    
    
    // compare between two cards
    func compare(card: Card) -> Int{
        if self.power > card.power{
            return 1
        }else if self.power < card.power{
            return -1
        }else{
            return 0
        }
    }
    
    
}

//
//  Player.swift
//  war_cards_game
//
//  Created by דניאל בן אבי on 17/06/2024.
//

import Foundation

class Player{
    let name: String
    var cards: [Card]
    
    init(name: String, cards: [Card]){
        self.name = name
        self.cards = cards
        self.cards.shuffle()
    }
    
    func getCard() -> Card{
        let card = self.cards.removeFirst()
        print("\(self.name) removed a card - now has \(self.cards.count) cards")
        return card
    }
    
    func addCards(cards: [Card]){
        print("Before adding cards, \(self.name) has \(self.cards.count) cards")
        self.cards.append(contentsOf: cards)
        print("After adding cards, \(self.name) has \(self.cards.count) cards\n")
    }
    
    func getCardName() -> String{
        return self.cards[0].getImage()
    }
    
    func getScore() -> Int{
        return self.cards.count
    }
    
    func getCardScore() -> Int{
        return self.cards[0].power
    }
    
}

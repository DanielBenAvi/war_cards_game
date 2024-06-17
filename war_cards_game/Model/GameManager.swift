//
//  GameManager.swift
//  war_cards_game
//
//  Created by דניאל בן אבי on 17/06/2024.
//

import Foundation

class GameManager{
    
    var cards: [Card]
    var leftPlayer: Player
    var rightPlayer: Player
    
    init() {
        self.cards = [
            Card(power: 2, image: "2_of_clubs"),
            Card(power: 3, image: "3_of_clubs"),
            Card(power: 4, image: "4_of_clubs"),
            Card(power: 5, image: "5_of_clubs"),
            Card(power: 6, image: "6_of_clubs"),
            Card(power: 7, image: "7_of_clubs"),
            Card(power: 8, image: "8_of_clubs"),
            Card(power: 9, image: "9_of_clubs"),
            Card(power: 10, image: "10_of_clubs"),
            Card(power: 11, image: "jack_of_clubs"),
            Card(power: 12, image: "queen_of_clubs"),
            Card(power: 13, image: "king_of_clubs"),
            Card(power: 14, image: "ace_of_clubs"),
            
            Card(power: 2, image: "2_of_diamonds"),
            Card(power: 3, image: "3_of_diamonds"),
            Card(power: 4, image: "4_of_diamonds"),
            Card(power: 5, image: "5_of_diamonds"),
            Card(power: 6, image: "6_of_diamonds"),
            Card(power: 7, image: "7_of_diamonds"),
            Card(power: 8, image: "8_of_diamonds"),
            Card(power: 9, image: "9_of_diamonds"),
            Card(power: 10, image: "10_of_diamonds"),
            Card(power: 11, image: "jack_of_diamonds"),
            Card(power: 12, image: "queen_of_diamonds"),
            Card(power: 13, image: "king_of_diamonds"),
            Card(power: 14, image: "ace_of_diamonds"),
            
            Card(power: 2, image: "2_of_hearts"),
            Card(power: 3, image: "3_of_hearts"),
            Card(power: 4, image: "4_of_hearts"),
            Card(power: 5, image: "5_of_hearts"),
            Card(power: 6, image: "6_of_hearts"),
            Card(power: 7, image: "7_of_hearts"),
            Card(power: 8, image: "8_of_hearts"),
            Card(power: 9, image: "9_of_hearts"),
            Card(power: 10, image: "10_of_hearts"),
            Card(power: 11, image: "jack_of_hearts"),
            Card(power: 12, image: "queen_of_hearts"),
            Card(power: 13, image: "king_of_hearts"),
            Card(power: 14, image: "ace_of_hearts"),
            
            Card(power: 2, image: "2_of_spades"),
            Card(power: 3, image: "3_of_spades"),
            Card(power: 4, image: "4_of_spades"),
            Card(power: 5, image: "5_of_spades"),
            Card(power: 6, image: "6_of_spades"),
            Card(power: 7, image: "7_of_spades"),
            Card(power: 8, image: "8_of_spades"),
            Card(power: 9, image: "9_of_spades"),
            Card(power: 10, image: "10_of_spades"),
            Card(power: 11, image: "jack_of_spades"),
            Card(power: 12, image: "queen_of_spades"),
            Card(power: 13, image: "king_of_spades"),
            Card(power: 14, image: "ace_of_spades"),
            
            Card(power: 15, image: "black_joker"),
            Card(power: 15, image: "red_joker")
            
            ]
        
        // split the cards between the players
        let half = self.cards.count / 2
        self.cards.shuffle()
        let leftPlayerCards = Array(self.cards[0..<half])
        let rightPlayerCards = Array(self.cards[half..<self.cards.count])
            
        self.leftPlayer = Player(name: "Left Player", cards: leftPlayerCards) // left
        self.rightPlayer = Player(name: "Right Player", cards: rightPlayerCards) // right
    }
    
    func makeTurn() -> Direction{
        var direction = Direction.default_direction
        
        let left_open_card = self.leftPlayer.getCard()
        let right_open_card = self.rightPlayer.getCard()
        
        if left_open_card.compare(card: right_open_card) == 1
        {
            self.leftPlayer.addCards(cards: [left_open_card, right_open_card])
            direction = Direction.player_left_direction
        }
        else if left_open_card.compare(card: right_open_card) == -1
        {
            self.rightPlayer.addCards(cards: [left_open_card, right_open_card])
            direction = Direction.player_right_direction
        }
        else
        {
            direction = war(pc1: left_open_card, pc2: right_open_card)
        }
        
        return direction
    }
    
    func war(pc1:Card, pc2:Card) -> Direction{
        var cards = [Card]()
        cards.append(pc1)
        cards.append(pc2)
        
        var direction = Direction.default_direction
        
        // get 3 cards from each player
        for _ in 0..<3{
            cards.append(self.leftPlayer.getCard())
            cards.append(self.rightPlayer.getCard())
        }
        
        // compare the last card
        let pc1 = self.leftPlayer.getCard()
        let pc2 = self.rightPlayer.getCard()
        
        if pc1.compare(card: pc2) == 1{
            self.leftPlayer.addCards(cards: cards)
            direction = Direction.player_left_direction
            
        }else if pc1.compare(card: pc2) == -1{
            self.rightPlayer.addCards(cards: cards)
            direction = Direction.player_right_direction
            
        }else{
            
            // todo: recursive war
            
            direction = war(pc1: pc1, pc2: pc2)
        }
        
        return direction
    }
    
    func isGameOver() -> Bool{
        return self.leftPlayer.cards.count == 0 || self.rightPlayer.cards.count == 0
    }
    
    func getGameStatus() -> String{
        if self.leftPlayer.getCardScore() > self.rightPlayer.getCardScore(){
            return "Left Player is won the round"
        }
        if self.rightPlayer.getCardScore() > self.leftPlayer.getCardScore(){
            return "Right Player is won the round"
        }
        return "War!"
    }
    
}

//
//  Game.swift
//  Cards
//
//  Created by Дмитрий Головин on 25.05.2021.
//

import UIKit

class Game {
    var cardsCount = 0
    var cards = [Card]()
    var flipsCount = 0
    
    func generateCards() {
        var cards = [Card]()
        for _ in 0...cardsCount {
            let randomElement = (type: CardType.allCases.randomElement()!, color: CardColor.allCases.randomElement()!)
            cards.append(randomElement)
        }
        self.cards = cards
    }
    
    func checkCards(_ firstCard: Card, _ secondCard: Card) -> Bool {
        if firstCard == secondCard {
            return true
        }
        return false
    }
}

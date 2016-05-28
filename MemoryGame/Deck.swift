//
//  Deck.swift
//  MemoryGame
//
//  Created by Juan Jose Corbalan on 27/5/16.
//  Copyright © 2016 Juan Jose Corbalan. All rights reserved.
//

import Foundation

enum Difficulty : String {
    case Easy, Normal, High
    
    func gameSize() -> (Int, Int) {
        switch self {
        case .Easy: return (3, 4)
        case .Normal: return (4, 6)
        case .High: return (4, 8)
        }
    }
}

enum Rank : Int, CustomStringConvertible {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King

    var description: String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

enum Suit : String {
    case Spades = "spades"
    case Hearts = "hearts"
    case Diamonds = "diamonds"
    case Clubs = "clubs"

    static func allValues() -> [String] {
        return [Spades.rawValue, Hearts.rawValue, Clubs.rawValue, Diamonds.rawValue]
    }
}

struct Card : Equatable, CustomStringConvertible {
    let rank : Rank
    let suit : Suit
    
    var description: String {
        return "\(rank.description)_of_\(suit.rawValue)"
    }
}

func ==(card1 : Card, card2 : Card) -> Bool {
    return card1.rank == card2.rank && card1.suit == card2.suit
}

struct Deck {
    private var cards = [Card]()
    
    var difficulty : Difficulty = .Normal
    
    var count : Int {
        get {
            return cards.count
        }
    }
    
    var pairs : Int {
        get {
            return count / 2
        }
    }

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
    }
    
    subscript(index: Int) -> Card {
        get {
            return cards[index]
        }
        set {
            cards[index] = newValue
        }
    }
}

extension Deck {

    static func fullDeck() -> [Card] {
        var cards = [Card]()
        for suitValue in Suit.allValues() {
            for rankValue in Rank.Ace.rawValue...Rank.King.rawValue {
                let rank = Rank(rawValue:rankValue)!
                let suit = Suit(rawValue: suitValue)!
                let card = Card(rank:rank, suit:suit)
                cards.append(card)
            }
        }
        return cards
    }
    
    mutating func suffle() {
        let firstCardsInPair = Deck.fullDeck().shuffle()[0..<(difficulty.gameSize().0 * difficulty.gameSize().1)/2]
        let secondCardsInPair = firstCardsInPair
        cards = Array(firstCardsInPair) + Array(secondCardsInPair)
    }
}
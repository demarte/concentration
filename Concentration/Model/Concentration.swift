
import Foundation

struct Concentration {

  // MARK: - properties

  private(set) var cards = [Card]()
  private var numberOfPairsOfCards: Int

  private var indexOfOneAndOnlyFaceUpCard: Int? {
    get {
      return cards.indices.filter({ cards[$0].isFaceUp}).oneAndOnly
    }
    set {
      for index in cards.indices {
        cards[index].isFaceUp = (index == newValue)
      }
    }
  }

  // MARK: - Init

  init(numberOfPairsOfCards: Int) {
    assert(numberOfPairsOfCards > 0, "Concentration.init(at: \(numberOfPairsOfCards)): you must have at least one pair of cards")
    self.numberOfPairsOfCards = numberOfPairsOfCards
    createDeck()
  }

  //MARK: - Methods

  mutating func chooseCard(at index: Int) {
    assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
    if !cards[index].isMatched {
      if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
        if cards[matchIndex] == cards[index] {
          cards[matchIndex].isMatched = true
          cards[index].isMatched = true
        }
        cards[index].isFaceUp = true
      } else {
        indexOfOneAndOnlyFaceUpCard = index
      }
    }
  }

  private mutating func createDeck() {
    for _ in 1...numberOfPairsOfCards {
      let card = Card()
      cards += [card, card]
    }
    shuffleCards()
  }
  
  mutating func shuffleCards() {
    cards.shuffle()
  }

  mutating func newGame() {
    indexOfOneAndOnlyFaceUpCard = nil
    for index in cards.indices {
      cards[index].isMatched = false
      cards[index].isFaceUp = false
    }
    shuffleCards()
  }
}

extension Collection {
  var oneAndOnly: Element? {
    return count == 1 ? first : nil
  }
}










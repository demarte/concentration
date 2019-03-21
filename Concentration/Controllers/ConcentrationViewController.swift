

import UIKit

class ConcentrationViewController: UIViewController {

  //MARK: IBOutlets

  @IBOutlet private weak var flipCountLabel: UILabel! {
    didSet {
      updateFlipCountLabel()
    }
  }

  @IBOutlet private var cardButtons: [UIButton]!

  private var visibleCardButtons: [UIButton]! {
    return cardButtons?.filter { !$0.superview!.isHidden }
  }

  private var faceUpCardButtons: [UIButton]! {
    return cardButtons?.filter { $0.backgroundColor == #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
  }

  //MARK: - properties

  private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

  var numberOfPairsOfCards: Int {
    return (visibleCardButtons.count) / 2
  }

  private(set) var flipCount = 0 {
    didSet {
      updateFlipCountLabel()
    }
  }

  private var emojiChoices = "🎃👻😈🙀🕷🍬♛♜♚♞♝"

  private var emoji = [Card : String]()

  var theme: String? {
    didSet {
      emojiChoices = theme ?? ""
      emoji = [:]
      updateViewFromModel()
    }
  }

  //MARK: - View Controller Life Cycle

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateViewFromModel()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateFlipCountLabel()
  }

  //MARK: IBActions

  @IBAction private func touchCard(_ sender: UIButton) {
    if let cardNumber = visibleCardButtons.index(of: sender) {
      flipCount += 1
      sender.flipCard {
        self.game.chooseCard(at: cardNumber)
        self.updateViewFromModel()
      }
    }
  }

  @IBAction func newGame(_ sender: UIButton) {
    game.newGame()
    updateViewFromModel()
    flipCount = 0
  }

  //MARK: - Methods

  func updateFlipCountLabel() {
    let attributes: [NSAttributedString.Key:Any] = [
      .strokeWidth : 5.0,
      .strokeColor : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    ]
    let attibuteString = NSAttributedString(
      string: traitCollection.verticalSizeClass == .compact ? "Flips\n\(flipCount)" :
      "Flips: \(flipCount)",
      attributes: attributes
    )
    flipCountLabel.attributedText = attibuteString
  }

  private func updateViewFromModel() {
    if visibleCardButtons != nil {
      for index in visibleCardButtons.indices {
        let button = visibleCardButtons[index]
        let card = game.cards[index]
        if card.isFaceUp {
          button.setTitle(emoji(for: card), for: UIControl.State.normal)
          button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
          button.setTitle("", for: UIControl.State.normal)
          button.backgroundColor =  card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)

        }
      }
    }
  }

  private func emoji(for card: Card) -> String {
    if emoji[card] == nil, emojiChoices.count > 0 {
      let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
      emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
    }
    return emoji[card] ?? "?"
  }
}

extension UIButton {
  func flipCard(completion: @escaping () -> Void) {
    UIView.transition(
      with: self,
      duration: 0.6,
      options: [.transitionFlipFromLeft],
      animations: { completion() }
      )
  }

  func mathCards() {
    UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: 0.6,
      delay: 0,
      options: [],
      animations: {
        self.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
    },
      completion: { position in
        UIViewPropertyAnimator.runningPropertyAnimator(
          withDuration: 0.75,
          delay: 0,
          options: [],
          animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        },
          completion: { position in
            self.isHidden = true
            self.transform = .identity
        })
    })
  }
}



















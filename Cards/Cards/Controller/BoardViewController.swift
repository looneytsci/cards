//
//  BoardViewController.swift
//  Cards
//
//  Created by Дмитрий Головин on 25.05.2021.
//

import UIKit

class BoardViewController: UIViewController {

    // свойства для поддержки игры
    var cardsPairsCount = 8
    lazy var game: Game = getNewGame()
    var cardViews = [UIView]()
    private var flippedCards = [UIView]()
    
    // ленивые свойства для UI элементов
    lazy var flipAllCardsButton = getFlipAllCardsButton()
    lazy var startButtonView = getStartButtonView()
    lazy var boardGameView = getBoardGameView()
    lazy var closeController = getCloseButton()
    lazy var flipsLabel = getFlipsLabel()
    
    // настройка окна и размера карт
    private let window = UIApplication.shared.windows.first!
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    
    // вычисление максимальных координат для позиционирования карт
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    
    // MARK: ViewController LifeCycle
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(startButtonView)
        view.addSubview(flipAllCardsButton)
        view.addSubview(boardGameView)
        view.addSubview(closeController)
        boardGameView.addSubview(flipsLabel)
        
    }
    
    // MARK: Создание UI элемента кнопка
    
    // описание лейбла с переворотами
    private func getFlipsLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 200, height: 20))
        
        label.text = "Перевороты: \(game.flipsCount)"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        
        return label
    }
    
    // Описание кнопки "close"
    private func getCloseButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: Int(startButtonView.frame.origin.x + 220), y: 0, width: 50, height: 50))
        
        button.frame.origin.y = window.safeAreaInsets.top
        
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        return button
    }
    
    // описание кнопки "Flip All Cards"
    private func getFlipAllCardsButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 20, y: 0, width: 50, height: 50))
        
        button.frame.origin.y = window.safeAreaInsets.top
        
        button.setTitle("Flip", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.addTarget(self, action: #selector(flipAllCards), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }
    
    // описание кнопки "начать игру"
    private func getStartButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.center.x = view.center.x

        button.frame.origin.y = window.safeAreaInsets.top
        
        button.setTitle("Начать игру", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        return button
    }
    
    // настройка игрового поля
    private func getBoardGameView() -> UIView {
        let margin: CGFloat = 10
        let boardView = UIView()
        boardView.clipsToBounds = true
        // Отступы
        boardView.frame.origin.x = margin
        let window = UIApplication.shared.windows.first!
        let topPadding = window.safeAreaInsets.top
        boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
        
        // Ширина
        boardView.frame.size.width = UIScreen.main.bounds.width - margin*2
        // Высота
        let bottomPadding = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
        
        // Стиль
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
        return boardView
    }
    
    // MARK: Создание игры
    
    private func getNewGame() -> Game {
        let game = Game()
        game.cardsCount = self.cardsPairsCount
        game.generateCards()
        return game
    }
    
    // загрузка карт из фабрики
    private func getCardsBy(modelData: [Card]) -> [UIView] {
        var cardViews = [UIView]()
        let cardViewFactory = CardViewFactory()
        
        for (index, modelCard) in modelData.enumerated() {
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)
            
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                
                if self.flippedCards.count == 2 {
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]
                    
                    if game.checkCards(firstCard, secondCard) {
                        UIView.animate(withDuration: 0.3) {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
                        } completion: { _ in
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last!.removeFromSuperview()
                            self.flippedCards = []
                        }
                    } else {
                        for card in self.flippedCards {
                            (card as! FlippableView).flip()
                        }
                        game.flipsCount += 1
                        flipsLabel.text = "Перевороты: \(game.flipsCount)"
                    }
                }
            }
        }
        return cardViews
    }
    
    // загрузка карт на доску, рандомное позиционирование относительно superview
    private func placeCardsOnBoard(_ cards: [UIView]) {
        for card in cardViews {
            card.removeFromSuperview()
        }
        
        cardViews = cards
        
        for card in cardViews {
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 50...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            boardGameView.addSubview(card)
        }
    }
    
    // MARK: @objc methods
    
    // используется при нажатии на кнопку "начать игру"
    @objc func startGame(_ sender: UIButton) {
        game = getNewGame()
        game.flipsCount = 0
        flipsLabel.text = "Перевороты: \(game.flipsCount)"
        flipAllCardsButton.isHidden = false
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
    }
    
    // используется при нажатии на кнопку "close"
    @objc func closeVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // используется при нажатии на кнопку "Flip All Cards"
    @objc func flipAllCards(_ sender: UIButton) {
        if flippedCards.isEmpty {
            for card in cardViews {
                (card as! FlippableView).flipAll()
            }
        } else {
            let flippedCard = flippedCards.first
            for card in cardViews {
                if card != flippedCard {
                    (card as! FlippableView).flipAll()
                    
                }
            }
            flippedCards = []
        }
    }
}

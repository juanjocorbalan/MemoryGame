//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Juan Jose Corbalan on 28/5/16.
//  Copyright © 2016 Juan Jose Corbalan. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: - Costants
    
    private struct Costants {
        static let padding : CGFloat = 5.0
        static let ratio : CGFloat = 1.452
        static let topMargin : CGFloat = 60.0
        static let animationDuration : Double = 1.0
        static let cellIdentifier = "cardCell"
        static let cardBackName = "card_back"
    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var pairsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //MARK: - Properties
    
    private var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.isScrollEnabled = false
            collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: Costants.cellIdentifier)
            collectionView.backgroundColor = UIColor.clear
        }
    }
    
    private var facedUpCardIndexes = [Int]()
    
    private var score = 0 {
        didSet {
            self.scoreLabel?.text = String(score)
        }
    }
    
    private var pairs = 0 {
        didSet {
            self.pairsLabel?.text = "\(pairs) of \(game.pairsCount)"
        }
    }
    
    var game : Game! = nil
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Actions
    
    @IBAction func newGame(_ sender: UIButton) {
        setup()
    }
    
    @IBAction func endGame(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - CollectionView DataSource Delegate

extension GameViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.cardsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Costants.cellIdentifier, for: indexPath) as! CardCollectionViewCell
        
        let card = game[(indexPath as NSIndexPath).row]
        cell.setupCard(card.description, backImageName: Costants.cardBackName)
        
        return cell
    }
}

//MARK: - CollectionView Delegate

extension GameViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell {
            
            if facedUpCardIndexes.count == 2 || facedUpCardIndexes.contains((indexPath as NSIndexPath).row) {
                return
            }
            
            facedUpCardIndexes.append((indexPath as NSIndexPath).row)
            score += 1
            cell.turnCard()
            
            if facedUpCardIndexes.count == 2 {
                if game[facedUpCardIndexes[0]] == game[facedUpCardIndexes[1]] {
                    pairs += 1
                    updateFacedUpCards(alsoRemove: true)
                    checkFinishedGame()
                }
                else {
                    updateFacedUpCards(alsoRemove: false)
                }
            }
        }
    }
}

//MARK: - Collection view setup

extension GameViewController {
    
    private var cardSize : CGSize {
        let (rows, _) = game.gameSize()
        let viewSize = view.frame.size
        
        let height = (viewSize.height - Costants.topMargin - CGFloat(rows+1)*Costants.padding) / CGFloat(rows)
        return CGSize(width: height/Costants.ratio, height: height)
    }
    
    private func setup() {
        game.suffle()
        score = 0
        pairs = 0
        facedUpCardIndexes = [Int]()
        
        if let collectionView = collectionView {
            collectionView.removeFromSuperview()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Costants.padding
        layout.minimumInteritemSpacing = Costants.padding
        layout.itemSize = cardSize
        layout.sectionInset = UIEdgeInsets(top: Costants.padding, left: Costants.padding, bottom: Costants.padding, right: Costants.padding)
        
        let (_, cols) = game.gameSize()
        let cvWidth = CGFloat(cols)*cardSize.width + CGFloat(cols+1)*Costants.padding
        
        collectionView = UICollectionView(frame:
            CGRect(x: (view.frame.size.width - cvWidth) / 2.0, y: Costants.topMargin, width: cvWidth, height: view.frame.size.height - Costants.topMargin),
                                          collectionViewLayout:layout)
        var center = view.center
        center.y += Costants.topMargin
        
        view.addSubview(collectionView)
    }
}

//MARK: - Game control logic

extension GameViewController {
    
    func updateFacedUpCards(alsoRemove removeCards: Bool) {
        dispatchAfer(Costants.animationDuration) {
            for index in self.facedUpCardIndexes {
                let cell = self.collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) as! CardCollectionViewCell
                removeCards ? cell.removeCard() : cell.turnCard()
            }
            self.facedUpCardIndexes.removeAll()
        }
    }
    
    func checkFinishedGame() {
        dispatchAfer(Costants.animationDuration) {
            if self.pairs == self.game.pairsCount {
                let alert = UIAlertController.init(title: "Congratulations!", message: "Your score is \(self.score)", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { action in self.setup() }))
                self.present(alert, animated: true, completion:nil)
            }
        }
    }
}

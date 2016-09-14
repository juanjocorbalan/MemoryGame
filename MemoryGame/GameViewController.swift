//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Juan Jose Corbalan on 28/5/16.
//  Copyright © 2016 Juan Jose Corbalan. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: - Constants
    
    fileprivate struct Constants {
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
    
    fileprivate var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.isScrollEnabled = false
            collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
            collectionView.backgroundColor = UIColor.clear
        }
    }
    
    fileprivate var facedUpCardIndexes = [Int]()
    
    fileprivate var score = 0 {
        didSet {
            self.scoreLabel?.text = String(score)
        }
    }
    
    fileprivate var pairs = 0 {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! CardCollectionViewCell
        
        let card = game[(indexPath as NSIndexPath).row]
        cell.setupCard(card.description, backImageName: Constants.cardBackName)
        
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
    
    fileprivate var cardSize : CGSize {
        let (rows, _) = game.gameSize()
        let viewSize = view.frame.size
        
        let height = (viewSize.height - Constants.topMargin - CGFloat(rows+1)*Constants.padding) / CGFloat(rows)
        return CGSize(width: height/Constants.ratio, height: height)
    }
    
    fileprivate func setup() {
        game.suffle()
        score = 0
        pairs = 0
        facedUpCardIndexes = [Int]()
        
        if let collectionView = collectionView {
            collectionView.removeFromSuperview()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.padding
        layout.minimumInteritemSpacing = Constants.padding
        layout.itemSize = cardSize
        layout.sectionInset = UIEdgeInsets(top: Constants.padding, left: Constants.padding, bottom: Constants.padding, right: Constants.padding)
        
        let (_, cols) = game.gameSize()
        let cvWidth = CGFloat(cols)*cardSize.width + CGFloat(cols+1)*Constants.padding
        
        collectionView = UICollectionView(frame:
            CGRect(x: (view.frame.size.width - cvWidth) / 2.0, y: Constants.topMargin, width: cvWidth, height: view.frame.size.height - Constants.topMargin),
                                          collectionViewLayout:layout)
        var center = view.center
        center.y += Constants.topMargin
        
        view.addSubview(collectionView)
    }
}

//MARK: - Game control logic

extension GameViewController {
    
    func updateFacedUpCards(alsoRemove removeCards: Bool) {
        dispatchAfer(Constants.animationDuration) {
            for index in self.facedUpCardIndexes {
                let cell = self.collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) as! CardCollectionViewCell
                removeCards ? cell.removeCard() : cell.turnCard()
            }
            self.facedUpCardIndexes.removeAll()
        }
    }
    
    func checkFinishedGame() {
        dispatchAfer(Constants.animationDuration) {
            if self.pairs == self.game.pairsCount {
                let alert = UIAlertController.init(title: "Congratulations!", message: "Your score is \(self.score)", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { action in self.setup() }))
                self.present(alert, animated: true, completion:nil)
            }
        }
    }
}

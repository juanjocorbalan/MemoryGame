//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Juan Jose Corbalan on 28/5/16.
//  Copyright © 2016 Juan Jose Corbalan. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    //MARK: -Costants
    
    private struct Costants {
        static let padding : CGFloat = 5.0
        static let ratio : CGFloat = 1.452
        static let topMargin : CGFloat = 60.0
        static let animationDuration : Double = 1.0
        static let cellIdentifier = "cardCell"
        static let cardBackName = "card_back"
    }
    
    //MARK: -Outlets
    
    @IBOutlet weak var pairsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //MARK: -Properties
    
    private var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.scrollEnabled = false
            collectionView.registerClass(CardCollectionViewCell.self, forCellWithReuseIdentifier: Costants.cellIdentifier)
            collectionView.backgroundColor = UIColor.clearColor()
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
            self.pairsLabel?.text = "\(pairs) of \(deck.pairs)"
        }
    }
    
    private var cardSize : CGSize {
        let (rows, _) = deck.difficulty.gameSize()
        let viewSize = view.frame.size
        
        let height = (viewSize.height - Costants.topMargin - CGFloat(rows+1)*Costants.padding) / CGFloat(rows)
        return CGSizeMake(height/Costants.ratio, height)
    }

    var deck : Deck! = nil
    
    //MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        deck.suffle()
        score = 0
        pairs = 0
        facedUpCardIndexes = [Int]()
        
        if let collectionView = collectionView where collectionView.superview != nil {
            collectionView.removeFromSuperview()
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Costants.padding
        layout.minimumInteritemSpacing = Costants.padding
        layout.itemSize = cardSize
        layout.sectionInset = UIEdgeInsets(top: Costants.padding, left: Costants.padding, bottom: Costants.padding, right: Costants.padding)
        
        let (_, cols) = deck.difficulty.gameSize()
        let cvWidth = CGFloat(cols)*cardSize.width + CGFloat(cols+1)*Costants.padding
        
        collectionView = UICollectionView(frame:
            CGRect(x:(view.frame.size.width - cvWidth) / 2.0,
                y:Costants.topMargin,
                width:cvWidth,
                height:view.frame.size.height - Costants.topMargin),
                                          collectionViewLayout:layout)
        var center = view.center
        center.y += Costants.topMargin
        
        view.addSubview(collectionView)
    }

    //MARK: -Actions
    
    @IBAction func newGame(sender: UIButton) {
        setup()
    }
    
    @IBAction func endGame(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: CollectionView DataSource Delegate

extension GameViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deck.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Costants.cellIdentifier, forIndexPath: indexPath) as! CardCollectionViewCell
        
        let card = deck[indexPath.row]
        cell.setupCard(card.description, backImageName: Costants.cardBackName)
        
        return cell
    }
}

//MARK: CollectionView Delegate

extension GameViewController : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CardCollectionViewCell {
            
            if facedUpCardIndexes.count == 2 || facedUpCardIndexes.contains(indexPath.row) {
                return
            }

            facedUpCardIndexes.append(indexPath.row)
            score += 1
            cell.turnCard()
            
            if facedUpCardIndexes.count == 2 {
                if deck[facedUpCardIndexes[0]] == deck[facedUpCardIndexes[1]] {
                    pairs += 1
                    removeFacedUpCards()
                    isGameFinished()
                }
                else {
                    turnDownFacedUpCards()
                }
            }
        }
    }
}

//MARK: -Game control logic

extension GameViewController {
    
    func removeFacedUpCards() {
        dispatchAfer(Costants.animationDuration) { 
            for index in self.facedUpCardIndexes {
                let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath.init(forRow: index, inSection: 0)) as! CardCollectionViewCell
                cell.removeCard()
            }
            self.facedUpCardIndexes.removeAll()
        }
    }
    
    func turnDownFacedUpCards() {
        
        dispatchAfer(Costants.animationDuration) { 
            for index in self.facedUpCardIndexes {
                let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath.init(forRow: index, inSection: 0)) as! CardCollectionViewCell
                cell.turnCard()
            }
            self.facedUpCardIndexes.removeAll()
        }
    }
    
    func isGameFinished() {
        dispatchAfer(Costants.animationDuration) { 
            if self.pairs == self.deck.pairs {
                let alert = UIAlertController.init(title: "Congratulations!", message: "Your score is \(self.score)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .Default, handler: { action in self.setup() }))
                self.presentViewController(alert, animated: true, completion:nil)
            }
        }
    }
}

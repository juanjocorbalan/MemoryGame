//
//  CardCollectionViewCell.swift
//  MemoryGame
//
//  Created by Juan Jose Corbalan on 28/5/16.
//  Copyright © 2016 Juan Jose Corbalan. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    private struct Costants {
        static let durationDuration : Double = 0.5
    }
    
    private let imageView: UIImageView!
    private var cardImageName: String!
    private var backImageName: String!
    
    var isFacedUp : Bool = false
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x:0, y:0, width:frame.size.width, height:frame.size.height))
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCard(cardImageName: String, backImageName: String){
        self.cardImageName = cardImageName
        self.backImageName = backImageName
        self.alpha = 0
        imageView.image = UIImage(named: self.backImageName)
        UIView.animateWithDuration(Costants.durationDuration,
                                   animations: {
                                    self.alpha = 1
            },
                                   completion: nil)
    }
    
    func turnCard() {
        UIView.transitionWithView(contentView,
                                  duration:Costants.durationDuration,
                                  options:.TransitionFlipFromLeft,
                                  animations: {
                                    self.imageView.image = UIImage(named: self.isFacedUp ? self.backImageName : self.cardImageName)
            },
                                  completion: nil)
        self.isFacedUp = !self.isFacedUp
    }
    
    func removeCard() {
        UIView.animateWithDuration(Costants.durationDuration,
                                   animations: {
                                    self.alpha = 0
            },
                                   completion: nil)
    }
}


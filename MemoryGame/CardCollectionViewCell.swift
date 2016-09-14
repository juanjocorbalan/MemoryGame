//
//  CardCollectionViewCell.swift
//  MemoryGame
//
//  Created by Juan Jose Corbalan on 28/5/16.
//  Copyright © 2016 Juan Jose Corbalan. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    fileprivate struct Constants {
        static let durationDuration : Double = 0.5
    }
    
    fileprivate let imageView: UIImageView!
    fileprivate var cardImageName: String!
    fileprivate var backImageName: String!
    
    var isFacedUp : Bool = false
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x:0, y:0, width:frame.size.width, height:frame.size.height))
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.backgroundColor = UIColor.clear
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCard(_ cardImageName: String, backImageName: String){
        self.cardImageName = cardImageName
        self.backImageName = backImageName
        self.alpha = 0
        imageView.image = UIImage(named: self.backImageName)
        UIView.animate(withDuration: Constants.durationDuration,
                                   animations: {
                                    self.alpha = 1
            },
                                   completion: nil)
    }
    
    func turnCard() {
        UIView.transition(with: contentView,
                                  duration:Constants.durationDuration,
                                  options:.transitionFlipFromLeft,
                                  animations: {
                                    self.imageView.image = UIImage(named: self.isFacedUp ? self.backImageName : self.cardImageName)
            },
                                  completion: nil)
        self.isFacedUp = !self.isFacedUp
    }
    
    func removeCard() {
        UIView.animate(withDuration: Constants.durationDuration,
                                   animations: {
                                    self.alpha = 0
            },
                                   completion: nil)
    }
}


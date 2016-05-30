//
//  MenuViewController.swift
//  MemoryGame
//
//  Created by Juan Jose Corbalan on 28/5/16.
//  Copyright © 2016 Juan Jose Corbalan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    private struct Storyboard {
        static let GameSegueIdenfifier = "showGame"
    }
    
    @IBAction func startGame(sender: UIButton) {
        performSegueWithIdentifier(Storyboard.GameSegueIdenfifier, sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.GameSegueIdenfifier {
            if let button = sender as? UIButton, vc = segue.destinationViewController as? GameViewController {
                let difficulty = Difficulty(rawValue: button.currentTitle!) ?? .Normal
                vc.game = Game(difficulty: difficulty)
            }
        }
    }
}

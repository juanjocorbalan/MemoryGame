//
//  MenuViewController.swift
//  MemoryGame
//
//  Created by Juan Jose Corbalan on 28/5/16.
//  Copyright © 2016 Juan Jose Corbalan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    fileprivate struct Storyboard {
        static let GameSegueIdenfifier = "showGame"
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        performSegue(withIdentifier: Storyboard.GameSegueIdenfifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.GameSegueIdenfifier {
            if let button = sender as? UIButton, let vc = segue.destination as? GameViewController {
                let difficulty = Difficulty(rawValue: button.currentTitle!) ?? .Normal
                vc.game = Game(difficulty: difficulty)
            }
        }
    }
}

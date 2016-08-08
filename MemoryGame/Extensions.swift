//
//  Extensions.swift
//  MemoryGame
//
//  Created by Juan Jose Corbalan on 28/5/16.
//  Copyright © 2016 Juan Jose Corbalan. All rights reserved.
//

import Foundation
import UIKit

extension Collection where Index == Int {
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        for i in 0..<list.count - 1 {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            guard i != j else { continue }
            swap(&list[i], &list[j])
        }
        return list
    }
}

extension UIViewController {
    func dispatchAfer(_ delay: Double, block: () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
    }
}

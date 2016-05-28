//
//  Extensions.swift
//  MemoryGame
//
//  Created by Juan Jose Corbalan on 28/5/16.
//  Copyright © 2016 Juan Jose Corbalan. All rights reserved.
//

import Foundation
import UIKit

extension CollectionType where Index == Int {
    func shuffle() -> [Generator.Element] {
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
    func dispatchAfer(delay: Double, block: () -> Void) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
    }
}
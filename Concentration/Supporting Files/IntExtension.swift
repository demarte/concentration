//
//  ExtensionInt.swift
//  Concentration
//
//  Created by Ivan De Martino on 3/20/19.
//  Copyright © 2019 Ivan De Martino. All rights reserved.
//

import Foundation

extension Int {
  var arc4random: Int {
    if self > 0 {
      return Int(arc4random_uniform(UInt32(self)))
    } else if self < 0 {
      return -Int(arc4random_uniform(UInt32(abs(self))))
    } else {
      return 0
    }
  }
}

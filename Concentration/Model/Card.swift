//
//  Card.swift
//  Concentration
//
//  Created by Ivan De Martino on 6/2/18.
//  Copyright © 2018 Ivan De Martino. All rights reserved.
//

import Foundation

struct Card : Hashable
{
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    public var hashValue: Int { return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}

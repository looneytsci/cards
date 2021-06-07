//
//  Card.swift
//  Cards
//
//  Created by Дмитрий Головин on 25.05.2021.
//

import UIKit

enum CardType: CaseIterable {
    case circle
    case cross
    case squeare
    case fill
    case emptyCircle
}

enum CardColor: String, CaseIterable {
    case red
    case green
    case blue
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}

typealias Card = (type: CardType, color: CardColor)

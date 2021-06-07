//
//  Settings.swift
//  Cards
//
//  Created by Дмитрий Головин on 26.05.2021.
//

import UIKit

protocol SettingsProtocol {
    var cardsCount: Int { get set }
    var colors: [UIColor] { get set }
    var backType: cardsBackType.AllCases { get set }
    var frontType: cardsFrontType.AllCases { get set }
    static var shared: SettingsProtocol { get set }
    init(cardsCount: Int, colors: [UIColor], backType: cardsBackType.AllCases, frontType: cardsFrontType.AllCases) 
}

enum SettingSections: CaseIterable {
    case cardsCount
    case cardsColor
    case cardsBackType
    case cardsFrontType
}

enum cardsBackType: String, CaseIterable {
    case circle
    case line
}

enum cardsFrontType: String, CaseIterable {
    case circle
    case cross
    case squeare
    case fill
    case emptyCircle
}


class Settings: SettingsProtocol {
    var cardsCount: Int
    var colors: [UIColor]
    var backType: cardsBackType.AllCases
    var frontType: cardsFrontType.AllCases
    
    static var shared: SettingsProtocol = Settings(cardsCount: 8, colors: [.black, .blue, .red, .yellow, .brown, .orange, .gray, .purple, .green], backType: [.circle, .line], frontType: [.circle, .cross, .emptyCircle, .fill, .squeare])
    
    required init(cardsCount: Int, colors: [UIColor], backType: cardsBackType.AllCases, frontType: cardsFrontType.AllCases) {
        self.cardsCount = cardsCount
        self.colors = colors
        self.backType = backType
        self.frontType = frontType
    }
}

//
//  User.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 30.11.23.
//

import Foundation
import SwiftUI

struct Player: Identifiable,Codable, Hashable {
    var id: UUID
    var name: String
    var money: Int
    var color: Color?
    var typeOfPlayer: TypeOfPlayer
    
    init(name: String, money: Int, color: Color,id: UUID,typeOfPlayer: TypeOfPlayer) {
        self.name = name
        self.money = money
        self.color = color
        self.id = id
        self.typeOfPlayer = typeOfPlayer
    }
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.color == rhs.color &&
        lhs.typeOfPlayer == rhs.typeOfPlayer
    }
}

//
//  GameModel.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 14.12.23.
//

import Foundation

struct GameModel: Codable {
         var players: [Player] = []
         var streets: [Street] = []
}

//
//  ModelForSend.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 20.12.23.
//

import Foundation

struct ModelForSend: Codable {
    var typeOfAction: TypeOfAction
    var model: GameModel
    var fromWho: TypeOfPlayer = .guest
    var buyModel: BuyModel?
    var payRentModel :PayRentModel?
    var payLoopModel: PayForLoopModel?
    var buyHotelModel: BuyHotelModel?
    var tradeModel: TradeModel?
}
 


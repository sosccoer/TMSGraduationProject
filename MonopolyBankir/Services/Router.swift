//
//  Router.swift
//  MonopolyBankir
//
//  Created by Виктор Васильков on 29.07.23.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case streetsView
    case playerView(player: Player)
    case payRentView
    case buyView
    case buyHotelView
    case tradeView
}

final class Router: ObservableObject {
    
    var currentPlayer: Player?
    
    static let shared = Router()
    
    private init () {}

    @Published var path = [Route]()
    
    func showTradeView() {
        path.append(.tradeView)
    }
    
    func showBuyHotelsView() {
        path.append(.buyHotelView)
    }
    
    func showBuyView() {
        path.append(.buyView)
    }
    
    func showPayRentView() {
        path.append(.payRentView)
    }
    
    func showPlayerView(player: Player) {
        currentPlayer = player 
        path.append(.playerView(player: player))
    }
    
    func showStreetsView () {
        path.append(.streetsView)
    }
    
    //ENDING FUNC
    func backToRoot() {
        path.removeAll()
    }
    
    func back() {
        if path.count > 0 {
            path.removeLast()
        }
    }
}

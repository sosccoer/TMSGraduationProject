//
//  GameViewModel.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 4.12.23.
//

import Foundation
import SwiftUI
import Network

class GameViewModel: ObservableObject{
    
    @Published var gameModel: GameModel

    let buttonTypes: [ButtonType] = [.buy, .trade, .houses, .payRent, .fullCircle, .buyHotelsView]
    init(viewModel: GameModel = GameModel(players: [],streets: [])) {
        self.gameModel = viewModel
    }
    
    func addNewPlayer(name: String, typeOfPlayer: TypeOfPlayer) {
        let id = UUID()
        let randomColorValue: Color = Color.random
        gameModel.players.append(Player(name: name,money: 1000,color: randomColorValue, id: id, typeOfPlayer: typeOfPlayer))
    }
   
    func actionOfButton(_ button: ButtonType) {
        switch button {
        case .buy:
            Router.shared.showBuyView()
        case .trade:
            Router.shared.showTradeView()
        case .houses:
            Router.shared.showStreetsView()
        case .payRent:
            Router.shared.showPayRentView()
        case .fullCircle:
            actionOnFullCircle()
        case .buyHotelsView:
            Router.shared.showBuyHotelsView()
        }
    }

    func actionOnFullCircle() {
        
        guard let player = returnPlayer() else {return}
        let modelForSend = ModelForSend(typeOfAction: .payForLoop, model: gameModel,payLoopModel: PayForLoopModel(player: player))
        Coder().encoder(viewModel: modelForSend)
        
    }
    
    func BuyHotel(house: House) {
        
        let player: Player? = returnPlayer()
        let buyModel = BuyHotelModel(player: player!, house: house)
        let modelForSend = ModelForSend(typeOfAction:.buyHotel , model: gameModel,fromWho: .guest, buyHotelModel: buyModel)
        sender(modelForSend: modelForSend)
        
    }
    
    func buyHouse(house: House) {
        guard house.owner == nil else { return }
        
        let buyer: Player? = returnPlayer()
        
        guard let buyer = buyer else { return }
        let byuModel = BuyModel(house: house, buyer: buyer)
        let modelForSend = ModelForSend(typeOfAction: .buy,
                                        model: gameModel,
                                        fromWho: .guest,
                                        buyModel: byuModel)
        sender(modelForSend: modelForSend)
    }
    
    func trade(partner: Player?, partnerHouses: House, myHouses: House, partnerMoney: Int, myMoney: Int) {
        guard let swapPartner = partner else {return}
        guard let me = returnPlayer() else {return}
        let tradeModel = TradeModel(swapPartner: swapPartner, me: me, moneyOfSwapPartner: partnerMoney, myMoney: myMoney, myHouses: myHouses, partnerHouses: partnerHouses)
        let modelForSend = ModelForSend(typeOfAction: .trade, model: gameModel,fromWho: .guest, tradeModel: tradeModel)
        sender(modelForSend: modelForSend)
    }
    
    func payRent(nameOfReciver: Player?, house: House) {
        guard let recievedPlayer = nameOfReciver else { return }
        
        let taxPayer: Player? = returnPlayer()
        guard let taxPayer = taxPayer else { return }
        
        let payRentModel = PayRentModel(taxPayer: taxPayer,
                                        receiver: recievedPlayer,
                                        house: house)
        
        let modelForSend = ModelForSend(typeOfAction: .payRent,
                                        model: gameModel,
                                        payRentModel: payRentModel)
    
        sender(modelForSend: modelForSend)
    }
    
    
    func sender(modelForSend: ModelForSend) {
        Coder().encoder(viewModel: modelForSend)
        Router.shared.back()
    }
    func returnPlayer() -> Player? {
        let playerName = UserDefaults.standard.string(forKey: User.name)
        var buyer: Player?
        gameModel.players.forEach({ if $0.name == playerName {
            buyer = $0
        }})
        return buyer
    }
    
    func starnGame() {
        
        gameModel.streets = [
            Street(id: 1, name: .brown,
                   houses: [House(id: 11, price: 60, name: .BalticAvenue, color: .brown,owner: nil,priceOfRent: 2, countOfHouses: 0),
                            House(id: 12, price: 60, name: .MediaterraneanAvenue,color: .brown,owner: nil,priceOfRent: 4, countOfHouses: 0)] ,
                   color: .brown),
            
            Street(id: 2, name: .blue,
                   houses: [House(id: 21, price: 120, name: .ConnecticutAvenue, color: .skyBlue,owner: nil,priceOfRent: 6 , countOfHouses: 0),
                            House(id: 22, price: 100, name: .VentnorAvenue,color: .skyBlue,owner: nil,priceOfRent: 6 , countOfHouses: 0),
                            House(id: 23, price: 100, name: .OrientalAvenue, color: .skyBlue,owner: nil,priceOfRent: 8, countOfHouses: 0)] ,
                   color: .skyBlue),
            
            Street(id: 3, name: .pink,
                   houses: [House(id: 31, price: 160, name: .VermontAvenue, color: .pink,owner: nil,priceOfRent: 10, countOfHouses: 0),
                            House(id: 32, price: 140, name: .StatesAvenue,color: .pink,owner: nil,priceOfRent: 10, countOfHouses: 0),
                            House(id: 33, price: 140, name: .StCharlesPlace, color: .pink,owner: nil,priceOfRent: 12, countOfHouses: 0)] ,
                   color: .pink),
            
            Street(id: 4, name: .orange,
                   houses: [House(id: 41, price: 200, name: .NewYorkAvenue, color: .orange,owner: nil,priceOfRent: 14, countOfHouses: 0),
                            House(id: 42, price: 180, name: .TennesseeAvenue,color: .orange,owner: nil,priceOfRent: 14, countOfHouses: 0),
                            House(id: 43, price: 180, name: .STJamesPlace, color: .orange,owner: nil,priceOfRent: 16, countOfHouses: 0)] ,
                   color: .orange),
            
            Street(id: 5, name: .red,
                   houses: [House(id: 51, price: 240, name: .IllinoisAvenue, color: .red,owner: nil,priceOfRent: 18, countOfHouses: 0),
                            House(id: 52, price: 220, name: .IndianaAvenue,color: .red,owner: nil,priceOfRent: 18, countOfHouses: 0),
                            House(id: 53, price: 220, name: .KentuckyAvenue, color: .red,owner: nil,priceOfRent: 20, countOfHouses: 0)] ,
                   color: .red),
            
            Street(id: 6, name: .yellow,
                   houses: [House(id: 61, price: 280, name: .MarvinGardens, color: .yellow,owner: nil,priceOfRent: 22, countOfHouses: 0),
                            House(id: 62, price: 260, name: .VentnorAvenue,color: .yellow,owner: nil,priceOfRent: 22, countOfHouses: 0),
                            House(id: 63, price: 260, name: .AtlanticAvenue, color: .yellow,owner: nil,priceOfRent: 24, countOfHouses: 0)] ,
                   color: .yellow),
            
            Street(id: 7, name: .green,
                   houses: [House(id: 71, price: 320, name: .PennsylvaniaAvenue, color: .green,owner: nil,priceOfRent: 26, countOfHouses: 0),
                            House(id: 72, price: 300, name: .NorthCarolinaAvenue,color: .green,owner: nil,priceOfRent: 26, countOfHouses: 0),
                            House(id: 73, price: 300, name: .PacificAvenue, color: .green,owner: nil,priceOfRent: 28, countOfHouses: 0)] ,
                   color: .green),
            
            Street(id: 8, name: .darkBlue,
                   houses: [House(id: 81, price: 400, name: .Boardwalk, color: .darkBlue,owner: nil,priceOfRent: 35, countOfHouses: 0),
                            House(id: 82, price: 350, name: .ParkPlace,color: .darkBlue,owner: nil,priceOfRent: 50, countOfHouses: 0)] ,
                   color: .darkBlue),
            
            Street(id: 9, name: .tax ,
                   houses: [House(id: 91, price: 400, name: .readingRailroad, color: .black,owner: nil,priceOfRent: 25, countOfHouses: 0),
                            House(id: 92, price: 350, name: .PensylvaniaRailroad,color: .black,owner: nil,priceOfRent: 20, countOfHouses: 0),
                            House(id: 93, price: 400, name: .BQRailroad, color: .black,owner: nil,priceOfRent: 20, countOfHouses: 0),
                            House(id: 94, price: 350, name: .ShortLine,color: .black,owner: nil,priceOfRent: 20, countOfHouses: 0)] ,
                   color: .black),
        ]
    }
}



extension GameViewModel {
    enum ButtonType {
        case buy, trade, houses, payRent, fullCircle, buyHotelsView
        
        func getName() -> String {
            switch self {
            case .buy:
                return "Покупка"
            case .trade:
                return "Обмен"
            case .houses:
                return "Здания"
            case .payRent:
                return "Оплата арены"
            case .fullCircle:
                return "Полный круг"
            case .buyHotelsView:
                return "Купить отели"
            }
        }
    }
}

extension Color {
    static let brown = Color(hex: "4C2F1F")
    static let skyBlue = Color(hex: "87CEEB")
    static let pink = Color(hex: "FFC0CB")
    static let orange = Color(hex: "FFA500")
    static let red = Color(hex: "FF0000")
    static let yellow = Color(hex: "FFFF00")
    static let green = Color(hex: "008000")
    static let darkBlue = Color(hex: "000080")
    static let black = Color(hex: "000000")
}

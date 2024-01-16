//
//  EventHandler.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 15.12.23.
//

import Foundation
import Combine

class BankirReciever {
    
    var typeOfAction: TypeOfAction
    var model: GameModel
    var buyModel: BuyModel?
    var payRentModel :PayRentModel?
    var payForLoopModel: PayForLoopModel?
    var buyHotelModel: BuyHotelModel?
    var tradeModel: TradeModel?
    
    init(typeOfAction: TypeOfAction, model: GameModel, buyModel: BuyModel?, payRentModel: PayRentModel?, payForLoopModel: PayForLoopModel?,buyHotelModel: BuyHotelModel?,tradeModel: TradeModel?){
        self.typeOfAction = typeOfAction
        self.model = model
        self.buyModel = buyModel
        self.payRentModel = payRentModel
        self.payForLoopModel = payForLoopModel
        self.buyHotelModel = buyHotelModel
        self.tradeModel = tradeModel
    }
    
    func handlerEvent () {
        
        switch typeOfAction {
        case .payForLoop:
            payForLoop()
        case .buy:
            buy()
        case .payRent:
            payRent()
        case .buyHotel:
            buyHotel()
        case .trade:
            trade()
            
        case .update : break
        }
        
    }
    
    private func trade() {
        //работаем с собой
        for index in 0..<model.players.count {
            if model.players[index].id == tradeModel?.me.id {
                model.players[index].money += tradeModel!.moneyOfSwapPartner
                model.players[index].money -= tradeModel!.myMoney
                //ЭТО Я ЗАБРАЛ ЧУЖОЙ ДОМ
                for indexOfStreet in 0..<model.streets.count{
                    for indexOfHouse in 0..<model.streets[indexOfStreet].houses.count{
                        if model.streets[indexOfStreet].houses[indexOfHouse].id == tradeModel?.partnerHouses.id{
                            model.streets[indexOfStreet].houses[indexOfHouse].owner = model.players[index]
                            model.streets[indexOfStreet].houses[indexOfHouse].color = model.players[index].color
                        }
                    }
                }
                
            }
        }
        //ТЕПЕРЬ СО ВТОРЫМ ИГРОКОМ
        for index in 0..<model.players.count {
            if model.players[index].id == tradeModel?.swapPartner.id {
                model.players[index].money -= tradeModel!.moneyOfSwapPartner
                model.players[index].money += tradeModel!.myMoney
                
                for indexOfStreet in 0..<model.streets.count {
                    for indexOfHouse in 0..<model.streets[indexOfStreet].houses.count{
                        if model.streets[indexOfStreet].houses[indexOfHouse].id == tradeModel?.myHouses.id {
                            model.streets[indexOfStreet].houses[indexOfHouse].owner = model.players[index]
                            model.streets[indexOfStreet].houses[indexOfHouse].color = model.players[index].color
                        }
                    }
                }
            }
        }
        
        let modelForSend = ModelForSend(typeOfAction: .update, model: model,fromWho: .guest)
        Coder().encoder(viewModel: modelForSend)
        
    }
    
    private func buyHotel() {
        for indexOfStreet in 0..<model.streets.count {
            for indexOfHouse in 0..<model.streets[indexOfStreet].houses.count {
                if model.streets[indexOfStreet].houses[indexOfHouse].name == buyHotelModel?.house.name {
                
                    switch model.streets[indexOfStreet].houses[indexOfHouse].countOfHouses {
                    case 0:
                        switch model.streets[indexOfStreet].houses[indexOfHouse].name{
                        case .BalticAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .MediaterraneanAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 20
                        case .ConnecticutAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 30
                        case .VermontAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 30
                        case .OrientalAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 40 //
                        case .VirginiaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 50 //
                        case .StatesAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 50
                        case .StCharlesPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 60 // 8
                        case .NewYorkAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 70
                        case .TennesseeAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 70 // 10
                        case .STJamesPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 80
                        case .IllinoisAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 90
                        case .IndianaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 90
                        case .KentuckyAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 100
                        case .MarvinGardens: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 110
                        case .VentnorAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 110
                        case .AtlanticAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 120
                        case .PennsylvaniaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 130
                        case .NorthCarolinaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 130
                        case .PacificAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 150
                        case .Boardwalk: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 175
                        case .ParkPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 200
                            
                        case .readingRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 50
                        case .PensylvaniaRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .BQRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .ShortLine: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        }
                    case 1:
                        switch model.streets[indexOfStreet].houses[indexOfHouse].name{
                        case .BalticAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 30
                        case .MediaterraneanAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 60
                        case .ConnecticutAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 90
                        case .VermontAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 90
                        case .OrientalAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 100
                        case .VirginiaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 150 //
                        case .StatesAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 150 // 7
                        case .StCharlesPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 180
                        case .NewYorkAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 200
                        case .TennesseeAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 200 // 10
                        case .STJamesPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 220
                        case .IllinoisAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 250
                        case .IndianaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 250
                        case .KentuckyAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 300
                        case .MarvinGardens: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 330
                        case .VentnorAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 330
                        case .AtlanticAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 360
                        case .PennsylvaniaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 390
                        case .NorthCarolinaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 390
                        case .PacificAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 350
                        case .Boardwalk: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 500
                        case .ParkPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 600
                            
                        case .readingRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 100
                        case .PensylvaniaRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .BQRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .ShortLine: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        }
                    case 2:
                        switch model.streets[indexOfStreet].houses[indexOfHouse].name{
                        case .BalticAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 90
                        case .MediaterraneanAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 180
                        case .ConnecticutAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 270
                        case .VermontAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 270
                        case .OrientalAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 300
                        case .VirginiaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 450
                        case .StatesAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 450 // 7
                        case .StCharlesPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 500
                        case .NewYorkAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 550
                        case .TennesseeAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 550 // 10
                        case .STJamesPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 600
                        case .IllinoisAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 700
                        case .IndianaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 700
                        case .KentuckyAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 750
                        case .MarvinGardens: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 800
                        case .VentnorAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 800
                        case .AtlanticAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 850
                        case .PennsylvaniaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 900
                        case .NorthCarolinaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 900
                        case .PacificAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1000
                        case .Boardwalk: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1100
                        case .ParkPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1400
                            
                        case .readingRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 200
                        case .PensylvaniaRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .BQRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .ShortLine: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        }
                    case 3:
                        switch model.streets[indexOfStreet].houses[indexOfHouse].name{
                        case .BalticAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 160
                        case .MediaterraneanAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 320
                        case .ConnecticutAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 400
                        case .VermontAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 400
                        case .OrientalAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 450
                        case .VirginiaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 625
                        case .StatesAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 125 // 7
                        case .StCharlesPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 700
                        case .NewYorkAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 750
                        case .TennesseeAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 750 // 10
                        case .STJamesPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 800
                        case .IllinoisAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 875
                        case .IndianaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 875
                        case .KentuckyAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 925
                        case .MarvinGardens: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 975
                        case .VentnorAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 975
                        case .AtlanticAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1025
                        case .PennsylvaniaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1100
                        case .NorthCarolinaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1100
                        case .PacificAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1200
                        case .Boardwalk: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1300
                        case .ParkPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1700
                            
                        case .readingRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .PensylvaniaRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .BQRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .ShortLine: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        }
                    case 4:
                        switch model.streets[indexOfStreet].houses[indexOfHouse].name{
                        case .BalticAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 250
                        case .MediaterraneanAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 450
                        case .ConnecticutAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 550
                        case .VermontAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 550
                        case .OrientalAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 600
                        case .VirginiaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 750
                        case .StatesAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 750 // 7
                        case .StCharlesPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 900
                        case .NewYorkAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 950 // 9
                        case .TennesseeAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 950 //10
                        case .STJamesPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1000
                        case .IllinoisAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1050
                        case .IndianaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1050
                        case .KentuckyAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1100
                        case .MarvinGardens: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1150
                        case .VentnorAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1150
                        case .AtlanticAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1200
                        case .PennsylvaniaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1275
                        case .NorthCarolinaAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1275
                        case .PacificAvenue: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1400
                        case .Boardwalk: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 1500
                        case .ParkPlace: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 2000
                            
                        case .readingRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .PensylvaniaRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .BQRailroad: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        case .ShortLine: model.streets[indexOfStreet].houses[indexOfHouse].priceOfRent = 10
                        }
                    
                        
                    default: return
                        
                    }
                    model.streets[indexOfStreet].houses[indexOfHouse].countOfHouses += 1
                }
            }
        }
        let modelForSend = ModelForSend(typeOfAction: .update, model: model,fromWho: .guest)
        Coder().encoder(viewModel: modelForSend)
    }
    
    private func payForLoop() {
        
        for index in 0..<model.players.count{
            if payForLoopModel?.player.name == model.players[index].name{
                model.players[index].money += 1000
            }
        }
        
        let modelForSend = ModelForSend(typeOfAction: .update, model: model,fromWho: .guest)
        Coder().encoder(viewModel: modelForSend)
    }
    
    private func buy() {
        
        DispatchQueue.global(qos: .userInteractive).sync {
            // цикл for для покупки дома
            var counterOfRailHouses = 0
            for index in 0..<model.streets.count {
                for houseIndex in 0..<model.streets[index].houses.count {
                    if model.streets[index].houses[houseIndex].id == buyModel!.house.id {
                        buyModel!.house.owner = buyModel!.buyer
                        buyModel!.house.color = buyModel!.buyer.color
                        buyModel!.buyer.money -= buyModel!.house.price
                        model.streets[index].houses[houseIndex] = buyModel!.house
                        
                        if (model.streets[index].houses[houseIndex].name == .BQRailroad || model.streets[index].houses[houseIndex].name == .readingRailroad || model.streets[index].houses[houseIndex].name == .PensylvaniaRailroad || model.streets[index].houses[houseIndex].name == .ShortLine) {
                            
                            
                            for house in model.streets[index].houses {
                                if house.owner?.id == buyModel?.buyer.id && (model.streets[index].houses[houseIndex].name == .BQRailroad || model.streets[index].houses[houseIndex].name == .readingRailroad || model.streets[index].houses[houseIndex].name == .PensylvaniaRailroad || model.streets[index].houses[houseIndex].name == .ShortLine) {
                                    counterOfRailHouses += 1
                                }
                            }
                              
                        }
                        
                    }
                }
            }
            
            for index in 0..<model.players.count {
                if model.players[index].id == buyModel?.buyer.id {
                    model.players[index].money -= (buyModel?.house.price)!
                }
            }
            
            for index in 0..<model.streets.count {
                for houseIndex in 0..<model.streets[index].houses.count {
                    
                    var priceOfRent = 0
                    
                    switch counterOfRailHouses {
                    case 1: priceOfRent = 25
                    case 2: priceOfRent = 50
                    case 3: priceOfRent = 100
                    case 4: priceOfRent = 200
                    default: return
                    
                    }
                    
                    if (model.streets[index].houses[houseIndex].name == .BQRailroad || model.streets[index].houses[houseIndex].name == .readingRailroad || model.streets[index].houses[houseIndex].name == .PensylvaniaRailroad || model.streets[index].houses[houseIndex].name == .ShortLine){
                        model.streets[index].houses[houseIndex].priceOfRent = priceOfRent
                    }
                    
                }
            }
            
        }
        
        let modelForSend = ModelForSend(typeOfAction: .update, model: model,fromWho: .guest)
        Coder().encoder(viewModel: modelForSend)
    }
    
    private  func payRent() {
        let nilPayRentModel = PayRentModel(taxPayer: Player(name: "", money: 0, color: .clear, id: UUID(), typeOfPlayer: .guest), receiver: Player(name: "", money: 0, color: .clear, id: UUID(), typeOfPlayer: .guest), house: House(id: 0, price: 0, name: .AtlanticAvenue,color: .clear,priceOfRent: 0, countOfHouses: 0))
        
        for index in 0..<model.players.count {
            if model.players[index].id == payRentModel?.taxPayer.id {
                model.players[index].money -= payRentModel?.house.priceOfRent ?? nilPayRentModel.house.priceOfRent
            }
        }
        
        for index in 0..<model.players.count {
            if model.players[index].id == payRentModel?.receiver.id {
                model.players[index].money += payRentModel?.house.priceOfRent ?? nilPayRentModel.house.priceOfRent
            }
        }
        
        let modelForSend = ModelForSend(typeOfAction: .update, model: model , fromWho: .guest)
        
        Coder().encoder(viewModel: modelForSend)
        
    }
    
}

enum TypeOfAction: Codable {
    case payForLoop
    case buy
    case payRent
    case update
    case buyHotel
    case trade
}

struct BuyModel:Codable {
    var house: House
    var buyer: Player
}

struct PayRentModel:Codable {
    var taxPayer: Player
    var receiver: Player
    var house: House
}

struct PayForLoopModel: Codable {
    var player: Player
}

struct BuyHotelModel: Codable {
    var player: Player
    var house: House
}

struct TradeModel: Codable{
    var swapPartner: Player
    var me: Player
    var moneyOfSwapPartner: Int
    var myMoney: Int
    var myHouses: House
    var partnerHouses: House
}

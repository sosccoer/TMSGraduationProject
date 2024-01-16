//
//  AlertManager.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 21.12.23.
//

import Foundation
import SwiftUI

class AlertManager: ObservableObject {
    static let shared = AlertManager()
    @Published var showAlert: Bool = false
    @Published var alertType: AlertsTypes = .thisHouseIsBuyed
    private init () {}
}
enum AlertsTypes {
    case userWantsToBuyHotel(model: ModelForSend)
    case thisHouseIsBuyed
    case userWantsToBuyHouse(model: ModelForSend)
    case userWantsTakeMoneyForLoop(model: ModelForSend)
    case userWantsPayRent(model: ModelForSend)
    case userWantsPayRentForHouseOfAnotherPlayer
    case userWantsBuySixthHotel
    case userWantsToTrade(model: ModelForSend)
    case thisHouseHaveAnotherOwenr
    case thisIsNotNumber
    case shouldEnterName
    case notEnoughtMoney
    
    func returnMessage() -> Message {
        switch self {
        case .shouldEnterName:
            return Message(title: "ERROR", body: "Введите имя")
        case .thisIsNotNumber:
            return Message(title: "ERROR", body: "Введите число")
        case .thisHouseHaveAnotherOwenr:
            return Message(title: "ERROR", body: "Этот игрок не владеет этим домом")
        case .thisHouseIsBuyed:
            return Message(title: "Error", body: "House already buyed")
        case .userWantsToBuyHouse(let model):
            return Message(title: "Одобрите покупку", body: "Игрок \(model.buyModel!.buyer.name): хочет купить здание \(model.buyModel!.house.name)")
        case.userWantsTakeMoneyForLoop(model: let model):
            return Message(title: "Одобрите действие", body: "Игрок \(model.payLoopModel!.player.name) прошел круг ?")
        case .userWantsPayRent(model: let model) :
            return Message(title: "Одобрите действие", body: "Игрок \(model.payRentModel!.taxPayer.name) хочет заплатить ренту за \(model.payRentModel!.house.name) игроку \(model.payRentModel!.receiver.name)")
        case .userWantsPayRentForHouseOfAnotherPlayer :
            return Message(title: "Ошибка", body: "Этот игрок не владеет этим домом")
        case .userWantsBuySixthHotel :
            return Message(title: "Error", body: "Нельзя иметь больше 5 отелей")
        case .userWantsToTrade(model: let model) :
            return Message(title: "Одобрите действие", body: "Игрок \(model.tradeModel!.me.name) хочет поменяться с \(model.tradeModel!.swapPartner.name)")
        case .userWantsToBuyHotel(model: let model):
            return Message(title: "Одобрите действие", body: "Игрок \(model.buyHotelModel!.player.name) хочет купить отель для \(model.buyHotelModel!.house.name.rawValue)")
        case .notEnoughtMoney:
            return Message(title: "ERROR", body: "Недостаточно денег")
        }
        
    }
    
    private func showBasicAlertWithError(returnMessage:Message) -> Alert{
        return Alert(title: Text("\(returnMessage.title)"),
                     message: Text("\(returnMessage.body)"),
                     dismissButton: .default(Text("Got it!")))
    }
    
    func returnAlertView(action: @escaping () -> Void ) -> Alert {
        switch self {
        case .shouldEnterName:
            return showBasicAlertWithError(returnMessage: returnMessage())
        case .thisIsNotNumber:
            return showBasicAlertWithError(returnMessage: returnMessage())
        case .thisHouseHaveAnotherOwenr:
            return showBasicAlertWithError(returnMessage: returnMessage())
        case .userWantsToTrade(model: let model):
            return Alert(title: Text("\(returnMessage().title)"),
                         message: Text("\(returnMessage().body)"),
                         primaryButton: Alert.Button.default(Text("OK"), action: {
                let actionForRecieve = BankirReciever(typeOfAction: .trade, model: model.model, buyModel: nil, payRentModel: nil, payForLoopModel: nil, buyHotelModel: nil, tradeModel: model.tradeModel)
                actionForRecieve.handlerEvent()
                action()}),
                         secondaryButton: Alert.Button.cancel(Text("Cancel"), action: {
                action()}))
        case .thisHouseIsBuyed:
            return showBasicAlertWithError(returnMessage: returnMessage())
        case .userWantsToBuyHouse(let model):
            return Alert(title: Text("\(returnMessage().title)"),
                         message: Text("\(returnMessage().body)"),
                         primaryButton: Alert.Button.default(Text("OK"), action: {
                let actionForRecieve = BankirReciever(typeOfAction: .buy, model: model.model, buyModel: model.buyModel, payRentModel: nil, payForLoopModel: nil, buyHotelModel: nil, tradeModel: nil)
                actionForRecieve.handlerEvent()
                action()}),
                         secondaryButton: Alert.Button.cancel(Text("Cancel"), action: {
                action()}))
        case .userWantsTakeMoneyForLoop(model: let model):
            return Alert(title: Text("\(returnMessage().title)"),
                         message: Text("\(returnMessage().body)"),
                         primaryButton: Alert.Button.default(Text("OK"), action: {
                let actionForRecieve = BankirReciever(typeOfAction: .payForLoop, model: model.model, buyModel: nil, payRentModel: nil, payForLoopModel: model.payLoopModel, buyHotelModel: nil, tradeModel: nil)
                actionForRecieve.handlerEvent()
                action()}),
                         secondaryButton: Alert.Button.cancel(Text("Cancel"), action: {
                action()}))
        case .userWantsPayRent(model: let model):
            return Alert(title: Text("\(returnMessage().title)"),
                         message: Text("\(returnMessage().body)"),
                         primaryButton: Alert.Button.default(Text("OK"), action: {
                let actionForRecieve = BankirReciever(typeOfAction: .payRent, model: model.model, buyModel: nil, payRentModel: model.payRentModel, payForLoopModel: nil, buyHotelModel: nil, tradeModel: nil)
                actionForRecieve.handlerEvent()
                action()}),
                         secondaryButton: Alert.Button.cancel(Text("Cancel"), action: {
                action()}))
        case .userWantsPayRentForHouseOfAnotherPlayer :
            return showBasicAlertWithError(returnMessage: returnMessage())
        case .userWantsBuySixthHotel :
            return showBasicAlertWithError(returnMessage: returnMessage())
        case .userWantsToBuyHotel(model: let model):
            return Alert(title: Text("\(returnMessage().title)"),
                         message: Text("\(returnMessage().body)"),
                         primaryButton: Alert.Button.default(Text("OK"), action: {
                let actionForRecieve = BankirReciever(typeOfAction: .buyHotel, model: model.model, buyModel: nil, payRentModel: nil, payForLoopModel: nil, buyHotelModel: model.buyHotelModel, tradeModel: nil)
                actionForRecieve.handlerEvent()
                action()}),
                         secondaryButton: Alert.Button.cancel(Text("Cancel"), action: {
                action()}))
        case .notEnoughtMoney:
            return showBasicAlertWithError(returnMessage: returnMessage())
        }
        
    }

}
struct Message: Codable {
    let title: String
    let body: String
}

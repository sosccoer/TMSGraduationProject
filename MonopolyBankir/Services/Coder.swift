//
//  Encoder.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 13.12.23.
//

import Foundation
struct Coder {
    
    public static let shared = Coder()
    
    func encoder (viewModel: ModelForSend) {
        
        do{
            let encodedData  = try JSONEncoder().encode(viewModel)
            let jsonString = String(data: encodedData, encoding: .utf8) ?? "error of string"
            LocalNetworkService.shared.send(string: jsonString)
        }catch {
            print("Ошибка при кодировании data: \(error)")
        }
    }
    
    func decoder(dataString: String) {
        var typeOfPlayer: TypeOfPlayer = .guest
        if let data = UserDefaults.standard.value(forKey: User.typeOfPlayer) {
            
            typeOfPlayer = (try? JSONDecoder().decode(TypeOfPlayer.self, from: data as! Data)) ?? TypeOfPlayer.guest
            print(typeOfPlayer)
        }
        
        guard let jsonData = dataString.data(using: .utf8) else { return}
        
        var model: ModelForSend!
        
        do {
            let sendModel = try JSONDecoder().decode(ModelForSend.self, from: jsonData)
            model = sendModel
            
        } catch {
            print("Decode error: \(error)")
        }
        
        if model.typeOfAction == .update {
            sendGameModel.send(model.model)
        }else {
            
            if typeOfPlayer == .bankir {
                
                switch model.typeOfAction {
                    
                case .buy :
                    AlertManager.shared.alertType = .userWantsToBuyHouse(model: model)
                    AlertManager.shared.showAlert = true
                case.payRent :
                    AlertManager.shared.alertType = .userWantsPayRent(model: model)
                    AlertManager.shared.showAlert = true
                case .payForLoop:
                    AlertManager.shared.alertType = .userWantsTakeMoneyForLoop(model: model)
                    AlertManager.shared.showAlert = true
                case .trade :
                    AlertManager.shared.alertType = .userWantsToTrade(model: model)
                    AlertManager.shared.showAlert = true
                case .buyHotel:
                    AlertManager.shared.alertType = .userWantsToBuyHotel(model: model)
                    AlertManager.shared.showAlert = true
                default: return
                    
                }
            }
        }
    }
}

//
//  StreetCells.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 1.12.23.
//

import SwiftUI

struct StreetsCells: View {
    
    @State var street: Street
    @EnvironmentObject var viewModel: GameViewModel
    //MARK: данные для трейда
    @State var recievedPlayer: Player? = nil
    
    //MARK: MONEY FOR TRADE
    @State var recievedMoney: Int?
    @State var myMoney: Int?
    //MARK: HOUSES FOR TRADE
    @State var recievedPlayerHouse: House?
    @State var myHouse: House?
    
    @State var typeOfView: TypeOfHouseView = .partnerHouse
    
    var body: some View {
        VStack{
            ForEach(street.houses, id: \.self) { house in
                Text(house.name.rawValue)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background(house.color)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 5)
                    )
                    .onTapGesture {
                        switch Router.shared.path.last{
                        case .buyView:
                            if house.owner != nil {
                                AlertManager.shared.alertType = .thisHouseIsBuyed
                                AlertManager.shared.showAlert = true
                            }else{
                                viewModel.buyHouse(house: house)
                            }
                        case .payRentView:
                            if house.owner != recievedPlayer{
                                AlertManager.shared.alertType = .userWantsPayRentForHouseOfAnotherPlayer
                                AlertManager.shared.showAlert = true
                            }else{
                                viewModel.payRent(nameOfReciver: recievedPlayer, house: house)
                            }
                        case .buyHotelView:
                            if house.countOfHouses > 5 {
                                AlertManager.shared.alertType = .userWantsBuySixthHotel
                                AlertManager.shared.showAlert = true
                                
                            }else {
                                viewModel.BuyHotel(house: house)
                            }
                        case .tradeView:
                            
                            switch typeOfView {
                            case .partnerHouse:
                                if house.owner != recievedPlayer{
                                    AlertManager.shared.alertType = .thisHouseHaveAnotherOwenr
                                    AlertManager.shared.showAlert = true
                                }else {
                                    recievedPlayerHouse = house
                                    typeOfView = .myHouse
                                }
                            case .myHouse:
                                if house.owner != viewModel.returnPlayer(){
                                    AlertManager.shared.alertType = .thisHouseHaveAnotherOwenr
                                    AlertManager.shared.showAlert = true
                                }else {
                                    myHouse = house
                                    viewModel.trade(partner: recievedPlayer, partnerHouses: recievedPlayerHouse!, myHouses: myHouse!, partnerMoney: recievedMoney!, myMoney: myMoney!)
                                }
                            }
                        default: break
                        }
                    }
            }
            if street.houses.count == 2 {
                Text("")
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background(.clear)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.clear, lineWidth: 5)
                    )
            }
        }.frame(width: 200,height: 150)
            .background(street.color)
            .background(Color.red)
            .cornerRadius(20)
    }
}


enum TypeOfHouseView{
    case partnerHouse
    case myHouse
}

//
//  TradeView.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 29.12.23.
//

import SwiftUI

struct TradeView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    @State var swapPartner: Player = Player(name: "", money: 0, color: .clear, id: UUID(), typeOfPlayer: .guest)
    @State var partnerMoney: String = "0"
    @State var myMoney: String = "0"
    @State var typeOfScreen: TypeOfTradeViewScreent = .swapPartner
    @State var textForHouseView = "Выберите дома которые хотите получить"
    
    let rows = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
    var body: some View {
        
        switch typeOfScreen {
        case .swapPartner:
            VStack(spacing: 4) {
                Text("Выберите игрока для обмена")
                HStack{
                    ForEach(viewModel.gameModel.players){player in
                        let me = viewModel.returnPlayer()
                        if player != me {
                            PlayerCells(player: player)
                                .onTapGesture {
                                    swapPartner = player
                                    typeOfScreen = .moneyOfSwapPartner
                                }
                        }
                    }
                }
            }
            
        case .moneyOfSwapPartner:
            VStack{
                
                Text("Введите колличество денег,которок хотите получить при обмене").padding().background(Color.gray).cornerRadius(20).foregroundColor(Color.white).font(.system(size: 20))
                VStack{
                    TextField("Введите сумму", text: $partnerMoney).padding().background(Color.white).cornerRadius(20)
                }.padding().background(Color.gray).cornerRadius(20)
                
                Button("готово"){
                    if Int(partnerMoney) == nil{
                        AlertManager.shared.alertType = .thisIsNotNumber
                        AlertManager.shared.showAlert = true
                    }
                    
                    if Int(partnerMoney) ?? 0 > swapPartner.money {
                        AlertManager.shared.alertType = .notEnoughtMoney
                        AlertManager.shared.showAlert = true
                    }else {
                        typeOfScreen = .myMoney
                    }
                    
                    
                }
                .padding()
                .background(Color.green)
                .cornerRadius(20)
                .foregroundColor(.white)
            }
            
        case .myMoney:
            VStack{
                Text("Сколько денег желаете отдать при обмене").padding().padding().background(Color.gray).cornerRadius(20).foregroundColor(Color.white).font(.system(size: 20))
                VStack{
                    TextField("Введите сумму", text: $myMoney).padding().background(Color.white).cornerRadius(20)
                }.padding().background(Color.gray).cornerRadius(20)
                
                HStack{
                    Button("Назад"){
                        typeOfScreen = .moneyOfSwapPartner
                    }.padding()
                        .background(Color.red)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                    Button("Готово"){
                        if Int(myMoney) == nil{
                            AlertManager.shared.alertType = .thisIsNotNumber
                            AlertManager.shared.showAlert = true
                        }
                        
                        if Int(myMoney) ?? 0 > viewModel.returnPlayer()!.money {
                            AlertManager.shared.alertType = .notEnoughtMoney
                            AlertManager.shared.showAlert = true
                        } else {
                            typeOfScreen = .houses
                        }
                    }.padding()
                        .background(Color.green)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                }.padding()
                    .background(Color.gray)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                
            }
            
        case .houses:
            VStack{
                Text(textForHouseView)
                Spacer()
                ScrollView(.horizontal, showsIndicators: false){
                    LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 0), count: 1),spacing: 8) {
                        ForEach(viewModel.gameModel.streets){street in
                            if (street.houses.first(where: {$0.owner == swapPartner}) != nil) || ((street.houses.first(where: {$0.owner == viewModel.returnPlayer()}) != nil)) {
                                StreetsCells(street: street, recievedPlayer: swapPartner,recievedMoney: Int(partnerMoney),myMoney: Int(myMoney) )
                                    .padding(6)
                                    .background(Color.gray)
                                    .cornerRadius(20)
                            }
                            
                        }
                    }
                    .environmentObject(viewModel)
                }
                .ignoresSafeArea()
                .frame(height: .minimum(190, 1000))
                Button("Далее"){
                    textForHouseView = "Выберите дома которые хотите отдать"
                }
            }
        }
    }
}
enum TypeOfTradeViewScreent{
    case swapPartner
    case moneyOfSwapPartner
    case houses
    case myMoney
}

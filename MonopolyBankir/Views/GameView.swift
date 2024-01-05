//
//  GameView.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 13.12.23.
//

import SwiftUI

struct GameView: View {
    
    @ObservedObject var router = Router.shared
    @ObservedObject var alertManager = AlertManager.shared
    @EnvironmentObject var viewModel: GameViewModel
    @State var name = ""
    var body: some View {
        
        NavigationStack(path: $router.path){
            
            VStack{
                HStack{
                    ForEach(viewModel.gameModel.players){ player in
                        PlayerCells(player: player).onTapGesture {
                            router.showPlayerView(player: player)
                        }
                    }
                    
                }.padding(16).background(Color.gray).cornerRadius(20)
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), alignment: .center, spacing: 16) {
                    ForEach(viewModel.buttonTypes, id: \.self) { type in
                        Button(action: {
                            viewModel.actionOfButton(type)
                        }, label: {
                            Text("\(type.getName())")
                                .frame(maxWidth: .infinity)
                        })
                        .padding()
                        .background(Color.skyBlue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(20)
                    .foregroundColor(.black)
                }
                .padding(16)
                    .navigationBarBackButtonHidden()
                    .ignoresSafeArea()
            }.onReceive(sendGameModel, perform: { model in
                viewModel.gameModel = model
                
            })
            .alert(isPresented: $alertManager.showAlert) {
                customAlertSubView 
            }

            .navigationDestination(for: Route.self) { route in
                switch route {
                case .tradeView :
                    TradeView()
                    
                case .streetsView :
                    StreetsView()
                    
                case .playerView(let player) :
                    PlayerView(player: player)
                    
                case .payRentView :
                    PayRentView()
                    
                case .buyView :
                    BuyView()
                    
                case .buyHotelView :
                    BuyHotelsView()
                }
            }
        }
    }
    var customAlertSubView: Alert {
        alertManager.alertType.returnAlertView(action: {
            alertManager.showAlert = false
        })
    }
}

//#Preview {
//    GameView()
//}

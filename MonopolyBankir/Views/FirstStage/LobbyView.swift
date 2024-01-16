//
//  LobbyView.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 13.12.23.
//

import SwiftUI
import Combine

let changeCountOfBrowser = PassthroughSubject <Bool, Never>()
struct LobbyView: View{
    
    @EnvironmentObject var viewModel: GameViewModel
    @State var typeOfPlayer: TypeOfPlayer
    @State var arrayOfUsers: [String] = []
    @State var name: String
    @Binding var showlobbyScreen: Bool
    @Binding var showGameScreen: Bool
    var body: some View {
        VStack(spacing: 16) {
            
            HStack{
                Text("Back")
                    .onTapGesture {
                        showlobbyScreen.toggle()
                    }.padding().background(Color.blue).cornerRadius(20)
                Spacer()
            }
            
            Spacer()
            
            VStack{
                
                Text("Now in lobby \(arrayOfUsers.count) users:")
                
                HStack{
                ForEach(arrayOfUsers, id: \.self) { name in
                    PlayerCells(player: Player(name: name, money: 0, color: Color.random, id: UUID(), typeOfPlayer: .guest))
                }
            }
            }.padding().background(Color.gray).cornerRadius(20)
            
            Spacer()
        
        if typeOfPlayer == .bankir {
            
            Button("START"){
                for playerName in arrayOfUsers {
                    if playerName == name {
                        viewModel.addNewPlayer(name: playerName,typeOfPlayer: .bankir)
                    }else {
                        viewModel.addNewPlayer(name: playerName,typeOfPlayer: .guest)
                    }
                }
                viewModel.starnGame()
                let model = ModelForSend(typeOfAction: .update, model: viewModel.gameModel, fromWho: .bankir)
                Coder().encoder(viewModel: model)
            }.padding().background(Color.green).cornerRadius(20).foregroundStyle(Color.white)
        }
        
        }.padding(16)
        .navigationBarBackButtonHidden()
        .onAppear{
            LocalNetworkService.shared.startDeinit()
            LocalNetworkService.shared.restartLocalNW(name: name)
            self.arrayOfUsers = LocalNetworkService.shared.getArrayOfUsers()
        }
        .onReceive(sendGameModel, perform: { model in
            viewModel.gameModel = model
                showGameScreen = true
        })
        .onReceive(changeCountOfBrowser, perform: { _ in
            self.arrayOfUsers = LocalNetworkService.shared.getArrayOfUsers()
        })
}

}

//
//  EnterNameView.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 13.12.23.
//

import SwiftUI

struct EnterNameScreen: View {
    
    @StateObject var viewModel = GameViewModel()
    @State var typeOfPlayer: TypeOfPlayer
    @State var enteredName: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State var showlobbyScreen: Bool = false
    @State var startGame: Bool = false
    var body: some View {
        VStack(content: {
            
            if !showlobbyScreen {
                Text("Hello, \(typeOfPlayer.rawValue)").padding().background(Color.gray).cornerRadius(20).foregroundColor(Color.white).font(.system(size: 30))
                VStack{
                    TextField("Enter name:", text: $enteredName).padding().background(Color.white).cornerRadius(20)
                }.padding().background(Color.gray).cornerRadius(20)
                HStack{
                    Text("Back")
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }.frame(width: 120,height: 50).background(Color.blue).foregroundColor(.white).cornerRadius(20)
                    Text("Start")
                        .onTapGesture {
                            if enteredName == ""{
                                AlertManager.shared.alertType = .shouldEnterName
                                AlertManager.shared.showAlert = true
                            }else {
                                showlobbyScreen.toggle()
                                saveTypeOfPlayer(typeOfPlayer: typeOfPlayer)
                            }
                        }.frame(width: 120,height: 50).background(Color.green).foregroundColor(.white).cornerRadius(20)
                    
                }.padding().background(Color.gray).cornerRadius(20)
                
            } else {
                if startGame {
                    GameView().environmentObject(viewModel)
                } else {
                    LobbyView( typeOfPlayer: typeOfPlayer, name: enteredName, showlobbyScreen: $showlobbyScreen, showGameScreen: $startGame).environmentObject(viewModel)
                }
            }
        })
        .navigationBarBackButtonHidden()
    }
    
    func saveTypeOfPlayer(typeOfPlayer: TypeOfPlayer) {
        if let encoded = try? JSONEncoder().encode(typeOfPlayer) {
            UserDefaults.standard.set(encoded, forKey: User.typeOfPlayer)
        }
    }
    
}


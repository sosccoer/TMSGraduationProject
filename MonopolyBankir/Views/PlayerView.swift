//
//  PlayerView.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 14.12.23.
//

import SwiftUI

struct PlayerView: View {
    
    @EnvironmentObject var viewModel: GameViewModel
    @State var player: Player
    let rows = Array(repeating: GridItem(.flexible()), count: 1)
    
    var body: some View {
        VStack {
            HStack {
                PlayerCells(player: player)
                Text("Money: \(player.money)").padding().background(Color.gray).cornerRadius(20)
            }
            
            VStack{
                ScrollView(.horizontal,showsIndicators: false) {
                    LazyHGrid(rows: rows,spacing: 16) {
                        ForEach(viewModel.gameModel.streets){ street in
                            if (street.houses.first(where: {$0.owner == player}) != nil) {
                                StreetsCells(street: street)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

//#Preview {
//    PlayerView(player: Player(name: "432", money: 213, color: Color.red, id: UUID(), typeOfPlayer: .bankir))
//}

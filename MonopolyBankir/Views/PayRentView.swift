//
//  PayRentView.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 17.12.23.
//

import SwiftUI

struct PayRentView: View {
    
    @EnvironmentObject var viewModel: GameViewModel
    @State var recievedPlayer: Player?
    
    let rows = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
    
    var body: some View {
        switch recievedPlayer == nil {
        case true:
            VStack(spacing: 4) {
                HStack{
                    ForEach(viewModel.gameModel.players){player in
                        PlayerCells(player: player)
                            .onTapGesture {
                                recievedPlayer = player
                            }
                    }
                }
            }
        case false:
            ScrollView(.horizontal,showsIndicators: false) {
                LazyHGrid(rows: rows,spacing: 8) {
                    ForEach(viewModel.gameModel.streets){street in
                        if (street.houses.first(where: {$0.owner == recievedPlayer}) != nil) {
                            StreetsCells(street: street, recievedPlayer: recievedPlayer)
                                .padding(6)
                                .background(Color.gray)
                                .cornerRadius(20)
                        }
                    }
                }.environmentObject(viewModel)
            }.ignoresSafeArea(.all, edges: [.top, .bottom,.trailing])
        }
    }
}

//#Preview {
//    PayRentView()
//}

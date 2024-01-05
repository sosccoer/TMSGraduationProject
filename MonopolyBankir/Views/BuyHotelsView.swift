//
//  BuyHotelsView.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 28.12.23.
//

import SwiftUI

struct BuyHotelsView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State var recievedPlayer: Player?
    
    let rows = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            LazyHGrid(rows: rows,spacing: 8) {
                ForEach(viewModel.gameModel.streets){street in
                    let me = viewModel.returnPlayer()
                    if (street.houses.allSatisfy({$0.owner == me})) {
                        StreetsCells(street: street, recievedPlayer: recievedPlayer)
                            .padding(6)
                            .background(Color.gray)
                            .cornerRadius(20)
                    }
                }
            }.environmentObject(viewModel)
        }
    }
}

#Preview {
    BuyHotelsView()
}

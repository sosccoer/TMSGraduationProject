//
//  StreetsView.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 9.12.23.
//

import SwiftUI

struct StreetsView: View {
    
    @EnvironmentObject var viewModel: GameViewModel
    let rows = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHGrid(rows: rows,spacing: 16) {
                ForEach(viewModel.gameModel.streets){street in
                    StreetsCells(street: street)
                        .padding(6)
                            .background(Color.gray)
                            .cornerRadius(20)
                }
            }
        }
    }
}

//struct StreetsView_Previews: PreviewProvider {
//    let vm = GameViewModel()
//    static var previews: some View {
//        StreetsView().environmentObject(GameViewModel(viewModel: GameModel()))
//    }
//}




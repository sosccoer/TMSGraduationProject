//
//  BuyView.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 24.12.23.
//

import SwiftUI

struct BuyView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State var recievedPlayer: Player?
    
    let rows = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
    
    var body: some View {
        
        Spacer()
        
        VStack(spacing: 4) {
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                LazyHGrid(rows: rows,spacing: 8) {
                    
                    ForEach(viewModel.gameModel.streets){street in
                        if (street.houses.first(where: {$0.owner == recievedPlayer}) != nil) {
                            StreetsCells(street: street, recievedPlayer: recievedPlayer)
                                .padding(6)
                                .background(Color.gray)
                                .cornerRadius(20)
                        }
                    }.environmentObject(viewModel)
                    
                    
                    Spacer()
                }.ignoresSafeArea(.all, edges: [.top, .bottom,.trailing])
                Spacer()
            }
            
        }
        
    }
}

//#Preview {
//    BuyView()
//}

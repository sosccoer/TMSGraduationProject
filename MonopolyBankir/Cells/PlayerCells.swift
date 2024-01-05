//
//  UserCells.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 30.11.23.
//

import SwiftUI

struct PlayerCells: View {
    
    @State var player: Player
    
    var body: some View {
        Text(player.name).padding()
            .background(player.color)
            .cornerRadius(25)
    }
}

//struct UserCells_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack{
//            Spacer(minLength: 16)
//            HStack {
//                
//                PlayerCells(player: Player(name: "alex", money: 142, color: .random, id: UUID(), typeOfPlayer: .guest))
//                PlayerCells(player: Player(name: "yuliya", money: 142, color: .random, id: UUID(), typeOfPlayer: .guest))
//                PlayerCells(player: Player(name: "alex", money: 142, color: .random, id: UUID(), typeOfPlayer: .guest))
//                PlayerCells(player: Player(name: "yuliya", money: 142, color: .random, id: UUID(), typeOfPlayer: .guest))
//                PlayerCells(player: Player(name: "alex", money: 142, color: .random, id: UUID(), typeOfPlayer: .guest))
//                PlayerCells(player: Player(name: "yuliya", money: 142, color: .random, id: UUID(), typeOfPlayer: .guest))
//                PlayerCells(player: Player(name: "alex", money: 142, color: .random, id: UUID(), typeOfPlayer: .guest))
//                PlayerCells(player: Player(name: "yuliya", money: 142, color: .random, id: UUID(), typeOfPlayer: .guest))
//                
//            }.padding()
//                .background(Color.gray)
//                .cornerRadius(20)
//            
//            Spacer(minLength: 280)
//            
//        }
//    }
//}

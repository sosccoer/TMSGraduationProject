//
//  StartScreen.swift
//  MonopolyBankir
//
//  Created by Виктор Васильков on 2023-12-11.
//

import SwiftUI
import Network

struct StartScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("MONOPOLY")
                    .font(.system(size: 100))
                    .bold()
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                
                VStack{
                    
                    Text("Choose your destiny").font(.system(size: 30)).foregroundColor(.white)
                    
                    HStack {
                        NavigationLink("Bankir") {
                            EnterNameScreen(typeOfPlayer: .bankir)
                        }.frame(width: 120,height: 50).background(Color.blue).foregroundColor(.white).cornerRadius(20)
                        NavigationLink("Guest") {
                            EnterNameScreen(typeOfPlayer: .guest)
                        }.frame(width: 120,height: 50).background(Color.pink).foregroundColor(.white).cornerRadius(20)
                    }
                }.padding()
                    .background(Color.gray)
                    .cornerRadius(20)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
enum TypeOfPlayer: String, Codable {
    case bankir = "Bankir"
    case guest = "Guest"
}

//struct StartScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        StartScreen()
//    }
//}

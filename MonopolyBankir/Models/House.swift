//
//  House.swift
//  MonopolyBankir
//
//  Created by lelya.rumynin@gmail.com on 30.11.23.
//

import Foundation
import SwiftUI

struct Street: Identifiable,Codable, Hashable{
    var id: Int
    var name: StreetName
    var houses: [House]
    var color: Color?
    
    init (id: Int, name: StreetName, houses: [House], color: Color) {
        self.id = id
        self.name = name
        self.houses = houses
        self.color = color
    }
    static func == (lhs: Street, rhs: Street) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.houses == rhs.houses &&
        lhs.color == rhs.color
    }
}

struct House: Identifiable,Codable,Hashable {
    var id: Int
    var price: Int
    var name: HouseNames
    var color: Color?
    var owner: Player? 
    var priceOfRent: Int
    var countOfHouses: Int
    
    static func == (lhs: House, rhs: House) -> Bool {
        return lhs.id == rhs.id &&
        lhs.price == rhs.price &&
        lhs.name == rhs.name &&
        lhs.color == rhs.color &&
        lhs.owner == rhs.owner
    }
}

enum StreetName: String,Codable {
    case brown
    case blue
    case pink
    case orange
    case red
    case yellow
    case green
    case darkBlue
    case railRoad
    case tax
}

enum HouseNames: String, Codable {
    case BalticAvenue =         "Baltic Avenue"
    case MediaterraneanAvenue = "Mediaterranean Avenue"
    case ConnecticutAvenue =    "Connecticut Avenue"
    case VermontAvenue =        "Vermont Avenue"
    case OrientalAvenue =       "Oriental Avenue"
    case VirginiaAvenue =       "Virginia Avenue"
    case StatesAvenue =         "States Avenue"
    case StCharlesPlace =       "St. Charles Place"
    case NewYorkAvenue =        "New York Avenue"
    case TennesseeAvenue =      "Tennessee Avenue"
    case STJamesPlace =         "ST. James Place"
    case IllinoisAvenue =       "Illinois Avenue"
    case IndianaAvenue =        "Indiana Avenue"
    case KentuckyAvenue =       "Kentucky Avenue"
    case MarvinGardens =        "Marvin Gardens"
    case VentnorAvenue =        "Ventnor Avenue"
    case AtlanticAvenue =       "Atlantic Avenue"
    case PennsylvaniaAvenue =   "Pennsylvania Avenue"
    case NorthCarolinaAvenue =  "North Carolina Avenue"
    case PacificAvenue =        "Pacific Avenue"
    case Boardwalk =            "Boardwalk"
    case ParkPlace =            "Park Place"
    case readingRailroad =      "Reading Railroad"
    case PensylvaniaRailroad =  "Pensylvania Railroad"
    case BQRailroad =           "B. & Q. Railroad"
    case ShortLine =            "Short Line"
}



//
//
//enum StreetEnum {
//    case brown(BrownHouse)
//    case blue(BlueHouse)
//    case pink(PinkHouse)
//    // Добавьте другие улицы по мере необходимости
//
//    enum BrownHouse: String, Codable {
//        case house1
//        case house2
//        case house3
//        // Добавьте другие названия домов для коричневой улицы по мере необходимости
//    }
//
//    enum BlueHouse: String, Codable {
//        case house1
//        case house2
//        case house3
//        // Добавьте другие названия домов для синей улицы по мере необходимости
//    }
//
//    enum PinkHouse: String, Codable {
//        case house1
//        case house2
//        case house3
//        // Добавьте другие названия домов для розовой улицы по мере необходимости
//    }
//}
//
//// Пример использования
//let brownStreet: Street = .brown(.house1)
//let blueStreet: Street = .blue(.house2)
//
//switch brownStreet {
//case .brown(let house):
//    print("Brown street, house: \(house.rawValue)")
//case .blue(let house):
//    print("Blue street, house: \(house.rawValue)")
//case .pink(let house):
//    print("Pink street, house: \(house.rawValue)")
//}

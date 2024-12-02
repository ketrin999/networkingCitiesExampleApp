//
//  Country.swift
//  Cities
//
//  Created by Ekaterina Yashunina on 10.09.2023.
//

import Foundation

struct Country: Codable {
    let id: Int
    let name: String
    let cities: [City]
}



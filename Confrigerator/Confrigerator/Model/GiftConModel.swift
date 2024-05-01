//
//  GiftConModel.swift
//  Confrigerator
//
//  Created by BAE on 5/2/24.
//

import Foundation

struct GiftCon: Identifiable, Hashable {
    var id: Int
    var name: String
    var image: String
}

let dummyData: [GiftCon] = [
    GiftCon(id: 0, name: "더미1", image: "photo"),
    GiftCon(id: 1, name: "더미2", image: "photo"),
    GiftCon(id: 2, name: "더미3", image: "photo"),
    GiftCon(id: 3, name: "더미4", image: "photo"),
    GiftCon(id: 4, name: "더미5", image: "photo"),
    GiftCon(id: 5, name: "더미6", image: "photo"),
]

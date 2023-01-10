//
//  RestaurantVO.swift
//  WherEat
//
//  Created by 陳武玄 on 2023/1/5.
//

import UIKit

struct RestaurantVO: Codable {
    var lat: CGFloat = 0.00
    var lng: CGFloat = 0.00
    var rating: Double = 0.0
    var name: String = ""
    var vicinity: String = ""
    var photo: String = ""
}

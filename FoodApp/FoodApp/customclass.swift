//
//  customclass.swift
//  FoodApp
//
//  Created by kaho ito on 2023/03/04.
//

import Foundation

// jsonのDecoad用構造体の設定
struct resulted:Decodable{
    let results:shops
}
    
struct shops:Decodable{
    let shop:[Shop]
}
    
struct Shop:Decodable{
    let name:String
    let logo_image:String
    let access:String
    let address:String
    let open:String
    let lat:Double
    let lng:Double
    let photo:Photo
}

struct Photo:Decodable{
    let mobile:Mobile
}

struct Mobile:Decodable{
    let l:String
    let s:String
}

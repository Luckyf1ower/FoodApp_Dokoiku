//
//  globalvalue.swift
//  FoodApp
//
//  Created by kaho ito on 2023/03/04.
//
import UIKit

class globalvalue: NSObject {
    let baseURL:String = "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=6df5714c2b68d225&format=json"
    
    let pickerdata = ["300m", "500m", "1km", "2km", "3km"]
    var pickerRow:Int = 100
    
    var latitude:Double = 0
    var longitude:Double = 0
    var allowGPS:Bool = false
    var searchtext:String = ""
    var numOfShops:Int = 100
    var shopinfos:[resulted] = []
    var selectedcell:Int = 100
}

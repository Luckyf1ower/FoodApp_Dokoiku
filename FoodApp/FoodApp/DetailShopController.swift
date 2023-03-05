//
//  DetailShopController.swift
//  FoodApp
//
//  Created by kaho ito on 2023/03/05.
//

import UIKit
import MapKit

class DatailShopController: UIViewController{
    
    @IBOutlet weak var ShopName: UILabel!
    @IBOutlet weak var ShopImg: UIImageView!
    @IBOutlet weak var ShopAddress: UILabel!
    @IBOutlet weak var ShopOpen: UILabel!
    @IBOutlet weak var ShopAccess: UILabel!
    @IBOutlet weak var ShopMap: MKMapView!
    
    var selectedRow = globalvars.selectedcell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 各要素に情報を格納する
        ShopImg.image = getImageByUrl(url: globalvars.shopinfos[0].results.shop[selectedRow].photo.mobile.l)
        
        ShopName.text = globalvars.shopinfos[0].results.shop[selectedRow].name
        ShopName.adjustsFontSizeToFitWidth = true
        
        ShopAddress.text = globalvars.shopinfos[0].results.shop[selectedRow].address
        ShopAddress.adjustsFontSizeToFitWidth = true
        
        ShopAccess.text = globalvars.shopinfos[0].results.shop[selectedRow].access
        ShopAccess.adjustsFontSizeToFitWidth = true
        
        ShopOpen.text = globalvars.shopinfos[0].results.shop[selectedRow].open
        ShopOpen.adjustsFontSizeToFitWidth = true
        
        // 地図情報の表示設定
        let loc = CLLocation(latitude: globalvars.shopinfos[0].results.shop[selectedRow].lat, longitude: globalvars.shopinfos[0].results.shop[selectedRow].lng)
        let cr = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        ShopMap.setRegion(cr, animated: true)
                
        let point = MKPointAnnotation()
        point.title = "お店はこちら！"
        point.coordinate = loc.coordinate
        ShopMap.removeAnnotations(ShopMap.annotations)
        ShopMap.addAnnotation(point)
    }
    
    // URLからUIImageへ変換するメソッド
    func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
}

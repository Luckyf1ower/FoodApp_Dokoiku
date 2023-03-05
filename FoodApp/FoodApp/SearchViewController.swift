//
//  SearchViewController.swift
//  FoodApp
//
//  Created by kaho ito on 2023/03/04.
//

import UIKit
import CoreLocation

let globalvars = globalvalue()

class SearchViewController: UIViewController {
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var LogoImage: UIImageView!
    
    let locationManager = CLLocationManager()
    var picker: UIPickerView = UIPickerView()
    let semaphore = DispatchSemaphore(value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        keyboardsetup()
        locationManager.delegate = self
        LogoImage.image = UIImage(named: "Logo")
    }
    
    // pickerviewのキーボード設定
    private func keyboardsetup() {
        picker.delegate = self
        picker.dataSource = self
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SearchViewController.tappedDone))
        toolbar.items = [space, doneButton]
        toolbar.sizeToFit()
        textfield.inputView = picker
        textfield.inputAccessoryView = toolbar
    }
        
    @objc func tappedDone() {
        textfield.resignFirstResponder()
    }
    
    // 検索ボタンを押した後の処理
    @IBAction func tappedSearchButton(_ sender: UIButton) {
        if globalvars.pickerRow == 100 {
            Alert.okAlert(vc: self, title: "検索条件の半径を\n選択して下さい", message: "")
        } else {
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                    self.locationManager.requestWhenInUseAuthorization() // 位置情報サービスを使用するために許可を要求する
                }
                self.locationManager.delegate = self
            }
            if globalvars.allowGPS == true{
                // 検索URLの作成
                let urlString = globalvars.baseURL+"&lat="+String(globalvars.latitude)+"&lng="+String(globalvars.longitude)+"&range="+String(globalvars.pickerRow)
                let url = URL(string: urlString)!
                
                let task: URLSessionTask = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
                    do{
                        guard let data = data else{
                            return
                        }
                        // utf8の文字化け解消のために一度Stringにキャスト
                        let Stringdata = String(data: data, encoding: .utf8)
                        // data型に再変換して日本語表記に
                        let castdata = Stringdata?.data(using: .utf8)
                        let resultdata:resulted = try JSONDecoder().decode(resulted.self, from: castdata!)
                        globalvars.shopinfos = [resultdata]
                        globalvars.numOfShops = globalvars.shopinfos[0].results.shop.count
                        self.semaphore.signal()
                    }catch{
                        print(error)
                    }
                })
                task.resume()
                self.semaphore.wait()
                print("test")
                self.performSegue(withIdentifier: "ToResult", sender: nil)
            } else {
                Alert.okAlert(vc: self, title: "アプリの位置情報サービスを\nオンにして下さい", message: "")
            }
            
        }
        
    }
}

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return globalvars.pickerdata.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return globalvars.pickerdata[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        globalvars.searchtext = "半径"+globalvars.pickerdata[row]+"以内のお店"
        textfield.text = globalvars.searchtext
        globalvars.pickerRow = row
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // プロパティの確認
        switch manager.authorizationStatus {
        case .notDetermined: // 初回呼び出し時、設定で次回確認を選択時
            self.locationManager.requestWhenInUseAuthorization()
            print("notDetermined")
            break
        case .restricted: // ペアレンタルコントロールなどの制限あり
            self.locationManager.requestWhenInUseAuthorization()
            print("restricted")
            break
        case .denied: // 使用拒否した
            self.locationManager.requestWhenInUseAuthorization()
            print("denied")
            Alert.okAlert(vc: self, title: "アプリの位置情報サービスを\nオンにして下さい", message: "")
            break
        case .authorizedAlways: // いつでも位置情報サービスを開始することを許可した
            print("authorizedAlways")
            manager.startUpdatingLocation() // 位置情報の取得開始
            globalvars.allowGPS = true
            break
        case .authorizedWhenInUse: // アプリ使用中のみ位置情報サービスを開始することを許可した
            print("authorizedWhenInUse")
            manager.startUpdatingLocation() // 位置情報の取得開始
            globalvars.allowGPS = true
        @unknown default:
            break
        }
        
        // 位置情報精度の確認
        switch manager.accuracyAuthorization {
        case .fullAccuracy: // 正確な位置情報
            print("fullAccuracy")
            break
        case .reducedAccuracy: // おおよその位置情報
            print("reducedAccuracy")
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations: \(locations)") //  位置情報の取得成功
        if let loc = locations.last {
            print("lat: \(loc.coordinate.latitude), loc: \(loc.coordinate.longitude)")
            globalvars.latitude = fabs(loc.coordinate.latitude)
            globalvars.longitude = fabs(loc.coordinate.longitude)
        }
        manager.stopUpdatingLocation() // 位置情報の収集終了
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError: \(error)") //  位置情報の取得失敗
    }
}


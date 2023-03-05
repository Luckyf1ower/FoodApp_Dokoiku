//
//  ResultViewController.swift
//  FoodApp
//
//  Created by kaho ito on 2023/03/04.
//

import UIKit

class ResultViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textfield: UITextField!
    
    var picker: UIPickerView = UIPickerView()
    var rownum = globalvars.pickerRow+1
    var shopinfos = [resulted]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.text = globalvars.searchtext
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalvars.numOfShops
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの表示設定
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = globalvars.shopinfos[0].results.shop[indexPath.row].name
        cell.detailTextLabel?.text = globalvars.shopinfos[0].results.shop[indexPath.row].access
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.imageView?.image = getImageByUrl(url: globalvars.shopinfos[0].results.shop[indexPath.row].logo_image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalvars.selectedcell = indexPath.row
        // 選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 詳細画面へ遷移
        performSegue(withIdentifier: "ToDatail", sender: nil)
    }
    
    // URLからUIImageに変換するメソッド
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

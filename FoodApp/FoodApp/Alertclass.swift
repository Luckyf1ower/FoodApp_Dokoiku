//
//  Alertclass.swift
//  FoodApp
//
//  Created by kaho ito on 2023/03/04.
//

import UIKit

// Alert表示設定用のクラス
final class Alert {
    static func okAlert(vc: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let okAlertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        okAlertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        vc.present(okAlertVC, animated: true, completion: nil)
     }
}

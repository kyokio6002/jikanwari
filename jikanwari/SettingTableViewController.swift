//
//  SettingTableViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/25.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    //saveボタン
    var saveBarButton = UIBarButtonItem()
    //時間割データ配列を空で宣言
    var jikanwariDatas:[jikanwariDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBarButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveBarButtonTapped(_:)))
        
        //データをuserDefaultsからとってきて入れる
        jikanwariDatas = getJikanwariData()
        //保存ボタンの配置
        self.navigationItem.rightBarButtonItem = saveBarButton
    }

    @IBOutlet weak var jikanwariNameTextField: UITextField!
    @IBOutlet weak var classesTextField: UITextField!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var sumPointsLabel: UILabel!
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択の解除
        tableView.deselectRow(at: indexPath, animated: true)
        //別の画面に遷移
        if indexPath.section == 0{
            if indexPath.row == 2{
                performSegue(withIdentifier: "goDays", sender: nil)
            }
        }
    }
    
    @objc func saveBarButtonTapped(_ sender:UIBarButtonItem){
        var jikanwariName:String = ""
        var classes:Int = 5
        
        if jikanwariNameTextField.text != nil && jikanwariNameTextField.text != ""{
            jikanwariName = jikanwariNameTextField.text!
        }else{
            print("時間割の名前が設定されていません")
        }
        if classesTextField.text != nil && classesTextField.text != ""{
            classes = Int(classesTextField.text!) ?? 5
        }else{
            print("最大授業数が設定されていません")
        }
        jikanwariDetail.init(jikanwariName: jikanwariName, jikanwariModelNum: 00, days: 5, classes: classes, initialOrNot: true)
        
        
    }

    
    //保存作業
    func saveJikanwariData(jikanwariDetails:[jikanwariDetail]){
        let data = jikanwariDetails.map{try! JSONEncoder().encode($0)}
        let userDefaults = UserDefaults.standard
        userDefaults.set(data as [Any],forKey: "jikanwariDetails")
        userDefaults.synchronize()
    }
    //取り出し作業
    func getJikanwariData()->[jikanwariDetail]{
        let userDefaults = UserDefaults.standard
        guard let jikanwariDetails = userDefaults.array(forKey: "jikanwariDetails") as? [Data] else { return [jikanwariDetail]() }
        
        let decodedJikanwariDetails = jikanwariDetails.map { try! JSONDecoder().decode(jikanwariDetail.self, from: $0) }
        return decodedJikanwariDetails
    }
}

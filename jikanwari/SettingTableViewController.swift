//
//  SettingTableViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/25.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class SettingTableViewController: UITableViewController {

    //saveボタン
    var saveBarButton = UIBarButtonItem()
    //新規(exist==fauls)か既存(exist==true)か
    var exist:Bool = false
    //既存の場合のプライマリーキー
    var nowJikanwariData:jikanwariDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBarButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveBarButtonTapped))
        
        //保存ボタンの配置
        self.navigationItem.rightBarButtonItem = saveBarButton
        
        setDetils()
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
            }else if indexPath.row == 3{
                performSegue(withIdentifier: "goAllClassesAndPoints", sender: nil)
            }
        }else if indexPath.section == 1{
            if nowJikanwariData?.initialOrNot == true{
                //何もせず
            }else if nowJikanwariData?.initialOrNot == false{
                let cell = super.tableView(tableView, cellForRowAt: indexPath)
                cell.textLabel?.text = "この時間割はメインに設定されています"
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = .lightGray
                
                let realm = try! Realm()
                let theJikanwari = realm.object(ofType: jikanwariDetail.self, forPrimaryKey: nowJikanwariData?.jikanwariModelNum)
                let AllJikanwari = realm.objects(jikanwariDetail.self)
                try! realm.write{
                    theJikanwari?.initialOrNot = true
                    for i in 0..<AllJikanwari.count{
                      AllJikanwari[i].initialOrNot = false
                    }
                    theJikanwari?.initialOrNot = true
                }
            }
        }else if indexPath.section == 3 {
            let alert = UIAlertController(title: "消去しますか？", message: "この時間割を消去します", preferredStyle: .alert)
            let ok = UIAlertAction(title: "消去", style: .default) { (UIAlertAction) in
                let realm = try! Realm()
                let deleteJikanwari = realm.object(ofType: jikanwariDetail.self, forPrimaryKey: self.nowJikanwariData?.jikanwariModelNum)
                try! realm.write{
                    realm.delete(deleteJikanwari!.classDetail)
                    realm.delete(deleteJikanwari!)
                }
                self.navigationController?.popViewController(animated: true)
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            if exist == true{
                present(alert,animated: true,completion: nil)
            }
            else{
                
            }
        }
    }
    
    @objc func saveBarButtonTapped(){
        if exist == true{
            let realm = try! Realm()
            let theJikanwari = realm.object(ofType: jikanwariDetail.self, forPrimaryKey: nowJikanwariData?.jikanwariModelNum)
            try! realm.write{
                theJikanwari?.jikanwariName = jikanwariNameTextField.text
                theJikanwari?.days = checkDays(days: daysLabel.text!)
                if Int(classesTextField.text!) != nil && Int(classesTextField.text!)! >= 0 && Int(classesTextField.text!)! <= 12{
                    theJikanwari?.classes = Int(classesTextField.text!)!
                }else{
                    theJikanwari?.classes = 12
                }
            }
        }else if exist == false{
            if jikanwariNameTextField.text != nil && jikanwariNameTextField.text != ""{
                let realm = try! Realm()
                let theClass:jikanwariDetail = jikanwariDetail()
                
                theClass.jikanwariName = jikanwariNameTextField.text
                theClass.days = checkDays(days: daysLabel.text!)
                theClass.classes = Int(classesTextField.text!) ?? 5
                theClass.initialOrNot = false
                
                try! realm.write{
                    realm.add(theClass)
                }
            }else{
                let alert = UIAlertController(title: "時間割名を入力してください", message: "時間割名が入力されていません", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert,animated: true,completion: nil)
            }
        }else{
            print("error")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func setDetils(){
        //既存の場合
        if exist == true{
            jikanwariNameTextField.text = nowJikanwariData?.jikanwariName
            classesTextField.text = String((nowJikanwariData?.classes)!)
            daysLabel.text = daysDisplay(days: (nowJikanwariData?.days)!)
            sumPointsLabel.text = String((nowJikanwariData?.AllPoints)!)
            //nowJikanwariDataがメインに設定されている場合
            if nowJikanwariData?.initialOrNot == true{
                let MainOrNotCell = super.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))
                MainOrNotCell.textLabel?.text = "この時間割はメインに設定されています"
                MainOrNotCell.textLabel?.textAlignment = .center
                MainOrNotCell.textLabel?.textColor = .lightGray
            }else if nowJikanwariData?.initialOrNot == false{
                let MainOrNotCell = super.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))
                MainOrNotCell.textLabel?.text = "この時間割をメインに設定する"
                MainOrNotCell.textLabel?.textAlignment = .center
                MainOrNotCell.textLabel?.textColor = .red
            }
            let DeletCell = super.tableView(tableView,cellForRowAt: IndexPath(row: 0, section: 3))
            DeletCell.textLabel?.text = "この時間割を消去する"
            DeletCell.textLabel?.textAlignment = .center
            DeletCell.textLabel?.textColor = .red
        }else if exist == false{
            let MainOrNotCell = super.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))
            MainOrNotCell.textLabel?.text = "この時間割をメインに設定する"
            MainOrNotCell.textLabel?.textAlignment = .center
            MainOrNotCell.textLabel?.textColor = .red
            
            let DeletCell = super.tableView(tableView,cellForRowAt: IndexPath(row: 0, section: 3))
            DeletCell.textLabel?.text = "時間割が登録されていません"
            DeletCell.textLabel?.textAlignment = .center
            DeletCell.textLabel?.textColor = .lightGray
        }else{
            print("error")
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDays"{
            if let nextVC = segue.destination as? DaysTableViewController{
                nextVC.exist = exist
                if daysLabel.text == "月火水木金"{
                    nextVC.useDaysHere = 5
                }else if daysLabel.text == "月火水木金土"{
                    nextVC.useDaysHere = 6
                }else if daysLabel.text == "月火水木金土日"{
                    nextVC.useDaysHere = 7
                }else{
                    nextVC.useDaysHere = 5
                }
            }
        }else if segue.identifier == "goAllClassesAndPoints"{
            if let nextVC = segue.destination as? AllClassesAndPointsTableViewController{
                print("nowjikanwari:\(nowJikanwariData)")
                print("nextVC.jikanwari:\(nextVC.nowJikanwariData)")
                nextVC.nowJikanwariData = nowJikanwariData
            }
        }
    }
    
    func daysDisplay(days:Int)->String{
        if days == 5{
            return "月火水木金"
        }else if days == 6{
            return "月火水木金土"
        }else if days == 7{
            return "月火水木金土日"
        }else{
            return "error"
        }
    }
    
    func checkDays(days:String)->Int{
        if days == "月火水木金"{
            return 5
        }else if days == "月火水木金土"{
            return 6
        }else if days == "月火水木金土日"{
            return 7
        }else{
            print("error")
            return 5
        }
    }
}

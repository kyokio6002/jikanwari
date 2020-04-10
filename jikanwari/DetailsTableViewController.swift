//
//  DetailsTableViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/16.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class DetailsTableViewController: UITableViewController {
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var roomTextField: UITextField!
    @IBOutlet weak var teacherTextField: UITextField!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var memo: UITextView!
    
    //押されたボタンのタグを受け取る変数
    var tag:Int = 0
    //新規(exist==fauls)か既存(exist==true)か
    var exist:Bool = false
    //既存の場合の受け渡し
    var nowJikanwari:jikanwariDetail?
    //選んできたかどうか
    var selected:Bool = false
    //AllClassesから取ってきたデータ
    var getFromAllClassesVC = classModel()
    
    //保存ボタン
    var saveBarButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("画面遷移しました")
        //既存か新規かをprint
        if exist == true{
            print("------------------------------------")
            print("tag:\(tag)")
            print("既存(exist==\(exist))")
        }else{
            print("------------------------------------")
            print("tag:\(tag)")
            print("新規(exist==\(exist))")
        }
        
        saveBarButton = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveBarButtonTapped(_:)))
        
        //保存ボタンの配置
        self.navigationItem.rightBarButtonItem = saveBarButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selected == false{
            print("--------------------")
            print("selected:\(selected)")
            checkExsist(btnTag: tag)
            
            //持ってきたらsubjectTextFieldの編集を可能にする
            subjectTextField.isSelected = true
            subjectTextField.isEnabled = true
            
        }else{
            print("--------------------")
            print("selected:\(selected)")
            //持ってきたらsubjectTextFieldの編集を不可能にする
            subjectTextField.isSelected = false
            subjectTextField.isEnabled = false
            
            subjectTextField.text = getFromAllClassesVC.subjectName
            roomTextField.text = getFromAllClassesVC.roomNum
            termTextField.text = getFromAllClassesVC.teacherName
            pointsTextField.text = String(getFromAllClassesVC.points)
        }
    }
    
    //section数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    //cellの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //既存の授業を選択ボタン
        if indexPath.section == 1 && exist == false{
            performSegue(withIdentifier: "goClasses", sender: nil)
        }
        //classを消去ボタン
        if indexPath.section == 2 && exist == true{
            //現在のclass
            let theClass:classModel = ((nowJikanwari?.classDetail.filter("classPlace == %@",tag).first)!)
            
            //現在のclassのid
            let selectedClassId = theClass.classModelNum
            //realmのインスタンス化
            let realm = try! Realm()
            let classesFromRealm = realm.objects(classModel.self).filter("classModelNum == %@",selectedClassId as Any)
            print("classes:\(classesFromRealm)")
            
            let alert = UIAlertController(title: "他のクラス情報も消去されます", message: "他も消去されるよ？", preferredStyle: .alert)
            let delete = UIAlertAction(title: "消去", style: .default) { (UIAlertAction) in
                
                for _ in 0..<classesFromRealm.count{
                    try! realm.write{
                        realm.delete(classesFromRealm)
                    }
                }
                //元の画面に戻る
                self.navigationController?.popToRootViewController(animated: true)
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(delete)
            alert.addAction(cancel)
            
            //変更するclassの数によって場合わけ
            if classesFromRealm.count == 1{
                try! realm.write{
                    realm.delete(classesFromRealm)
                }
                //元の画面に戻る
                self.navigationController?.popToRootViewController(animated: true)
            }else if classesFromRealm.count >= 2{
                present(alert,animated: true,completion: nil)
            }
        }
        //データを持ってきたのにsubjectTextFieldを変更しようとした場合の処理
        if indexPath == IndexPath(row: 0, section: 0) && selected == true{
            //alertを表示
            let alert = UIAlertController(title: "既存の授業データです", message: "既存のデータだから授業名は変更できないよ", preferredStyle: .alert)
            let addNewOneAlert = UIAlertAction(title: "新規登録", style: .default) { (UIAlertAction) in
                //selectedを外す
                self.selected = false
                //subjectTextFieldの編集を可能にする
                self.subjectTextField.isSelected = true
                self.subjectTextField.isEnabled = true
            }
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(addNewOneAlert)
            alert.addAction(ok)
            present(alert,animated: true,completion: nil)
        }
        //セルの選択の解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func saveBarButtonTapped(_ sender:UIBarButtonItem){
        print("保存ボタンが押されました")
        
        //既存か新規か
        //既存の場合
        if exist == true{
            
            let theClass:classModel = (nowJikanwari?.classDetail.filter("classPlace == %@",tag).first)!
            
            //現在のclassのid
            let selectedClassId = theClass.classModelNum
            //realmのインスタンス化
            let realm = try! Realm()
            let classesFromRealm = realm.objects(classModel.self).filter("classModelNum == %@",selectedClassId as Any)
            print("classes:\(classesFromRealm)")
            
            let alert = UIAlertController(title: "他のクラス情報も変更されます", message: "他も変更されるよ？", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                
                for j in 0..<classesFromRealm.count{
                    try! realm.write{
                        classesFromRealm[j].subjectName = self.subjectTextField.text
                        classesFromRealm[j].teacherName = self.teacherTextField.text
                        classesFromRealm[j].roomNum = self.roomTextField.text
                        if let num:Int = Int(self.pointsTextField.text!){
                            classesFromRealm[j].points = num
                        }else{
                            classesFromRealm[j].points = 0
                        }
                        classesFromRealm[j].memo = self.memo.text
                    }
                }
                //元の画面に戻る
                self.navigationController?.popToRootViewController(animated: true)
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            
            //変更するclassの数によって場合わけ
            if classesFromRealm.count == 1{
                try! realm.write{
                    classesFromRealm[0].subjectName = self.subjectTextField.text
                    classesFromRealm[0].teacherName = self.teacherTextField.text
                    classesFromRealm[0].roomNum = self.roomTextField.text
                    if let num:Int = Int(self.pointsTextField.text!){
                        classesFromRealm[0].points = num
                    }else{
                        classesFromRealm[0].points = 0
                    }
                    classesFromRealm[0].memo = self.memo.text
                }
            }else if classesFromRealm.count >= 2{
                present(alert,animated: true,completion: nil)
            }
        }
        //新規の場合
        else{
            if subjectTextField.text != nil && subjectTextField.text != ""{
                let ClassModel = classModel()
                //textFieldのtextを代入
                ClassModel.subjectName = subjectTextField.text
                ClassModel.teacherName = teacherTextField.text
                ClassModel.roomNum = roomTextField.text
                ClassModel.classPlace = tag
                if let num:Int = Int(self.pointsTextField.text!){
                    ClassModel.points = num
                }else{
                    ClassModel.points = 0
                }
                ClassModel.memo = memo.text
                //クラスのprimaryKeyを代入
                ClassModel.jikanwariPrimaryKey = nowJikanwari?.jikanwariModelNum
                if selected == true{
                    ClassModel.classModelNum = getFromAllClassesVC.classModelNum
                }else{
                    ClassModel.classModelNum = NSUUID().uuidString
                }
                
                let realm = try! Realm()
                try! realm.write{
                   nowJikanwari?.classDetail.append(ClassModel)
                }
            }
            
        }
        //元の画面に戻る
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //イッチするデータがあるか確かめる関数
    func checkExsist(btnTag:Int){
        
        let cell = super.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 1))
        cell.textLabel?.text = "既存の授業から選ぶ"
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        
        let deleteCell = super.tableView(tableView,cellForRowAt: IndexPath(row: 0, section: 2))
        deleteCell.textLabel?.text = "この授業を消去する"
        deleteCell.textLabel?.textAlignment = .center
        deleteCell.textLabel?.textColor = .lightGray
        
        for i in 0..<(nowJikanwari?.classDetail.count)!{
            //データがあった場合の処理
            if nowJikanwari?.classDetail[i].classPlace == btnTag{
                subjectTextField.text = nowJikanwari?.classDetail[i].subjectName
                roomTextField.text = nowJikanwari?.classDetail[i].roomNum
                teacherTextField.text = nowJikanwari?.classDetail[i].teacherName
                pointsTextField.text = String((nowJikanwari?.classDetail[i].points)!)
                memo.text = nowJikanwari?.classDetail[i].memo
                //print("exist:\(exist),tag:\(tag)")
                //print("一致したmodel:\(nowJikanwari?.classDetail[i])")
                cell.textLabel?.textColor = .lightGray
                deleteCell.textLabel?.textColor = .red
                break
            }else{
                subjectTextField.placeholder = "教科名を入力してください"
                roomTextField.placeholder = "教室を入力してください"
                teacherTextField.placeholder = "教師の名前を入力してください"
                pointsTextField.placeholder = "単位数を入力してください"
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////
/*
参考文献
 
 エラーまとめ
 https://re35.org/swift-error/#lwptoc30
*/
/////////////////////////////////////////////////////////////////////////////

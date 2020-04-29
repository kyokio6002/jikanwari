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
    @IBOutlet weak var GPALabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
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
    //colorから帰ってきたよ変数
    var backColor:Bool = false
    //GPAから帰ってきたよ変数
    var backGPA:Bool = false
    //色
    var color:String = "FFD7B1"
    //GPA
    var GPA:Int = 0
    
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
        
        colorLabel.layer.borderWidth = 1.0
        colorLabel.layer.borderColor = UIColor.lightGray.cgColor
        colorLabel.layer.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        colorLabel.layer.cornerRadius = 20
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkExsist(btnTag: tag)
        if selected == false{
            print("--------------------")
            print("selected:\(selected)")
            
            //持ってきたらTextFieldの編集を可能にする
            subjectTextField.isSelected = true
            subjectTextField.isEnabled = true
            roomTextField.isSelected = true
            roomTextField.isEnabled = true
            teacherTextField.isSelected = true
            teacherTextField.isEnabled = true
            pointsTextField.isSelected = true
            pointsTextField.isEnabled = true
            memo.isSelectable = true
            memo.isEditable = true
            
        }else{
            print("--------------------")
            print("selected:\(selected)")
            //持ってきたらTextFieldの編集を不可能にする
            subjectTextField.isSelected = false
            subjectTextField.isEnabled = false
            roomTextField.isSelected = false
            roomTextField.isEnabled = false
            teacherTextField.isSelected = false
            teacherTextField.isEnabled = false
            pointsTextField.isSelected = false
            pointsTextField.isEnabled = false
            memo.isSelectable = false
            memo.isEditable = false
            
            subjectTextField.text = getFromAllClassesVC.subjectName
            roomTextField.text = getFromAllClassesVC.roomNum
            teacherTextField.text = getFromAllClassesVC.teacherName
            pointsTextField.text = String(getFromAllClassesVC.points)
            GPALabel.text = String(getFromAllClassesVC.GPA)
            if let nonOptinalColor:String = getFromAllClassesVC.coler{
                color = nonOptinalColor
                colorLabel.layer.backgroundColor = UIColor.hex(string: color, alpha: 1.0).cgColor
            }else{
                print("error")
            }
            memo.text = getFromAllClassesVC.memo
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
        //GPA選択
        if indexPath == IndexPath(row: 4, section: 0) && selected == false{
            print("goGPA:\(GPA)")
            performSegue(withIdentifier: "goGPA", sender: GPA)
        }
        //背景色選択
        if indexPath == IndexPath(row: 5, section: 0) && selected == false{
            print("移動")
            performSegue(withIdentifier: "goColor", sender: color)
        }
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
            
            let alert = UIAlertController(title: "他の授業も消去されますがよろしいですか？", message: "この授業は複数存在します", preferredStyle: .alert)
            let deleteAll = UIAlertAction(title: "すべて消去", style: .destructive) { (UIAlertAction) in
                
                for _ in 0..<classesFromRealm.count{
                    try! realm.write{
                        realm.delete(classesFromRealm)
                    }
                }
                //元の画面に戻る
                self.navigationController?.popToRootViewController(animated: true)
            }
            let deleteOne = UIAlertAction(title: "この授業のみ消去", style: .destructive) { (UIAlertAction) in
                //オプショナルバインディング
                if let nonOptionalJikanwariName = self.nowJikanwari?.jikanwariModelNum{
                    //print("nonOp:\(nonOptionalJikanwariName)")
                    //print("tag:\(self.tag)")
                    //授業を特定
                    let theClass = classesFromRealm.filter("jikanwariPrimaryKey == %@ AND classPlace == %@",nonOptionalJikanwariName,self.tag)
                    //print("theclass:\(theClass)")
                    //消去
                    try! realm.write{
                        realm.delete(theClass)
                    }
                    //元の画面に戻る
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    print("error")
                }
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(deleteOne)
            alert.addAction(deleteAll)
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
        if indexPath.section == 0 && selected == true{
            //alertを表示
            let alert = UIAlertController(title: "変更できません", message: "既存の授業を使用しいています", preferredStyle: .alert)
            let addNewOneAlert = UIAlertAction(title: "新規で登録", style: .default) { (UIAlertAction) in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goColor"{
            if let nextVC = segue.destination as? colorTableViewController{
                let color = (sender as? String)!
                nextVC.color = color
            }
        }
        else if segue.identifier == "goGPA"{
            if let nextVC = segue.destination as? GPATableViewController{
                let GPA:Int = (sender as? Int ?? 0)
                nextVC.GPA = GPA
            }
        }
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
            
            let alert = UIAlertController(title: "他の授業も変更されますがよろしいですか？", message: "この授業は複数存在します", preferredStyle: .alert)
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
                        classesFromRealm[j].GPA = Int(self.GPALabel.text!) ?? 0
                        classesFromRealm[j].coler = self.color
                        classesFromRealm[j].memo = self.memo.text
                    }
                }
                //元の画面に戻る
                self.navigationController?.popToRootViewController(animated: true)
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            //alert.addAction(deleteOne)
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
                    classesFromRealm[0].GPA = Int(self.GPALabel.text!) ?? 0
                    classesFromRealm[0].coler = self.color
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
                ClassModel.GPA = Int(self.GPALabel.text!) ?? 0
                ClassModel.coler = color
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
        print("color00:\(color)")
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
        
        subjectTextField.placeholder = "教科名を入力してください"
        roomTextField.placeholder = "教室を入力してください"
        teacherTextField.placeholder = "教師の名前を入力してください"
        pointsTextField.placeholder = "単位数を入力してください"
        //countが0だとfor文に入らないからその時用に初期値設定
        colorLabel.layer.backgroundColor = UIColor.hex(string: color, alpha: 1.0).cgColor
        //countが0だとfor文に入らないからその時用に初期値設定
        GPALabel.text = String(GPA)
        
        
        for i in 0..<(nowJikanwari?.classDetail.count)!{
            //データがあった場合の処理
            if nowJikanwari?.classDetail[i].classPlace == btnTag{
                subjectTextField.text = nowJikanwari?.classDetail[i].subjectName
                roomTextField.text = nowJikanwari?.classDetail[i].roomNum
                teacherTextField.text = nowJikanwari?.classDetail[i].teacherName
                pointsTextField.text = String((nowJikanwari?.classDetail[i].points)!)
                if backGPA == false{
                    if let nonOptionalGPA:Int = nowJikanwari?.classDetail[i].GPA{
                        GPA = nonOptionalGPA
                        GPALabel.text = String(nonOptionalGPA)
                    }else{
                        GPA = 0
                        GPALabel.text = String(GPA)
                    }
                }else{
                    GPALabel.text = String(GPA)
                }
                if backColor == false{
                    if let nonOptionalColor:String = nowJikanwari?.classDetail[i].coler{
                        color = nonOptionalColor
                        colorLabel.layer.backgroundColor = UIColor.hex(string:nonOptionalColor, alpha: 1.0).cgColor
                    }else{
                        color = "FFD7B1"
                        colorLabel.layer.backgroundColor = UIColor.hex(string:color, alpha: 1.0).cgColor
                    }
                }else{
                    colorLabel.layer.backgroundColor = UIColor.hex(string:color, alpha: 1.0).cgColor
                }
                
                memo.text = nowJikanwari?.classDetail[i].memo
                //print("exist:\(exist),tag:\(tag)")
                //print("一致したmodel:\(nowJikanwari?.classDetail[i])")
                cell.textLabel?.textColor = .lightGray
                deleteCell.textLabel?.textColor = .red
                break
            }else{
                print("更新はなし")
            }
        }
    }
}
extension UIColor {
    class func hex ( string : String, alpha : CGFloat) -> UIColor {
        let string_ = string.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: string_ as String)
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.white;
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

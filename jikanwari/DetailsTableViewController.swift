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
    
    //押されたボタンのタグを受け取る変数
    var tag:Int = 0
    //新規(exist==fauls)か既存(exist==true)か
    var exist:Bool = false
    
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
        
        checkRealm(btnTag: tag)
    }
    
    //section数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //cellの数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return 2
        default:
            return 0
        }
    }
    //セルの編集を許可
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc func saveBarButtonTapped(_ sender:UIBarButtonItem){
        print("保存ボタンが押されました")
        
        //既存か新規か
        //既存の場合
        if exist == true{
            //新規登録しなで変更があれば更新
            //MyMemo()をインスタンス化
            let realm = try! Realm()
            let classModels = realm.objects(classModel.self)
            
            print(classModels)
            
            for i in 0..<classModels.count{
                if classModels[i].classPlace == tag{
                    try! realm.write{
                        classModels[i].subjectName = subjectTextField.text
                        classModels[i].teacherName = teacherTextField.text
                        classModels[i].roomNum = roomTextField.text
                    }
                    break
                }
                else {
                }
            }
        }
        //新規の場合
        else{
            //科目名が空でなかったら保存作業
            if subjectTextField.text != nil && subjectTextField.text != ""{
                //classModelをインスタンス化
                let ClassModel:classModel = classModel()
                
                ClassModel.subjectName = subjectTextField.text!
                ClassModel.teacherName = teacherTextField.text
                ClassModel.roomNum = roomTextField.text
                ClassModel.classPlace = tag
                
                //保存作業
                let realm = try! Realm()
                try! realm.write{
                    realm.add(ClassModel)
                }
            }
        }
        
        //元の画面に戻る
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    
    //イッチするデータがあるか確かめる関数
    func checkRealm(btnTag:Int){
        //インスタンス化
        let realm = try! Realm()
        let subjectsFromRealm = realm.objects(classModel.self)
        ////Realm内に保存データがあるか確認
        for i in 0..<subjectsFromRealm.count{
            //データがあった場合の処理
            if subjectsFromRealm[i].classPlace == btnTag{
                subjectTextField.text = subjectsFromRealm[i].subjectName
                roomTextField.text = subjectsFromRealm[i].roomNum
                teacherTextField.text = subjectsFromRealm[i].teacherName
                pointsTextField.text = subjectsFromRealm[i].points
                print("exist:\(exist),tag:\(tag)")
                print("一致したmodel:\(subjectsFromRealm[i])")
                break
            }else{
                
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

//
//  JikanwarisTableViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/25.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class JikanwarisTableViewController: UITableViewController {

    //+ボタン
    var addBarButton = UIBarButtonItem()
 
    var jikanwariDatas:Results<jikanwariDetail>?
    @IBOutlet weak var allPointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addBarButtonTapped))

        //保存ボタンの配置
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if jikanwariDatas?.count != nil{
            //print(jikanwariDatas?.count)
            //print(jikanwariDatas)
            return jikanwariDatas?.count ?? 0
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print(jikanwariDatas?[indexPath.row].jikanwariModelNum)
        
        //print("AllPoints:\((jikanwariDatas?[indexPath.row].AllPoints)!)")
        //print("getSumPoints:\(getSumPoints(primarykey: (jikanwariDatas?[indexPath.row].jikanwariModelNum)!))")
        
        let realm = try! Realm()
        try! realm.write{
            let primaryKey:String = jikanwariDatas?[indexPath.row].jikanwariModelNum ?? ""
            jikanwariDatas?[indexPath.row].AllPoints = Int(getSumPoints(primarykey: primaryKey,GPAreturn: false))
            jikanwariDatas?[indexPath.row].GPA = getSumPoints(primarykey: primaryKey, GPAreturn: true)
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        cell.textLabel?.text = jikanwariDatas![indexPath.row].jikanwariName
        cell.detailTextLabel?.text = "総単位数:"+String((jikanwariDatas?[indexPath.row].AllPoints)!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択の解除
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goSetting", sender: jikanwariDatas?[indexPath.row])
    }
    
    @objc func addBarButtonTapped(){
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    //値を渡したい
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSetting"{
            if let nextVC = segue.destination as? SettingTableViewController{
                if sender != nil{
                    nextVC.exist = true
                    nextVC.nowJikanwariData = sender as? jikanwariDetail
                }else if sender == nil{
                    nextVC.exist = false
                    nextVC.nowJikanwariData = nil
                }
            }
        }
    }
    //Realmからデータを撮ってくる
    func getData(){
        let realm = try! Realm()
        jikanwariDatas = realm.objects(jikanwariDetail.self)
        //print(jikanwariDatas)
    }
    
    //総単位数を出す関数
    func getSumPoints(primarykey:String,GPAreturn:Bool)->Double{
        
        let realm = try! Realm()
        let theJikanwari = realm.object(ofType: jikanwariDetail.self, forPrimaryKey: primarykey)

        //すべての授業(idが同じのも含む)
        let allClasses = realm.objects(classModel.self).filter("jikanwariPrimaryKey == %@",theJikanwari?.jikanwariModelNum as Any)
        var allOriginalClasses:[classModel] = []
        
        for i in 0..<allClasses.count{
            //print("i:\(i)")
            if allOriginalClasses.count == 0{
                allOriginalClasses.append(allClasses[i])
            }else{
                for_j:for j in 0..<allOriginalClasses.count{
                    //一致したらiFor文をbreak
                    //print(i,j)
                    if allClasses[i].classModelNum == allOriginalClasses[j].classModelNum{
                        break for_j
                    }else if j == allOriginalClasses.count - 1{
                        allOriginalClasses.append(allClasses[i])
                    }
                }
            }
        }
        //print("allclasses:\(allClasses)")
        //print("originalClasses:\(allOriginalClasses)")
        let allPoints:Int = allOriginalClasses.reduce(0){$0+$1.points}
        
        var GPA:Int = 0
        for i in 0..<allOriginalClasses.count{
            GPA += allOriginalClasses[i].points*allOriginalClasses[i].GPA
        }
        //print(allPoints)
        if GPAreturn == false{
            return Double(allPoints)
        }else{
            if allPoints == 0{
                return 0
            }else{
                let num:Double = Double(Double(GPA)/Double(allPoints))
                //print("GPAAll:\(GPA)")
                //print("allPoints:\(allPoints)")
                //print("num:\(num)")
                //print("GPA:\(floor(num*100)/100)")
                return floor(num*100)/100
            }
        }
        
    }
}

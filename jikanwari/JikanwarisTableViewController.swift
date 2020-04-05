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
}

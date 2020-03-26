//
//  JikanwarisTableViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/25.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit

class JikanwarisTableViewController: UITableViewController {

    //+ボタン
    var addBarButton = UIBarButtonItem()
    //時間割データ配列を空で宣言
    var jikanwariDatas:[jikanwariDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addBarButtonTapped))
        
        //データをuserDefaultsからとってきて入れる
        jikanwariDatas = getJikanwariData()
        //保存ボタンの配置
        self.navigationItem.rightBarButtonItem = addBarButton
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jikanwariDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = jikanwariDatas[indexPath.row].jikanwariName
        
        return cell
    }
    
    
    
    @objc func addBarButtonTapped(){
        performSegue(withIdentifier: "goSetting", sender: nil)
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

//
//  AllClassesTableViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/29.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class AllClassesTableViewController: UITableViewController {
    
    //すべての時間割
    var allClasses:Results<classModel>?
    //すべての授業(idが同じものを含まない)
    var allOriginalClasses:[classModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //id(classModelNum)の被りなしですべてのclassを表示
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        //すべての授業(idが同じのも含む)
        let allClasses = realm.objects(classModel.self)
        
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
        print("Cellcount:\(allOriginalClasses.count)")
        return allOriginalClasses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let realm = try! Realm()
        let allClasses = realm.objects(classModel.self)
        cell.textLabel?.text = allClasses[indexPath.row].subjectName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択の解除
        tableView.deselectRow(at: indexPath, animated: true)
        /*let realm = try! Realm()
        allClasses = realm.objects(classModel.self)*/
        
        
        
        //print(allClasses?[indexPath.row])
        
        let previousNC = self.navigationController!
        let previousVC = previousNC.viewControllers[previousNC.viewControllers.count - 2] as! DetailsTableViewController
        //previousVC.getFromAllClassesVC = allClasses![indexPath.row]
        previousVC.getFromAllClassesVC = allOriginalClasses[indexPath.row]
        previousVC.selected = true
        //元の画面に戻る
        self.navigationController?.popViewController(animated: true)
    }
}

////////////////////////////////////////////////////////////////
/*
 参考文献
 
 他の場面のデータの書き換え(performSegueなしの場合(ex:前の画面に戻る時performSegueだとアニメーションが左から右になるから戻った感なくて使わない場合))
 https://qiita.com/wadaaaan/items/acc8967c836d616e3b0b
 
*/
///////////////////////////////////////////////////////////////

//
//  AllClassesAndPointsTableViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/04/10.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class AllClassesAndPointsTableViewController: UITableViewController {
    
    //既存の場合のプライマリーキー
    var nowJikanwariData:jikanwariDetail?
    
    var allOriginalClasses:[classModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let realm = try! Realm()
        let theJikanwari = realm.object(ofType: jikanwariDetail.self, forPrimaryKey: nowJikanwariData?.jikanwariModelNum)
        
        //すべての授業(idが同じのも含む)
        let allClasses = realm.objects(classModel.self).filter("jikanwariPrimaryKey == %@",theJikanwari?.jikanwariModelNum as Any)
        
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
        
        return allOriginalClasses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        cell.textLabel?.text = allOriginalClasses[indexPath.row].subjectName
        let points:Int = allOriginalClasses[indexPath.row].points
        cell.detailTextLabel?.text = "\(points)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

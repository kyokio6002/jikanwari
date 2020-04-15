//
//  AllGPAViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/04/13.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class AllGPAViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var GPALabel: UILabel!
    @IBOutlet weak var detailGPALabel: UILabel!
    @IBOutlet weak var allPointsLabel: UILabel!
    
    //既存の場合のプライマリーキー
    var nowJikanwariData:jikanwariDetail?
    
    var allOriginalClasses:[classModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        showLabel()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        print("allOriginal:\(allOriginalClasses)")
        
        return allOriginalClasses.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = allOriginalClasses[indexPath.row].subjectName
        let GPAText:Int = allOriginalClasses[indexPath.row].GPA
        let pointsText:Int = allOriginalClasses[indexPath.row].points
        cell.detailTextLabel?.text = "GPA:\(GPAText)(\(pointsText))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func showLabel(){
        
        var fourPoints:Int = 0
        var threePoints:Int = 0
        var twoPoints:Int = 0
        var onePoints:Int = 0
        var zeroPoints:Int = 0
        
        for i in 0..<allOriginalClasses.count{
            if allOriginalClasses[i].GPA == 4{
                fourPoints += 1
            }else if allOriginalClasses[i].GPA == 3{
                threePoints += 1
            }else if allOriginalClasses[i].GPA == 2{
                twoPoints += 1
            }else if allOriginalClasses[i].GPA == 1{
                onePoints += 1
            }else{
                zeroPoints += 1
            }
        }
        if let nonOptionalGPA:Double = nowJikanwariData?.GPA{
            GPALabel.text = "GPA:\(nonOptionalGPA)"
        }else{
            GPALabel.text = "GPA:\(Error.self)"
        }
        detailGPALabel.text = "4.0(A)×\(fourPoints) + 3.0(B)×\(threePoints) + 2.0(C)×\(twoPoints) + 1.0(D)×\(onePoints) + 0(E)×\(zeroPoints)"
        if let nonOptinalAllpoints = nowJikanwariData?.AllPoints{
            allPointsLabel.text = "履修単位数:\(nonOptinalAllpoints)"
        }else{
            allPointsLabel.text = "履修単位数:\(Error.self)"
        }
        
    }

}

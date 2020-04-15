//
//  DaysTableViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/04/06.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class DaysTableViewController: UITableViewController {
    
    //新規(exist==fauls)か既存(exist==true)か
    var exist:Bool = false
    //ここで保存しないための変数
    var useDaysHere:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        //単一選択
        tableView.allowsMultipleSelection = false
    }
    override func viewWillLayoutSubviews() {
        checkCell(exist: exist, days: useDaysHere)
    }
    
    //画面遷移時にチェックマークを入れる関数
    func checkCell(exist:Bool,days:Int){
        if exist == true{
            if days == 5{
                let cell = tableView.cellForRow(at:IndexPath(row: 0, section: 0))
                cell?.accessoryType = .checkmark
            }else if days == 6{
                let cell = tableView.cellForRow(at:IndexPath(row: 1, section: 0))
                cell?.accessoryType = .checkmark
            }else if days == 7{
                let cell = tableView.cellForRow(at:IndexPath(row: 2, section: 0))
                cell?.accessoryType = .checkmark
            }
        }else if exist == false{
            let cell = tableView.cellForRow(at:IndexPath(row: 0, section: 0))
            cell?.accessoryType = .checkmark
        }else{
            print("error")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if useDaysHere == 5{
            print("ここよ01")
            tableView.deselectRow(at: indexPath, animated: true)
            let cell = tableView.cellForRow(at:IndexPath(row: 0, section: 0))
            //print(cell?.textLabel?.text)
            cell?.accessoryType = .none
            
            reload(indexPath: indexPath)
        }else if useDaysHere == 6{
            print("ここよ02")
            tableView.deselectRow(at: indexPath, animated: true)
            let cell = tableView.cellForRow(at:IndexPath(row: 1, section: 0))
            //print(cell?.textLabel?.text)
            cell?.accessoryType = .none
            
            reload(indexPath: indexPath)
        }else if useDaysHere == 7{
            print("ここよ03")
            tableView.deselectRow(at: indexPath, animated: true)
            let cell = tableView.cellForRow(at:IndexPath(row: 2, section: 0))
            //print(cell?.textLabel?.text)
            cell?.accessoryType = .none
            
            reload(indexPath: indexPath)
        }else{
            print("ここよ04")
            print("error")
        }
        
        let cell = tableView.cellForRow(at:indexPath)
        // セルが選択された時の背景色を消す
        cell!.selectionStyle = .default
        //チェックマークを入れる
        cell?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        //チェックマークを外す
        cell?.accessoryType = .none
    }
    
    func reload(indexPath:IndexPath){
        if indexPath.row == 0{
            useDaysHere = 5
        }else if indexPath.row == 1{
            useDaysHere = 6
        }else if indexPath.row == 2{
            useDaysHere = 7
        }else{
            print("error")
        }
        
        let previousNC = self.navigationController!
        let previousVC = previousNC.viewControllers[previousNC.viewControllers.count - 2] as! SettingTableViewController
        previousVC.daysLabel.text = daysDisplay(days: useDaysHere)
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
}

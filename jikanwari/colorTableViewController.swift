//
//  colorTableViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/04/10.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit

class colorTableViewController: UITableViewController {
    
    var color:String = "FFD7B1"

    override func viewDidLoad() {
        super.viewDidLoad()
        //単一選択
        tableView.allowsMultipleSelection = false
    }
    
    //このタイミングじゃないとcellが設置されてない
    override func viewWillLayoutSubviews() {
        let cell = tableView.cellForRow(at: IndexPath(row: checkCell(color: color), section: 0))
        cell?.accessoryType = .checkmark
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<12{
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
            cell?.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
        // セルが選択された時の背景色を消す
        cell!.selectionStyle = .default
        //チェックマークを入れる
        cell?.accessoryType = .checkmark
        
        let previousNC = self.navigationController!
        let previousVC = previousNC.viewControllers[previousNC.viewControllers.count - 2] as! DetailsTableViewController
        previousVC.color = checkColor(row: indexPath.row)
        previousVC.backColor = true
        print("color:\(previousVC.color)")
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        //チェックマークを外す
        cell?.accessoryType = .none
    }
    
    func checkColor(row:Int)->String{
        switch row {
        case 0:
            return "FFD7B1"
        case 1:
            return "FFC5B3"
        case 2:
            return "FFC7DB"
        case 3:
            return "EDC3FF"
        case 4:
            return "B9A7FF"
        case 5:
            return "B4CAFF"
        case 6:
            return "D3FFFC"
        case 7:
            return "B0FFCB"
        case 8:
            return "9EFFA1"
        case 9:
            return "BEFF84"
        case 10:
            return "F2FF7E"
        case 11:
            return "FFD268"
        default:
            return ""
        }
    }
    
    func checkCell(color:String)->Int{
        switch color {
        case "FFD7B1":
            return 0
        case "FFC5B3":
            return 1
        case "FFC7DB":
            return 2
        case "EDC3FF":
            return 3
        case "B9A7FF":
            return 4
        case "B4CAFF":
            return 5
        case "D3FFFC":
            return 6
        case "B0FFCB":
            return 7
        case "9EFFA1":
            return 8
        case "BEFF84":
            return 9
        case "F2FF7E":
            return 10
        case "FFD268":
            return 11
        default:
            return 0
        }
    }
}

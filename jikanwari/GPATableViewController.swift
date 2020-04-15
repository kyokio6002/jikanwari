//
//  GPATableViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/04/13.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit

class GPATableViewController: UITableViewController {
    
    var GPA:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //単一選択
        tableView.allowsMultipleSelection = true
    }
    
    //subviewが表示されるたびに実行されてしまう(ここでは4回)
    override func viewWillLayoutSubviews() {
        print("getGPA:\(GPA)")
        let cell = tableView.cellForRow(at: IndexPath(row: 4-GPA, section: 0))
        cell?.accessoryType = .checkmark
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<5{
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
            cell?.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        //セル画選択されたときの背景色を消す
        cell?.selectionStyle = .default
        //チェックマークを入れる
        cell?.accessoryType = .checkmark
        
        let previousNC = self.navigationController!
        let previousVC = previousNC.viewControllers[previousNC.viewControllers.count - 2] as! DetailsTableViewController
        previousVC.GPA = 4 - indexPath.row
        previousVC.backGPA = true
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}

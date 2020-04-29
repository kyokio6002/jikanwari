//
//  jikanwariDetail.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/25.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class jikanwariDetail: Object{
    @objc dynamic var jikanwariName:String? = nil
    @objc dynamic var jikanwariModelNum = NSUUID().uuidString
    @objc dynamic var days:Int = 5
    @objc dynamic var classes:Int = 5
    @objc dynamic var initialOrNot:Bool = false
    @objc dynamic var AllPoints:Int = 0
    @objc dynamic var GPA:Double = 0
    @objc dynamic var ImageData:Data? = nil
    
    override static func primaryKey() -> String?{
        return "jikanwariModelNum"
    }
    
    //List
    let classDetail = List<classModel>()
}

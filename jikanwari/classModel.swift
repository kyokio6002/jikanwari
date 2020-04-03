//
//  classModel.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/16.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class classModel: Object {
    @objc dynamic var subjectName:String? = nil
    @objc dynamic var classModelNum:String? = nil
    @objc dynamic var classPlace:Int = 0
    @objc dynamic var roomNum:String? = nil
    @objc dynamic var teacherName:String? = nil
    @objc dynamic var points:String? = nil
    @objc dynamic var coler:String? = nil
    @objc dynamic var memo:String? = nil
    @objc dynamic var jikanwariPrimaryKey:String? = nil
    
}

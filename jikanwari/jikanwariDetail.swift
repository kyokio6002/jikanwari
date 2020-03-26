//
//  jikanwariDetail.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/25.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit

class jikanwariDetail: NSObject,Codable {
    var jikanwariName:String
    var jikanwariModelNum:Int
    var days:Int
    var classes:Int
    var initialOrNot:Bool
    
    init(jikanwariName:String,jikanwariModelNum:Int,days:Int,classes:Int,initialOrNot:Bool){
        self.jikanwariName = jikanwariName
        self.jikanwariModelNum = jikanwariModelNum
        self.days = days
        self.classes = classes
        self.initialOrNot = initialOrNot
    }
}

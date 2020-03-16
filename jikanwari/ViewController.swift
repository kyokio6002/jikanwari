//
//  ViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/12.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //表示する曜日数
    var dayCount:Int = 5
    //表示する1日の授業数
    var classCount:Int = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .gray
        navigationItem.title = "時間割表"
        
        setButtons(dayCount: dayCount, classCount: classCount)
    }

    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func setButtons(dayCount:Int,classCount:Int){
        
        //縦横目次
        let dayDisp = 1
        let classDisp = 1
        //Y軸更新
        let plusY = 1
        
        //ステータスバーとナビゲーションバーの高さを取得
        let statusbarHeight:CGFloat = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight:CGFloat = (self.navigationController?.navigationBar.frame.size.height)!
        //縦横幅の合計(の初期値)
        var SumX:CGFloat = 0
        var SumY:CGFloat = statusbarHeight + navigationBarHeight
        //ボタンのxy座標
        var btnX:CGFloat = 0
        var btnY:CGFloat = 0
        //スペースの幅
        let spaceWidth:CGFloat = 4
        //スクリーンの縦横
        let screenWidth:CGFloat = UIScreen.main.bounds.width
        let screenHeight:CGFloat = UIScreen.main.bounds.height
        //ボタンの縦横幅
        let classAxisWidth_dayAxisHeight:CGFloat = 30
        let dayAxisWidth:CGFloat = CGFloat(((screenWidth - (classAxisWidth_dayAxisHeight + spaceWidth)) - (CGFloat(dayCount+1))*spaceWidth) / CGFloat(dayCount))
        print("dayAxisWidth:\(dayAxisWidth)")
        let classAxisHeight:CGFloat = 100

        
        for y in 0..<classCount+classDisp{
            SumX = 0
            for x in 0..<dayCount+dayDisp+plusY{
                let btn = UIButton()
                btn.backgroundColor = .white
                btn.layer.borderColor = UIColor.black.cgColor
                btn.layer.borderWidth = 1.0
                btn.layer.cornerRadius = 0.5
                
                if y == 0{
                    if x == 0{
                        //タグ番号をつける(後でxとyに分解できるようにしておく)
                        btn.tag = x*100 + y
                        print("tag:\(btn.tag)")

                        //ボタンのxy座標を決める
                        btnX = SumX + spaceWidth
                        btnY = SumY + spaceWidth
                        //frame
                        btn.frame = CGRect(x: btnX, y: btnY, width: classAxisWidth_dayAxisHeight, height: classAxisWidth_dayAxisHeight)
                        //縦横幅合計更新(SumYの更新はなし)
                        SumX += btn.frame.width + spaceWidth
                        print("SumX:\(SumX)")
                        print("frame:\(btn.frame)")
                        self.view.addSubview(btn)
                    }else if x != 0 && x != dayCount+1{
                        //タグ番号
                        btn.tag =  x*100 + y
                        print("tag:\(btn.tag)")
                        //ボタンタイトル
                        btn.setTitle(DayCheck(btn.tag), for: .normal)
                        btn.setTitleColor(.black, for: .normal)
                        //ボタンのxy座標を決める
                        btnX = SumX + spaceWidth
                        btnY = SumY + spaceWidth
                        //frame
                        btn.frame = CGRect(x: btnX, y: btnY, width: dayAxisWidth, height: classAxisWidth_dayAxisHeight)
                        //縦横幅合計更新(SumYの更新はなし)
                        SumX += btn.frame.width + spaceWidth
                        print("SumX:\(SumX)")
                        print("frame:\(btn.frame)")
                        self.view.addSubview(btn)
                    }else if x == dayCount+1{
                        SumY += classAxisWidth_dayAxisHeight + spaceWidth
                    }else{
                        print("error")
                    }
                }else if y != 0{
                    if x == 0{
                        //タグ番号
                        btn.tag = 100*x + y
                        print("tag:\(btn.tag)")
                        btn.setTitle(String(btn.tag%100), for: .normal)
                        btn.setTitleColor(.black, for: .normal)
                        //ボタンのxy座標を決める
                        btnX = SumX + spaceWidth
                        btnY = SumY + spaceWidth
                        //frame
                        btn.frame = CGRect(x: btnX, y: btnY, width: classAxisWidth_dayAxisHeight, height: classAxisHeight)
                        //縦横幅合計更新(SumYの更新はなし)
                        SumX += btn.frame.width + spaceWidth
                        print("SumX:\(SumX)")
                        print("frame:\(btn.frame)")
                        self.view.addSubview(btn)
                    }else if x != 0 && x != dayCount+1{
                        //タグ番号
                        btn.tag = 100*x + y
                        print("tag:\(btn.tag)")
                        //ボタンのxy座標を決める
                        btnX = SumX + spaceWidth
                        btnY = SumY + spaceWidth
                        //frame
                        btn.frame = CGRect(x: btnX, y: btnY, width: dayAxisWidth, height: classAxisHeight)
                        //縦横幅合計更新(SumYの更新はなし)
                        SumX += btn.frame.width + spaceWidth
                        print("SumX:\(SumX)")
                        print("frame:\(btn.frame)")
                        btn.addTarget(self, action: #selector(btnTapped(sender:)), for: .touchUpInside)
                        self.view.addSubview(btn)
                    }else if x == dayCount+1{
                        SumY += classAxisHeight + spaceWidth
                    }else{
                        print("error")
                    }
                }else{
                    print("error")
                }
            }
        }
    }
    
    @objc func btnTapped(sender:UIButton){
        let btn:UIButton = sender
        print("曜日:\(DayCheck(btn.tag)),時限:\(btn.tag%10)")
        performSegue(withIdentifier: "goDetails", sender: nil)
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func DayCheck(_ btnTag:Int)->String{
        let returnDay:String
        let btnTagX = btnTag / 100
        
        switch btnTagX {
        case 1:
            returnDay = "月"
        case 2:
            returnDay = "火"
        case 3:
            returnDay = "水"
        case 4:
            returnDay = "木"
        case 5:
            returnDay = "金"
        case 6:
            returnDay = "土"
        case 7:
            returnDay = "日"
        default:
            print("error:\(btnTag)")
            returnDay = "error"
        }
        return returnDay
    }
}

//////////////////////////////////////////////////////////////
/*
 参考文献
 
 
*/
/////////////////////////////////////////////////////////////

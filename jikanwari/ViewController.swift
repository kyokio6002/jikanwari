//
//  ViewController.swift
//  jikanwari
//
//  Created by 塩澤響 on 2020/03/12.
//  Copyright © 2020 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    //表示する曜日数
    var dayCount:Int = 5
    //表示する1日の授業数
    var classCount:Int = 6
    //現在の時間割のデータ
    var nowJikanwari:jikanwariDetail?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //データの保存先のURLの表示(Realm)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkJikanwariDatas()
        navigationItem.title = nowJikanwari?.jikanwariName
        print("現在の時間り:\(nowJikanwari)")
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //時間割データがあるかないか
    func checkJikanwariDatas(){
        let realm = try! Realm()
        let jikanwariDatas = realm.objects(jikanwariDetail.self)
        for i in 0..<jikanwariDatas.count{
            if jikanwariDatas[i].initialOrNot == true{
                setButtons(dayCount: jikanwariDatas[i].days, classCount: jikanwariDatas[i].classes,jikanwariData: jikanwariDatas[i])
                nowJikanwari = jikanwariDatas[i]
                break
            }else if i == jikanwariDatas.count-1{
                removeBtns()
                print("時間割データがありません")
            }
        }
    }
    
    
    
    //ボタン設置関数
    func setButtons(dayCount:Int,classCount:Int,jikanwariData:jikanwariDetail){
        
        //すべてのパーツを消去して再配置を始める(二重に重なるのを防ぐ)
        removeBtns()
        
        //縦横目次(わかりやすさのため)
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
        let classAxisHeight:CGFloat = 100

        //ループ開始
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

                        //ボタンのxy座標を決める
                        btnX = SumX + spaceWidth
                        btnY = SumY + spaceWidth
                        //frame
                        btn.frame = CGRect(x: btnX, y: btnY, width: classAxisWidth_dayAxisHeight, height: classAxisWidth_dayAxisHeight)
                        //縦横幅合計更新(SumYの更新はなし)
                        SumX += btn.frame.width + spaceWidth
                        self.view.addSubview(btn)
                    }else if x != 0 && x != dayCount+1{
                        //タグ番号
                        btn.tag =  x*100 + y
                        
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
                        
                        btn.setTitle(String(btn.tag%100), for: .normal)
                        btn.setTitleColor(.black, for: .normal)
                        //ボタンのxy座標を決める
                        btnX = SumX + spaceWidth
                        btnY = SumY + spaceWidth
                        //frame
                        btn.frame = CGRect(x: btnX, y: btnY, width: classAxisWidth_dayAxisHeight, height: classAxisHeight)
                        //縦横幅合計更新(SumYの更新はなし)
                        SumX += btn.frame.width + spaceWidth
                        self.view.addSubview(btn)
                    }else if x != 0 && x != dayCount+1{
                        //タグ番号
                        btn.tag = 100*x + y

                        //ボタンのxy座標を決める
                        btnX = SumX + spaceWidth
                        btnY = SumY + spaceWidth
                        //frame
                        btn.frame = CGRect(x: btnX, y: btnY, width: dayAxisWidth, height: classAxisHeight)
                        //縦横幅合計更新(SumYの更新はなし)
                        SumX += btn.frame.width + spaceWidth
                        btn.addTarget(self, action: #selector(btnTapped(sender:)), for: .touchUpInside)
                        
                        for i in 0..<jikanwariData.classDetail.count{
                            if jikanwariData.classDetail[i].classPlace == btn.tag{
                                print("一致あり01:\(btn.tag)")
                                let nowSubject = jikanwariData.classDetail[i].subjectName!
                                var nowRoom:String
                                if jikanwariData.classDetail[i].roomNum != nil && jikanwariData.classDetail[i].roomNum != ""{
                                    nowRoom = jikanwariData.classDetail[i].roomNum!
                                }else{
                                    nowRoom = ""
                                }
                                print("\(nowSubject)\n\(nowRoom)\n")
                                btn.setTitleColor(.black, for: .normal)
                                btn.titleLabel?.numberOfLines = 0
                                btn.titleLabel?.textAlignment = .center
                                btn.titleLabel?.adjustsFontForContentSizeCategory = true
                                btn.setTitle("\(nowSubject)\n\(nowRoom)", for: .normal)
                            }
                        }
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
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    //settingBtnを押された時の処理
    @IBAction func settiongBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "goJikanwaris", sender: nil)
    }

    //ボタンを押された時の処理
    @objc func btnTapped(sender:UIButton){
        let btn:UIButton = sender
        let tagNum:Int = sender.tag
        print("クラスボタンが押されました")
        print("曜日:\(DayCheck(btn.tag)),時限:\(btn.tag%10)")
        print("画面遷移します")
        performSegue(withIdentifier: "goDetails", sender: tagNum)
    }
    //値を渡したい
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetails"{
            if let nextVC = segue.destination as? DetailsTableViewController{
                let tag = (sender as? Int)!
                nextVC.tag = tag
                nextVC.nowJikanwari = nowJikanwari
                
                
                let classesFromNowJikanwari = nowJikanwari?.classDetail
                
                //Realm内に保存データがあるか確認
                for i in 0..<(classesFromNowJikanwari?.count)!{
                    //データがあった場合の処理
                    if classesFromNowJikanwari?[i].classPlace == tag{
                        print("一致あり02:\(tag)")
                        nextVC.exist = true
                        break//一致した場合はbreakしないと次のループで書き換えられる
                    }else if i == (classesFromNowJikanwari?.count)! - 1{
                        print("一致なし02:\(tag)")
                        nextVC.exist = false
                    }
                }
            }
        }
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
    
    
    //設置してあるボタンを消去する関数
    func removeBtns(){
        for i in view.subviews{
            //print("removedObjectsTag:\(i.tag):")
            i.removeFromSuperview()
        }
    }
}


//////////////////////////////////////////////////////////////
/*
 参考文献
 
 画面変異での値渡し
 https://teratail.com/questions/161439
 
 パーツの消去
 https://teratail.com/questions/35300
 
*/
/////////////////////////////////////////////////////////////

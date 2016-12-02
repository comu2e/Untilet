//
//  ViewController.swift
//  Untilet
//
//  Created by Eiji Takahashi on 2016/11/28.
//  Copyright © 2016年 Eiji Takahashi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KDCircularProgress
class ViewController: UIViewController {
    //クラス変数
//    var __data__:NSDictionary!
    var percentage:Int! = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LoadAPI()
    }

    @IBOutlet weak var progressBar: KDCircularProgress!
    
    
    @IBAction func LoadAPI_button(_ sender: AnyObject) {
        LoadAPI()
    }
    
    
    @IBOutlet weak var valueLabel: UILabel!

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     メイン処理
     呼び出し時：
     ViewDidLoad時に一回
     Loadボタンが押されるたびに一回ずつ呼び出される
     流れ：
     現在時刻の取得
     現在時刻までのデータをAPIから呼び出し
     JSONをパースする。
     最新要素だけを得てそこからパーセント表示する
     */
    func LoadAPI(){
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"+"T"+"HH:mm:ss.000Z"
        
        //HeaderはAPI key
        let headers = [
                        "X-M2X-KEY": "9875a0904ad6ff8c46a0ed47dd1730c3",
                       ]
        //APIURLはstreamに割り振られているAPI＿URLにする
        
        let streamID = "MQ4"
        
        let start = "2016-11-26T00:00:00.000Z"
        let end = "2016-11-28T00:00:00.000Z"
        let limit = 10
        
        let API_URL = "https://api-m2x.att.com/v2/devices/a0b52f8541b7e2a4a35617d42f6efe5d/streams/\(streamID)/sampling?type=nth&interval=1&start=\(start)&end=\(end)&limit=\(limit)&pretty"
        //start,endのパラメータは現時刻の時点にできるようにする
        Alamofire.request(API_URL,method:.get,headers: headers).responseJSON{response in
            if let jsonDict = response.result.value as! NSDictionary!{
            let values = jsonDict["values"] as! NSArray
            
            let leatest_element = values[0] as! NSDictionary
                
            let leatestTimeStamp = leatest_element["timestamp"] as! String
            let leatestValue = leatest_element["value"] as! Int
            
            print(leatestTimeStamp)
            print(leatestValue)
            self.valueLabel.text = leatestValue.description
            }
        
        }
        func sample_bar(){
            let progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            progress.startAngle = -90
            progress.progressThickness = 0.2
            progress.trackThickness = 0.6
            progress.clockwise = true
            progress.gradientRotateSpeed = 2
            progress.roundedCorners = false
            progress.glowMode = .forward
            progress.glowAmount = 0.9
            progress.set(colors: UIColor.cyan ,UIColor.white, UIColor.magenta, UIColor.white, UIColor.orange)
            progress.center = CGPoint(x: view.center.x, y: view.center.y + 25)
            view.addSubview(progress)
        }
        
        func judge_value(value:Int)->Int!{
            var return_val:Int!
            switch value{
            case let v where v < 390:
                return_val = 10
            case let v where 390<v && v<630:
                return_val =  10 * (value - 390) * 4/100
            case let v where 630 <= v:
                return_val =  70+(value-390) * 10/100
            default:
                print("error")
            }
            return return_val

        }
}
}

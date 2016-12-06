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
        Load_Current_API()
    }
    

    @IBOutlet weak var progressBar: KDCircularProgress!
    
    @IBAction func changeAngle_button(_ sender: UIButton) {
        
    }
    
    @IBAction func LoadAPI_button(_ sender: AnyObject) {
        Load_Current_API()
    }
    
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBAction func backHomeFromDiary(segue: UIStoryboardSegue) {
    }
    
    @IBAction func backHomeFromFriend(segue: UIStoryboardSegue) {
    }
    
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
    
    //APIにある最新のデータのみが取り出されて表示される。
    
    //
    func judge_value(value:Double) -> Double{
        
        let double_value:Double = Double(value)
        
        let point1:Double = 270
        let point2:Double = 500
        let point3:Double = 1023
        
        let percentage1:Double = 10
        let percentage2:Double = 70
        let percentage3:Double = 100
        
        let increment12:Double = (percentage2 - percentage1)/(point2 - point1)
        let increment23:Double = (percentage3 - percentage2)/(point3 - point2)
        
        
        var val:Double = 10
        
        if value < point1 {
            val = percentage1
        }
        else if point1 <= value && value < point2 {
            val =  percentage1 +  increment12 * (double_value - point1)
            print("2")
        }
        else if point2 <= value && value <= point3 {
            val = percentage2 + increment23 * (double_value - point2)
        }
        return val
    }
    
    
    func Load_Current_API(){
        //HeaderはAPI key
        let headers = [
            "X-M2X-KEY": "9875a0904ad6ff8c46a0ed47dd1730c3",
            ]
        //APIURLはstreamに割り振られているAPI＿URLにする
        
        let API_URL = "https://api-m2x.att.com/v2/devices/a0b52f8541b7e2a4a35617d42f6efe5d/streams"
        //start,endのパラメータは現時刻の時点にできるようにする
        Alamofire.request(API_URL,method:.get,headers: headers).responseJSON{response in
            if let jsonDict = response.result.value as! NSDictionary!{
                print("==")
//                print(jsonDict)
                let latest_streams = jsonDict["streams"] as! NSArray
//                print(latest_streams)
                print("===")
                let latest_value_dic = latest_streams[0] as! NSDictionary
                
                for i in latest_value_dic{
                    print("==")
                    print(i)
                    print("**")
                }
                let value = latest_value_dic["value"] as! String
                let value_double = Double(value)
                print(value_double)
                let judge_parcent = self.judge_value(value: value_double!)
                print(judge_parcent)
                self.valueLabel.text = Int(ceil(judge_parcent)).description
                
                // ％を角度に変換
                let newAngle = 360 * (judge_parcent / 100)
                self.progressBar.angle = newAngle
                
                // 緩和時間予測
                
                let relaxTime = 0.0016 * (judge_parcent *
                    judge_parcent) * 10
                
                var smell:String = ""
                
                if judge_parcent <= 20 {
                    smell = "安全圏"
                }
                
                else if judge_parcent <= 100{
                    smell = "安全圏まで\(ceil(relaxTime) / 10)分"
                }
                self.commentLabel.text = smell
                
            }
            
        }
    }
    
    
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
     
        
        
        func getNowClockString() -> (String,String) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            
            let now = Date()
            
            //2min前までのデータを取り出すstart_time
            let start_timeDate = NSDate(timeInterval: -60 * 2, since: now as Date)
            let start_time = formatter.string(from:start_timeDate as Date)
            //現在時刻
            let end_time = formatter.string(from: now)
            return (start_time,end_time)
        }
        

    }
}

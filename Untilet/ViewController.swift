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

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LoadAPI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     API読み込み関数
     */
    func LoadAPI() {
        //HeaderはAPI key
        let headers = [
                        "X-M2X-KEY": "9875a0904ad6ff8c46a0ed47dd1730c3",
                       ]
        //APIURLはstreamに割り振られているAPI＿URLにする
        let API_URL = "https://api-m2x.att.com/v2/devices/a0b52f8541b7e2a4a35617d42f6efe5d/streams/MQ4/sampling?type=nth&interval=2&start=2016-11-26T00:00:00.000Z&end=2016-11-28T00:00:00.000Z&limit=4&pretty"
        //start,endのパラメータは現時刻の時点にできるようにする
        Alamofire.request(API_URL,method:.get,headers: headers).responseJSON{response in
            if let JSON = response.result.value{
                print("=")
                
                print("JSON:\(JSON)")
            }
        }
        
    }
    
    /*
     JSON処理関数
     */
  
    
}


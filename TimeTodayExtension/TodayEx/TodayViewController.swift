//
//  TodayViewController.swift
//  TodayEx
//
//  Created by 王荣庆 on 16/3/7.
//  Copyright © 2016年 Ryukie. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        let userDefaults = NSUserDefaults(suiteName: "group.TimeTodayExtensionSharedDefaults")
        let leftTimeWhenQuit = userDefaults!.integerForKey("com.ryukie.simpleTimer.lefttime")
        let quitDate = userDefaults!.integerForKey("com.ryukie.simpleTimer.quitdate")
        
        let passedTimeFromQuit = NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: NSTimeInterval(quitDate)))
        let leftTime = leftTimeWhenQuit - Int(passedTimeFromQuit)
        
        lb_time.text = "\(leftTime)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    
    
    @IBOutlet weak var lb_time: UILabel!
}

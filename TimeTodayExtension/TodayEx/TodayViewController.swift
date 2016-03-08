//
//  TodayViewController.swift
//  TodayEx
//
//  Created by 王荣庆 on 16/3/7.
//  Copyright © 2016年 Ryukie. All rights reserved.
//

import UIKit
import NotificationCenter
import RYTimerKit

class TodayViewController: UIViewController, NCWidgetProviding {
    var timer : RYTimer!
    var image : NSData?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        if  let userDefaults = NSUserDefaults(suiteName: "group.TimeTodayExtensionSharedDefaults") {
            let leftTimeWhenQuit = userDefaults.integerForKey(keyLeftTime)
            let quitDate = userDefaults.integerForKey(keyQuitDate)
            image = userDefaults.objectForKey(keyImage) as? NSData
            let passedTimeFromQuit = NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: NSTimeInterval(quitDate)))
            let leftTime = leftTimeWhenQuit - Int(passedTimeFromQuit)
            
            if (leftTime > 0) {
                timer = RYTimer(timeInterval: NSTimeInterval(leftTime))
                timer.start({
                    [weak self] leftTick in self!.updateLabel()
                    }, stopHandler: {
                        [weak self] finished in self!.showOpenAppButton()
                    })
            } else {
                showOpenAppButton()
            }
        }
        
    }
    
    private func updateLabel() {
        lb_time.text = timer.leftTimeString
    }
    
    private func showOpenAppButton() {
        lb_time.text = "Finished"
        preferredContentSize = CGSizeMake(0, 100)
        let button = UIButton(frame: CGRectMake(0, 50, 50, 50))
        button.setTitle("Open", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
//        button.setBackgroundImage(UIImage(named: "02"), forState: .Normal)
        button.setBackgroundImage(UIImage(data: image!), forState: .Normal)
        button.backgroundColor = UIColor.redColor()
        view.addSubview(button)
    }
    
    @objc private func buttonPressed(sender: AnyObject!) {
        extensionContext!.openURL(NSURL(string: "TimerToday://finished")!, completionHandler: nil)
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

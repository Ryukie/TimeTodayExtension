//
//  ViewController.swift
//  TimeTodayExtension
//
//  Created by 王荣庆 on 16/3/7.
//  Copyright © 2016年 Ryukie. All rights reserved.
//

import UIKit
import RYTimerKit

let defaultTimeInterval: NSTimeInterval = 10
let taskDidFinishedInWidgetNotification: String = "com.ryukie.timerToady.TaskDidFinishedInWidgetNotification"
class ViewController: UIViewController {
    
    var timer : RYTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bt_startClick(sender: AnyObject) {
        if timer == nil {
            timer = RYTimer(timeInterval: defaultTimeInterval)
        }
        let (started , error) = timer!.start({ [weak self] (leftTime) -> Void in
            self!.updateLabel()
            }, stopHandler: { [weak self] (finished) -> Void in
                self!.showFinishAlert(finished)
                self!.timer = nil
            })
        //闭包 另一种写法
        //        let (started, error) = timer!.start({
        //            [weak self] leftTick in self!.updateLabel()
        //            }, stopHandler: {
        //                [weak self] finished in
        //                self!.showFinishAlert(finished)
        //                self!.timer = nil
        //            })
        
        if started {
            updateLabel()
        } else {
            if let realError = error {
                print("error: \(realError.code)")
            }
        }
    }
    @IBAction func bt_stopClick(sender: AnyObject) {
        if let realTimer = timer {
            let (stopped, error) = realTimer.stop()
            if !stopped {
                if let realError = error {
                    print("error: \(realError.code)")
                }
            }
        }
    }
    private func updateLabel() {
        lb_leftTime.text = timer!.leftTimeString
    }
    private func showFinishAlert(finished: Bool) {
        let ac = UIAlertController(title: nil , message: finished ? "Finished" : "Stopped", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: {[weak ac] action in ac!.dismissViewControllerAnimated(true, completion: nil)}))
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var lb_leftTime: UILabel!
}
// MARK: - 应用本体和插件 通过 AppGroup 共享数据
extension ViewController {
    @objc private func applicationWillResignActive() {
        print("app will resign active")
        
        if timer == nil {
            clearDefaults()
        } else {
            if timer!.isRunning {
                saveDefaults()
            } else {
                clearDefaults()
            }
        }
    }
    private func saveDefaults() {
        /*
        这里注意，可能一般我们在使用
        NSUserDefaults 时更多地是使用 standardUserDefaults，
        但是这里我们需要这两个数据能够被扩展访问到的话，
        我们必须使用在 App Groups 中定义的名字来使用 NSUserDefaults。
        */
        if let userDefault = NSUserDefaults(suiteName:  "group.TimeTodayExtensionSharedDefaults") {
            userDefault.setInteger(Int(timer!.leftTime), forKey: keyLeftTime)
            userDefault.setInteger(Int(NSDate().timeIntervalSince1970), forKey: keyQuitDate)
            
            userDefault.synchronize()
        }
    }
    private func clearDefaults() {
        if  let userDefault = NSUserDefaults(suiteName: "group.TimeTodayExtensionSharedDefaults") {
            userDefault.removeObjectForKey(keyLeftTime)
            userDefault.removeObjectForKey(keyQuitDate)
            userDefault.synchronize()
        }
    }
}

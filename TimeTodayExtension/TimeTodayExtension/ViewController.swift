//
//  ViewController.swift
//  TimeTodayExtension
//
//  Created by 王荣庆 on 16/3/7.
//  Copyright © 2016年 Ryukie. All rights reserved.
//

import UIKit

let defaultTimeInterval: NSTimeInterval = 10

class ViewController: UIViewController {

    var timer : RYTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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


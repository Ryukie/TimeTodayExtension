//
//  RYTimer.swift
//  TimeTodayExtension
//
//  Created by 王荣庆 on 16/3/7.
//  Copyright © 2016年 Ryukie. All rights reserved.
//

import UIKit
public let keyLeftTime = "com.ryukie.simpleTimer.lefttime"
public let keyQuitDate = "com.ryukie.simpleTimer.quitdate"
public let keyImage = "com.ryukie.simpleTimer.image"
public let timerErrorDomain = "SimpleTimerError"

public enum SimperTimerError: Int {
    case AlreadyRunning = 1001
    case NegativeLeftTime = 1002
    case NotRunning = 1003
}

public class RYTimer: NSObject {
    public var isRunning : Bool = false
    
    public var leftTime : NSTimeInterval {
        didSet {
            if leftTime < 0 {
                leftTime = 0
            }
        }
    }
    // get
    public var leftTimeString : String {
        get {
            return leftTime.toString()
        }
    }
    
    private var timerTickHandler: (NSTimeInterval -> ())? = nil
    private var timerStopHandler: (Bool ->())? = nil
    private var timer: NSTimer!
    
    public func start(updateTick: (NSTimeInterval -> Void)?, stopHandler: (Bool -> Void)?) -> (start: Bool, error: NSError?) {
        
        if isRunning {
            return (false,NSError(domain: timerErrorDomain, code: SimperTimerError.NotRunning.rawValue, userInfo: nil))
        }
        if leftTime < 0 {
            return (false,NSError(domain: timerErrorDomain, code: SimperTimerError.NegativeLeftTime.rawValue, userInfo: nil))
        }
        timerTickHandler = updateTick
        timerStopHandler = stopHandler
        isRunning = true
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:"countTick", userInfo: nil, repeats: true)//通过此方法创建的直接放在当前运行循环中
        return(true,nil)
    }
    
    public func stop () -> (stopped:Bool,error:NSError?) {
        if !isRunning {
            return (false, NSError(domain: timerErrorDomain, code: SimperTimerError.NotRunning.rawValue, userInfo:nil))
        }
        
        isRunning = false
        timer.invalidate()
        timer = nil
        
        if let stopHandler = timerStopHandler {
            stopHandler(leftTime <= 0)
        }
        timerStopHandler = nil
        timerTickHandler = nil
        
        return (true,nil)
    }
    
    public init(timeInterval:NSTimeInterval) {
        leftTime = timeInterval
    }
    
    @objc private func countTick() {
        leftTime -= 1
        if let tickHandler = timerTickHandler {
            tickHandler(leftTime)
        }
        if leftTime <= 0 {
            stop()
        }
    }
}

extension NSTimeInterval {
    func toString() -> String {
        let totalSecond = Int(self)
        let minute = totalSecond / 60
        let second = totalSecond % 60
        
        switch (minute, second) {
        case (0...9, 0...9):
            return "0\(minute):0\(second)"
        case (0...9, _):
            return "0\(minute):\(second)"
        case (_, 0...9):
            return "\(minute):0\(second)"
        default:
            return "\(minute):\(second)"
        }
    }
}
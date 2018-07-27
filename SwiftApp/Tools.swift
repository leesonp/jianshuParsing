//
//  Tools.swift
//  swiftTest
//
//  Created by leeson on 2018/6/6.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

import UIKit

class Tools: NSObject {
    
    ///MARK: - --- 时间转字符串。参数：{date:时间; 格式：YYYY-MM-dd HH:mm:ss}
    class func DATETOSTR(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
    ///MARK: - --- 时间转字符串。参数{dateFormat:格式化时间字符串; date:时间}
    class func dateToStr(dateFormat:String,date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
    /** 字符串转时间 +8 正常时间，用于展示或上传服务器*/
    class func strToDate(formatStr: String) -> Date{
        let formatter = DateFormatter()
        let timeZone = TimeZone.init(secondsFromGMT: +0)
        formatter.timeZone = timeZone
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let newDate = formatter.date(from: formatStr)
        return newDate!
    }
    
    /** 字符串转时间 GMT 比正常时间少8小时，用于传入pick，不知什么原因pick会给传入的时间多加8小时*/
    class func  strToDateWithGMT(formatStr: String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newDate = formatter.date(from: formatStr)
        return newDate!
    }
    
    /** 时间拆分 */
    class func breakDate(date: Date) -> DateComponents{
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year,.month, .day, .hour,.minute,.second,.weekday], from: date )
        return dateComponents
    }
    
}

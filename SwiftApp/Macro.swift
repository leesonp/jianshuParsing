//
//  Macro.swift
//  SwiftApp
//
//  Created by leeson on 2018/6/14.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

import UIKit

/** 屏幕宽度 */
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
/** 屏幕高度 */
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

/** 宽度适配系数*/
func ViewScale(num: CGFloat) -> CGFloat{
    return (SCREEN_WIDTH / 375.0 * num)
}

/** 判断是否是iPhoneX */
let IsiPhonX = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), UIScreen.main.currentMode!.size) : false

/** 字体 */
func Font(font:CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: font)
}
/** 字体(参数：字号，字体名) */
func FontWithName(_ name:String, _ font:CGFloat) -> UIFont {
    return UIFont.init(name: name, size: font)!
}

/** 16进制颜色 */
func RGB16(value: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(value & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

/** rgb颜色 */
func RGB_COLOR(r: Float, g: Float, b: Float) -> UIColor{
    return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: 1)
}

/** 计算多行文字高度 */
func GETSTRHEIGHT(fontSize: CGFloat, width: CGFloat, words: String) -> CGFloat {
    let font = UIFont.systemFont(ofSize: fontSize)
    let rect = NSString(string: words).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
    return rect.height //ceil(rect.height)
}






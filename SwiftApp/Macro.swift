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
/** 判断是否是iPhoneXR*/
let IsiPhonXR = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 828, height: 1792), UIScreen.main.currentMode!.size) : false
/** 判断是否是iPhoneXS*/
let IsiPhonXS = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), UIScreen.main.currentMode!.size) : false
/** 判断是否是iPhoneXS_MAX*/
let IsiPhonXS_MAX = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1242, height: 2688), UIScreen.main.currentMode!.size) : false
/** 是否全面屏*/
let IsFullScreen = (IsiPhonX || IsiPhonXR || IsiPhonXS || IsiPhonXS_MAX) ? true : false
/** 状态栏高度*/
let StatusBarH = IsFullScreen ? 44.0:20.0;
/** 导航栏高度*/
let NavBarH = IsFullScreen ? 88.0:64.0;
/** 标签栏高度*/
let TabBarH = IsFullScreen ? 83.0:49.0;


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

/** 读取项目本地文件数据 */
func ReadData(_ fileName:String, _ type:String) -> String {
    let path = Bundle.main.path(forResource: fileName, ofType: type)
    let url = URL(fileURLWithPath: path!)
    let data = try! Data(contentsOf: url)
    return String.init(data: data, encoding: .utf8)!
}




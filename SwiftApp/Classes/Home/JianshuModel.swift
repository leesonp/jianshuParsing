//
//  jianshuModel.swift
//  SwiftApp
//
//  Created by leeson on 2018/7/16.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

import UIKit

class JianshuModel: NSObject {
    ///封面
    var wrap:String?
    ///文章URL
    var articleUrl:String?
    ///标题
    var title:String?
    ///文摘
    var abstract:String?
    ///阅读人数
    var read:String?
    ///评论个数
    var comments:String?
    ///喜欢
    var like:String?
    ///发布时间
    var time:String?
    

    ///图片宽度
    var imgW:Float?
    ///图片高度
    var imgH:Float?
    ///item高度
    var itemHeight:String?
    
    ///title高度
    var titleH:CGFloat?
    ///摘要高度
    var abstractH:CGFloat?

}

//
//  JianshuRequestModel.swift
//  SwiftApp
//
//  Created by leeson on 2018/7/20.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

import UIKit

//声明元组类型
typealias Yuanzu = (headImge: String, name: String, sex:String, infoList: Array<String>, totalPage: Int, intro: String, headerH:CGFloat)
//头部信息回调，返回一个元组
typealias HeadBlock = (_ str: Yuanzu) -> Void
//列表数据
typealias DataListBack = (_ str: [JianshuModel]) -> Void

class JianshuRequestModel: NSObject {
    
    static func jianshuRequestDataWithPage(_ page:Int, _ itemWith:Float, _ headBlock:HeadBlock, _ dataListBack:DataListBack){
        var dataArr = [JianshuModel]()
        do {
            //作者ID
            let authorId = "1b4c832fb2ca"
            //获取HTML源码
            var str = try String(contentsOf:URL.init(string: "https://www.jianshu.com/u/\(authorId)?page=\(page)")!, encoding: .utf8)
            print(str)
            
            //剔除换行符和空格
            str = str.replacingOccurrences(of: "\n", with: "")
            str = str.replacingOccurrences(of: " ", with: "")
            
            if page == 1 {
                //获取头部div标签数据
                let headTop =  "<divclass=\"main-top\">(.*?)</div><ulclass=\"trigger-menu\""
                let topInfo:String = self.extractStr(str, headTop)
                //获取头像url
                let headImagRegex = "(?<=aclass=\"avatar\"href=\".{0,200}\"><imgsrc=\")(.*?)(?=\"alt=\".*?\"/></a>)"
                let headImge = self.extractStr(topInfo, headImagRegex)
                /*
                //也可用这个正则表达式获取头像
                let headImagRegex = "(?<=aclass=\"avatar\"href=\")(.*?)(?=\">)|(?<=imgsrc=\")(.*?)(?=\"alt=\".*?\"/></a>)"
                let headImagArr = self.regexGetSub(headImagRegex, self.topInfo!)
                //获取头像url
                self.headImge = headImagArr[1]
                */
                //用户名
                let nameRegex = "(?<=aclass=\"name\"href=\".{0,200}\">)(.*?)(?=</a>)"
                let name = self.extractStr(topInfo, nameRegex)
                
                //性别
                let sexRegex = "(?<=iclass=\"iconfontic-)(.*?)(?=\">.*?</i>)"
                let sex = self.extractStr(topInfo, sexRegex)
                
                //[关注，粉丝，文章，字数，收获喜欢] 。 li标签一般是多个，匹配出来自然是数组
                let infoListRegex = "(?<=li><divclass=\"meta-block\">.{0,200}<p>)(.*?)(?=</p>.*?</li>)"
                let infoList = self.regexGetSub(infoListRegex, topInfo)
                //总页数
                let articleCount = Int(Double((infoList[2]))!)
                let totalPage = articleCount % 9 > 0 ? (articleCount / 9 + 1) : articleCount / 9
                
                //个人介绍
                let introRegex = "(?<=divclass=\"js-intro\">)(.*?)(?=</div>)"
                var intro = self.regexGetSub(introRegex, str)[0]
                intro = intro.replacingOccurrences(of: "<br>", with: "\n")
                
                //头部高度计算
                let headerH = 10 + 60 + 5 + 12 + 8 + GETSTRHEIGHT(fontSize: 12, width: CGFloat(SCREEN_WIDTH - (10 + 60 + 15 + 10)) , words: intro) + 10 + 1
                
                //返回头部信息
                let headCallBackInfo = (headImge:headImge, name:name, sex:sex, infoList:infoList, totalPage:totalPage, intro:intro, headerH:headerH)
                headBlock(headCallBackInfo)
            }
            
            //列表数据
            let articleListStrRegex = "<ulclass=\"note-list\"infinite-scroll-url=\".*?\">(.*?)</ul>"
            //获取文章列表ul标签数据
            let articleListStrArr = self.regexGetSub(articleListStrRegex, str)
            if articleListStrArr[0] != "" {
                let articleListStr = articleListStrArr[0]
                //单条数据正则
                let liLableRegex = "<liid=(.*?)</li>"
                //匹配获取li标签，得到一个元素不大于9的数组
                let liLableArr = self.regexGetSub(liLableRegex, articleListStr)
                //遍历li标签 匹配需要的数据
                for item in liLableArr {
                    //print(item)
                    //正则 ↓
                    let wrapRegex = "(?<=aclass=\"wrap-img\".{0,300}src=\")(.*?)(?=\"alt=\".*?\"/></a>)"
                    let articleUrlRegex = "(?<=aclass=\"title\"target=\"_blank\"href=\")(.*?)(?=\">.*?</a><pclass)"
                    let titleRegex = "(?<=aclass=\"title\".{0,200}>)(.*?)(?=</a><pclass)"
                    let abstractRegex = "(?<=pclass=\"abstract\">)(.*?)(?=</p>)"
                    //let readCommentsRegex = "(?<=atarget=\"_blank\".{0,200}></i>)(.*?)(?=</a>)"
                    let readRegex = "(?<=atarget=\"_blank\".{0,200}><iclass=\"iconfontic-list-read\"></i>)(.*?)(?=</a>)"
                    let commentsRegex = "(?<=atarget=\"_blank\".{0,200}><iclass=\"iconfontic-list-comments\"></i>)(.*?)(?=</a>)"
                    let likeRegex = "(?<=span><iclass=\"iconfontic-list-like\"></i>)(.*?)(?=</span>)"
                    let timeRegex = "(?<=spanclass=\"time\"data-shared-at=\")(.*?)(?=\"></span>)"
                    
                    //数据模型
                    let model = JianshuModel()
                    
                    //封面(可能有文章没有封面) 获取的图片URL最后面类似"w/300/h/240"代表长宽，修改长宽如"w/600/h/480"可得到2倍尺寸的图片，清晰度相应提高，反之亦然。假如超过原图长或宽的尺寸就会显示原图
                    model.wrap = self.regexGetSub(wrapRegex, item)[0]
                    model.imgW = itemWith - 16
                    //如果长度大于0个字符
                    if model.wrap!.count > 0  {
                        //此步是为了按比例缩放图片，但是发现所有的图片都是 宽 * 120 / 150 ，所以可不写这步直接通过宽计算高即可
                        let temp1 = self.matchingStr(str: model.wrap!)
                        var temp2 = temp1.replacingOccurrences(of: "w/", with: "")
                        temp2 = temp2.replacingOccurrences(of: "/h/", with: " ")
                        let tempArr = temp2.components(separatedBy: " ")
                        model.imgH = model.imgW! * Float(tempArr[1])! / Float(tempArr[0])!
                        let temp3 = String(format: "w/%.f/h/%.f", model.imgW!, model.imgH!)
                        model.wrap = model.wrap!.replacingOccurrences(of: temp1, with: temp3)
                    }
                    //文章url
                    model.articleUrl = self.regexGetSub(articleUrlRegex, item)[0]
                    //文章title
                    model.title = self.regexGetSub(titleRegex, item)[0]
                    //文摘
                    model.abstract = self.regexGetSub(abstractRegex, item)[0]
                    
                    //此方法可以只写一个正则表达式，返回一个（两个元素的数组）
                    //                    let redComments = self.regexGetSub(readCommentsRegex, item)
                    //                    let red = redComments[0]    //查看人数
                    //                    let comments = redComments[1]       //评论人数
                    
                    //查看人数
                    model.read = self.regexGetSub(readRegex, item)[0]
                    //评论人数
                    model.comments = self.regexGetSub(commentsRegex, item)[0]
                    //喜欢
                    model.like = self.regexGetSub(likeRegex, item)[0]
                    //发布时间
                    var time = self.regexGetSub(timeRegex, item)[0]
                    time = time.replacingOccurrences(of: "T", with: " ")
                    time = time.replacingOccurrences(of: "+08:00", with: "")
                    model.time = time
                    
                    //计算标题和摘要的高度
                    model.titleH = GETSTRHEIGHT(fontSize: 20, width: CGFloat(model.imgW!) , words: model.title!) + 1
                    model.abstractH = GETSTRHEIGHT(fontSize: 14, width: CGFloat(model.imgW!) , words: model.abstract!) + 1
                    
                    //item高度
                    var computeH:CGFloat = 8 + 25 + 3 + 10 + 8 + (model.imgH != nil ? CGFloat(model.imgH!) : 0) + 8 + model.titleH! + 8 + model.abstractH! + 8 + 10 + 8
                    //如果没有图片减去一个间隙8
                    computeH = computeH - (model.wrap!.count > 0 ? 0 : 8)
                    model.itemHeight = String(format: "%.f", computeH)
                    dataArr.append(model)
                    
                }
                //print(dataArr)
            }
            
        } catch {
            print(error)
        }
        dataListBack(dataArr)
    }
    
    //MARK: - --- 根据正则表达式提取字符串(获取单条)
    static func extractStr(_ str:String, _ pattern:String) -> String{
        
        do{
            let regex = try NSRegularExpression(pattern: pattern , options: .caseInsensitive)
            
            let firstMatch = regex.firstMatch(in: str, options: .reportProgress, range: NSMakeRange(0, str.count))
            if firstMatch != nil {
                let resultRange = firstMatch?.range(at: 0)
                let result = (str as NSString).substring(with: resultRange!)
                //print(result)
                return result
            }
        }catch{
            print(error)
            return ""
        }
        return ""
    }
    
    //MARK: - --- 根据正则表达式提取字符串(获取多条)
    static func regexGetSub(_ pattern:String, _ str:String) -> [String] {
        var subStr = [String]()
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options:[NSRegularExpression.Options.caseInsensitive])
            let results = regex.matches(in: str, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, str.count))
            //解析出子串
            for  rst in results {
                let nsStr = str as  NSString  //可以方便通过range获取子串
                subStr.append(nsStr.substring(with: rst.range))
            }
        }catch{
            print(error)
            return [""]
        }
        return subStr.count == 0 ? [""]:subStr
    }
    
    //MARK: - --- 正则匹配类似"w/300/h/240"的字符串
    static func matchingStr(str:String) -> String{
        let regex = "w/\\d+/h/\\d+$"
        let rangeindex = str.range(of: regex, options: .regularExpression, range: str.startIndex..<str.endIndex, locale:Locale.current)
        var value:String?
        if rangeindex != nil {
            value = String(str[rangeindex!])
            //print(value!) //str.substring(with: rangeindex!)
            return value!
        }
        return ""
    }
}

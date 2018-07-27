//
//  TestVC.swift
//  SwiftApp
//
//  Created by leeson on 2018/6/14.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

import UIKit
import Alamofire

class TestVC: UIViewController {

    var topInfo:String?     //顶部用户信息
    var name:String?        //用户名
    var headImge:String?    //头像
    var infoList:[String]?  //[关注，粉丝，文章，字数，收获喜欢] 数组
    var dataArr = [JianshuModel]()  //文章列表数据
    var intro:String?       //个人介绍
    var page:Int = 1        //分页
    var totalPage:Int = 1   //总页数

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(IsiPhonX)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(pop))
        
        //self.httpRequestData()
        
        self.getHtmlStr()
        
    }
    
    @objc func pop(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //网络请求数据
    func httpRequestData(){
        //let parameters:Dictionary = ["key":"93c921ea8b0348af8e8e7a6a273c41bd"] // http://apis.haoservice.com/weather/city
        Alamofire.request("https://www.jianshu.com/u/1b4c832fb2ca?page=1", method: .get, parameters: nil).responseJSON { (response) in
            print("result==\(response.result)")   // 返回结果，是否成功
            if let jsonValue = response.result.value as? NSDictionary {
                /*
                 error_code = 0
                 reason = ""
                 result = 数组套字典的城市列表
                 */
                print("code: \(jsonValue["error_code"]!)\nresult: \(jsonValue["result"]!)\nreason: \(jsonValue["reason"]!)")
            }
        }

    }
    
    //获取网络HTML源码
    func getHtmlStr(){
        do {
            //获取HTML源码
            var str = try String(contentsOf:URL.init(string: "https://www.jianshu.com/u/1b4c832fb2ca?page=" + String(self.page))!, encoding: .utf8)
            //print(str)
            
            //剔除换行符和空格
            str = str.replacingOccurrences(of: "\n", with: "")
            str = str.replacingOccurrences(of: " ", with: "")
            
            if self.page == 1 {
                let headTop =  "<divclass=\"main-top\">(.*?)</div><ulclass=\"trigger-menu\""
                //获取头部div标签数据
                self.topInfo = self.matchingStr(str, headTop)
                let headImagRegex = "(?<=aclass=\"avatar\"href=\".{0,200}\"><imgsrc=\")(.*?)(?=\"alt=\".*?\"/></a>)"   //(?<=aclass=\"avatar\"href=\").*(?=\"><imgsrc=\")"  //<aclass=\"avatar\"href=\".*?\"><imgsrc=\"(.*?)\".*?/></a>
                //获取头像url
                self.headImge = self.extractStr(self.topInfo!, headImagRegex)
                //用户名
                let nameRegex = "(?<=aclass=\"name\"href=\".{0,200}\">)(.*?)(?=</a>)"
                self.name = self.extractStr(self.topInfo!, nameRegex)
                
                //let headImagRegex = "(?<=aclass=\"avatar\"href=\")(.*?)(?=\">)|(?<=imgsrc=\")(.*?)(?=\"alt=\".*?\"/></a>)"
                //            let headImagArr = self.regexGetSub(headImagRegex, self.topInfo!)
                //            //获取头像url
                //            self.headImge = headImagArr[1]
                
                let infoListRegex = "(?<=li><divclass=\"meta-block\">.{0,200}<p>)(.*?)(?=</p>.*?</li>)"  //(?<=li><divclass=\"meta-block\"><ahref=\".*?\"><p>)(.*?)(?=</p>.*?</li>)
                //[关注，粉丝，文章，字数，收获喜欢]
                self.infoList = self.regexGetSub(infoListRegex, self.topInfo!)
                //总页数
                let articleCount = Int(Double((self.infoList![2]))!)
                self.totalPage = articleCount % 9 > 0 ? (articleCount / 9 + 1) : articleCount / 9
                
                //个人介绍
                let introRegex = "(?<=divclass=\"js-intro\">)(.*?)(?=</div>)"
                self.intro = self.regexGetSub(introRegex, str)[0]
                self.intro = self.intro?.replacingOccurrences(of: "<br>", with: "\n")
            }
            
            //列表数据
            let articleListStrRegex = "<ulclass=\"note-list\"infinite-scroll-url=\".*?\">(.*?)</ul>"
            //获取文章列表ul标签数据
            let articleListStrArr = self.regexGetSub(articleListStrRegex, str)
            if articleListStrArr[0] != "" {
                let articleListStr = articleListStrArr[0]
                let liLableRegex = "<liid=(.*?)</li>"
                //匹配获取li标签个数
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
                    //文章url
                    model.articleUrl = self.regexGetSub(articleUrlRegex, item)[0]
                    //文章title
                    model.title = self.regexGetSub(titleRegex, item)[0]
                    //文摘
                    model.abstract = self.regexGetSub(abstractRegex, item)[0]

//此方法可以只写一个正则表达式，返回一个（两个元素的数组）
//                    let redComments = self.regexGetSub(readCommentsRegex, item)
//                    let red = redComments[0]    //查看人数
//                    let comments = redComments[1]       //评论
                    
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
                    self.dataArr.append(model)
                    
                }
                print(self.dataArr)
            }
            
        } catch {
            print(error)
        }
    }
    
    //正则匹配字符串
    func matchingStr(_ str:String, _ regex:String) -> String{
        
        let rangeindex = str.range(of: regex, options: .regularExpression, range: str.startIndex..<str.endIndex, locale:Locale.current)
        
        if rangeindex != nil {
            let value = str[rangeindex!]
            //print(value)
            return String(value)
        }else{
            return ""
        }
        
    }
    
    //MARK: - --- 根据正则表达式提取字符串(获取单条)
    func extractStr(_ str:String, _ pattern:String) -> String{
        
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
        }
        return ""
    }
    
    //MARK: - --- 根据正则表达式提取字符串(获取多条)
    func regexGetSub(_ pattern:String, _ str:String) -> [String] {
        var subStr = [String]()
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options:[NSRegularExpression.Options.caseInsensitive])
            let results = regex.matches(in: str, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, str.count))
            //解析出子串
            for  rst in results {
                let nsStr = str as  NSString  //可以方便通过range获取子串
                subStr.append(nsStr.substring(with: rst.range))
                //str.substring(with: Range<String.Index>) //本应该用这个的，可是无法直接获得参数，必须自己手动获取starIndex 和 endIndex作为区间
            }
        }catch{
            print(error)
            return [""]
        }
        return subStr.count == 0 ? [""]:subStr
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

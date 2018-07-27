//
//  HomeCell.swift
//  SwiftApp
//
//  Created by leeson on 2018/6/15.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {

    ///头像
    @IBOutlet weak var headImage: UIImageView!
    ///用户名
    @IBOutlet weak var userName: UILabel!
    ///发布时间
    @IBOutlet weak var creatTime: UILabel!
    ///文章封面
    @IBOutlet weak var wrapImg: UIImageView!
    ///文章标题
    @IBOutlet weak var titleLb: UILabel!
    ///摘要
    @IBOutlet weak var abstractLb: UILabel!
    ///阅读人数
    @IBOutlet weak var readLb: UILabel!
    ///评论条数
    @IBOutlet weak var commentsLb: UILabel!
    ///喜欢人数
    @IBOutlet weak var loveLb: UILabel!
    
    ///封面高度
    @IBOutlet weak var wrapH: NSLayoutConstraint!
    ///封面距离顶部高度    
    @IBOutlet weak var wrapTop: NSLayoutConstraint!
    ///标题高度
    @IBOutlet weak var titleH: NSLayoutConstraint!
    ///摘要高度
    @IBOutlet weak var abstractH: NSLayoutConstraint!
    
    var model:JianshuModel?
    
    var headInfo: Yuanzu?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.creatTime.font = FontWithName("DINPro-Regular", 10)
        self.readLb.font = FontWithName("DINPro-Regular", 10)
        self.commentsLb.font = self.readLb.font
        self.loveLb.font = self.readLb.font
        self.wrapImg.contentMode = .scaleAspectFill
        self.wrapImg.layer.masksToBounds = true
    }
    
    //MARK: - --- 设置头像
    func setHeadInfo(_ headInfo:Yuanzu){
        let headArr = headInfo.headImge.components(separatedBy: "?")
        self.headImage.sd_setImage(with: URL(string: "https:" + headArr[0])) { (image, error, type, url) in
            
        }
        self.userName.text = headInfo.name
    }
    
    //MARK: - --- 模型赋值
    func setModel(_ model:JianshuModel){
        self.model = model
        if self.model == nil {return}
        
        var timeStr = self.model!.time!
        timeStr = timeStr.replacingOccurrences(of: "-", with: ".")
        let startIndex = timeStr.index(timeStr.startIndex, offsetBy: 5)
        let endIndex = timeStr.index(timeStr.startIndex, offsetBy: 15)
        timeStr = String(timeStr[startIndex...endIndex])
        self.creatTime.text = timeStr  //substring(from: timeStr!.index(timeStr!.startIndex, offsetBy: 3))
        
        if model.wrap!.count > 0 {
            self.wrapH.constant = CGFloat(self.model!.imgH!)
            self.wrapTop.constant = 8
            //sd取不到？后面带参数的图片，不知为何？？
            let wrapArr = self.model!.wrap!.components(separatedBy: "?")
            self.wrapImg.sd_setImage(with: URL(string: "https:" + wrapArr[0])) { (image, error, cacheType, imageURL) in
                if error != nil {
                    print("imgeWidth: \(image!.size.width)\nimgeHeight: \(image!.size.height)\nimageURL: \(imageURL!)")
                }
                
            }
            //self.wrapImg.sd_setImage(with: URL.init(string: String(format: "https:%@", wrapArr[0])), placeholderImage: UIImage.init(named: "barBgView"))
            
            /*
            //下载图片
            SDWebImageManager.shared().loadImage(with: URL(string: "https:" + wrapArr[0]), options: SDWebImageOptions.highPriority, progress: { (receivedSize:Int,expectedSize:Int,targetURL:URL?) in
                let pro = Float(receivedSize)/Float(expectedSize)*100
                print("进度..\(pro)%")
            }) { ( image:UIImage?,data:Data?, error:Error? ,cacheType:SDImageCacheType, finished:Bool,url:URL?) in
                print(image!.size)
            }
            */
        }else{
            self.wrapImg.image = nil
            self.wrapH.constant = 0
            self.wrapTop.constant = 0
        }
                
        self.titleLb.text = self.model?.title
        self.titleH.constant = self.model!.titleH!
        
        self.abstractLb.text = self.model?.abstract
        self.abstractH.constant =  self.model!.abstractH!
        
        self.readLb.text = self.model?.read
        
        self.commentsLb.text = self.model?.comments
        
        self.loveLb.text = self.model?.like
        
    }
    

}



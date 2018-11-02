//
//  HomeHeadView.swift
//  SwiftApp
//
//  Created by leeson on 2018/7/25.
//  Copyright © 2018年 李斯芃 ---> 512523045@qq.com. All rights reserved.
//

import UIKit

class HomeHeadView: UICollectionReusableView {
    typealias SwitchBtBlock = (_ click: Bool) -> Void
    
    ///头像
    @IBOutlet weak var headImg: UIImageView!
    ///用户名
    @IBOutlet weak var userName: UILabel!
    ///性别
    @IBOutlet weak var sexIcon: UIImageView!
    ///关注
    @IBOutlet weak var focus: UILabel!
    ///粉丝
    @IBOutlet weak var fans: UILabel!
    ///文章
    @IBOutlet weak var article: UILabel!
    ///字数
    @IBOutlet weak var number: UILabel!
    ///收获喜欢
    @IBOutlet weak var totalLike: UILabel!
    ///个人介绍
    @IBOutlet weak var introduce: UILabel!
    
    var switchBack: SwitchBtBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userName.font = FontWithName("DIN-Medium", 18)
        self.focus.font = FontWithName("DINPro-Regular", 12)
        self.fans.font = self.focus.font;
        self.article.font = self.focus.font;
        self.number.font = self.focus.font;
        self.totalLike.font = self.focus.font;
    }
    
    func setHearderInfo(_ headInfo: Yuanzu) {
        let headImgArr = headInfo.headImge.components(separatedBy: "?")
        self.headImg.sd_setImage(with: URL.init(string: String(format: "https:%@", headImgArr[0])), placeholderImage: UIImage.init(named: "headImg"))
        self.userName.text = headInfo.name
        if headInfo.sex == "woman" {
            self.sexIcon.image = UIImage(named: "sex_w")
        }else if (headInfo.sex == "man") {
            self.sexIcon.image = UIImage(named: "sex_m")
        }else {
            self.sexIcon.isHidden = true
        }
        self.focus.text = headInfo.infoList[0]
        self.fans.text = headInfo.infoList[1]
        self.article.text = headInfo.infoList[2]
        self.number.text = headInfo.infoList[3]
        self.totalLike.text = headInfo.infoList[4]
        self.introduce.text = headInfo.intro
    }
    
    //切换布局按钮
    @IBAction func switchBtClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.switchBack!(sender.isSelected)
    }
    
}

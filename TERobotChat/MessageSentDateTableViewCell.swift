//
//  MessageSentDateTableViewCell.swift
//  TERobotChat
//
//  Created by offcn on 15/9/7.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

import UIKit
import SnapKit
class MessageSentDateTableViewCell: UITableViewCell {
    let sentDateLabel: UILabel
   override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        sentDateLabel = UILabel(frame: CGRectZero)
        sentDateLabel.backgroundColor = UIColor.clearColor()
        sentDateLabel.font = UIFont.systemFontOfSize(10)
        sentDateLabel.textAlignment = .Center
        sentDateLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        self.contentView.addSubview(sentDateLabel)
        sentDateLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    //设置标签左右居中，顶部距离cell视图顶部13，底部距离cell视图底部4.5点
    /*
    sentDateLabel.centerX = contentView.centerX
    sentDateLabel.top = contentView.top + 13
    sentDateLabel.bottom = contentView.bottom - 4.5
    */
        sentDateLabel.snp_makeConstraints({(make)->Void in
            make.centerX.equalTo(contentView.snp_centerX)
            make.top.equalTo(contentView.snp_top).offset(13)
            make.bottom.equalTo(contentView.snp_bottom).offset(-4.5)
        
        })
    }

   required init(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

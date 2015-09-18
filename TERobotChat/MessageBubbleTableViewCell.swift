//
//  MessageBubbleTableViewCell.swift
//  TERobotChat
//
//  Created by offcn on 15/9/7.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

import UIKit
import SnapKit
let incomingTag = 0, outgoingTag = 1
let bubbleTag = 8
class MessageBubbleTableViewCell: UITableViewCell {
    let bubbleImageView: UIImageView
    let messageLabel:UILabel
    var url = ""
   override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
     //设置气泡视图和消息标签
        bubbleImageView = UIImageView(image: bubbleImage.incomming, highlightedImage: bubbleImage.incomingHighted)
        bubbleImageView.tag = bubbleTag
        bubbleImageView.userInteractionEnabled = true
    
        messageLabel = UILabel(frame: CGRectZero)
        messageLabel.font = UIFont.systemFontOfSize(messageFontSize)
        messageLabel.numberOfLines = 0
        messageLabel.userInteractionEnabled = false
    
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(messageLabel)
    
    bubbleImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    messageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    //气泡左侧距离cell左侧10，顶部4.5，是messagelabel.windth+30，底部距离4.5
    bubbleImageView.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(contentView.snp_left).offset(10)
        make.top.equalTo(contentView.snp_top).offset(4.5)
        make.width.equalTo(messageLabel.snp_width).offset(30)
        make.bottom.equalTo(contentView.snp_bottom).offset(-4.5)
        
        
    }
    messageLabel.snp_makeConstraints { (make) -> Void in
        make.centerX.equalTo(bubbleImageView.snp_centerX).offset(3)
        make.centerY.equalTo(bubbleImageView.snp_centerY).offset(-0.5)
        messageLabel.preferredMaxLayoutWidth = 218
        make.height.equalTo(bubbleImageView.snp_height).offset(-15)
        
    }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithMessage(message:Message) {
        messageLabel.text = message.text
        if message.url != "" {
            url = message.url
        
        }
        /*
        根据消息类型进行对应的设置，包括使用的图片还有约束条件。由于发送消息的聊天气泡是靠右的，而接受消息的聊天气泡是靠左的，所以发送消息的聊天气泡距离cell右边缘10点
        
        */
        let constraints: NSArray = contentView.constraints()
        let indexOfConstraint = constraints.indexOfObjectPassingTest({(var constraint,idx,stop) in
         return (constraint.firstItem as! UIView).tag == bubbleTag && (constraint.firstAttribute == NSLayoutAttribute.Left || constraint.firstAttribute == NSLayoutAttribute.Right)
        })
        
        contentView.removeConstraint(constraints[indexOfConstraint] as! NSLayoutConstraint)
        bubbleImageView.snp_makeConstraints({ (make) -> Void in
            if message.incoming {
                tag = incomingTag
                bubbleImageView.image = bubbleImage.incomming
                bubbleImageView.highlightedImage = bubbleImage.incomingHighted
                messageLabel.textColor = UIColor.blackColor()
                make.left.equalTo(contentView.snp_left).offset(10)
                messageLabel.snp_updateConstraints { (make) -> Void in
                    make.centerX.equalTo(bubbleImageView.snp_centerX).offset(3)
                }
                
            } else { // outgoing
                tag = outgoingTag
                bubbleImageView.image = bubbleImage.outgoing
                bubbleImageView.highlightedImage = bubbleImage.outgoingHightlighed
                messageLabel.textColor = UIColor.whiteColor()
                make.right.equalTo(contentView.snp_right).offset(-10)
                messageLabel.snp_updateConstraints { (make) -> Void in
                    make.centerX.equalTo(bubbleImageView.snp_centerX).offset(-3)
                }
                
                
            }
        })
    
    
    
}

   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        super.setSelected(selected, animated: animated)
        bubbleImageView.highlighted = selected    }

}

let bubbleImage = bubbleImageMake()
//返回一个结构体包含四种图片：发送消息气泡的正常和高亮图片，接收信息气泡的正常和高亮图片
func bubbleImageMake()->(incomming:UIImage, incomingHighted:UIImage,outgoing:UIImage,outgoingHightlighed:UIImage) {
    
    let maskOutgoing = UIImage(named: "MessageBubble")!
    //获得该图片的水平镜像
    let maskIncoming = UIImage(CGImage: maskOutgoing.CGImage, scale: 2, orientation: .UpMirrored)!
    //设置可拉伸区域 1*1 像素 但是这一部分可以无限的横向或者纵向拉伸
    let capInsetsIncoming = UIEdgeInsets(top: 17, left: 26.5, bottom: 17.5, right: 21)
    let capInsetsOutgoing = UIEdgeInsets(top: 17, left: 21, bottom: 17.5, right: 26.5)
    //resizableImageWithCapInsets获取可拉伸图片
    let incoming = coloredImage(maskIncoming, 229/255, 229/255, 234/255, 1).resizableImageWithCapInsets(capInsetsIncoming)
    let incomingHighlighted = coloredImage(maskIncoming, 206/255, 206/255, 210/255, 1).resizableImageWithCapInsets(capInsetsIncoming)
    let outgoing = coloredImage(maskOutgoing,  0.05 ,0.47,0.91,1.0).resizableImageWithCapInsets(capInsetsOutgoing)
    let outgoingHighlighted = coloredImage(maskOutgoing, 32/255, 96/255, 200/255, 1).resizableImageWithCapInsets(capInsetsOutgoing)
    
    return (incoming,incomingHighlighted,outgoing,outgoingHighlighted)
}
//对图片进行染色处理
func coloredImage(image:UIImage, red:CGFloat, green:CGFloat, blue:CGFloat,alpha:CGFloat)->UIImage {
    //获取图片大小
    let rect = CGRect(origin: CGPointZero, size: image.size)
    //创建绘图上下文
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    //获取位图绘图上下文，并开化寺渲染操作
    let context = UIGraphicsGetCurrentContext()
    image.drawInRect(rect)
    CGContextSetRGBFillColor(context, red, green, blue, alpha)
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop)
    CGContextFillRect(context, rect)
    //获取到绘图结果，结束位图绘图上下文并返回绘图结果
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}

//
//  ChatViewController.swift
//  TERobotChat
//
//  Created by offcn on 15/9/6.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

import UIKit
import SnapKit
import Parse
import Alamofire
let messageFontSize:CGFloat = 17
let toolBarMinHeight:CGFloat = 44
let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)


class ChatViewController: UITableViewController,UITextViewDelegate {

    var toolBar:UIToolbar!
    var textView:UITextView!
    var sendButton:UIButton!
    var messages:[[Message]] = [[]]
    var question = ""
    var response:String?
    override var inputAccessoryView:UIView!{
        get {
            if toolBar == nil {
                toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight-0.5))
                textView = InputTextView(frame: CGRectZero)
                textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
                textView.font = UIFont.systemFontOfSize(messageFontSize)
                textView.delegate = self
                textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)
                
                sendButton = UIButton.buttonWithType(.System) as! UIButton
                sendButton.enabled = false
                sendButton.titleLabel?.font = UIFont.systemFontOfSize(17)
                sendButton.setTitle("发送", forState: .Normal)
                sendButton.setTitleColor(UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1.0), forState: .Normal)
                sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                sendButton.addTarget(self, action: Selector("sendAction"), forControlEvents: .TouchUpInside)
                toolBar.addSubview(sendButton)
                textView.setTranslatesAutoresizingMaskIntoConstraints(false)
                sendButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        //系统代码实现autolayout
//                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: toolBar, attribute: .Left, multiplier: 1, constant: 8))
//                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 7.5))
//                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: sendButton, attribute: .Left, multiplier: 1, constant: -2))
//                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -8))
//                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
//                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5))
                textView.snp_makeConstraints({(make)->Void in
                    //也就是textView.left = self.toolBar.left + 8，这样一看就很直观了，文字框的左侧距输入框左侧8点。
                    make.left.equalTo(self.toolBar.snp_left).offset(8)
                    make.top.equalTo(self.toolBar.snp_top).offset(7.5)
                    make.right.equalTo(self.sendButton.snp_left).offset(-2)
                    make.bottom.equalTo(self.toolBar.snp_bottom).offset(-8)
                
                })
                sendButton.snp_makeConstraints({ (make) -> Void in
                    //表示发送按钮右侧直接贴输入框的右侧,没有位移
                    make.right.equalTo(self.toolBar.snp_right)
                    //发送按钮底部距离输入框底部4.5点
                    make.bottom.equalTo(self.toolBar.snp_bottom).offset(-4.5)
                    
                })
            
            }
            
          return toolBar
        }
    
    
    }
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    func initData() {
        var index = 0
        var section = 0
        var currentDate:NSDate?
        if messages.count <= 1 {
            //新建查询，查询我们刚才所建立的Message类
            var query : PFQuery = PFQuery(className: "Messages")
            query.orderByAscending("sentDate")
            for obj in query.findObjects() as! [PFObject] {
            
               let message = Message(incoming: obj["incoming"] as! Bool, text: obj["text"] as! String, sentDate: obj["sentDate"] as! NSDate)
                if let url = obj["url"] as? String {
                
                    message.url = url
                
                }
                
                if index == 0 {
                
                    currentDate = message.sentDate
                
                }
                let timeInterVal = message.sentDate.timeIntervalSinceDate(currentDate!)
                if timeInterVal < 120 {
                
                   messages[section].append(message)
                }else {
                
                    section++
                    messages.append([message])
                
                }
                currentDate = message.sentDate
                index++
            
            }
        
        }
    
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //The manner in which the keyboard is dismissed when a drag begins in the scroll view
        tableView.keyboardDismissMode = .Interactive
        tableView.registerClass(MessageSentDateTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MessageSentDateTableViewCell))
        self.tableView.estimatedRowHeight = 44
        //对tableView进行一些必要的设置,由于tableView底部有一个输入框，因此会遮挡cell，所以要将tableView的内容inset增加一些底部位移:
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: toolBarMinHeight, right: 0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    
        initData()
        

        // Do any additional setup after loading the view.
    }
    deinit {
    
       NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //根据输入框有文字与否来决定sendbutton是否可以被点击
    func textViewDidChange(textView: UITextView) {
        upDateTextViewHeight()
        sendButton.enabled = textView.hasText()
    }
    
   //tableViewDelegate
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return messages.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count + 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cellIdentifier = NSStringFromClass(MessageSentDateTableViewCell)
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MessageSentDateTableViewCell
            let message = messages[indexPath.section][0]
            println(message.sentDate)
            cell.sentDateLabel.text = formatDate(message.sentDate)
            return cell
        
        }else {
             let cellIdentifier = NSStringFromClass(MessageBubbleTableViewCell)
//             var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? MessageBubbleTableViewCell
            var cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier(cellIdentifier) as? MessageBubbleTableViewCell
            if cell == nil {
                cell = MessageBubbleTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            
            }
            let message = messages[indexPath.section][indexPath.row-1]
            cell?.configureWithMessage(message)
            return cell!
        }
    }
    
    func formatDate(date: NSDate) -> String {
        //获取当前日历
        let calendar = NSCalendar.currentCalendar()
        var dateFormatter = NSDateFormatter()
        //新建日期格式化器，设置地区为中国大陆
        dateFormatter.locale = NSLocale(localeIdentifier: "zh_CN")
        //设置一些布尔变量用来判断消息发送时间相对于当前时间有多久
        let last18hours = (-18*60*60 < date.timeIntervalSinceNow)
        let isToday = calendar.isDateInToday(date)
        let isLast7Days = (calendar.compareDate(NSDate(timeIntervalSinceNow: -7*24*60*60), toDate: date, toUnitGranularity: .CalendarUnitDay) == NSComparisonResult.OrderedAscending)
        
        if last18hours || isToday {
            dateFormatter.dateFormat = "a HH:mm"
        } else if isLast7Days {
            dateFormatter.dateFormat = "MM月dd日 a HH:mm EEEE"
        } else {
            dateFormatter.dateFormat = "YYYY年MM月dd日 a HH:mm"
            
        }
        return dateFormatter.stringFromDate(date)
    }
    
    func saveMessage(message:Message) {
       var saveObject = PFObject(className: "Messages")
        saveObject["incoming"] = message.incoming
        saveObject["text"] = message.text
        saveObject["sentDate"] = message.sentDate
        saveObject["url"] = message.url
        saveObject.saveEventually{(success,error)->Void in
        
            if success {
            
                println("消息保存成功")
            
            }else {
            
                 println("消息保存失败\(error)")
            }
      
        }
    
    }
    
    func sendAction() {
    //将新的消息添加到消息数组
       var message = Message(incoming: false, text: textView.text, sentDate: NSDate())
        saveMessage(message)
        messages.append([message])
        question = textView.text
        textView.text = nil
        upDateTextViewHeight()
        sendButton.enabled = false
        
        //添加两行cell 一行添加消息，另一行添加时间
        let lastSection = tableView.numberOfSections()
        //开始执行更新
        tableView.beginUpdates()
        //插入一个一个新分区，将插入两个cell，第一行显示发送时间，第二行显示消息
        tableView.insertSections(NSIndexSet(index: lastSection), withRowAnimation: .Automatic)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: lastSection),NSIndexPath(forRow: 1, inSection: lastSection)], withRowAnimation: .Automatic)
        tableView.endUpdates()
        tableViewScrollToBottomAnimated(true)
        //数据请求

        Alamofire.request(.GET, NSURL(string: api_url)!, parameters: ["key":api_key,"info":question,"userid":userId]).responseJSON(options: NSJSONReadingOptions.MutableContainers, completionHandler: {(_,_,data,error)->Void in
            println(data)
            if error == nil {
                if let text = data!.objectForKey("text") as? String {
                    if let url = data!.objectForKey("url") as? String {
                        var message = Message(incoming: true, text: text+"\n(点击该消息查看)", sentDate: NSDate())
                        message.url = url
                        self.saveMessage(message)
                        self.messages[lastSection].append(message)
                    
                    }else {
                        var message = Message(incoming: true, text: text, sentDate: NSDate())
                        self.saveMessage(message)
                        self.messages[lastSection].append(message)
                    
                    
                    }
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: lastSection)], withRowAnimation: .Automatic)
                    self.tableView.endUpdates()
                    self.tableViewScrollToBottomAnimated(true)
                
                
                }else {
                    println("error:\(error?.userInfo)")
                
                }
            
            }
        
        })
    
    
    
    }
    
    //将tableview滚动到我们新添加消息的位置，当然这个函数还没有定义
    func tableViewScrollToBottomAnimated(animated: Bool) {
        
        let numberOfSections = messages.count
        let numberOfRows = messages[numberOfSections - 1].count
        if numberOfRows > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow:numberOfRows, inSection: numberOfSections - 1), atScrollPosition: .Bottom, animated: animated)
        }
    }
    //更新输入框的高度来适应tableview的高度
    func upDateTextViewHeight() {
        let oldHeight = textView.frame.height
        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
        var newHeight = min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.max)).height, maxHeight)
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
            #else
            newHeight = CGFloat(ceilf(newHeight.native))
        #endif
        if newHeight != oldHeight {
            toolBar.frame.size.height = newHeight+8*2-0.5
        }
    
    
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        var selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! MessageBubbleTableViewCell
        println(selectedCell.url)
        if selectedCell.url != "" {
           var url = NSURL(string: selectedCell.url)
            UIApplication.sharedApplication().openURL(url!)
        
        }
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class InputTextView: UITextView {
    
//    override var inputAccessoryView:UIView! {
//        get {
//        
//        
//        
//        }
//        
//        
//    }
    
    
}

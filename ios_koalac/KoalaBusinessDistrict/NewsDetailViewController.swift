//
//  NewsDetailViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/7/6.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit
class NewsDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,EMChatManagerDelegate,DXMessageToolBarDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    lazy var chatToolBar:DXMessageToolBar = {
        let chatToolBar = DXMessageToolBar.init(frame: CGRectMake(0, self.view.frame.size.height - DXMessageToolBar.defaultHeight(), self.view.frame.size.width, DXMessageToolBar.defaultHeight()))
        
        chatToolBar.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin,UIViewAutoresizing.FlexibleRightMargin];
        
        chatToolBar.delegate = self;
        return chatToolBar;
    }()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView.init(frame: CGRectMake(0, 0/*self.callAreaHeight*/, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height - 0/*self.callAreaHeight*/), style: UITableViewStyle.Plain)
        
        tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight,UIViewAutoresizing.FlexibleWidth]

        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView.init()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "keyBoardHidden")
        tap.delegate = self
        tableView.addGestureRecognizer(tap)
        
        return tableView
    }()
    
    lazy var imagePicker: UIImagePickerController = {
        let imageP = UIImagePickerController()
        imageP.delegate = self
        imageP.navigationController?.delegate = self
        return imageP
    }()

    var messageQueue:dispatch_queue_t = dispatch_queue_create("easemob.com", nil)
    
    var userId:String = "" //用户id
    var userName:String = ""//用户名字
    var hxTimeStamp:Int64 = 0
    var HXID:String = "" //环信id
    var telphoneUser = "" //传过来用户的电话
    var messagesSource:[EMMessage] = []
    var hxConversation:EMConversation?
    lazy var chatTagDate = {
        return NSDate.init(timeIntervalInMilliSecondSince1970:0)
    }()
    
    var textCell:NewsTextCell?
    private var currPage:Int = 0

//    private var tableData:[NewsDetailModel] = []//
    private var tableData1:[NewsDetailModel] = []//tableview显示的数组
    private var tableDataTemp:[NewsDetailModel] = []//没用!!!
    //    let arrMessage:NSMutableArray = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        EaseMob.sharedInstance().chatManager.conversationForChatter!(self.HXID, conversationType: EMConversationType.eConversationTypeChat).markAllMessagesAsRead(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //1.处理特定的cell没有聊天机会
        self.title = self.userName
        //1.处理特定的cell没有聊天机会 
        if self.userId == "1" || self.userId == "2"
        {
//            self.messageBackView.hidden = true
//            self.messageBackViewH.constant = CGFloat(0)

            self.tableView.updateConstraintsIfNeeded()
            self.tableView.updateConstraints()
            
        }
        //2.设置环信聊天代理
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
        
        //3. 处理键盘监听键盘的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        //4.创建界面
        self.view.addSubview(self.tableView)
        self.initControl()
        
        //5.添加数据
        self.initData("formVC")
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
    }
    
    //获取单个聊天对象
    func getSingleMessages(str:String)
    {
        //单个聊天对象
        if let conversation:EMConversation = EaseMob.sharedInstance().chatManager.conversationForChatter!(self.HXID, conversationType: EMConversationType.eConversationTypeChat){
            pprLog(self.tableData1.count)
            //刷新
            if self.tableData1.count > 0 {
                self.hxTimeStamp = Int64(self.tableData1.first!.hx_timeStamp)
            }else {
                let dateNow = NSDate()
                let dateStamp:NSTimeInterval = dateNow.timeIntervalSince1970 * 1000
                self.hxTimeStamp = Int64(dateStamp)
            }//刷新
            if let hx_messagesArr:Array = conversation.loadNumbersOfMessages(10, before: self.hxTimeStamp) {
                self.tableDataTemp = []
                for hx_messagee in hx_messagesArr {
                    //容器
                    let hx_message = hx_messagee as! EMMessage
                    //添加到环信消息容器
                    self.messagesSource.append(hx_message)
                    //时间戳
                    //                    let messageTimestamp = String(hx_message.timestamp / 1000)
                    let createDate:NSDate = NSDate.init(timeIntervalInMilliSecondSince1970: Double(hx_message.timestamp))
                    let timeCuo = createDate.formattedTime()
                    
                    //取消息容器内容
                    let hx_messageBodies = hx_message.messageBodies.first
                    //判断文本类型
                    if hx_messageBodies is EMTextMessageBody
                    {
                        let hx_textMessageBody = hx_messageBodies as! EMTextMessageBody
                        let messageModel = NewsDetailModel()
                        messageModel.messageContent = hx_textMessageBody.text
                        
                        messageModel.cellHeight = 0
                        messageModel.uid = ""
                        messageModel.userName = ""
                        messageModel.order_id = ""
                        messageModel.message_type = "text_message"
                        messageModel.messageTime = timeCuo
                        messageModel.hx_timeStamp = hx_message.timestamp
                        messageModel.goodsUrl = ""
                        messageModel.goodsImage = ""
                        messageModel.goodsName = ""
                        messageModel.noticePic = ""
                        messageModel.noticeTitle = ""
                        messageModel.noticeUrl = ""
                        //自己的消息ext字段为空
                        if hx_message.ext != nil
                        {
                            //消息体内扩展模型
                            let messageExt = hx_message.ext as! Dictionary<String,AnyObject>
                            let modelExt = XHMessageExtModel.init(ext:messageExt)
                            messageModel.userHeadIcon = modelExt.hx_avator
                            messageModel.hx_ext = modelExt
                            //处理电话被覆盖bug
                            if modelExt.hx_disp_tel.isEmpty{}else{
                                self.telphoneUser = modelExt.hx_disp_tel
                            }
                            
                        }
                        if conversation.chatter != hx_message.from{
                            messageModel.hx_MessageOri = "me"
                        }else{
                            messageModel.hx_MessageOri = "other"
                        }
                        
                        //                        self.tableData1.insert(messageModel, atIndex: 0)
                        self.tableDataTemp.append(messageModel)
                        //                        self.tableData1.append(messageModel)
                        //                        self.tableView.reloadData()
                        //第一次进来滚到底
                        //                        if str == "formVC"{
                        //                              self.HXScrollToRowAtIndex()
                        //                        }else{
                        //
                        //                        }
                    }
                }
                self.tableData1 =  self.tableDataTemp + self.tableData1
                self.tableView.reloadData()
                
                if str == "formVC"{
                    self.scrollViewToBottom()
//                    self.HXScrollToRowAtIndex()
                }else{
                    
                }
            }
            
        }
        
    }
    //发消息
    func sendTextMessage(text:String){
        
        if text == ""{
            
        }else{
            let message:EMMessage = self.sendTextMessage(text, toUser:self.HXID, messageType: EMMessageType.eMessageTypeChat, requireEncryption: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func addMessageToDataSource(message:EMMessage,progress:IEMChatProgressDelegate?){
        
    }
    //发消息调用方法
    func sendTextMessage(text:String,toUser:String, messageType:EMMessageType, requireEncryption:Bool) -> EMMessage
    {
        //转换表情
        //        let willSendText:String = EaseConvertToCommonEmoticonsHelper.convertToCommonEmoticons(text)
        let textChat:EMChatText = EMChatText.init(text: text)
        let body:EMTextMessageBody = EMTextMessageBody.init(chatObject: textChat)
        let message:EMMessage = EMMessage.init(receiver: toUser, bodies: [body])
        message.requireEncryption = requireEncryption
        message.messageType = messageType
        message.from = HXMessageModel.sharedHXInstance.hxUsername
        message.to = toUser
        //        message.ext = messageExt as [NSObject : AnyObject]
        let retMessage:EMMessage = EaseMob.sharedInstance().chatManager.asyncSendMessage(message, progress: nil)
        
        return retMessage
    }
    
    func didSendMessage(message: EMMessage!, error: EMError!) {
        NSNotificationCenter.defaultCenter().postNotificationName("refreshEaseMob", object: self)
    }
    
    //接收信息
    func didReceiveMessage(message:EMMessage)
    {
        EaseMob.sharedInstance().chatManager.conversationForChatter!(self.HXID, conversationType: EMConversationType.eConversationTypeChat).markAllMessagesAsRead(true)
        let hx_messageBodies = message.messageBodies.first
        let createDate:NSDate = NSDate()
        let timeCuo = createDate.formattedTime()
        
        //消息体内扩展模型
        let messageExt = message.ext as! Dictionary<String,AnyObject>
        let modelExt = XHMessageExtModel.init(ext:messageExt)
        if hx_messageBodies is EMTextMessageBody
        {
            let str = hx_messageBodies as! EMTextMessageBody
            switch(str.messageBodyType)
            {
            case MessageBodyType.eMessageBodyType_Text :
                if self.title == modelExt.hx_nickname{//过滤在聊天页面接收到的消息
                    let messageModel = NewsDetailModel()
                    messageModel.hx_ext = modelExt
                    
                    messageModel.messageContent = str.text
                    messageModel.hx_MessageOri = "other"
                    messageModel.cellHeight = 0
                    messageModel.uid = ""
                    messageModel.userHeadIcon = modelExt.hx_avator
                    messageModel.userName = modelExt.hx_nickname
                    messageModel.order_id = ""
                    messageModel.message_type = "text_message"
                    messageModel.messageTime = timeCuo
                    messageModel.goodsUrl = ""
                    messageModel.goodsImage = ""
                    messageModel.goodsName = ""
                    messageModel.noticePic = ""
                    messageModel.noticeTitle = ""
                    messageModel.noticeUrl = ""
                    self.tableData1.append(messageModel)
                    self.tableView.reloadData()
                    // 自动滚动表格到最后一行
                    self.scrollViewToBottom()
                }
            default:
                break
            }
        } else if hx_messageBodies is EMImageMessageBody
        {
        }else{
        }
    }
    
    //离线消息
    func didFinishedReceiveOfflineMessages()
    {
        pprLog("didFinishedReceiveOfflineMessages()")
    }
    
    func didReceiveOfflineMessages(offlineMessages: [AnyObject]!) {
        pprLog("didReceiveOfflineMessages(offlineMessages: [AnyObject]!)")
    }
    
    private func initControl(){
//        let aaa = KLNewChatBarMoreView.init(frame: CGRectMake(0,screenHeight-180, 320, 250))
//        aaa.backgroundColor = UIColor.yellowColor()
//        self.view.addSubview(aaa)
//        aaa.orderButtonBlock =  {(NewChatBarMoreView) -> () in
//            pprLog("蓝天白云")
//             pprLog(NewChatBarMoreView)
//        }
        
        self.view.addSubview(self.chatToolBar)
        self.toolBlock()
        
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        //电话
        let imageCall = UIImage(named: "personInfo")
        let backBtnCall:UIButton = UIButton(type:UIButtonType.Custom)
        backBtnCall.setImage(imageCall, forState: UIControlState.Normal)
        backBtnCall.frame = CGRectMake(0, 0, 30, 30)
        backBtnCall.addTarget(self, action:Selector("backActionCall"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItemCall = UIBarButtonItem(customView: backBtnCall)
        if self.userId == "1" || self.userId == "2" {
            
        }else{
            self.navigationItem.rightBarButtonItem = backItemCall
        }
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        
        self.tableView.header = MJRefreshNormalHeader(){
            self.currPage += 1
            self.initData("fromflash")
        }
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    //打电话
    func backActionCall(){
        var flagVC:String = ""
        for vc1:UIViewController in (self.navigationController!.viewControllers){

            if vc1.isKindOfClass(CustomerDetailViewController){
                //            NewsDetailVC = (vc1 as! NewsDetailViewController)
                flagVC = "1"
                self.navigationController?.popViewControllerAnimated(true)
                break
            }else{
                flagVC = "2"
            }
        }
        if flagVC == "2" {
            let newsDetailVC = CustomerDetailViewController(nibName:"CustomerDetailViewController",bundle:nil)
            newsDetailVC.customerData.tel = self.telphoneUser
            newsDetailVC.customerData.uid = self.userId
            newsDetailVC.customerData.name = self.userName
            newsDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(newsDetailVC, animated: true)
        }
        
    }
    private func initData(fremFlag:String){
        
        self.getSingleMessages(fremFlag)
        if self.tableView.header.isRefreshing(){
            self.tableView.header.endRefreshing()
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return self.tableData.count
        return self.tableData1.count
    }
    
    private func getCellHeight(cell:UITableViewCell)->CGFloat{
        cell.layoutIfNeeded()
        cell.updateConstraintsIfNeeded()
        
        let height = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height;
        return height+1.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        let model = self.tableData[indexPath.row]
        let model = self.tableData1[indexPath.row]
        if model.cellHeight == 0{
            if model.message_type == "text_message"{
                
                //只创建一个cell用作测量高度
                if self.textCell == nil{
                    
                    textCell = NSBundle.mainBundle().loadNibNamed("NewsTextCell", owner: nil, options: nil).first as? NewsTextCell
                    
                }
                self.textCell!.cellData = model;
                if model.hx_ext?.hx_msg_type == "txt" { //文本类型
                    model.cellHeight = self.getCellHeight(self.textCell!)
                }else{
                    if model.hx_MessageOri == "me" {//自己的信息
                        model.cellHeight = self.getCellHeight(self.textCell!)
                    }else {
                        model.cellHeight = NewsDetailCell.cellHeight()
                    }
                    
                }
                
                
            }else{
                model.cellHeight = NewsDetailCell.cellHeight()
            }
        }
        
        return model.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let model = self.tableData1[indexPath.row]
        //twk新加的
        if model.isNew {
            let cell = UITableViewCell()
            return cell
        }else{
        //历史以前遗留下来的
        //自己
        if model.hx_MessageOri == "me"
        {
            self.tableView.registerNib(UINib(nibName: "messageTableViewCell", bundle: nil), forCellReuseIdentifier: messageTableViewCell.cellIdentifier())
            let cell = self.tableView.dequeueReusableCellWithIdentifier(messageTableViewCell.cellIdentifier(), forIndexPath: indexPath) as! messageTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.backgroundColor = GlobalBgColor
            cell.cellData1 = model
            return cell
            
        }else{
            //对方的消息分两种类型 1.聊天纯文本 2.购买商品 [model.hx_ext?.hx_msg_type == nil处理商圈小助手]
            if model.hx_ext?.hx_msg_type == "txt" || model.hx_ext?.hx_msg_type == nil {
                self.tableView.registerNib(UINib(nibName: "NewsTextCell", bundle: nil), forCellReuseIdentifier: NewsTextCell.cellIdentifier())
                let cell = self.tableView.dequeueReusableCellWithIdentifier(NewsTextCell.cellIdentifier(), forIndexPath: indexPath) as! NewsTextCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.backgroundColor = GlobalBgColor
                cell.cellData = model
                //6.回调头像手势 uid怎么拿到？  2.切换服务器
                cell.headIconBlock = {
                    () -> () in
                    let webVC = WebViewController()
                    
                    let store_id = LoginInfoModel.sharedInstance.store.store_id
                    //                    let store_name = LoginInfoModel.sharedInstance.store.store_name
                    let titleStr = self.title!
                    webVC.title = "\(titleStr)"
                    webVC.webUrl = NetworkManager.sharedInstance.baseUrl + "/mall/index.php?app=store_business&store_id=\(store_id)&user_id=\(model.uid)"
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
                return cell
            }else{  //订单支付通知'orderpayed',发送订单'order',发送商品'goods' 都用这个cell
                self.tableView.registerNib(UINib(nibName: "NewsDetailCell", bundle: nil), forCellReuseIdentifier: NewsDetailCell.cellIdentifier())
                let cell = self.tableView.dequeueReusableCellWithIdentifier(NewsDetailCell.cellIdentifier(), forIndexPath: indexPath) as! NewsDetailCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.backgroundColor = GlobalBgColor
                cell.cellData = model
                //回调头像手势
                cell.headIconDetailsBlock = {
                    () -> () in
                    let webVC = WebViewController()
                    //                let store_name = LoginInfoModel.sharedInstance.store.store_name
                    let titleStr = self.title!
                    webVC.title = "\(titleStr)"
                    let store_id = LoginInfoModel.sharedInstance.store.store_id
                    webVC.webUrl = NetworkManager.sharedInstance.baseUrl + "/mall/index.php?app=store_business&store_id=\(store_id)&user_id=\(model.uid)"
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
                return cell
            }
        }
        
        }
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let model = self.tableData[indexPath.row]
        let model = self.tableData1[indexPath.row]
        //这里最好写个枚举
        if model.message_type == "commentorder"{
            let webVC = WebViewController()
            webVC.title = "详情"
            webVC.webUrl = model.goodsUrl
            self.navigationController?.pushViewController(webVC, animated: true)
        }else if model.message_type == "neworder" || model.message_type == "finishorder"{
            
            NetworkManager.sharedInstance.requestOrderInfo(model.order_id, success: { (jsonDic:AnyObject) -> () in
                let dic = jsonDic as! Dictionary<String, AnyObject>
                let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                let model = OrderModel(jsonDic: objDic)
                let orderDetailVC = OrderDetailViewController(nibName:"OrderDetailViewController", bundle:nil)
                orderDetailVC.orderData = model
                orderDetailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(orderDetailVC, animated: true)
                }, fail: { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                        
                    }else{
                        GShowAlertMessage(error)
                    }
            })
        }else if model.message_type == "verify"{
            
            let webTitle = model.noticeTitle
            let webVC: WebViewShareController?
            webVC = webHelper.openWebShareVC(webTitle, jumpURL: model.noticeUrl)
            webVC?.webShareType = webTitle
            self.navigationController?.pushViewController(webVC!, animated: true)
            
        }else if model.message_type == "text_message"{
            
            if model.hx_ext?.hx_target == "url" { //是url直接跳转
                let webVC = WebViewController()
                webVC.title = "详情"
                if model.hx_ext?.hx_url == ""{
                }else{
                    webVC.webUrl = (model.hx_ext?.hx_url)! + "&" + LoginInfoModel.sharedInstance.store.store_id
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            }else if model.hx_ext?.hx_target == "self"{//跳详情信息页面
                
                if model.hx_ext?.hx_msg_type == "txt"||model.hx_MessageOri == "me" {}else{
                    var idForJump:String = ""
                    if self.userId == "1" || self.userId == "2" {
                        idForJump = (model.hx_ext?.hx_id)!
                    }else{
                        idForJump = (model.hx_ext?.hx_order_id)!
                    }
                    
                    NetworkManager.sharedInstance.requestOrderInfo(idForJump, success: { (jsonDic:AnyObject) -> () in
                        let dic = jsonDic as! Dictionary<String, AnyObject>
                        let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
                        let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
                        let model = OrderModel(jsonDic: objDic)
                        let orderDetailVC = OrderDetailViewController(nibName:"OrderDetailViewController", bundle:nil)
                        orderDetailVC.orderData = model
                        orderDetailVC.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(orderDetailVC, animated: true)
                        }, fail: { (error:String, needRelogin:Bool) -> () in
                            if needRelogin == true{
                                
                            }else{
                                GShowAlertMessage(error)
                            }
                    })
                }
            }
            
            pprLog("text_message")
            
        }else{
            
        }
    }
    
    /**
     *  当键盘改变了frame(位置和尺寸)的时候调用
     */
    
    func keyboardWillChangeFrame(note:NSNotification)
    {
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        let keyboardFrame = note.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        let transformY = keyboardFrame.origin.y - self.view.frame.size.height-64
        UIView.animateWithDuration(duration) { () -> Void in
            
            if self.tableData1.count > 1
            {
                self.tableView.transform = CGAffineTransformMakeTranslation(0, transformY)
//                self.messageBackView.transform = CGAffineTransformMakeTranslation(0, transformY)
            }else{
                
//                self.messageBackView.transform = CGAffineTransformMakeTranslation(0, transformY)
            }
            
            //             self.messageTextFied.transform = CGAffineTransformMakeTranslation(0, transformY)
            // 4.自动滚动表格到最后一行
            self.scrollViewToBottom()
        }
    }
//    //发信息按钮函数
//    @IBAction func sendMessageHX(sender: UIButton) {
//        
//        sender.enabled = false
////        self.sendMessageModel()
//        
//    }
    //发信息模型
    func sendMessageModel(text:String){
        self.sendTextMessage(text)
        //时间戳
        let createDate:NSDate = NSDate()
        let timeCuo = createDate.formattedTime()
        //给模型添加数据
        
        let messageModel = NewsDetailModel()
        messageModel.messageContent = text
        messageModel.hx_MessageOri = "me"
        messageModel.cellHeight = 0
        messageModel.uid = ""
        messageModel.userHeadIcon = ""
        messageModel.userName = ""
        messageModel.order_id = ""
        messageModel.message_type = "text_message"
        messageModel.messageTime = timeCuo
        messageModel.goodsUrl = ""
        messageModel.goodsImage = ""
        messageModel.goodsName = ""
        messageModel.noticePic = ""
        messageModel.noticeTitle = ""
        messageModel.noticeUrl = ""
        if messageModel.messageContent.isEmpty{
            
        }else{
            self.tableData1.append(messageModel)
        }
        //        self.tableData1.append(messageModel)
        self.tableView.reloadData()
        
        // 自动滚动表格到最后一行
        self.scrollViewToBottom()
        
        // 3.清空文字
//        self.messageTextFied.text = ""

    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        self.messageTextFied.resignFirstResponder()
    }
    
    // 自动滚动表格到最后一行
//    func HXScrollToRowAtIndex(){
//        
//        if self.tableData1.count > 0
//        {
//            let lastPath:NSIndexPath = NSIndexPath.init(forRow: self.tableData1.count-1, inSection: 0)
//            
//            self.tableView.scrollToRowAtIndexPath(lastPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
//        }
//        
//    }
    
    func scrollViewToBottom(){
        
        if (self.tableView.contentSize.height > self.tableView.frame.size.height)
        {
            let offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
            pprLog(offset)
            self.tableView.setContentOffset(offset, animated: true)
        }
        
    }
    
    func keyBoardHidden(){
        self.chatToolBar.endEditing(true)
    }
    
    // MARK: - pr
    func didChangeFrameToHeight(toHeight: CGFloat) {
        UIView.animateWithDuration(0.3) { () -> Void in
            var rect:CGRect = self.tableView.frame
            rect.origin.y = 0
            rect.size.height = self.view.frame.size.height - toHeight - 0
            self.tableView.frame = rect
        }
        self.scrollViewToBottom()
    }
    
    func didSendText(text: String!) {
        if !text.isEmpty{
//            self.sendTextMessage(text)
            self.sendMessageModel(text)
        }
    }
    
    func inputTextViewWillBeginEditing(messageInputTextView: XHMessageTextView!) {
        //文字要开始编辑的时候
    }
    
    // MARK: - block
    func toolBlock(){
        if self.chatToolBar.moreView.isKindOfClass(KLNewChatBarMoreView){
            let moreView:KLNewChatBarMoreView = self.chatToolBar.moreView as! KLNewChatBarMoreView
            moreView.photoButtonBlock = {(NewChatBarMoreView) -> () in
                print("照片")
                self.moreViewPhotoAction()
            }
            moreView.takePhotoButtonBlock = {(NewChatBarMoreView) -> () in
                print("拍照")
            }
            moreView.orderButtonBlock = {(NewChatBarMoreView) -> () in
                print("订单")
            }
        }
    }
    
    func moreViewPhotoAction(){
        
        self.keyBoardHidden();
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        self.imagePicker.mediaTypes = [kUTTypeImage as String]
        self.presentViewController(self.imagePicker, animated: true) { () -> Void in
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let orgImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismissViewControllerAnimated(true) { () -> Void in
        }
        self .sendImageMessage(orgImage)
    }
    
    func sendImageMessage(imageMessage:UIImage){
        let conversation = EaseMob.sharedInstance().chatManager.conversationForChatter!(self.HXID, isGroup: false)
        let tempMessage = ChatSendHelper.sendImageMessageWithImage(imageMessage, toUsername:conversation.chatter, isChatGroup: false, requireEncryption: false)
        self.addChatDataToMessage(tempMessage)
    }
    
    func addChatDataToMessage(message:EMMessage){
        self.tableDataTemp = []
        let weakSelf:NewsDetailViewController = self
        dispatch_async(messageQueue) { () -> Void in
            let messages = weakSelf.addChatToMessage(message)
            let indexPaths = NSMutableArray()
            
            for var i = 0; i < messages.count; i++ {
                let indexPath = NSIndexPath.init(forRow: weakSelf.tableData1.count+i, inSection: 0)
                indexPaths.addObject(indexPath)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                weakSelf.tableView.beginUpdates()
                
//                weakSelf.tableData1 + messages
                
            })
            
            
//            for (int i = 0; i < messages.count; i++) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count+i inSection:0];
//                //            [indexPaths insertObject:indexPath atIndex:0];
//                [indexPaths addObject:indexPath];
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.tableView beginUpdates];
//                [weakSelf.dataSource addObjectsFromArray:messages];
//                [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//                [weakSelf.tableView endUpdates];
//                
//                //            [weakSelf.tableView reloadData];
//                
//                [weakSelf.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                });
            
            
        }
    }
    
    func addChatToMessage(message:EMMessage) -> NSMutableArray{
        
        let ret = NSMutableArray()
        
        let createDate = NSDate.init(timeIntervalInMilliSecondSince1970: Double(message.timestamp))
        
        let tempDate = createDate.timeIntervalSinceDate(self.chatTagDate)
            ret.addObject(createDate.formattedTime())
            self.chatTagDate = createDate;
        ret.addObject(MessageModelManager.modelWithMessage(message))
        return ret;
    }
    
}








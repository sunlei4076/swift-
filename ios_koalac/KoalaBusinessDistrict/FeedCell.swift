//
//  FeedCell.swift
//  KoalaBusinessDistrict
//
//  Created by liuny on 15/8/24.
//  Copyright (c) 2015年 koalac. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell , UIAlertViewDelegate {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeAgaLabel: UILabel!
    @IBOutlet weak var addGoodsView: UIView!
    @IBOutlet weak var xiaoquLabel: UILabel!
    @IBOutlet weak var InfoLabel: KILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    var showAllBlock:((Int)->())?
    var index:Int = 0
    var cellData:FeedModel = FeedModel(){
        didSet{
            self.feedImageView.setImageWithURL(NSURL(string: self.cellData.avatar)!, placeholderImage: UIImage(named: "PlaceHolder"))
            self.nameLabel.text = self.cellData.user_name
            
            let date = NSDate(timeIntervalSince1970: (self.cellData.dateline as NSString).doubleValue)
            self.timeAgaLabel.text = date.timeAgoSinceNow()
            //            self.timeAgaLabel.text = GTimeSecondToSting(self.cellData.dateline, "yyyy-MM-dd")
            let distanceFloat = (self.cellData.distance as NSString).floatValue
            self.distanceLabel.text = String(stringInterpolationSegment: distanceFloat)+"km"
            if self.cellData.xiaoqu_name.isEmpty == false {
                self.xiaoquLabel.text = "·"+self.cellData.xiaoqu_name
            }
            self.InfoLabel.text = self.cellData.message
            if self.cellData.feed_type == "order"{
                self.addGoodsView.hidden = false
                self.xiaoquLabel.hidden = false
                self.refreshGoodViewForOrder()
            }else if self.cellData.feed_type == "text_feed"{
                self.addGoodsView.hidden = true
                self.xiaoquLabel.hidden = true
                self.refreshGoodViewForText()
                
            }else if self.cellData.feed_type == "add_notice"{
                self.addGoodsView.hidden = false
                self.xiaoquLabel.hidden = true
                self.refreshGoodViewForNotice()
            }else{
                
            }
        }
    }
    
    private func refreshGoodViewForNotice(){
        for item in self.addGoodsView.subviews{
            item.removeFromSuperview()
        }
        let goodView = FeedGoodView.instantiateFromNib()
        goodView.initData(self.cellData.notice_pic, title: self.cellData.notice_title, tapUrl: self.cellData.url, postStoreId: true)
        
        goodView.webViewType = self.cellData.webViewType
        
        goodView.translatesAutoresizingMaskIntoConstraints = false
        self.addGoodsView.addSubview(goodView)
        self.addWidth(-1, height: 60, view: goodView)
        self.setEdge(self.addGoodsView, view: goodView, edgeInset: UIEdgeInsetsMake(0, 0, 0, 0))
    }
    
    private func refreshGoodViewForText(){
        for item in self.addGoodsView.subviews{
            item.removeFromSuperview()
        }
        let label = UILabel()
        label.text = ""
        self.addGoodsView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.setEdge(self.addGoodsView, view: label, edgeInset: UIEdgeInsetsMake(0, 0, 0, 0))
        self.contentView.updateConstraintsIfNeeded()
        self.contentView.layoutIfNeeded()
    }
    
    private func refreshGoodViewForOrder(){
        for item in self.addGoodsView.subviews{
            item.removeFromSuperview()
        }
        
        var preItem:UIView?
        let hidenSame:Bool = self.cellData.goods_list.count > 3 && self.cellData.isShowAll == false
        let count = hidenSame ? 3 : self.cellData.goods_list.count
        
        for var i=0;i<count;i++ {
            let good = self.cellData.goods_list[i]
            let goodView = FeedGoodView.instantiateFromNib()
            let title = good.goods_name + "  x" + good.quantity
            goodView.initData(good.goods_image, title: title, tapUrl: good.good_url,postStoreId: false)
            goodView.translatesAutoresizingMaskIntoConstraints = false
            self.addGoodsView.addSubview(goodView)
            
            self.setEdge(self.addGoodsView, view: goodView, edgeInset: UIEdgeInsetsMake(-1, 0, -1, 0))
            self.addWidth(-1, height: 60, view: goodView)
            if preItem == nil{
                self.setEdge(self.addGoodsView, view: goodView, edgeInset: UIEdgeInsetsMake(0, -1, -1, -1))
            }else{
                self.addVerMargin(preItem!, bottomView: goodView, width: 1)
            }
            preItem = goodView
        }
        
        if (hidenSame){
            let showAllBtn:UIButton = UIButton(type:UIButtonType.Custom)
            showAllBtn.backgroundColor = GGetColor(58, g: 67, b: 86)
            showAllBtn.setTitle("显示全部", forState: UIControlState.Normal)
            showAllBtn.addTarget(self, action: Selector("showAllAction"), forControlEvents: UIControlEvents.TouchUpInside)
            showAllBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            showAllBtn.titleLabel?.font = GGetNormalCustomFont()
            self.addGoodsView.addSubview(showAllBtn)
            showAllBtn.translatesAutoresizingMaskIntoConstraints = false
            self.setEdge(self.addGoodsView, view: showAllBtn, edgeInset: UIEdgeInsetsMake(-1, 0, -1, 0))
            self.addVerMargin(preItem!, bottomView: showAllBtn, width: 1)
            self.addWidth(-1, height: 25, view: showAllBtn)
            preItem = showAllBtn
        }
        
        if preItem != nil{
            self.setEdge(self.addGoodsView, view: preItem!, edgeInset: UIEdgeInsetsMake(-1, -1, 0, -1))
        }
        
        self.contentView.updateConstraintsIfNeeded()
        self.contentView.layoutIfNeeded()
    }
    
    func showAllAction(){
        if self.showAllBlock != nil{
            self.showAllBlock!(self.index)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func initControl(){
        self.nameLabel.font = GGetNormalCustomFont()
        self.InfoLabel.font = GGetNormalCustomFont()
        self.xiaoquLabel.font = GGetNormalCustomFont()
        self.timeAgaLabel.font = GGetCustomFontWithSize(GNormalFontSize-3)
        self.distanceLabel.font = GGetCustomFontWithSize(GNormalFontSize-3)
        
        self.InfoLabel.numberOfLines = 0;
        
        //infoLabel自动识别@/URL/#
        //MARK: - 当面付优惠文字点击修改；
        self.InfoLabel.hashtagLinkTapHandler = {(label:KILabel, var str:String, range:NSRange)->Void in
            
            if   LoginInfoModel.sharedInstance.m_auth.isEmpty{
                // 判断是否登录,
                
                let app:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let rootVC = app.window?.rootViewController
                let loginVC = LoginViewController(nibName:"LoginViewController", bundle:nil)
                //更新登陆界面1202
                loginVC.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
                
                rootVC?.presentViewController(loginVC, animated: true, completion: nil)
                
            }else{
                //0:待审核，1：审核通过，2：已关闭， 3：注册成功但未提交店铺资料，4：审核不通过 -1：未开店
                
                if LoginInfoModel.sharedInstance.shopStatus == "3" ||   LoginInfoModel.sharedInstance.shopStatus == "-1" {
                    

                    //弹出提交店铺页面
                    let popover = OpenShopPopover.instantiateFromNib()
                    popover.show({ () -> () in
                        
                        
                        let register = RegisteriPhoneIdentifyController(nibName:"RegisteriPhoneIdentifyController", bundle:nil)
                        register.hidesBottomBarWhenPushed = true
                        let navVC = ProjectManager.sharedInstance.getTabSelectedNav()
                        navVC.pushViewController(register, animated: true)
                    })
                    
                } else if LoginInfoModel.sharedInstance.shopStatus == "0" {
                    let alert = UIAlertView(title: "提示", message: "亲，您的店铺正在审核中", delegate: self, cancelButtonTitle: "联系客服", otherButtonTitles: "我知道了")
                    alert.show()
                }else  if   LoginInfoModel.sharedInstance.shopStatus == "4"{
                    
                    let alert = UIAlertView(title: "提示", message: "店铺审核不通过", delegate: self, cancelButtonTitle: "重新申请", otherButtonTitles: "我知道了")
                    alert.show()
                    
                }else{
                    
                    if ProjectManager.sharedInstance.checkHasLogin() == true {
                        let urlStr = self.cellData.url
                        let urlSStrArray = self.cellData.urls
                        pprLog(urlSStrArray)
                        
                        var title = "商圈"
                        if self.cellData.feed_type == "order"{
                            title = self.cellData.store_name
                        }else if self.cellData.feed_type == "text_feed"{
                            str.removeAtIndex(str.startIndex)
                            str.removeAtIndex(str.endIndex.predecessor())
                            title = str
                            
                        }else if self.cellData.feed_type == "add_notice"{
                            title = self.cellData.notice_title
                        }else{
                            
                        }
                        
                        //完成2个url时的跳转；(过度的写法，为兼容旧版本使用的URL)
                        if urlSStrArray.isEmpty == false
                        {
                            var webJumpURL:String?
                            if str == "当面付" {
                                for item in urlSStrArray {
                                    if item is Dictionary<String,AnyObject>{
                                        let urlType = item["url_type"] as! String
                                        if urlType == "facepay_url" {
                                            webJumpURL = item["url"] as? String
                                        }
                                    }
                                }
                                
                                let webVC: WebViewController?
                                webVC = webHelper.openWebVC(str, jumpURL: webJumpURL!)
                                let selectNav = ProjectManager.sharedInstance.getTabSelectedNav()
                                selectNav.pushViewController(webVC!, animated: true)
                            }
                            else {
                                
                                for item in urlSStrArray {
                                    if item is Dictionary<String,AnyObject>{
                                        let urlType = item["url_type"] as! String
                                        if urlType != "facepay_url" {
                                            webJumpURL = item["url"] as? String
                                        }
                                    }
                                }
                                let webVC = WebViewController()
                                //                        webVC.webShareUrl = webJumpURL
                                webVC.webUrl = webJumpURL
                                webVC.title = title
                                // 后来添加
                                let request = NSMutableURLRequest(URL: NSURL(string: webVC.webUrl!)!)
                                //使用POST请求传参storeId
                                request.HTTPMethod = "POST"
                                let storeId = LoginInfoModel.sharedInstance.store.store_id
                                pprLog(storeId)
                                request.HTTPBody = "store_id=\(storeId)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                                webVC.webRequest = request
                                // 后来添加
                                
                                //                        webVC.webShareType = self.cellData.webViewType
                                webVC.hidesBottomBarWhenPushed = true
                                let selectNav = ProjectManager.sharedInstance.getTabSelectedNav()
                                selectNav.pushViewController(webVC, animated: true)
                            }
                            
                        }
                        else {
                            pprLog(str)
                            if urlStr.isEmpty == false && str != "当面付" {
                                let webVC = WebViewController()
                                webVC.webUrl = self.cellData.url
                                webVC.title = title
                                // 后来添加
                                let request = NSMutableURLRequest(URL: NSURL(string: webVC.webUrl!)!)
                                //使用POST请求传参storeId
                                request.HTTPMethod = "POST"
                                let storeId = LoginInfoModel.sharedInstance.store.store_id
                                pprLog(storeId)
                                request.HTTPBody = "store_id=\(storeId)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                                webVC.webRequest = request
                                
                                // 后来添加
                                
                                webVC.hidesBottomBarWhenPushed = true
                                let selectNav = ProjectManager.sharedInstance.getTabSelectedNav()
                                selectNav.pushViewController(webVC, animated: true)
                            }
                            else {
                                let webVC: WebViewController?
                                let webUrl = self.cellData.url
                                webVC = webHelper.openWebVC(str, jumpURL:webUrl)
                                let selectNav = ProjectManager.sharedInstance.getTabSelectedNav()
                                selectNav.pushViewController(webVC!, animated: true)
                            }
                        }
                    }
                }
                
            }
            
            let screenWidth = UIScreen.mainScreen().bounds.width
            self.InfoLabel.preferredMaxLayoutWidth = screenWidth - 8*2 - 50 - 15
        }
        

            }
            

    
    static func cellIdentifier()->String{
        return "FeedCell"
    }
    
    // MARK: - 设置约束
    //设置Autolayout中的边距辅助方法
    private func setEdge(superView:UIView, view:UIView, attr:NSLayoutAttribute, constant:CGFloat){
        let layoutCon = NSLayoutConstraint(item: view, attribute: attr, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: attr, multiplier: 1.0, constant: constant)
        superView.addConstraint(layoutCon)
    }
    
    //设置view相对于superview的约束，-1表示不设置
    private func setEdge(superView:UIView, view:UIView, edgeInset:UIEdgeInsets){
        if edgeInset.top != -1{
            self.setEdge(superView, view: view, attr: NSLayoutAttribute.Top, constant: edgeInset.top)
        }
        
        if edgeInset.left != -1{
            self.setEdge(superView, view: view, attr: NSLayoutAttribute.Left, constant: edgeInset.left)
        }
        
        if edgeInset.right != -1{
            self.setEdge(superView, view: view, attr: NSLayoutAttribute.Right, constant: -edgeInset.right)
        }
        
        if edgeInset.bottom != -1{
            self.setEdge(superView, view: view, attr: NSLayoutAttribute.Bottom, constant: -edgeInset.bottom)
        }
    }
    
    //垂直约束
    private func addVerMargin(topView:UIView, bottomView:UIView, width:CGFloat){
        let layoutCon = NSLayoutConstraint(item:bottomView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: width)
        topView.superview?.addConstraint(layoutCon)
    }
    
    //固定宽高
    private func addWidth(width:CGFloat, height:CGFloat, view:UIView){
        if width != -1{
            let layoutCon = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width)
            view.addConstraint(layoutCon)
        }
        
        if height != -1{
            let layoutCon = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: height)
            view.addConstraint(layoutCon)
        }
    }
    
    
    // MARK:- alertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        let buttonStr = alertView.buttonTitleAtIndex(buttonIndex)
        if buttonStr == "联系客服" {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://4000588577")!)
        }
        else if buttonStr == "重新申请"{
            let setShopInfo = SetShopInfoViewController(nibName:"SetShopInfoViewController", bundle:nil)
            setShopInfo.hidesBottomBarWhenPushed = true
//            self.navigationController!.pushViewController(setShopInfo, animated: true)
            let VC = ProjectManager.sharedInstance.getTabSelectedNav()
            
            VC.pushViewController(setShopInfo, animated: true)

            
        }
    }
}

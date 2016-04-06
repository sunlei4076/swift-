//
//  OrderDetailViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/18.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {
    @IBOutlet weak var remindBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var couponPay: UILabel!
    @IBOutlet weak var postage: UILabel!
    
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var faceToPay: UILabel!
    @IBOutlet weak var pointsPay: UILabel!
    @IBOutlet weak var realAmount: UILabel!
    
    @IBOutlet weak var showOrderNumLabel: UILabel!
    @IBOutlet weak var showOrderTimeLabel: UILabel!
    
    @IBOutlet weak var footerLabelView: UIView!
    @IBOutlet weak var footerButtonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableFooterView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var showPhoneLabel: UILabel!
    @IBOutlet weak var showAddressLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    
    
    var orderGoods:[GoodModel] = []
    var orderData:OrderModel = OrderModel()
    
    var goodModel:GoodModel = GoodModel()
    
    private var orderDataList:[OrderModel] = []
    private var is_select_goods:String = ""
    private var searchKeyword = ""
    private var requestDate:NSDate?
    private var currPage:Int = 0
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    
        self.is_select_goods = ProjectManager.sharedInstance.is_select_goods
        
        self.setForBottomBtn()
        let date:NSDate
        if self.requestDate == nil{
            date = NSDate()
        }else{
            date = self.requestDate!
        }
        NetworkManager.sharedInstance.requestOrderList(date, status: 2, keyword: self.searchKeyword, page: self.currPage, pageNum: 10, success: { (jsonDic:AnyObject) -> () in
            
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            
            if self.currPage == 0{
          
                self.orderDataList.removeAll(keepCapacity: true)

            }
            var  order:OrderModel?
            for item in listArray{
                
                if item is Dictionary<String, AnyObject>{
                     order = OrderModel(jsonDic: item as! Dictionary<String, AnyObject>)

                    self.orderDataList.append(order!)
                    
                }
                
            }
   
            
            self.tableView.reloadData()
            
            })  { (error:String, needRelogin:Bool) -> () in
                if self.currPage != 0{
                    self.currPage -= 1
                }
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        }
        
        ProjectManager.sharedInstance.orderID = self.orderData.order_id
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        
        let  cell = self.tableView.dequeueReusableCellWithIdentifier(OrderDetailCell.cellIdentifier(), forIndexPath: indexPath) as! OrderDetailCell
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.cellData = self.orderData.goods[indexPath.row]
        
        return cell
        
//        // 勾选过商品显示ShowOrderCell
        
//              let is_select_goods = ProjectManager.sharedInstance.is_select_goods
//        if (self.orderData.orderExtension as NSString).isEqualToString("secpay") && (self.orderData.status as NSString).isEqualToString("40") {
//            
//            let cell = self.tableView.dequeueReusableCellWithIdentifier(ShowOrderCell.cellIdentifier(), forIndexPath: indexPath) as! ShowOrderCell
//            
//            cell.selectionStyle = UITableViewCellSelectionStyle.None
//            
//            cell.cellData = self.orderData.goods[indexPath.row]
//            
//            return cell
//            
//        }
//        else if (self.orderData.orderExtension as NSString).isEqualToString("secpay") && (self.orderData.status as NSString).isEqualToString("30"){
//            
//            if (is_select_goods == "adobe" ){
//                
//                
//                
//                for model in self.orderDataList{
//                    
//                    
//                    pprLog(model.status)
//                    
//                    if self.is_select_goods == "adobe" && model.status == "30" && model.orderExtension == "secpay"{
//                        
//                        pprLog("++++++")
//                        
//                        
//                        self.orderData = model
//                    }
//                    
//                }
//                
//                
//                let cell = self.tableView.dequeueReusableCellWithIdentifier(ShowOrderCell.cellIdentifier(), forIndexPath: indexPath) as! ShowOrderCell
//                
//                cell.selectionStyle = UITableViewCellSelectionStyle.None
//
//                cell.cellData = self.orderData.goods[indexPath.row]
//
//            
//                return cell
//                
//            }else{
//                
//                let cell = self.tableView.dequeueReusableCellWithIdentifier(FaceOrderCell.cellIdentifier(), forIndexPath: indexPath) as! FaceOrderCell
//                
//                cell.selectionStyle = UITableViewCellSelectionStyle.None
//                
//                return cell
//            }
//        }
//            
//        else {
//            
//            let  cell = self.tableView.dequeueReusableCellWithIdentifier(OrderDetailCell.cellIdentifier(), forIndexPath: indexPath) as! OrderDetailCell
//            
//            
//            cell.selectionStyle = UITableViewCellSelectionStyle.None
//            
//            cell.cellData = self.orderData.goods[indexPath.row]
//            
//            return cell
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.initControl()
        self.initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initControl(){
        self.title = "详细信息"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.registerNib(UINib(nibName: "OrderDetailCell", bundle: nil), forCellReuseIdentifier: OrderDetailCell.cellIdentifier())
        self.tableView.tableFooterView = self.tableFooterView
        
        self.tableView.registerNib(UINib(nibName: "FaceOrderCell", bundle: nil), forCellReuseIdentifier: FaceOrderCell.cellIdentifier())
        
        
        self.tableView.registerNib(UINib(nibName: "ShowOrderCell", bundle: nil), forCellReuseIdentifier: ShowOrderCell.cellIdentifier())
        self.tableView.tableFooterView = self.tableFooterView
        
//        self.tableView.registerNib(UINib(nibName: "FaceOrderCell", bundle: nil), forCellReuseIdentifier: FaceOrderCell.cellIdentifier())
        
        //设置字体
        self.showNameLabel.font = GGetCustomFontWithSize(GBigFontSize+6.0)
        self.showAddressLabel.font = GGetNormalCustomFont()
        self.showPhoneLabel.font = GGetNormalCustomFont()
        self.showAddressLabel.numberOfLines = 0
        self.showNameLabel.numberOfLines = 0
        
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = GlobalGrayFontColor.CGColor
        
        self.footerLabelView.layer.borderWidth = 1.0
        self.footerLabelView.layer.borderColor = GlobalGrayFontColor.CGColor
        self.footerButtonView.layer.borderWidth = 1.0
        self.footerButtonView.layer.borderColor = GlobalGrayFontColor.CGColor
        
        GSetFontInView(self.footerLabelView, font: GGetCustomFontWithSize(GNormalFontSize - 1.0))
//        self.showTotalMoneyLabel.textColor = GlobalStyleFontColor

        self.remindBtn.layer.borderColor = GlobalStyleFontColor.CGColor
        self.remindBtn.layer.borderWidth = 1.0
        self.remindBtn.layer.cornerRadius = 2.0
        self.remindBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Normal)
        self.remindBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Disabled)
        self.remindBtn.titleLabel?.font = GGetNormalCustomFont()
        
        self.sendBtn.backgroundColor = GlobalStyleFontColor
        self.sendBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.sendBtn.setTitle("已发货", forState: UIControlState.Disabled)
        self.sendBtn.layer.cornerRadius = 2.0
        self.sendBtn.titleLabel?.font = GGetNormalCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        self.showNameLabel.text = self.orderData.user_name
        self.showPhoneLabel.text = "电话：" + self.orderData.user_mobile
        self.showAddressLabel.text = "地址：" + self.orderData.user_address
        
//        self.showTotalMoneyLabel.text = "￥" + self.orderData.total_money + "元"
//        if self.orderData.payType == "cod"{
//            self.showPayWayLabel.text = "支付方式：货到付款"
//        }else if self.orderData.payType == "lifeqcard"{
//            self.showPayWayLabel.text = "支付方式：考拉钱包"
//        }
        
        couponPay.text = "￥" + self.orderData.couponPay + "元"
        postage.text = "￥" + self.orderData.postage + "元"
        self.totalMoney.text = "￥" + self.orderData.total_money + "元"
        faceToPay.text = "-￥" + self.orderData.faceToPay + "元"
        pointsPay.text = "-￥" + self.orderData.pointsPay + "元"
        realAmount.text = "￥" + self.orderData.realAmount + "元"
        
        self.showOrderTimeLabel.text = "下单时间：" + GTimeSecondToSting(self.orderData.add_time, format: "yyyy-MM-dd")
        self.showOrderNumLabel.text = "订单号：" + self.orderData.order_sn
        self.setForBottomBtn()
    }
    
    private func setForBottomBtn(){
        self.remindBtn.hidden = false
        self.sendBtn.hidden = false
        self.footerButtonView.hidden = false
        
        let statusFloat = (self.orderData.status as NSString).floatValue
        if statusFloat == 17 || statusFloat == 18{
            //待退货
            self.remindBtn.enabled = true
            self.sendBtn.enabled = true
            self.remindBtn.layer.borderColor = GlobalStyleFontColor.CGColor
            self.remindBtn.setTitle("拒绝退货", forState: UIControlState.Normal)
            self.sendBtn.backgroundColor = GlobalStyleFontColor
            self.sendBtn.setTitle("确定退货", forState: UIControlState.Normal)
        }else if statusFloat == 20 || statusFloat == 10 || statusFloat == 11{
            //未发货
            self.remindBtn.enabled = true
            self.sendBtn.enabled = true
            self.remindBtn.layer.borderColor = GlobalStyleFontColor.CGColor
            self.remindBtn.setTitle("取消订单", forState: UIControlState.Normal)
            self.sendBtn.backgroundColor = GlobalStyleFontColor
            self.sendBtn.setTitle("确定发货", forState: UIControlState.Normal)
        }else if statusFloat == 40 || statusFloat == 30{
            //已发货
            self.remindBtn.hidden = true
            self.sendBtn.enabled = false
            let darkGray = GGetColor(191, g: 193, b: 194)
            self.sendBtn.backgroundColor = darkGray
            self.sendBtn.setTitle("已付款并取货", forState: UIControlState.Disabled)
        }else if statusFloat == 0{
            //已取消
            self.remindBtn.hidden = true
            self.sendBtn.hidden = true
            self.footerButtonView.hidden = true
        }else if statusFloat == 19 {

            self.sendBtn.hidden = true
            self.remindBtn.hidden = true
            self.footerButtonView.hidden = true
        }

//        else if statusFloat == 40{
//            //已发货 勾选过
//            self.remindBtn.hidden = true
//            self.sendBtn.enabled = false
//            let darkGray = GGetColor(191, g: 193, b: 194)
//            
//            if (self.orderData.orderExtension as NSString).isEqualToString("secpay"){
//                
//                self.sendBtn.backgroundColor = darkGray
//                self.sendBtn.setTitle("钱已到帐", forState: UIControlState.Disabled)
//            }else{
//                self.sendBtn.backgroundColor = darkGray
//                self.sendBtn.setTitle("已付款并取货", forState: UIControlState.Disabled)
//            }
// 
//        }else if  statusFloat == 30{
//            //已发货
//            self.remindBtn.hidden = true
//            self.sendBtn.enabled = false
//            let darkGray = GGetColor(191, g: 193, b: 194)
//           
//            if (self.orderData.orderExtension as NSString).isEqualToString("secpay"){
//                
//                let is_select_goods = ProjectManager.sharedInstance.is_select_goods
//                
//                if (is_select_goods == "adobe" ){// 勾选过
////                    self.sendBtn.backgroundColor = darkGray
//                    self.sendBtn.enabled = true
//                    self.sendBtn.backgroundColor = GlobalStyleFontColor
//                    self.sendBtn.setTitle("确认收款", forState: UIControlState.Normal)
//                    
//                }else{
//                    self.sendBtn.backgroundColor = darkGray
//                    self.sendBtn.setTitle("确认收款", forState: UIControlState.Disabled)
//                }
//                
//            }else{
//                self.sendBtn.backgroundColor = darkGray
//                self.sendBtn.setTitle("已付款并取货", forState: UIControlState.Disabled)
//            }
//        }else if statusFloat == 0{
//            //已取消
//            self.remindBtn.hidden = true
//            self.sendBtn.hidden = true
//            self.footerButtonView.hidden = true
//        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 60)
        view.backgroundColor = GlobalBgColor
        let label = UILabel()
        label.frame = CGRectMake(10, 0, 100, 30)
        label.text = "配送内容"
        label.font = GGetNormalCustomFont()
        label.backgroundColor = UIColor.clearColor()
        view.addSubview(label)
        
        let storeView = UIView()
        storeView.frame = CGRectMake(0, 30, screenWidth, 30)
        storeView.backgroundColor = UIColor.whiteColor()
        
        let storeLabel = UILabel()
        storeLabel.frame = CGRectMake(10, 5, screenWidth, 20)
        storeLabel.text = LoginInfoModel.sharedInstance.store.store_name
        storeLabel.font = GGetSmallCustomFont()
        storeView.addSubview(storeLabel)
        view.addSubview(storeView)
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
        return OrderDetailCell.CellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        return self.orderData.goods.count
 
    }
    
  
    @IBAction func actionFinishOrder(sender: AnyObject) {
        let statusFloat = (self.orderData.status as NSString).floatValue
        if statusFloat == 17 || statusFloat == 18{
            //待退货->确定退货
            let alert = UIAlertView(title: "提示", message: "是否确认退货？", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
            alert.show()
            
        }else if statusFloat == 20 || statusFloat == 10 || statusFloat == 11{
            //未发货->确定发货
            let alert = UIAlertView(title: "提示", message: "是否确认发货？", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
            alert.show()
        }
//        else if statusFloat == 30{
//            
//            NetworkManager.sharedInstance.requestFaceOrderConfirmreceipt(self.orderData.order_id, success: { (jsonDic:AnyObject) -> () in
//                
//                GShowAlertMessage("确认收货成功")
//                self.backAction()
//                
//                }) { (error:String, needRelogin:Bool) -> () in
//                    
//                    if needRelogin == true{
//                        
//                    }else{
//                        
//                        GShowAlertMessage(error)
//                    }
//            }
//        }

    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonStr = alertView.buttonTitleAtIndex(buttonIndex)
        if buttonStr == "确定"{
            let type:Int
            if alertView.message == "是否确认退货？"{
                type = 3
            }else if alertView.message == "是否确认发货？"{
                type = 1
            }else if alertView.message == "是否确认拒绝退货？"{
                type = 4
            }else if alertView.message == "是否确认取消订单？"{
                type = 2
            }else{
                type = 0
            }
            
            NetworkManager.sharedInstance.requestFinistOrder(type, orderId: self.orderData.order_id, success: { (jsonDic:AnyObject) -> () in
                self.sendBtn.enabled = false
                self.remindBtn.enabled = false
                self.navigationController?.popViewControllerAnimated(true)
                }, fail: { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                    
                    }else{
                        GShowAlertMessage(error)
                    }
            })
        }
    }
    
    @IBAction func actionShare(sender: AnyObject) {
        let statusFloat = (self.orderData.status as NSString).floatValue
        if statusFloat == 17 || statusFloat == 18{
            //待退货->拒绝退货
            let alert = UIAlertView(title: "提示", message: "是否确认拒绝退货？", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
            alert.show()
        }else if statusFloat == 20 || statusFloat == 10 || statusFloat == 11{
            //未发货->取消订单
            let alert = UIAlertView(title: "提示", message: "是否确认取消订单？", delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "取消")
            alert.show()
        }
        /*
        //判断是否安装微信
        if WXApi.isWXAppInstalled() == false{
            GShowAlertMessage("请先下载安装微信客户端！")
            return
        }
        
        var shareStr = "*配送信息*\n"
        shareStr += "收货人：\(self.orderData.user_name)\n"
        shareStr += "电话：\(self.orderData.user_mobile)\n"
        shareStr += "地址：\(self.orderData.user_address)\n"
        shareStr += "------------------\n"
        shareStr += "*商品信息*\n"
        for item in self.orderData.goods{
            shareStr += item.goods_name + "  x" + item.quantity + "\n"
        }
        shareStr += "------------------\n"
        let type:String
        if self.orderData.payType == "cod"{
            type = "支付方式：货到付款"
        }else if self.orderData.payType == "lifeqcard"{
            type = "支付方式：考拉钱包"
        }else{
            type = ""
        }
        shareStr += "总价：\(self.orderData.total_money)    \(type)"
        
        let req = SendMessageToWXReq()
        req.bText = true
        req.text = shareStr
        req.scene = Int32(WXSceneSession.rawValue);
        WXApi.sendReq(req)
        */
    }
    
    @IBAction func actionCallPhone(sender: AnyObject) {
        pprLog(self.orderData.user_mobile.characters.count)
        
        if self.orderData.user_mobile.characters.count >= 7 {
           pprLog(self.orderData.user_mobile)
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://"+self.orderData.user_mobile)!)
        }
        else {
            pprLog(self.orderData.user_mobile)
            
        }
    }
}

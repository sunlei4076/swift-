//
//  CustomerDetailViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/15.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class CustomerDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var mangerView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var attentionBtn: UIButton!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var showPhoneLabel: UILabel!
    @IBOutlet weak var showAddressLabel: UILabel!
    @IBOutlet weak var showNameLabel: UILabel!
    @IBOutlet weak var tableHeadView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var customerData:CustomerModel = CustomerModel()
    var orderList:[CustomerOrderModel] = []

    var uid:String = ""
    var address:String = ""
    var tel:String = ""
    var name:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControl()
        self.initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //客户分析
    @IBAction func btnClick() {
        

        pprLog(customerData.uid)
    
        let webVC = WebViewController()
        webVC.title = "客户分析"
        let store_id = LoginInfoModel.sharedInstance.store.store_id
        webVC.webUrl = NetworkManager.sharedInstance.baseUrl + "/mall/index.php?app=store_business&store_id=\(store_id)&user_id=\(customerData.uid)"
        
        webVC.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(webVC, animated: true)
        
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
        self.tableView.registerNib(UINib(nibName: "CustomOrderCell", bundle: nil), forCellReuseIdentifier: CustomOrderCell.cellIdentifier())
        
        //设置字体
        self.showNameLabel.font = GGetCustomFontWithSize(GBigFontSize+6.0)
        self.showAddressLabel.font = GGetNormalCustomFont()
        self.showPhoneLabel.font = GGetNormalCustomFont()
        self.sendMessageBtn.titleLabel?.font = GGetBigCustomFont()
        self.attentionBtn.titleLabel?.font = GGetBigCustomFont()
        
        self.attentionBtn.layer.borderColor = GlobalStyleFontColor.CGColor
        self.attentionBtn.layer.borderWidth = 1.0
        self.attentionBtn.layer.cornerRadius = 2.0
        self.attentionBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Normal)
        self.attentionBtn.titleLabel?.font = GGetNormalCustomFont()
        
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = GlobalGrayFontColor.CGColor
        
        self.mangerView.layer.borderWidth = 1.0
        self.mangerView.layer.borderColor = GlobalGrayFontColor.CGColor
        self.sendMessageBtn.backgroundColor = GlobalStyleFontColor
        self.sendMessageBtn.layer.cornerRadius = 2.0
        self.sendMessageBtn.titleLabel?.font = GGetNormalCustomFont()
    }
    
    func backAction(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func initData(){
        self.showNameLabel.text = self.customerData.name.isEmpty ? self.name : self.customerData.name
        self.showAddressLabel.text = "地址：" + (self.customerData.address.isEmpty ? self.address: self.customerData.address )
        self.showPhoneLabel.text = "电话：" + (self.customerData.tel.isEmpty ? self.tel:self.customerData.tel)
        
        let attention = (self.customerData.attention as NSString).floatValue
        if attention == 1{
            self.attentionBtn.setTitle(" 取消关注", forState: UIControlState.Normal)
        }else{
            self.attentionBtn.setTitle(" 特别关注", forState: UIControlState.Normal)
        }
        
        //获取用户详情
        NetworkManager.sharedInstance.requestCustomDetail(self.customerData.uid, success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            self.uid = JsonDicHelper.getJsonDicValue(objDic, key: "uid")
            self.address = JsonDicHelper.getJsonDicValue(objDic, key: "address")
            self.tel = JsonDicHelper.getJsonDicValue(objDic, key: "tel")
            self.name = JsonDicHelper.getJsonDicValue(objDic, key: "name")
            self.showNameLabel.text = self.customerData.name.isEmpty ? self.name : self.customerData.name
            self.showAddressLabel.text = "地址：" + (self.customerData.address.isEmpty ? self.address: self.customerData.address )
            self.showPhoneLabel.text = "电话：" + (self.customerData.tel.isEmpty ? self.tel:self.customerData.tel)

            let ordersArray = JsonDicHelper.getJsonDicArray(objDic, key: "orders")
            for item in ordersArray{
                if item is Dictionary<String, AnyObject>{
                    let order = CustomerOrderModel(jsonDic: item as! Dictionary<String,AnyObject>, name: self.customerData.name)
                    self.orderList.append(order)
                    

                }
            }
            

         
            
            self.tableView.reloadData()
            if(self.orderList.count < 0){
                GShowAlertMessage("无数据！")
            }

            }) { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                
                }else{
                    GShowAlertMessage(error)
                }
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let goodList = self.orderList[indexPath.row].orderList
        let goodCount:CGFloat = CGFloat(goodList.count)
        let height = CustomOrderCell.cellHeight() + OrderGoodView.viewHeight()*goodCount
        return height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CustomOrderCell.cellIdentifier(), forIndexPath: indexPath) as! CustomOrderCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.orderData = self.orderList[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 30)
        view.backgroundColor = GlobalBgColor
        let label = UILabel()
        label.frame = CGRectMake(10, 0, 100, 30)
        label.text = "订单内容"
        label.font = GGetNormalCustomFont()
        label.backgroundColor = UIColor.clearColor()
        view.addSubview(label)
        return view
    }
    
    @IBAction func actionSendMessage(sender: AnyObject) {

//        let vc = ProjectManager.sharedInstance.getRootTab()
//        vc.selectedIndex  = 0
        var flagVC:String = ""
        for vc1:UIViewController in (self.navigationController!.viewControllers){
            if vc1.isKindOfClass(NewsDetailViewController){
                flagVC = "1"
                self.navigationController?.popViewControllerAnimated(true)
                break
            }else{
                flagVC = "2"
            }
        }
        if flagVC == "2" {
//             let newsDetailVC = NewsDetailViewController(nibName:"NewsDetailViewController",bundle:nil)
            let newsDetailVC = NewsDetailViewController()
            newsDetailVC.HXID = "lq_" + self.customerData.uid
            newsDetailVC.userName = self.customerData.name.isEmpty ? self.name : self.customerData.name
            self.navigationController?.pushViewController(newsDetailVC, animated: true)
        }
    }
    
    @IBAction func actionAttention(sender: AnyObject) {
        //关注
        let attention = (self.customerData.attention as NSString).floatValue
        let attentionType = attention==1 ? false:true
        NetworkManager.sharedInstance.requestAttentionCustomer(attentionType, uid: self.customerData.uid, success: { (jsonDic:AnyObject) -> () in
            if attentionType == true{
                self.attentionBtn.setTitle(" 取消关注", forState: UIControlState.Normal)
                GShowAlertMessage("关注成功")
            }else{
                self.attentionBtn.setTitle(" 特别关注", forState: UIControlState.Normal)
                GShowAlertMessage("已取消关注")
            }
            }) { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                
                }else{
                    GShowAlertMessage(error)
                }
        }
    }
}

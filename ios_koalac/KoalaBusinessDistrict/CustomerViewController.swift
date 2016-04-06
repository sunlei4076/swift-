//
//  CustomerViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/13.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class CustomerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate , UIAlertViewDelegate{
    
    @IBOutlet weak var changeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionMoneyNumBtn: UIButton!
    @IBOutlet weak var optionOrderNumBtn: UIButton!
    @IBOutlet var searchKeyboardInputView: UIView!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var arrowView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var inputSearchTextField: UITextField!
    @IBOutlet weak var topView: UIView!
    
    var imageBView:UIImageView = UIImageView()
    let lalBack:UILabel = UILabel()
    
    var customerList:[CustomerModel] = []
    private var inSearch:Bool = false
    private var searchList:[CustomerModel] = []
    
    
    var currPage:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.header = MJRefreshNormalHeader(){
            self.currPage = 0
            self.initData()
        }
        
        self.addFootRefresh()
        self.currPage = 0
        self.initData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notificationFunction"), name: "ChangeLogin", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("notifiChangeStoreStatus"), name: "ChangeStoreStatus", object: nil)
        self.initControl()
        
    }
    
    private func endRefresh(){
        if self.tableView.footer.isRefreshing(){
            self.tableView.footer.endRefreshing()
        }
        if self.tableView.header.isRefreshing(){
            self.tableView.header.endRefreshing()
        }
    }
    
    private func addFootRefresh(){
        self.tableView.footer = MJRefreshAutoNormalFooter(){
            self.currPage += 1
             self.initData()
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.initData()
    }
    
    private func initControl(){
        
         GNavgationStyle(self.navigationController!.navigationBar)
        let rightBtn = self.rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        //
        let imageBack = UIImage.init(named: "CRM_backgroundP")
        self.imageBView = UIImageView.init(image: imageBack)
        self.imageBView.center = CGPointMake(self.view.center.x, self.view.center.y - 100)
        self.lalBack.textAlignment = NSTextAlignment.Center
        self.lalBack.textColor = UIColor.init(red: 148.0/255, green: 148.0/255, blue: 148.0/255, alpha: 1)
        self.lalBack.text = "还没有客户噢～试试推广店铺吧！"
        let lalBackY = CGRectGetMaxY(self.imageBView.frame)
        self.lalBack.frame = CGRectMake(0, lalBackY, screenWidth, 70)
        
        self.view.addSubview(self.imageBView)
        self.view.addSubview(self.lalBack)
        
        self.view.backgroundColor = GlobalBgColor
        self.tableView.backgroundColor = GlobalBgColor
        self.tableView.registerNib(UINib(nibName: "CustomerCell", bundle: nil), forCellReuseIdentifier: CustomerCell.cellIdentifier())
        
        //设置字体
        GSetFontInView(self.topView, font: GGetNormalCustomFont())
        self.searchView.layer.borderColor = GlobalGrayFontColor.CGColor
        self.searchView.layer.borderWidth = 1.0
        self.searchView.layer.cornerRadius = 2.0
        
        self.optionView.hidden = true
        self.optionView.backgroundColor = GlobalBgColor
        self.optionMoneyNumBtn.titleLabel?.font = GGetNormalCustomFont()
        self.optionOrderNumBtn.titleLabel?.font = GGetNormalCustomFont()
        self.optionMoneyNumBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Selected)
        self.optionOrderNumBtn.setTitleColor(GlobalStyleFontColor, forState: UIControlState.Selected)
        
//        self.inputSearchTextField.inputAccessoryView = self.searchView
//        self.inputSearchTextField.inputAccessoryView = self.searchKeyboardInputView
        //当用户输入中文的时候，delegate中的参数string只是字母，而不是中文。也就是:当你输入zhang(张)的时候，它记录的分别是z h a n g.所以，对于中文的话，也就无法动态获取了。解决的办法就是给textfield加个状态监听器
        self.inputSearchTextField.addTarget(self, action: Selector("textFieldEditChanged:"), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textFieldEditChanged(textField: UITextField)
    {
        let searchText = textField.text
        if searchText?.characters.count == 0{
            self.inSearch = false
        }else{
            self.inSearch = true
            self.searchList.removeAll(keepCapacity: true)
            //精确搜索
            for item in self.customerList{
                if (item.name.rangeOfString(searchText!) != nil) {
                    self.searchList.append(item)
                }
            }
            //拼音搜索
            if self.searchList.count == 0{
                for item in self.customerList{
                    let cityPinyin = PinYinForObjc.chineseConvertToPinYin(item.name).uppercaseString
                    if (cityPinyin.rangeOfString(searchText!.uppercaseString) != nil) {
                        self.searchList.append(item)
                    }
                }
            }
            //首字母搜索
            if self.searchList.count == 0{
                for item in self.customerList{
                    let cityPinyin = PinYinForObjc .chineseConvertToPinYinHead(item.name).uppercaseString
                    if (cityPinyin.rangeOfString(searchText!.uppercaseString) != nil) {
                        self.searchList.append(item)
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func notificationFunction(){
        let rightBtn =  rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
//        
//        if LoginInfoModel.sharedInstance.m_auth.isEmpty == false{
//            self.currPage = 0
////            self.initData("n")
//        }
    }
    
    func notifiChangeStoreStatus(){
        let rightBtn =  rightBtnItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    func rightBtnItem() -> UIButton {
        let rightBtn:UIButton = UIButton(type:UIButtonType.Custom)
        var rightBtnTitle: String?
        if LoginInfoModel.sharedInstance.shopStatus == "1" || LoginInfoModel.sharedInstance.shopStatus == "0" {
            rightBtnTitle =  "推广"
        }
        else {
            rightBtnTitle =  "开店"
        }
        rightBtn.setTitle(rightBtnTitle, forState: UIControlState.Normal)
        rightBtn.titleLabel?.font = GGetNormalCustomFont()
        rightBtn.frame = CGRectMake(0, 0, 40, 30)
        rightBtn.addTarget(self, action: Selector("shareAction"), forControlEvents: UIControlEvents.TouchUpInside)
        return rightBtn
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
            self.navigationController!.pushViewController(setShopInfo, animated: true)
            
        }
    }
    
    
    //0:待审核，1：审核通过，2：已关闭， 3：注册成功但未提交店铺资料，4：审核不通过 -1：未开店
    func shareAction(){
        if LoginInfoModel.sharedInstance.shopStatus == "1"
        {
            let shareView = ShareView.instantiateFromNib()
            shareView.show()
            
        }
        else if LoginInfoModel.sharedInstance.shopStatus == "0" {
            let alert = UIAlertView(title: "提示", message: "亲，您的店铺正在审核中", delegate: self, cancelButtonTitle: "联系客服", otherButtonTitles: "我知道了")
            alert.show()
        }
        else if LoginInfoModel.sharedInstance.shopStatus == "4" {
            let alert = UIAlertView(title: "提示", message: "店铺审核不通过", delegate: self, cancelButtonTitle: "重新申请", otherButtonTitles: "我知道了")
            alert.show()
        }
        else  if LoginInfoModel.sharedInstance.shopStatus == "-1" {
            
            // 如果没有帐号 LoginInfoModel.sharedInstance.m_auth
            if LoginInfoModel.sharedInstance.m_auth.isEmpty{
                
                let login =  LoginViewController(nibName:"LoginViewController", bundle:nil)
                login.hidesBottomBarWhenPushed = true
                login.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
                self.presentViewController(login, animated: true, completion: nil)
                
            }else{
                
                let register = RegisteriPhoneIdentifyController(nibName:"RegisteriPhoneIdentifyController", bundle:nil)
                register.hidesBottomBarWhenPushed = true
                self.navigationController!.pushViewController(register, animated: true)
            }
            
        }else{
            
            let login =  LoginViewController(nibName:"LoginViewController", bundle:nil)
            login.hidesBottomBarWhenPushed = true
            login.view.backgroundColor = UIColor(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.6)
            self.presentViewController(login, animated: true, completion: nil)
        }
    }

    
    internal func initData(){

        
        //        获取客户列表
        NetworkManager.sharedInstance.requestCustomerListPage("",page: self.currPage, success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            if self.currPage == 0{
                self.customerList.removeAll(keepCapacity: true)
                
            }
            
            for item in listArray{
                if item is Dictionary<String,AnyObject>{
                    let customer = CustomerModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.customerList.append(customer)
                }
                
            }
            //1.回调主动发头像图片
            let vcT = ProjectManager.sharedInstance.getRootTab()
            for vc:UIViewController in (vcT.viewControllers![0] as! UINavigationController).viewControllers{
                if vc.isKindOfClass(NewsViewController){
                    let aaa = vc as! NewsViewController
                    if aaa.headIconImageBlock != nil {
                        aaa.headIconImageBlock!(imageURLList: self.customerList)
                        break
                    }
                    
                }
            }
            
            if self.customerList.count == 0{
                GShowAlertMessage("赶快分享店铺给您的好友吧！")
                self.imageBView.hidden = false
                self.lalBack.hidden = false
                
                
            }else {
                self.imageBView.hidden = true
                self.lalBack.hidden = true
            }
            
            if listArray.count < 10{
                
                self.tableView.footer.endRefreshingWithNoMoreData()
                
            }
                
            else{
                self.tableView.footer.resetNoMoreData()
            }
            self.endRefresh()
            self.tableView.reloadData()
            
        
            }) { (error:String, needRelogin:Bool) -> () in
                if self.currPage != 0{
                    self.currPage -= 1
                }
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        }
    }
    
    private func showOptionView(){
        if self.optionView.hidden == false{
            return
        }
        self.optionView.hidden = false
        self.changeTopConstraint.constant = 100
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            //箭头动画
            self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI*1.0))
            //table动画
            self.tableView.layoutIfNeeded()
        })
    }
    
    private func hideOptionView(){
        if self.optionView.hidden == true{
            return
        }
        self.changeTopConstraint.constant = 0
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            //箭头动画
            self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI*0.0))
            //table动画
            self.tableView.layoutIfNeeded()
            }) { (flag:Bool) -> Void in
                self.optionView.hidden = true
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.inputSearchTextField.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CustomerCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.inSearch == true{
            return self.searchList.count
        }else{
            return self.customerList.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(CustomerCell.cellIdentifier(), forIndexPath: indexPath) as! CustomerCell
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        if self.inSearch == true{
            cell.customerData = self.searchList[indexPath.row]
        }else{
            
            cell.customerData = self.customerList[indexPath.row]
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let customerDetailVC = CustomerDetailViewController(nibName:"CustomerDetailViewController", bundle:nil)
        if self.inSearch == true{
            customerDetailVC.customerData = self.searchList[indexPath.row]
        }else{
            customerDetailVC.customerData = self.customerList[indexPath.row]
        }

        customerDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(customerDetailVC, animated: true)
    }
    @IBAction func actionCancelSearch(sender: AnyObject) {
        self.inSearch = false
        self.inputSearchTextField.resignFirstResponder()
        self.inputSearchTextField.text = ""
        self.searchList.removeAll(keepCapacity: true)
        self.tableView.reloadData()
    }
    @IBAction func actionOkSearch(sender: AnyObject) {
        self.inputSearchTextField.resignFirstResponder()
    }
    @IBAction func actionShaiXuan(sender: AnyObject) {
        if self.optionView.hidden == true{
            self.showOptionView()
        }else{
            self.hideOptionView()
        }
    }
    @IBAction func actionOrderNumSort(sender: AnyObject) {
        self.customerList.sortInPlace { (itemOne:CustomerModel, itemTwo:CustomerModel) -> Bool in
            let orderOne = (itemOne.order_total as NSString).floatValue
            let orderTwo = (itemTwo.order_total as NSString).floatValue
            return orderOne > orderTwo
        }
        self.optionOrderNumBtn.selected = true
        self.optionMoneyNumBtn.selected = false
        self.hideOptionView()
        self.tableView.reloadData()
    }
    @IBAction func actionMoneyNumSort(sender: AnyObject) {
        self.customerList.sortInPlace { (itemOne:CustomerModel, itemTwo:CustomerModel) -> Bool in
            let moneyOne = (itemOne.money_total as NSString).floatValue
            let moneyTwo = (itemTwo.money_total as NSString).floatValue
            return moneyOne > moneyTwo
        }
        self.optionOrderNumBtn.selected = false
        self.optionMoneyNumBtn.selected = true
        self.hideOptionView()
        self.tableView.reloadData()
    }

    func dataList(){
        NetworkManager.sharedInstance.requestCustomerListPage("",page: self.currPage, success: { (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")

            if self.currPage == 0{
                self.customerList.removeAll(keepCapacity: true)
            }


            for item in listArray{
                if item is Dictionary<String,AnyObject>{
                    let customer = CustomerModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.customerList.append(customer)
                }
                
            }
            //1.回调主动发头像图片
            let vcT = ProjectManager.sharedInstance.getRootTab()
            for vc:UIViewController in (vcT.viewControllers![0] as! UINavigationController).viewControllers{
                if vc.isKindOfClass(NewsViewController){
                    let aaa = vc as! NewsViewController
                    if aaa.headIconImageBlock != nil {
                        aaa.headIconImageBlock!(imageURLList: self.customerList)
                        break
                    }
                    
                }
            }
            
            }) { (error:String, needRelogin:Bool) -> () in
                
        }
        
    }
}

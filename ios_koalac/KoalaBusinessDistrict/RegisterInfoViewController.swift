//
//  RegisterInfoViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/9. 
//  Copyright (c) 2015年 考拉先生. All rights reserved.
// ,RegisteriPhoneNumbDelegate

import UIKit

class RegisterInfoViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIKeyboardViewControllerDelegate ,UIAlertViewDelegate{
    var registeriPhoneIdentifyCer: RegisteriPhoneIdentifyController?
    
    @IBOutlet weak var cardImageAddBtn:UIButton?
    @IBOutlet weak var cardImageAddSuperView: UIView!
    @IBOutlet weak var cardUploadTipLabel: UILabel!
    @IBOutlet weak var headUploadTipLabel: UILabel!
//    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var headIconSetBtn: UIButton!
    @IBOutlet weak var inputShopName: UITextField!
    @IBOutlet weak var inputAddress: UITextField!
    @IBOutlet weak var showSelectProvinces: UILabel!
//    @IBOutlet weak var showSelectAddress: UILabel!
//    @IBOutlet weak var inputPhone: UITextField!
    
    @IBOutlet weak var recommendInfo: UITextField!
    
    @IBOutlet weak var showSelectShopType: UILabel!
    
    @IBOutlet weak var showSelectCoverRange: UILabel!
    var registerAccount:RegisterModel = RegisterModel()
    private var shopTypeList:[(cateId:String,cateName:String)] = []
    private var selectedShopTypeIndex:Int?
    
    private var coverRangeList:[String] = ["3","5","10"]
    private var selectedCoverRangeIndex:Int?
    
    //标识设置图片
    private var addImageType:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initControl()
        self.initData()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.keyboard.boardDelegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.keyboard.boardDelegate = nil
    }
    
    private func initControl(){
        self.title = "注册店铺"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        //提交；
        let commitBtn:UIButton = UIButton(type:UIButtonType.Custom)
        commitBtn.setTitle("提交", forState: UIControlState.Normal)
        commitBtn.frame = CGRectMake(0, 0, 40, 30)
        commitBtn.addTarget(self, action: Selector("actionNext"), forControlEvents: UIControlEvents.TouchUpInside)
        commitBtn.titleLabel?.font = GGetBigCustomFont()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: commitBtn)
        
        self.view.backgroundColor = GlobalBgColor
          
        self.showSelectShopType.text = "请选择类型"
        
        //设置字体
        GSetFontInView(self.view, font: GGetNormalCustomFont())
//        self.nextBtn.titleLabel!.font = GGetCustomFontWithSize(GBigFontSize)
        self.headUploadTipLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        self.cardUploadTipLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        self.showSelectProvinces.numberOfLines = 0
//        self.showSelectAddress.numberOfLines = 0
        
        if self.cardImageAddBtn == nil{
            let button:UIButton = UIButton(type:UIButtonType.Custom)
            button.frame = CGRectMake(20, CGRectGetMaxY(self.cardUploadTipLabel.frame)+8, 63.0, 63.0)
            button.setBackgroundImage(UIImage(named: "Register_SetHeadIcon"), forState: UIControlState.Normal)
            button.tag = 0
            button.addTarget(self, action: Selector("actionSelectCardPhoto:"), forControlEvents: UIControlEvents.TouchUpInside)
            self.cardImageAddSuperView.addSubview(button)
            self.cardImageAddBtn = button
        }
    }
    
    func backAction(){
        let alert = UIAlertView(title: "提示", message: "亲，还差几步你就完成开店咯", delegate: self, cancelButtonTitle: "继续", otherButtonTitles: "退出")
        alert.show()
    }
    
    private func initData(){
        
//        self.inputPhone.text = self.registerAccount.tel
//        pprLog(message: "\(self.registerAccount.tel)")
//        self.inputPhone.enabled = false
        
        //获取商铺分类
        NetworkManager.sharedInstance.requestGetShopTypeList({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            for item in listArray{
                if item is Dictionary<String,AnyObject>{
                    let cateId = JsonDicHelper.getJsonDicValue(item as! Dictionary<String,AnyObject>, key: "cate_id")
                    let cateName = JsonDicHelper.getJsonDicValue(item as! Dictionary<String,AnyObject>, key: "cate_name")
                    self.shopTypeList.append((cateId: cateId, cateName: cateName))
                }
            }
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                
                }else{
                    GShowAlertMessage(error)
                }
        })
        
        
        //定位
        LocateTool.shareInstance().startLocationWithReverse(true, success: { (result:BMKReverseGeoCodeResult!, location:BMKUserLocation!) -> Void in
            self.registerAccount.province = result.addressDetail.province
            self.registerAccount.city = result.addressDetail.city
            self.registerAccount.area = result.addressDetail.district
            self.showSelectProvinces.text = self.registerAccount.province + self.registerAccount.city + self.registerAccount.area
            self.registerAccount.address = result.address
            self.registerAccount.lat = String(stringInterpolationSegment: result.location.latitude)
            self.registerAccount.lng = String(stringInterpolationSegment: result.location.longitude)
            self.inputAddress.text = self.registerAccount.address
        }) { () -> Void in
            GShowAlertMessage("请允许定位服务！")
        }
    }
    
    private func showActionSheetToAddPhoto(){
//        self.inputPhone.resignFirstResponder()
        self.inputShopName.resignFirstResponder()
        self.inputAddress.resignFirstResponder()

        let actionSheet:UIActionSheet
        
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            //支持拍照
            actionSheet = UIActionSheet(title: "选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "从相册选择")
        }else{
            //不支持拍照
            actionSheet = UIActionSheet(title: "选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "从相册选择")
        }
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        
        let selectStr = actionSheet.buttonTitleAtIndex(buttonIndex)
        let sourceType:UIImagePickerControllerSourceType
        if(selectStr == "从相册选择"){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }else if(selectStr == "拍照"){
            sourceType = UIImagePickerControllerSourceType.Camera
        }else{
            return
        }
        // 跳转到相机或相册页面
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image: AnyObject = info[UIImagePickerControllerEditedImage]{
            if self.addImageType == 1{
                //设置头像
                let smallImage = GFitSmallImage((image as? UIImage)!, wantSize: CGSizeMake(200.0, 200.0), fitScale: true)
                self.headIconSetBtn.setImage(smallImage, forState: UIControlState.Normal)
                self.headIconSetBtn.tag += 1
            }else if self.addImageType == 2{
                //上传身份证照片
                let smallImage = GFitSmallImage((image as! UIImage), wantSize: CGSizeMake(200.0, 200.0), fitScale: true)
                
                pprLog("\(smallImage)")
                let imageView = UIImageView(image: smallImage)
                imageView.frame = self.cardImageAddBtn!.frame
                self.cardImageAddSuperView.addSubview(imageView)
                var frame = self.cardImageAddBtn!.frame
                frame.origin.x += (frame.size.width + 8.0)
                self.cardImageAddBtn!.frame = frame
                self.cardImageAddBtn!.tag += 1
                if self.cardImageAddBtn!.tag >= 2{
                    self.cardImageAddBtn!.hidden = true
                }
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionSetHeadIcon(sender: AnyObject) {
        self.addImageType = 1
        self.showActionSheetToAddPhoto()
    }
    @IBAction func actionSelectProvinces(sender: AnyObject) {
        self.inputShopName.resignFirstResponder()
//        self.inputPhone.resignFirstResponder()
        
        let popoverProvince = PopoverAreaSelectView.instantiateFromNib()
        let window = UIApplication.sharedApplication().keyWindow
        popoverProvince.show(window!, title: "选择你的省市区") { (selectString, provinceStr, cityStr, areaStr) -> () in
            self.registerAccount.province = provinceStr
            self.registerAccount.city = cityStr
            self.registerAccount.area = areaStr
            self.showSelectProvinces.text = selectString
        }
    }

    @IBAction func actionSelectShopType(sender: AnyObject) {
//        self.inputPhone.resignFirstResponder()
        self.inputShopName.resignFirstResponder()
        self.inputAddress.resignFirstResponder()
        
        let popoverSelect = PopoverSelectView.instantiateFromNib()
        
        //元组数组转换成字符数组
        var temArray:[String] = [];
        for item in self.shopTypeList{
            temArray.append(item.1)
        }
        
        //默认选中上次选择，无上次选择，则选中第一行
        let selectIndex:Int
        if self.selectedShopTypeIndex == nil{
            selectIndex = 0
        }else{
            selectIndex = self.selectedShopTypeIndex!
        }
        let window = UIApplication.sharedApplication().keyWindow
        
        popoverSelect.show(window!, title: "选择类型", data: temArray, defaultSelect: selectIndex, selectedDone: { (selectIndex, selectString) -> () in
            self.selectedShopTypeIndex = selectIndex
            self.showSelectShopType.text = selectString
        })
    }
    
    
    @IBAction func actionSelectCoverRange(sender: AnyObject) {
//        self.inputPhone.resignFirstResponder()
        self.inputShopName.resignFirstResponder()
        self.inputAddress.resignFirstResponder()
        
        let popoverSelect = PopoverSelectView.instantiateFromNib()
        
        let temArray:[String] = ["3公里","5公里","10公里"];
        
        //默认选中上次选择，无上次选择，则选中第一行
        let selectIndex:Int
        if self.selectedCoverRangeIndex != nil{
            selectIndex = self.selectedCoverRangeIndex!
        }else{
            selectIndex = 0
        }
        let window = UIApplication.sharedApplication().keyWindow
        
        popoverSelect.show(window!, title: "选择覆盖范围", data: temArray, defaultSelect: selectIndex, selectedDone: { (selectIndex, selectString) -> () in
            self.selectedCoverRangeIndex = selectIndex
            self.showSelectCoverRange.text = selectString
            self.registerAccount.radius = self.coverRangeList[selectIndex]
        })
    }
    
    @IBAction func actionSelectCardPhoto(sender: AnyObject) {
        self.addImageType = 2
        self.showActionSheetToAddPhoto()
    }
    
    func actionNext() {
        let store_name = self.inputShopName.text
       
        if store_name!.isEmpty{
            GShowAlertMessage("店铺名称不能为空！")
            return
        }
        self.registerAccount.stroe_name = store_name!
        self.registerAccount.real_name = store_name!
        
//        let address = self.inputAddress.text
        if self.inputAddress.text!.isEmpty {
            GShowAlertMessage("店铺地址不能为空！")
            return
        }
        self.registerAccount.address = self.inputAddress.text!
        
        pprLog(self.registerAccount.tel)
        //推荐人；
        self.registerAccount.recommendInfo = self.recommendInfo.text!
        
        if self.selectedShopTypeIndex == nil{
            GShowAlertMessage("请选择店铺类型！")
            return
        }
        self.registerAccount.cate_id = self.shopTypeList[self.selectedShopTypeIndex!].cateId
        
        if self.registerAccount.radius.isEmpty{
            GShowAlertMessage("请选择覆盖范围！")
            return
        }
        
        
        if self.headIconSetBtn.tag == 0{
            GShowAlertMessage("您还没有选择头像！")
            return
        }
        self.registerAccount.headIcon = self.headIconSetBtn.imageForState(UIControlState.Normal)
        
//        if self.cardImageAddBtn?.tag < 2{
//            GShowAlertMessage("上传的身份证照片不少于2张！")
//            return
//        }
        for item in self.cardImageAddSuperView.subviews{
            if item.isKindOfClass(UIImageView){
                let imageView = item as! UIImageView
                self.registerAccount.cardImage.append(imageView.image!)
            }
        }
        
        self.registerAccount.mAuth = LoginInfoModel.sharedInstance.m_auth
        NetworkManager.sharedInstance.requestRegister(self.registerAccount, success: { (jsonDic:AnyObject) -> () in
            //店铺注册成功
            LoginInfoModel.sharedInstance.shopStatus = "0"
            GShowAlertMessage("店铺注册成功!")
            self.navigationController?.popToRootViewControllerAnimated(true)
            NSNotificationCenter.defaultCenter().postNotificationName("ChangeStoreStatus", object: self)
            
            }) { (error:String, needRelogin:Bool) -> () in
            GShowAlertMessage(error)
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.message == "亲，还差几步你就完成开店咯"{
            if alertView.buttonTitleAtIndex(buttonIndex) == "退出"{
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
}

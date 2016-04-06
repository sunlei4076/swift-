//
//  RegisterInfoViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/9.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class SetShopInfoViewController: UIViewController,UIKeyboardViewControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UITextViewDelegate {
    
//    
//    private var mallCateList:[MallCateModel] = []
//    private var firstCateIndex:Int = 0
//    private var secondCateIndex:Int = 0
//    private var thirdCateIndex:Int = 0
    
//    @IBOutlet weak var cardImageAddBtn:UIButton?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headUploadTipLabel: UILabel!
    @IBOutlet weak var headIconSetBtn: UIButton!
    
    @IBOutlet weak var inputShopName: UITextField!
    @IBOutlet weak var recommendInfo: UITextField!
    @IBOutlet weak var inputAddress: UITextField!
    @IBOutlet weak var showSelectProvinces: UILabel!
//    @IBOutlet weak var showSelectAddress: UILabel!
    @IBOutlet weak var inputPhone: UITextField!
    @IBOutlet weak var showSelectShopType: UILabel!
    @IBOutlet weak var showSelectCoverRange: UILabel!
    //店铺公告；
    @IBOutlet weak var textView: UITextView!
//    @IBOutlet weak var store_banner: UIButton!
    
    //验证资料；
    @IBOutlet weak var cardImageAddSuperView: UIView!
    @IBOutlet weak var cardUploadTipLabel: UILabel!
    @IBOutlet weak var addVerifiDataImage: UIButton!
    @IBOutlet weak var addVerifiDataImageView: UIView!
    

    var registerAccount:RegisterModel = RegisterModel()
    private var shopTypeList:[(cateId:String,cateName:String)] = []
    private var selectedShopTypeIndex:Int?
    
    //改动否？
    private var edited:Bool = false

    
    private var coverRangeList:[String] = ["3","5","10"]
    private var selectedCoverRangeIndex:Int?
    
    //标识设置图片
    private var addImageType:Int = 0
    
    //验证资料图片；
    private var verificationDataImages:[UIImage] = []
    private var verificationHasImages:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.delegate = self
//        pprLog(message:"\(self)")
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
        self.title = "店铺设置"
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        //提交；
        let commitBtn:UIButton = UIButton(type:UIButtonType.Custom)
        commitBtn.setTitle("提交", forState: UIControlState.Normal)
        commitBtn.frame = CGRectMake(0, 0, 40, 30)
        commitBtn.addTarget(self, action: Selector("commitAction"), forControlEvents: UIControlEvents.TouchUpInside)
        commitBtn.titleLabel?.font = GGetBigCustomFont()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: commitBtn)

        self.view.backgroundColor = GlobalBgColor
        
        self.showSelectShopType.text = "请选择类型"
        
        //占位文字；
        self.textView.placeholder = "编辑好的店铺公告将在店铺首页展示，42个字内容更容易让人理解噢～"
//        textView.addSubview(placeholderLabel)
        
        //设置字体
        GSetFontInView(self.view, font: GGetNormalCustomFont())
        self.textView.font = GGetNormalCustomFont()
        self.headUploadTipLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        self.cardUploadTipLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        self.showSelectProvinces.numberOfLines = 0
    
        
        
        self.inputAddress.addTarget(self, action: "inputPhoneEditingDidEnd", forControlEvents:UIControlEvents.EditingDidEnd)
    }
    
    private func initData(){
        //头像;
        let avatarURL = LoginInfoModel.sharedInstance.avatar
//        pprLog(message: avatarURL)
        
        if avatarURL.isEmpty {
            
        }
        else {
            self.headIconSetBtn.setBackgroundImageForState(UIControlState.Normal, withURL: NSURL(string: avatarURL)!, placeholderImage: UIImage(named: "Register_SetHeadIcon"))
            self.headIconSetBtn.tag += 1
        }
        
        //店铺名；
        self.inputShopName.text = LoginInfoModel.sharedInstance.store.store_name
        
        self.inputShopName.userInteractionEnabled = false
        
        self.inputShopName.textColor = UIColor.lightGrayColor()
        
        //省市区；
        let province = LoginInfoModel.sharedInstance.store.province
        let city = LoginInfoModel.sharedInstance.store.city
        let area = LoginInfoModel.sharedInstance.store.area
        var str:String = ""
        if province == city{
            if (province == area) && (area == city)
            {
                str = province
            }else{
                str = city + " " + area
            }

        }else if area == city{
            if (province == area) && (area == city)
            {
                str = province
            }else{
                str = province + " " + city
            }

        }else{
            str = province + " " + city + " " + area
        }
//        self.showSelectProvinces.text = province + city + area
        self.showSelectProvinces.text = str

        self.registerAccount.province = LoginInfoModel.sharedInstance.store.province
        self.registerAccount.city = LoginInfoModel.sharedInstance.store.city
        self.registerAccount.area = LoginInfoModel.sharedInstance.store.area
 
        //店铺地址；
        self.inputAddress.text = LoginInfoModel.sharedInstance.store.address
        
        //手机号；
        self.inputPhone.text = LoginInfoModel.sharedInstance.store.tel
        //推荐人；
        self.recommendInfo.text = LoginInfoModel.sharedInstance.store.recommendInfo
        pprLog(self.recommendInfo.text)
        if (self.recommendInfo.text!.isEmpty == false)
        {
            self.recommendInfo.enabled = false
            self.recommendInfo.textColor = UIColor.lightGrayColor()
        }
        
        //店铺类型；
        self.showSelectShopType.text = LoginInfoModel.sharedInstance.store.cate_name

        //服务范围；
        self.showSelectCoverRange.text = LoginInfoModel.sharedInstance.store.radius
        //店铺公告；
        self.textView.text = LoginInfoModel.sharedInstance.store.description_t
        
//        //招牌图片；
//        var logoURL = LoginInfoModel.sharedInstance.store.store_banner
////        pprLog(message: logoURL)
//        
//        if logoURL.isEmpty {
//        }
//        else {
//            var storeBannerImage = self.store_banner.imageView!
////            pprLog(message: "\(storeBannerImage.image)")
//            self.store_banner.setBackgroundImageForState(UIControlState.Normal, withURL: NSURL(string: logoURL), placeholderImage: UIImage(named: "Register_SetHeadIcon"))
//            self.store_banner.tag += 1
//        }

        //验证资料；
//        pprLog("\(LoginInfoModel.sharedInstance.store.idIamges)")
        
         let idImages = LoginInfoModel.sharedInstance.store.idIamges
        pprLog(idImages)
        if idImages.isEmpty {
        }
        else {
//            pprLog("\(self.verificationHasImages)")
            self.verificationHasImages = LoginInfoModel.sharedInstance.store.idIamges
            self.showVerificationDataImages()
        }
        
//        self.verificationHasImages.removeAll(keepCapacity: true)
        
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
            self.registerAccount.lat = String(stringInterpolationSegment: result.location.latitude)
            self.registerAccount.lng = String(stringInterpolationSegment: result.location.longitude)
//            self.inputAddress.text = self.registerAccount.address
            }) { () -> Void in
                GShowAlertMessage("请允许定位服务！")
        }
        
    }
    
    func backAction() {
        if edited {
            
        }else {
            let alert = UIAlertView(title: "提示", message: "编辑资料未保存，确认退出吗？", delegate: self, cancelButtonTitle: "继续", otherButtonTitles: "退出")
            alert.show()
        }
    }
    
    // MARK: - ————————提交————————
    func commitAction() {
        if self.headIconSetBtn.tag == 0{
            GShowAlertMessage("您还没有选择头像！")
            return
        }
        self.registerAccount.headIcon = self.headIconSetBtn.backgroundImageForState(UIControlState.Normal)
        
        if let store_name = self.inputShopName.text{
            self.registerAccount.stroe_name = store_name
            self.registerAccount.real_name = store_name
        }else{
            GShowAlertMessage("店铺名称不能为空！")
            return
        }
        
        if self.showSelectProvinces.text!.isEmpty {
            self.registerAccount.province = LoginInfoModel.sharedInstance.store.province
            self.registerAccount.city = LoginInfoModel.sharedInstance.store.city
            self.registerAccount.area = LoginInfoModel.sharedInstance.store.area
        }
        

        
        
        if let address = self.inputAddress.text{
            self.registerAccount.address = address
        }
        
        if self.inputAddress.text?.characters.count == 0{
            GShowAlertMessage("店铺地址不能为空！")
            return
        }
        
        if self.inputPhone.text!.isEmpty{
            GShowAlertMessage("手机号码不能为空！")
            return
        }
        let phoneNumPattern = "^(0|86|17951)?(13[0-9]|15[012356789]|17[0678]|18[0-9]|14[57])[0-9]{8}$"
        let phoneNum = RegisteriPhoneIdentifyController.RegexHelper(phoneNumPattern)
        let maybePhone = self.inputPhone.text
        if phoneNum.match(maybePhone!) == false {
            GShowAlertMessage("手机号码不正确！")
            return
        }
        self.registerAccount.tel = self.inputPhone.text!
        
        //推荐人；
        pprLog(self.recommendInfo.text)
//        if self.recommendInfo.text.isEmpty == false && self.recommendInfo.enabled {
//            self.registerAccount.recommendInfo = self.recommendInfo.text
//        }
        self.registerAccount.recommendInfo = self.recommendInfo.text!

        
        if self.showSelectShopType.text!.isEmpty{
            GShowAlertMessage("请选择店铺类型！")
            return
        }

        if self.selectedShopTypeIndex == nil {
            self.registerAccount.cate_id = LoginInfoModel.sharedInstance.store.cate_id
        }
        else {
            self.registerAccount.cate_id = self.shopTypeList[self.selectedShopTypeIndex!].cateId
        }
        
        
        if self.showSelectCoverRange.text!.isEmpty{
            GShowAlertMessage("请选择服务范围！")
            return
        }
        pprLog("\(self.registerAccount.radius)")
        if self.registerAccount.radius.isEmpty {
            self.registerAccount.radius = self.showSelectCoverRange.text!
        }
        
        
        if self.textView.text.isEmpty {
            GShowAlertMessage("您还没有写店铺公告！")
            return
        }
        
        if self.textView.text!.characters.count > 42 {
            GShowAlertMessage("店铺公告超过了42个字")
            return
        }
        self.registerAccount.description_t = self.textView.text
        
        
//        if self.store_banner.tag == 0 {
//            GShowAlertMessage("您还没有设置招牌！")
//            return
//        }
//        self.registerAccount.store_banner = self.store_banner.backgroundImageForState(UIControlState.Normal)
        
        
        let imageNum = self.verificationDataImages.count +  self.verificationHasImages.count
        
        pprLog(self.verificationDataImages.count)
        if imageNum < 1 {
            GShowAlertMessage("请上传证件照片不少于1张！")
            return
        }
        
        pprLog(self.addVerifiDataImageView.subviews)
        //cardImageAddSuperView;addVerifiDataImageView；self.registerAccount.cardImage
        
        for item in self.addVerifiDataImageView.subviews {
            for itm in item.subviews {
                if itm.isKindOfClass(UIImageView){
                    let imageView = itm as! UIImageView
                    self.registerAccount.cardImage.append(imageView.image!)
                }
            }
        }
        
//        for item in self.verificationDataImages{
//            
//            self.registerAccount.cardImage.append(item)
//            pprLog(message: "\(item)")
//            
//            if item.isKindOfClass(UIImage){
////                let imageView = item as! UIImageView
////                self.registerAccount.cardImage.append(imageView.image!)
//                pprLog(message: "11 \(item)")
//            }
//        }
        
        self.registerAccount.mAuth = LoginInfoModel.sharedInstance.m_auth
        
        NetworkManager.sharedInstance.requestUpdateStoreInfo(self.registerAccount, success: { (jsonDic:AnyObject) -> () in
            //店铺设置成功
//            LoginInfoModel.sharedInstance.shopStatus = "0"
            GShowAlertMessage("店铺设置成功!")
            self.edited = true
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            //刷新登陆模型的数据；
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let objDic = JsonDicHelper.getJsonDicDictionary(dataDic, key: "obj")
            LoginInfoModel.sharedInstance.setDataWithJson(objDic)
            
            }) { (error:String, needRelogin:Bool) -> () in
                GShowAlertMessage(error)
        }
        
    }
    
    // MARK: - ————————照片选取————————
    private func showActionSheetToAddPhoto(){
        self.inputPhone.resignFirstResponder()
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
            sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
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
                self.headIconSetBtn.setBackgroundImage(smallImage, forState: UIControlState.Normal)
                self.headIconSetBtn.tag += 1
                
            }else if self.addImageType == 2{
                //上传身份证照片
                self.verificationDataImages.append((image as? UIImage)!)
                
                pprLog("\(self.verificationDataImages.count)")
                self.showVerificationDataImages()
                
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK:证件照
    func showVerificationDataImages(){
        //移除所有
        for view in self.addVerifiDataImageView.subviews {
            view.removeFromSuperview()
        }
        
        //显示已有的证照；
        var count = (self.verificationHasImages.count > 5) ? 5 : self.verificationHasImages.count
        
        var leftItem:UIView?
        for var i=0;i<count;i++ {
            let addImage = AddImageView.instantiateFromNib()
            addImage.initDataWithUrl(self.verificationHasImages[i], atIndex: i)
            addImage.deleteBlock = {(isUrl:Bool, index:Int)->() in
                if isUrl == true{
                    self.verificationHasImages.removeAtIndex(index)
                    self.showVerificationDataImages()
                }
            }
            
            self.addVerifiDataImageView.addSubview(addImage)
            addImage.translatesAutoresizingMaskIntoConstraints = false
            //添加约束
            self.addWidth(63, height: 63, view: addImage)
            self.setEdge(self.addVerifiDataImageView, view: addImage, edgeInset: UIEdgeInsetsMake( -1, -1, 8, -1))
            if leftItem == nil {
                self.setEdge(self.addVerifiDataImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, 8, -1, -1))
            }else{
                self.addHerMargin(leftItem!, rightView: addImage, width: 8)
            }
            leftItem = addImage
        }
        
        for var i=0;i<self.verificationDataImages.count;i++ {
            let addImage = AddImageView.instantiateFromNib()
            addImage.initDataWithImage(self.verificationDataImages[i], atIndex: i)
            addImage.deleteBlock = {(isUrl:Bool, index:Int)->() in
                if isUrl == false{
                    self.verificationDataImages.removeAtIndex(index)
                    self.showVerificationDataImages()
                }
            }
            
        self.addVerifiDataImageView.addSubview(addImage)
            addImage.translatesAutoresizingMaskIntoConstraints = false
            //添加约束
            //固定宽高63
            self.addWidth(63, height: 63, view: addImage)
        
              self.setEdge(self.addVerifiDataImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, -1, 8, -1))
                
              if leftItem == nil {
                    self.setEdge(self.addVerifiDataImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, 8, -1, -1))
                }else{
                    self.addHerMargin(leftItem!, rightView: addImage, width: 8)
                }
            
            if leftItem == nil {
                self.setEdge(self.addVerifiDataImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, 8, -1, -1))
            }else{
                self.addHerMargin(leftItem!, rightView: addImage, width: 8)
            }
            leftItem = addImage
            count++
        }
        
        if leftItem != nil{
            self.setEdge(self.addVerifiDataImageView, view: leftItem!, edgeInset: UIEdgeInsetsMake(-1, -1, -1, 8))
        }
        
        if count < 5{
            self.addVerifiDataImage.hidden = false
        }else{
            self.addVerifiDataImage.hidden = true
        }
        self.addVerifiDataImageView.updateConstraintsIfNeeded()
        self.addVerifiDataImageView.layoutIfNeeded()
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ————————点击设置资料————————
    @IBAction func actionSetHeadIcon(sender: AnyObject) {
        self.view.endEditing(true)
        self.addImageType = 1
        self.showActionSheetToAddPhoto()
    }
    //选择省市区按钮
    @IBAction func actionSelectProvinces(sender: AnyObject) {
        self.view.endEditing(true)
        self.inputShopName.resignFirstResponder()
        self.inputPhone.resignFirstResponder()

        let popoverProvince = PopoverAreaSelectView.instantiateFromNib()
        popoverProvince.provinceStr = self.registerAccount.province
        popoverProvince.cityStr = self.registerAccount.city
        popoverProvince.areaStr = self.registerAccount.area
        let window = UIApplication.sharedApplication().keyWindow
        popoverProvince.show(window!, title: "选择你的省市区") { (selectString, provinceStr, cityStr, areaStr) -> () in
        
            self.registerAccount.province = provinceStr
            self.registerAccount.city = cityStr
            self.registerAccount.area = areaStr
            self.showSelectProvinces.text = selectString
        }
    }

    @IBAction func actionSelectShopType(sender: AnyObject) {
        self.view.endEditing(true)
        self.inputPhone.resignFirstResponder()
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
        self.view.endEditing(true)
        self.inputPhone.resignFirstResponder()
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
        self.view.endEditing(true)
        self.addImageType = 2
        self.showActionSheetToAddPhoto()
    }
    
    
     //MARK: - ————————店铺公告————————
    func altextViewDidBeginEditing(textView: UITextView!) {
        self.inputPhone.resignFirstResponder()
        self.inputShopName.resignFirstResponder()
        self.inputAddress.resignFirstResponder()
    }
    
    func inputPhoneEditingDidEnd() {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height - self.view.frame.size.height)
    }
    
    func altextView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        
        let text = textView.text as NSString
        if text.length > 42 {
            textView.text = text.substringToIndex(42)
        }
        
        return true
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.message == "编辑资料未保存，确认退出吗？"{
            if alertView.buttonTitleAtIndex(buttonIndex) == "退出"{
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    // MARK: - ********************约束*********************
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
    
    //水平约束
    private func addHerMargin(leftView:UIView, rightView:UIView, width:CGFloat){
        let layoutCon = NSLayoutConstraint(item:rightView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: leftView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: width)
        leftView.superview?.addConstraint(layoutCon)
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
}

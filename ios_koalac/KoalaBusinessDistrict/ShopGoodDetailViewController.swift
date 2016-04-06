//
//  ShopGoodDetailViewController.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/16.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class ShopGoodDetailViewController: UIViewController, UIKeyboardViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate {
    
    var showBoughtGood:Bool = false
    var orderRecID:String = ""
    
    @IBOutlet weak var showDescriptionImageView: UIView!
    @IBOutlet weak var showCoverImageView: UIView!
    
    let maxDescroptionImageCount = 5
    let maxCoverImageCount = 1
    @IBOutlet weak var coverImageAddBtn: UIButton!
    @IBOutlet weak var descriptionImageAddBtn: UIButton!
    //    var descriptionImageAddBtn: UIButton?
    //    var coverImageAddBtn: UIButton?
    @IBOutlet weak var showSelectShopType: UITextField!
    @IBOutlet weak var showSelectMallType: UITextField!
    @IBOutlet weak var inputGoodInfo: UITextView!
    @IBOutlet weak var inputGoodOriginPrice2: UITextField!// 建议零售价
    @IBOutlet weak var inputGoodOriginPrice: UITextField!
    @IBOutlet weak var inputGoodCurrPrice: UITextField!
    @IBOutlet weak var inputGoodNum: UITextField!
    @IBOutlet weak var inputGoodName: UITextField!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var goodData:ShopGoodModel = ShopGoodModel()
    
    private var mallCateList:[MallCateModel] = []
    private var firstCateIndex:Int = 0
    private var secondCateIndex:Int = 0
    private var thirdCateIndex:Int = 0
    
    private var shopGoodTypeList:[ShopTypeModel] = []
    private var shopGoodTypeSelect:Int = 0
    //标识是添加封面图片还是描述图片
    private var addImageType:Int = 0
    private var userAddCoverImages:[UIImage] = []
    private var userAddDescripImages:[UIImage] = []
    private var goodHasCoverImages:[goodCoverImageModel] = []
    private var goodHasDescripImages:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pprLog(self.showBoughtGood)
        self.initControl()
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.keyboard.boardDelegate = self
        self.inputGoodInfo.contentOffset = CGPointZero
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        app.keyboard.boardDelegate = nil
    }
    
    private func initControl(){
        if self.showBoughtGood {
            self.title = "发布已进货商品"
        }
        else {
            self.title = "添加商品"
        }
        
        //back
        let backBtn = GNavigationBack()
        backBtn.addTarget(self, action:Selector("backAction"), forControlEvents: UIControlEvents.TouchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        //提交；
        let commitBtn:UIButton = UIButton(type:UIButtonType.Custom)
        commitBtn.setTitle("提交", forState: UIControlState.Normal)
        commitBtn.frame = CGRectMake(0, 0, 40, 30)
        commitBtn.addTarget(self, action: Selector("saveChangeAction"), forControlEvents: UIControlEvents.TouchUpInside)
        commitBtn.titleLabel?.font = GGetBigCustomFont()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: commitBtn)
        
        self.view.backgroundColor = GlobalBgColor
        self.scrollView.backgroundColor = GlobalBgColor
        self.scrollContentView.backgroundColor = UIColor.clearColor()
        
        //设置字体
        GSetFontInView(self.scrollContentView, font: GGetNormalCustomFont())
        //商品描述textView
        self.inputGoodInfo.font = GGetNormalCustomFont()
        self.inputGoodInfo.placeholder = "请输入商品描述：如规格、保质期、商品特色等"
        
        //        self.inputGoodName.text = ""
        
    }
    
    func backAction(){
        let alert = UIAlertView(title: "提示", message: "亲，你的店铺马上就有商品了", delegate: self, cancelButtonTitle: "继续编辑", otherButtonTitles: "下次再说")
        alert.show()
    }
    
    //MARK: - 提交
    @IBAction func saveChangeAction(){
        //提交前判断
        let coverCount = self.goodHasCoverImages.count + self.userAddCoverImages.count
        
        if coverCount == 0{
            GShowAlertMessage("请至少上传一张封面图片")
            return
        }
        let goodName = self.inputGoodName.text
        if goodName!.isEmpty{
            GShowAlertMessage("请输入商品名称！")
            return
        }
        
        let originPrice = self.inputGoodOriginPrice.text
        let originPriceNum = (originPrice! as NSString).floatValue
        if originPriceNum <= 0 {
            GShowAlertMessage("请输入合理的原价！")
            return
        }
        
        var preferPrice = self.inputGoodCurrPrice.text
        let preferPriceNum = (preferPrice! as NSString).floatValue
        if preferPrice!.isEmpty {
            preferPrice = originPrice
        }
        else {
            if preferPriceNum <=  0 || preferPriceNum > originPriceNum {
                GShowAlertMessage("请输入合理的优惠价！")
                return
            }
        }
        
        
        let goodNum = self.inputGoodNum.text
        let goodNumber = (goodNum! as NSString).integerValue
        if goodNumber <= 0 {
            GShowAlertMessage("请输入正确的商品库存！")
            return
        }
        
        let goodDes = self.inputGoodInfo.text
        if goodDes.isEmpty{
            GShowAlertMessage("请输入商品描述！")
            return
        }
        let mallType = self.showSelectMallType.text
        if mallType?.characters.count == 0{
            GShowAlertMessage("请选择商城分类！")
            return
        }
        let shopType = self.showSelectShopType.text
        if shopType?.characters.count == 0{
            GShowAlertMessage("请选择我的分类！")
            return
        }
        
        let descripCount = self.goodHasDescripImages.count + self.userAddDescripImages.count
        if descripCount == 0{
            GShowAlertMessage("请至少上传一张商品图片")
            return
        }
        
        
        let newGood = ShopGoodModel()
        newGood.goodDescription = goodDes
        newGood.goods_name = goodName!
        newGood.stock = goodNum!
        newGood.orige_price = originPrice!
        newGood.price = preferPrice!
        //        let price = self.inputGoodCurrPrice.text
        //        newGood.price = (price!.isEmpty ? originPrice:price)!
        
        let firstCate = self.mallCateList[self.firstCateIndex]
        if firstCate.nextCateArray.count != 0
        {
            let secondCate = firstCate.nextCateArray[self.secondCateIndex]
            newGood.cateSecendId = secondCate.cate_id
            if secondCate.nextCateArray.count != 0
            {
                let thirdCate = secondCate.nextCateArray[self.thirdCateIndex]
                newGood.cate_name = thirdCate.cate_name
                newGood.cate_id = firstCate.cate_id
                newGood.cateSecendId = secondCate.cate_id
                newGood.cateThridId = thirdCate.cate_id
            }else{
                newGood.cate_name = secondCate.cate_name
                newGood.cate_id = firstCate.cate_id
                newGood.cateSecendId = secondCate.cate_id
                
            }
        }else{
            newGood.cate_name = firstCate.cate_name
            newGood.cate_id = firstCate.cate_id
        }
        //        newGood.cate_id = firstCate.cate_id
        //        newGood.cate_name = firstCate.cate_name
        //        let secondCate = firstCate.nextCateArray[self.secondCateIndex]
        //        newGood.cateSecendId = secondCate.cate_id
        //        let thirdCate = secondCate.nextCateArray[self.thirdCateIndex]
        //        newGood.cateThridId = thirdCate.cate_id
        
        newGood.shopCate_id = self.shopGoodTypeList[self.shopGoodTypeSelect].cate_id
        newGood.shopCate_name = self.shopGoodTypeList[self.shopGoodTypeSelect].cate_name
        var goodId = self.goodData.goods_id
        //判断从进货口进来的；
        if self.showBoughtGood {
            goodId = ""
            self.orderRecID = goodData.order_rec_id
            newGood.goodCoverImages.removeAll()
            newGood.goodDescripImages.removeAll()
            
            for item in self.showCoverImageView.subviews {
                self.userAddCoverImages.removeAll()
                for itm in item.subviews {
                    if itm.isKindOfClass(UIImageView){
                        let imageView = itm as! UIImageView
                        self.userAddCoverImages.append(imageView.image!)
                    }
                }
            }
            
            self.userAddDescripImages.removeAll()
            for item in self.showDescriptionImageView.subviews {
                pprLog(self.userAddDescripImages.count)
                for itm in item.subviews {
                    if itm.isKindOfClass(UIImageView){
                        let imageView = itm as! UIImageView
                        self.userAddDescripImages.append(imageView.image!)
                    }
                }
            }
        }
        else {
            newGood.goodCoverImages += self.goodHasCoverImages
            newGood.goodDescripImages += self.goodHasDescripImages
            
        }
        
        newGood.goods_id = goodId.isEmpty ? "0":goodId
        
        let needUploadCoverImage = self.userAddCoverImages.count > 0 ? true:false
        let needUploadDescripImage = self.userAddDescripImages.count > 0 ? true:false
        
        pprLog(needUploadDescripImage)
        
        var coverUploadEnd = !needUploadCoverImage
        var descripUploadEnd = !needUploadDescripImage
        
        //上传封面图片 goodCoverImages.count
        if needUploadCoverImage{
            
            pprLog(self.userAddCoverImages)
            pprLog(newGood.goods_id)
            
            NetworkManager.sharedInstance.requestUploadGoodImage(self.userAddCoverImages, goodId:newGood.goods_id , success: { (rtnArray:AnyObject) -> () in
                if rtnArray is Array<goodCoverImageModel>{
                    let array = rtnArray as! [goodCoverImageModel]
                    for item in array{
                        newGood.goodCoverImages.append(item)
                    }
                    coverUploadEnd = true
                    if coverUploadEnd && descripUploadEnd{
                        NetworkManager.sharedInstance.requestEditOrAddGoodInfo(newGood, success: { (jsonDic:AnyObject) -> () in
                            let alert = UIAlertView(title: "提示", message: "发布成功！", delegate: self, cancelButtonTitle: "确定")
                            
                            alert.show()
                            }, fail: { (error:String, needRelogin:Bool) -> () in
                                if needRelogin == true{
                                    
                                }else{
                                    GShowAlertMessage(error)
                                }
                        })
                    }
                }
                }) { (error:String, flag:Bool) -> () in
                    GShowAlertMessage(error)
            }
        }
        
        //上传描述图片
        if needUploadDescripImage{
            NetworkManager.sharedInstance.requestUploadGoodDescripImage(self.userAddDescripImages, success: { (rtnArray:AnyObject) -> () in
                if rtnArray is Array<String>{
                    let array = rtnArray as! [String]
                    for item in array{
                        newGood.goodDescripImages.append(item)
                    }
                    descripUploadEnd = true
                    if coverUploadEnd && descripUploadEnd{
                        NetworkManager.sharedInstance.requestEditOrAddGoodInfo(newGood, success: { (jsonDic:AnyObject) -> () in
                            let alert = UIAlertView(title: "提示", message: "发布成功！", delegate: self, cancelButtonTitle: "确定")
                            alert.show()
                            }, fail: { (error:String, needRelogin:Bool) -> () in
                                if needRelogin == true{
                                    
                                }else{
                                    GShowAlertMessage(error)
                                }
                        })
                    }
                }
                }, fail: { (error:String, flag:Bool) -> () in
                    GShowAlertMessage(error)
            })
        }
        //由于必须等到图片上传后才能调用发布接口，故用此写法。应还有更好的方法
        if needUploadCoverImage == false && needUploadDescripImage == false{
            NetworkManager.sharedInstance.requestEditOrAddGoodInfo(newGood, success: { (jsonDic:AnyObject) -> () in
                let alert = UIAlertView(title: "提示", message: "发布成功！", delegate: self, cancelButtonTitle: "确定")
                alert.show()
                
                }, fail: { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                        
                    }else{
                        GShowAlertMessage(error)
                    }
            })
        }
    }
    
    private func requestMallGoodTypes(){
        NetworkManager.sharedInstance.requestMallAllGoodTypeList({ (jsonDic:AnyObject) -> () in
            //获取商城分类
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            for item in listArray{
                if let firstCategory = item as? Dictionary<String,AnyObject>{
                    let cate = MallCateModel(jsonDic: firstCategory)
                    self.mallCateList.append(cate)
                }
            }
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
    }
    
    private func requestShopGoodTypes(){
        self.shopGoodTypeList.removeAll(keepCapacity: true)
        //获得店铺商品分类列表
        NetworkManager.sharedInstance.requestShopGoodTypeList({ (jsonDic:AnyObject) -> () in
            let dic = jsonDic as! Dictionary<String, AnyObject>
            let dataDic = JsonDicHelper.getJsonDicDictionary(dic, key: "data")
            let listArray = JsonDicHelper.getJsonDicArray(dataDic, key: "list")
            
            for item in listArray{
                if item is Dictionary<String, AnyObject>{
                    let type = ShopTypeModel(jsonDic: item as! Dictionary<String, AnyObject>)
                    self.shopGoodTypeList.append(type)
                    let idFloat = (type.cate_id as NSString).floatValue
                    let idFloat2 = (self.goodData.shopCate_id as NSString).floatValue
                    if idFloat == idFloat2{
                        self.goodData.shopCate_name = type.cate_name
                    }
                }
            }
            self.showSelectShopType.text = self.goodData.shopCate_name
            }, fail: { (error:String, needRelogin:Bool) -> () in
                if needRelogin == true{
                    
                }else{
                    GShowAlertMessage(error)
                }
        })
    }
    
    private func addImageInView(superView:UIView, image:UIImage){
        let smallImage = GFitSmallImage(image, wantSize: CGSizeMake(63, 63), fitScale: false)
        let imageView = UIImageView(image: smallImage)
        superView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //水平居中
        let centerConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        superView.addConstraint(centerConstraint)
        
    }
    
    private func showCoverImage(){
        //移除所有
        for view in self.showCoverImageView.subviews {
            view.removeFromSuperview()
        }
        
        var count = self.goodHasCoverImages.count > maxCoverImageCount ? maxCoverImageCount : self.goodHasCoverImages.count
        pprLog(count)
        
        var leftItem:UIView?
        for var i=0;i<count;i++ {
            let addImage = AddImageView.instantiateFromNib()
            pprLog(self.goodHasCoverImages[i].image_url)
            
            addImage.initDataWithUrl(self.goodHasCoverImages[i].image_url, atIndex: i)
            addImage.deleteBlock = {(isUrl:Bool, index:Int)->() in
                if isUrl == true{
                    self.goodHasCoverImages.removeAtIndex(index)
                    self.showCoverImage()
                }
            }
            
            self.showCoverImageView.addSubview(addImage)
            addImage.translatesAutoresizingMaskIntoConstraints = false
            //添加约束
            //固定宽高63
            self.addWidth(63, height: 63, view: addImage)
            self.setEdge(self.showCoverImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, -1, 8, -1))
            if leftItem == nil {
                self.setEdge(self.showCoverImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, 8, -1, -1))
            }else{
                self.addHerMargin(leftItem!, rightView: addImage, width: 8)
            }
            leftItem = addImage
        }
        
        for var i=0;i<self.userAddCoverImages.count;i++ {
            let addImage = AddImageView.instantiateFromNib()
            addImage.initDataWithImage(self.userAddCoverImages[i], atIndex: i)
            addImage.deleteBlock = {(isUrl:Bool, index:Int)->() in
                if isUrl == false{
                    self.userAddCoverImages.removeAtIndex(index)
                    self.showCoverImage()
                }
            }
            
            self.showCoverImageView.addSubview(addImage)
            addImage.translatesAutoresizingMaskIntoConstraints = false
            //添加约束
            //固定宽高63
            self.addWidth(63, height: 63, view: addImage)
            self.setEdge(self.showCoverImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, -1, 8, -1))
            if leftItem == nil {
                self.setEdge(self.showCoverImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, 8, -1, -1))
            }else{
                self.addHerMargin(leftItem!, rightView: addImage, width: 8)
            }
            leftItem = addImage
            count++
        }
        
        if leftItem != nil{
            self.setEdge(self.showCoverImageView, view: leftItem!, edgeInset: UIEdgeInsetsMake(-1, -1, -1, 8))
        }
        
        if count < maxCoverImageCount{
            self.coverImageAddBtn.hidden = false
        }else{
            self.coverImageAddBtn.hidden = true
        }
        self.showCoverImageView.updateConstraintsIfNeeded()
        self.showCoverImageView.layoutIfNeeded()
    }
    
    private func showDescriptionImage(){
        //移除所有
        for view in self.showDescriptionImageView.subviews {
            view.removeFromSuperview()
        }
        
        var count = self.goodHasDescripImages.count > maxDescroptionImageCount ? maxDescroptionImageCount : self.goodHasDescripImages.count
        var leftItem:UIView?
        for var i=0;i<count;i++ {
            let addImage = AddImageView.instantiateFromNib()
            addImage.initDataWithUrl(self.goodHasDescripImages[i], atIndex: i)
            addImage.deleteBlock = {(isUrl:Bool, index:Int)->() in
                if isUrl == true{
                    self.goodHasDescripImages.removeAtIndex(index)
                    self.showDescriptionImage()
                }
            }
            
            self.showDescriptionImageView.addSubview(addImage)
            addImage.translatesAutoresizingMaskIntoConstraints = false
            //添加约束
            //固定宽高63
            self.addWidth(63, height: 63, view: addImage)
            self.setEdge(self.showDescriptionImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, -1, 8, -1))
            if leftItem == nil {
                self.setEdge(self.showDescriptionImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, 8, -1, -1))
            }else{
                self.addHerMargin(leftItem!, rightView: addImage, width: 8)
            }
            leftItem = addImage
        }
        
        for var i=0;i<self.userAddDescripImages.count;i++ {
            let addImage = AddImageView.instantiateFromNib()
            addImage.initDataWithImage(self.userAddDescripImages[i], atIndex: i)
            addImage.deleteBlock = {(isUrl:Bool, index:Int)->() in
                if isUrl == false{
                    self.userAddDescripImages.removeAtIndex(index)
                    self.showDescriptionImage()
                }
            }
            
            self.showDescriptionImageView.addSubview(addImage)
            addImage.translatesAutoresizingMaskIntoConstraints = false
            //添加约束
            //固定宽高63
            self.addWidth(63, height: 63, view: addImage)
            self.setEdge(self.showDescriptionImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, -1, 8, -1))
            if leftItem == nil {
                self.setEdge(self.showDescriptionImageView, view: addImage, edgeInset: UIEdgeInsetsMake(-1, 8, -1, -1))
            }else{
                self.addHerMargin(leftItem!, rightView: addImage, width: 8)
            }
            leftItem = addImage
            count++
        }
        
        if leftItem != nil{
            self.setEdge(self.showDescriptionImageView, view: leftItem!, edgeInset: UIEdgeInsetsMake(-1, -1, -1, 8))
        }
        
        if count < maxDescroptionImageCount{
            self.descriptionImageAddBtn.hidden = false
        }else{
            self.descriptionImageAddBtn.hidden = true
        }
        self.showDescriptionImageView.updateConstraintsIfNeeded()
        self.showDescriptionImageView.layoutIfNeeded()
        
    }
    
    func contentofset(){
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height - self.view.frame.size.height)
        //         self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height - self.view.frame.size.height)
    }
    
    private func initData(){
        
        self.requestMallGoodTypes()
        self.requestShopGoodTypes()
        
        self.inputGoodName.text = self.goodData.goods_name
//        self.inputGoodNum.text = self.goodData.stock
        
        if (self.goodData.stock as NSString).integerValue > 0{
            self.inputGoodNum.text =  self.goodData.stock
        }else{
            
            self.inputGoodNum.text = ""
        }
        
        //        Show Select Shop Type  Input Good Num  Show Select Mall Type
        self.showSelectShopType.addTarget(self, action: Selector("contentofset"), forControlEvents: UIControlEvents.EditingDidEnd)
        
        pprLog("\(self.goodData.price) + \(self.goodData.retail_price) +\(self.goodData.orige_price)")
        // 优惠价
        if (self.goodData.price as NSString).integerValue  > 0{
            
            self.inputGoodCurrPrice.text = self.goodData.price
        }else{
            
            self.inputGoodCurrPrice.text = ""
        }
        
        // 原价
        if (self.goodData.orige_price as NSString).integerValue  > 0{
            pprLog(self.goodData.orige_price)
            self.inputGoodOriginPrice.text! = self.goodData.orige_price
            pprLog(self.inputGoodOriginPrice.text)
        }else{
            
            self.inputGoodOriginPrice.text = ""
        }
        // 建议零售价
        if ((self.inputGoodOriginPrice2.text)! as NSString).integerValue > 0{
         
             self.inputGoodOriginPrice2.text = self.goodData.retail_price
            
        }else{
            
            self.inputGoodOriginPrice2.text = "无"
        }
//        self.inputGoodOriginPrice.text = self.goodData.orige_price
//        self.inputGoodOriginPrice.text = ""
        self.inputGoodInfo.text = self.goodData.goodDescription
        self.showSelectMallType.text = self.goodData.cate_name
        self.showSelectShopType.text = self.goodData.shopCate_name
       
        self.goodHasDescripImages = self.goodData.goodDescripImages
        for item in self.goodData.goodCoverImages{
            let coverModel = goodCoverImageModel()
            coverModel.file_id = item.file_id
            coverModel.image_url = item.image_url
            self.goodHasCoverImages.append(coverModel)
        }
        
        self.showCoverImage()
        self.showDescriptionImage()
    }
    //MARK: 商城分类显示
    @IBAction func actionShowMallGoodTypes(sender: AnyObject) {
        
        let window = UIApplication.sharedApplication().keyWindow
        let popover = PopoverCategorySelectView.instantiateFromNib()
        
        //在这里初赋值选pickView第一列 life
        if self.mallCateList.count != 0
        {
            for shopModel in self.mallCateList
            {
                if shopModel.cate_id == self.goodData.cate_id
                {
                    let pos = self.mallCateList.indexOf(shopModel)
                    self.firstCateIndex = pos!
                }
            }
            //第二列
            
            if self.mallCateList[self.firstCateIndex].nextCateArray.count != 0
            {
                for shopModel2 in self.mallCateList[self.firstCateIndex].nextCateArray
                {
                    if shopModel2.cate_id == self.goodData.cateSecendId
                    {
                        let pos = self.mallCateList[self.firstCateIndex].nextCateArray.indexOf(shopModel2)
                        self.secondCateIndex = pos!
                    }
                }
                
                //第三列
                if self.mallCateList[self.firstCateIndex].nextCateArray[self.secondCateIndex].nextCateArray.count != 0
                {
                    for shopModel3 in self.mallCateList[self.firstCateIndex].nextCateArray[self.secondCateIndex].nextCateArray
                    {
                        if shopModel3.cate_id == self.goodData.cateThridId
                        {
                            let pos = self.mallCateList[self.firstCateIndex].nextCateArray[self.secondCateIndex].nextCateArray.indexOf(shopModel3)
                            self.thirdCateIndex = pos!
                        }
                    }
                }
            }
        }
        
        popover.show(window!, title: "选择商城商品分类", data: self.mallCateList, defaultFirst: self.firstCateIndex, defaultSecond: self.secondCateIndex, defaultThird: self.thirdCateIndex) { (firstCateIndex, secondCateIndex, thirdCateIndex) -> () in
            self.firstCateIndex = firstCateIndex
            self.secondCateIndex = secondCateIndex
            self.thirdCateIndex = thirdCateIndex
            
            let firstCate = self.mallCateList[self.firstCateIndex]
            if firstCate.nextCateArray.count != 0
            {
                let secondCate = firstCate.nextCateArray[self.secondCateIndex]
                if secondCate.nextCateArray.count != 0
                {
                    let thirdCate = secondCate.nextCateArray[self.thirdCateIndex]
                    self.showSelectMallType.text = thirdCate.cate_name
                    
                }else{
                    self.showSelectMallType.text = secondCate.cate_name
                }
                
            }else{
                self.showSelectMallType.text = firstCate.cate_name
            }
            
            
            //            self.showSelectMallType.text = firstCate.cate_name
        }
    }
    @IBAction func actionShowShopGoodTypes(sender: AnyObject) {
        self.editing = false
        let popover = PopoverSelectView.instantiateFromNib()
        let window = UIApplication.sharedApplication().keyWindow
        var tempArray:[String] = []
        for item in self.shopGoodTypeList{
            tempArray.append(item.cate_name)
        }
        popover.show(window!, title: "选择类型", data: tempArray, defaultSelect: self.shopGoodTypeSelect) { (selectIndex, selectString) -> () in
            self.shopGoodTypeSelect = selectIndex
            self.showSelectShopType.text = selectString
        }
    }
    
    private func showActionSheetToAddPhoto(){
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
            // let smallImage = GFitSmallImage((image as? UIImage)!, wantSize: CGSizeMake(63.0, 63.0), fitScale: true)
            if self.addImageType == 1{
                //封面图片
                self.userAddCoverImages.append((image as? UIImage)!)
                self.showCoverImage()
            }else{
                //描述图片
                self.userAddDescripImages.append((image as? UIImage)!)
                self.showDescriptionImage()
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionAddCoverImage(sender: AnyObject) {
        self.editing = false
        self.addImageType = 1
        self.showActionSheetToAddPhoto()
    }
    @IBAction func actionAddDescriptionImage(sender: AnyObject) {
        self.editing = false
        self.addImageType = 2
        self.showActionSheetToAddPhoto()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.message == "亲，你的店铺马上就有商品了"{
            let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
            if buttonTitle == "下次再说"{
                
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        else if self.showBoughtGood {
            
            self.showBoughtGood = false
            NetworkManager.sharedInstance.requestBoughtGoodUpFinish(self.orderRecID, success: { (jsonDic:AnyObject) -> () in
                
                }, fail: { (error:String, needRelogin:Bool) -> () in
                    if needRelogin == true{
                    }else{
                        GShowAlertMessage(error)
                    }
            })
            
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
        }
        else{
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    //MARK: - ********************约束*********************
    //设置Autolayout中的边距辅助方法
    private func setEdge(superView:UIView, view:UIView, attr:NSLayoutAttribute, constant: CGFloat){
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

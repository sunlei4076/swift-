//
//  PopoverAreaSelectView.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/26.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class PopoverAreaSelectView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var titleBGView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonBGView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    private var allData:NSDictionary!
    private var province:[String] = []
    private var city:[String] = []
    private var area:[String] = []
    private var selectBlock:((String,String,String,String)->())?
    private var provinceIndex:Int = 0
    private var cityIndex:Int = 0
    private var areaIndex:Int = 0
//v2.8
     var provinceStr:String = ""
     var cityStr:String = ""
     var areaStr:String = ""


    private func initControl(){
        self.titleBGView.backgroundColor = GlobalStyleFontColor
        self.buttonBGView.backgroundColor = UIColor.blackColor()
        
        self.titleLabel.font = GGetBigCustomFont()
    }

    class func instantiateFromNib() -> PopoverAreaSelectView {
        let view = UINib(nibName: "PopoverAreaSelectView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! PopoverAreaSelectView
        
        return view
    }
    
    func show(inView:UIView, title:String, selectedDone:(selectString:String, provinceStr:String, cityStr:String, areaStr:String)->()){
        self.initControl()
        self.initData()
        self.titleLabel.text = title
        self.selectBlock = selectedDone
        self.frame = CGRectMake(0, 0, inView.bounds.size.width, inView.bounds.size.height)
        inView.addSubview(self)
    }
    
    private func initData(){
        let plistPath = NSBundle.mainBundle().pathForResource("area.plist", ofType: nil)
        if let path = plistPath{
            allData = NSDictionary(contentsOfFile: path)
            for var i=0;i<self.allData.count;i++ {
                let dic = allData.objectForKey(String(i)) as! Dictionary<String,AnyObject>
                self.province += dic.keys
            }

            //==设置省市区初次进入==
//            self.provinceIndex =  self.province.indexOf(LoginInfoModel.sharedInstance.store.province)!
            self.provinceIndex =  self.province.indexOf(self.provinceStr)!
            let dic = allData.objectForKey(String(self.provinceIndex)) as! Dictionary<String,AnyObject>
            let provinceStr = self.province[self.provinceIndex]
            let provinceDic = JsonDicHelper.getJsonDicDictionary(dic, key: provinceStr)
            for var i=0;i<provinceDic.count;i++ {
                let cityDic = JsonDicHelper.getJsonDicDictionary(provinceDic, key: String(i))
                self.city += cityDic.keys
                
            }
//            self.cityIndex = self.city.indexOf(LoginInfoModel.sharedInstance.store.city)!
            self.cityIndex = self.city.indexOf(self.cityStr)!
            let cityStr = self.city[self.cityIndex]
            let temp = JsonDicHelper.getJsonDicDictionary(provinceDic, key: String(self.cityIndex))
            let cityDic = JsonDicHelper.getJsonDicArray(temp, key: cityStr)
            self.area += cityDic as! [String]

//            self.areaIndex = self.area.indexOf(LoginInfoModel.sharedInstance.store.area)!
            self.areaIndex = self.area.indexOf(self.areaStr)!


            self.pickerView.reloadAllComponents()
            self.pickerView.selectRow(self.provinceIndex, inComponent: 0, animated: true)
            self.pickerView.selectRow(self.cityIndex, inComponent: 1, animated: true)
            self.pickerView.selectRow(self.areaIndex, inComponent: 2, animated: true)
            
            //            self.updateCityArray()
            //            self.updateAreaArray()
            //            self.pickerView.reloadAllComponents()
        }
    }
    
    private func updateCityArray(){
        self.cityIndex = 0
        self.city.removeAll(keepCapacity: true)
        let dic = allData.objectForKey(String(self.provinceIndex)) as! Dictionary<String,AnyObject>
        let provinceStr = self.province[self.provinceIndex]
        let provinceDic = JsonDicHelper.getJsonDicDictionary(dic, key: provinceStr)
        for var i=0;i<provinceDic.count;i++ {
            let cityDic = JsonDicHelper.getJsonDicDictionary(provinceDic, key: String(i))
            self.city += cityDic.keys

        }

    }
    
    private func updateAreaArray(){
        self.areaIndex = 0

        self.area.removeAll(keepCapacity: true)
        let dic = allData.objectForKey(String(self.provinceIndex)) as! Dictionary<String,AnyObject>
        let provinceStr = self.province[self.provinceIndex]
        let provinceDic = JsonDicHelper.getJsonDicDictionary(dic, key: provinceStr)
        let cityStr = self.city[self.cityIndex]
        let temp = JsonDicHelper.getJsonDicDictionary(provinceDic, key: String(self.cityIndex))
        let cityDic = JsonDicHelper.getJsonDicArray(temp, key: cityStr)
        self.area += cityDic as! [String]

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rtn = 0
        switch component{
        case 0:
            rtn = self.province.count
        case 1:
            rtn = self.city.count
        case 2:
            rtn = self.area.count
        default:
            break
        }
        return rtn
    }
    
    //字体太大，使用label
    /*
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var rtn:String = ""
        switch component{
        case 0:
            rtn = self.province[row]
        case 1:
            rtn = self.city[row]
        case 2:
            rtn = self.area[row]
        default:
            break
        }
        return rtn
    }*/
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel()
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = GGetCustomFontWithSize(13.0)
        label.textColor = UIColor.blackColor()
        label.frame = CGRectMake(0, 0, pickerView.bounds.size.width/3, 20)
        switch component{
        case 0:
            label.text = self.province[row]
        case 1:
            label.text = self.city[row]
        case 2:
            label.text = self.area[row]
        default:
            break
        }
        return label
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
        case 0:
            self.provinceIndex = row
            self.updateCityArray()
            self.updateAreaArray()
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 1:
            self.cityIndex = row
            self.updateAreaArray()
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 2:
            self.areaIndex = row
        default:
            break
        }
    }
    
    @IBAction func actionCancel(sender: AnyObject) {
        self.removeFromSuperview()
    }
    @IBAction func actionOk(sender: AnyObject) {
        self.removeFromSuperview()
        if self.selectBlock != nil {
            let provinceStr = self.province[self.provinceIndex]
            let cityStr = self.city[self.cityIndex]
            let areaStr = self.area[self.areaIndex]
            let str:String
            if provinceStr == cityStr{
                if (provinceStr == areaStr) && (areaStr == cityStr)
                {
                    str = provinceStr
                }else{
                    str = cityStr + " " + areaStr
                }

            }else if areaStr == cityStr{
                if (provinceStr == areaStr) && (areaStr == cityStr)
                {
                    str = provinceStr
                }else{
                    str = provinceStr + " " + cityStr
                }

            }else{
                str = provinceStr + " " + cityStr + " " + areaStr
            }
            self.selectBlock!(str,provinceStr,cityStr,areaStr)
        }
    }
}

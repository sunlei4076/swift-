//
//  PopoverAreaSelectView.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/26.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class PopoverCategorySelectView: UIView,UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet weak var titleBGView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonBGView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var firstCate:[MallCateModel] = []
    
    private var secondCate:[MallCateModel] = []
    private var thirdCate:[MallCateModel] = []
    private var firstSelect:Int = 0
    private var secondSelect:Int = 0
    private var thirdSelect:Int = 0
    
    private var selectBlock:((Int, Int, Int)->())!

    private func initControl(){
        self.titleBGView.backgroundColor = GlobalStyleFontColor
        self.buttonBGView.backgroundColor = UIColor.blackColor()
        self.titleLabel.font = GGetBigCustomFont()
    }
    
    private func initData(){
        self.secondCate = self.firstCate[self.firstSelect].nextCateArray
        if self.secondCate.count != 0{
            
            self.thirdCate = self.secondCate[self.secondSelect].nextCateArray
        }else{
            self.thirdCate = [];
        }
        
//        self.thirdCate = self.secondCate[self.secondSelect].nextCateArray
        self.pickerView.reloadAllComponents()
        self.pickerView.selectRow(self.firstSelect, inComponent: 0, animated: true)
        self.pickerView.selectRow(self.secondSelect, inComponent: 1, animated: true)
        self.pickerView.selectRow(self.thirdSelect, inComponent: 2, animated: true)
    }
    
    class func instantiateFromNib() -> PopoverCategorySelectView {
        let view = UINib(nibName: "PopoverCategorySelectView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! PopoverCategorySelectView
        
        return view
    }
    
    func show(inView:UIView, title:String, data:[MallCateModel], defaultFirst:Int, defaultSecond:Int, defaultThird:Int, selectedDone:(firstCateIndex:Int, secondCateIndex:Int, thirdCateIndex:Int)->()){
        self.firstCate = data
        self.firstSelect = defaultFirst
        self.secondSelect = defaultSecond
        self.thirdSelect = defaultThird
        self.initControl()
        self.titleLabel.text = title
        self.selectBlock = selectedDone
        self.initData()
        self.frame = CGRectMake(0, 0, inView.bounds.size.width, inView.bounds.size.height)
        inView.addSubview(self)
    }
    
    @IBAction func actionCancel(sender: AnyObject) {
        
        self.removeFromSuperview()
    }
    @IBAction func actionOk(sender: AnyObject) {
        
        self.removeFromSuperview()
        
        if self.selectBlock != nil {
            self.selectBlock(self.firstSelect,  self.secondSelect,  self.thirdSelect)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rtn = 0
        switch component{
        case 0:
            rtn = self.firstCate.count
        case 1:
            rtn = self.secondCate.count
        case 2:
            rtn = self.thirdCate.count
        default:
            break
        }
        return rtn
    }
    
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel()
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = GGetCustomFontWithSize(13.0)
        label.textColor = UIColor.blackColor()
        label.frame = CGRectMake(0, 0, pickerView.bounds.size.width/3, 20)
        switch component{
        case 0:
            label.text = self.firstCate[row].cate_name
        case 1:
            label.text = self.secondCate[row].cate_name
        case 2:
            label.text = self.thirdCate[row].cate_name
        default:
            break
        }
        return label
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
        case 0:
            self.firstSelect = row
            self.updateSecondCateArray()
            self.updateThirdCateArray()
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 1:
            self.secondSelect = row
            self.updateThirdCateArray()
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        case 2:
            self.thirdSelect = row
        default:
            break
        }
    }
    
    private func updateSecondCateArray(){
        self.secondSelect = 0
        self.secondCate = self.firstCate[self.firstSelect].nextCateArray
    }
    
    private func updateThirdCateArray(){
        self.thirdSelect = 0
        
        if self.secondCate.count != 0{
            
            self.thirdCate = self.secondCate[self.secondSelect].nextCateArray
        }else{
            self.thirdCate = [];
        }
    }
}

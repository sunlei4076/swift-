//
//  CheckOrderCell.swift
//  KoalaBusinessDistrict
//
//  Created by Adobe on 15/12/10.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class CheckOrderCell: UITableViewCell {

    var num:Int = 0

    var good_num = ""
    
    var cellModel = ShopGoodModel()


    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var MinusButton: UIButton!
    @IBOutlet weak var orderTextField: UITextField!
    @IBOutlet weak var checkImageView: UILabel!
    @IBOutlet weak var orderImageView: UIImageView!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    var cellData:ShopGoodModel = ShopGoodModel(){
        didSet{
            
        self.checkImageView.text =  cellData.goods_name

        self.orderImageView.setImageWithURL(NSURL(string: cellData.default_image)!, placeholderImage: nil)

            self.orderTextField.hidden = true
            self.MinusButton.hidden = true
            self.addButton.hidden = false
            
        }
        
    }
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func minusButtonClick(sender: AnyObject) {
   
        num--
        self.orderTextField.text! = String(num)
        if num == 0{
            self.MinusButton.hidden = true
            self.orderTextField.hidden = true
        }else{
            
            self.good_num = self.orderTextField.text!
            
             cellData.good_num = num

        }
    }

    @IBAction func addButtonClick(sender: AnyObject) {
        
        self.MinusButton.hidden = false
        self.orderTextField.hidden = false
        
        num++
        self.orderTextField.text! = String(num)
        
        self.good_num = self.orderTextField.text!
        cellData.good_num = num
        
    }
    

    static func cellIdentifier()->String{
        return "CheckOrderDetailCell"
    }
}

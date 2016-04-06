//
//  BankCardCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/12.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class BankCardCell: UITableViewCell {

    var cardData:BankCardInfoNewModel = BankCardInfoNewModel(){
        didSet{
            self.showCardTypeLabel.text = self.cardData.bank_type_name
            self.showCardNumberLabel.text = self.cardData.bank_account
        }
    }
    
    @IBOutlet weak var showCardNumberLabel: UILabel!
    @IBOutlet weak var showCardTypeLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }

    static func cellIdentifier()->String{
        return "BankCardCell"
    }
    
    static func cellHeight()->CGFloat{
        return 80.0
    }
    
    private func initControl(){
        self.backgroundColor = GlobalBgColor
        self.borderView.layer.borderWidth = 1.0
        self.borderView.layer.borderColor = GlobalGrayFontColor.CGColor
        self.showCardTypeLabel.textColor = GlobalStyleFontColor
        self.showCardNumberLabel.textColor = GlobalGrayFontColor
        
        self.showCardNumberLabel.font = GGetCustomFontWithSize(GNormalFontSize-1.0)
        self.showCardTypeLabel.font = GGetNormalCustomFont()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

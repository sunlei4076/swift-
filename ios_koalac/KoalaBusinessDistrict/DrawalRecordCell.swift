//
//  DrawalRecordCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/12.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class DrawalRecordCell: UITableViewCell {

    @IBOutlet weak var showMoneyNumLabel: UILabel!
    @IBOutlet weak var showCardInfoLabel: UILabel!
    @IBOutlet weak var showTimeLabel: UILabel!
    var recordData:DrawalRecordNewModel = DrawalRecordNewModel()
        {
        didSet{
            self.showTimeLabel.text = GTimeSecondToSting(self.recordData.apply_time, format: "yyyy-MM-dd HH:mm")
            self.showMoneyNumLabel.text = self.recordData.money
            self.showCardInfoLabel.text = self.getWantInfo(self.recordData)
        }
    }

    private func getWantInfo(record:DrawalRecordNewModel)->String{
        let cardNumber = record.bank_account
        if cardNumber.characters.count > 4{
            let index2 = cardNumber.endIndex.advancedBy(-4)
            let afterFour = cardNumber.substringFromIndex(index2)
            let rtn = record.bank_type_name + " 尾号\(afterFour)"
            return rtn
        }else{
            return record.bank_type_name + cardNumber
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }

    private func initControl(){
        self.showMoneyNumLabel.font = GGetBigCustomFont()
        self.showCardInfoLabel.font = GGetNormalCustomFont()
        self.showTimeLabel.font = GGetCustomFontWithSize(GNormalFontSize-2.0)
        
        self.showMoneyNumLabel.textColor = GlobalStyleFontColor
        self.showTimeLabel.textColor = GlobalGrayFontColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier()->String{
        return "DrawalRecordCell"
    }
    
    static func cellHeight()->CGFloat{
        return 80.0
    }
}

//
//  FaceOrderCell.swift
//  KoalaBusinessDistrict
//
//  Created by Adobe on 15/12/10.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class FaceOrderCell: UITableViewCell {


    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }


    @IBAction func btnClick(sender: AnyObject) {
        
        let VC = CheckOrdrerController()
        
        let mainVC = ProjectManager.sharedInstance.getTabSelectedNav()
        
        mainVC.pushViewController(VC, animated: true)
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func cellIdentifier()->String{
        return "faceOrderDetailCell"
    }
    
    static func CellHeight()->CGFloat{
        return 80.0
    }
    
}

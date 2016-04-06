//
//  CustomerCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/6/14.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class CustomerCell: UITableViewCell {

    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    var customerData:CustomerModel = CustomerModel(){
        didSet{
            self.headImageView.setImageWithURL(NSURL(string: self.customerData.avatar)!, placeholderImage: UIImage(named: "koalac_no_avatar"))
            self.nameLabel.text = self.customerData.name
            let starHidden = (self.customerData.attention as NSString).floatValue
            if starHidden == 1{
                self.starImageView.hidden = false
            }else{
                self.starImageView.hidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }

    private func initControl(){
        self.nameLabel.font = GGetNormalCustomFont()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func cellIdentifier()->String{
        return "CustomerCell"
    }
    
    static func cellHeight()->CGFloat{
        return  60.0
    }
}

//
//  DiscoveryCell.swift
//  koalac_PPM
//
//  Created by liuny on 15/8/21.
//  Copyright (c) 2015年 考拉先生. All rights reserved.
//

import UIKit

class DiscoveryCell: UITableViewCell {

    @IBOutlet weak var updateFlagImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var updateNumLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var cellData:DiscoveryModel = DiscoveryModel(){
        didSet{
            self.iconImage.setImageWithURL(NSURL(string: self.cellData.discovery_IconUrl)!, placeholderImage: nil)
            self.titleLabel.text = self.cellData.discovery_Title
            
            let updateInt = (self.cellData.discovery_Update as NSString).integerValue
            if updateInt == 0{
//                self.updateView.hidden = true
                self.updateFlagImage.hidden = true
            }else{
                self.updateFlagImage.hidden = false
//                self.updateView.hidden = false
//                self.updateNumLabel.text = String(updateInt)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initControl()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initControl(){
        self.titleLabel.font = GGetNormalCustomFont()
        self.updateView.layer.cornerRadius = 11.0
        self.updateView.layer.masksToBounds = true
    }
    
    static func cellIdentifier()->String{
        return "DiscoveryCell"
    }

}

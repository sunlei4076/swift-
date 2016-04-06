//
//  MyShopColleHeader.swift
//  KoalaBusinessDistrict
//
//  Created by seekey on 15/11/12.
//  Copyright © 2015年 koalac. All rights reserved.
//

import UIKit

class MyShopColleHeader: UICollectionReusableView {
    
    @IBOutlet weak var colletHead: UILabel!
    
    override func awakeFromNib() {
        colletHead.font =  UIFont(name: CustomFontName, size: (GSmallFontSize - 1))!
    }
    
}

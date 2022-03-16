//
//  CategoryCell.swift
//  News-Hafizh
//
//  Created by Hafizh Caesandro Kevinoza on 16/03/22.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var newSourceCategoryColor: UIImageView!
    @IBOutlet weak var newsSourceCategoryLabel: UILabel!
    @IBOutlet weak var categoryLabelName: UILabel!
    @IBOutlet weak var imageViewTest: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 9
        
        newSourceCategoryColor.layer.masksToBounds = true
        newSourceCategoryColor.layer.cornerRadius  = newSourceCategoryColor.frame.width/2
    }
    
}

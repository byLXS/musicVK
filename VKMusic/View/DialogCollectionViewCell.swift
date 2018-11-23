//
//  DialogCollectionViewCell.swift
//  VKMusic
//
//  Created by Robert on 14.11.2018.
//  Copyright © 2018 Robert. All rights reserved.
//

import UIKit

class DialogCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var dialogImageView: UIImageView!
    @IBOutlet weak var selectedCellImageView: UIImageView!
    @IBOutlet weak var dialogLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dialogImageView?.layer.cornerRadius = (dialogImageView?.layer.frame.size.width)! / 2
        dialogImageView?.clipsToBounds = true
        
        // Initialization code
    }
    
    
    func setup(_ model: Dialog) {
        selectedCellImageView.isHidden = true
        self.dialogImageView?.image = UIImage(data: model.photo as Data)
        self.dialogLabel!.text = model.firstName
    }
}

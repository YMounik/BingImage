//
//  PopoverCollectionViewCell.swift
//  BingImage
//

import UIKit

class PopoverCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var animalTitleLabel: UILabel!
    var animal: Animal!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateItemAt(indexPath: IndexPath) {
        animalImageView.imageFromServerURL(urlString: animal.thumbnailUrl)
        animalTitleLabel.text = animal.name
    }
}

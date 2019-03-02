//
//  ImagesCollectionViewCell.swift
//  BingImage
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var animalImageView: UIImageView!
    var animal: Animal!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateItemAt(indexPath: IndexPath) {
        animalImageView.imageFromServerURL(urlString: animal.thumbnailUrl)
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
}


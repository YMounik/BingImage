//
//  PopoverViewController.swift
//  BingImage
//

import UIKit

class PopoverViewController: UIViewController {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var animalsDataObjectsArray: [Animal] = []
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.prepareView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imagesCollectionView.scrollToItem(at: selectedIndexPath, at: .top, animated: false)
    }
    
    func prepareView() {
        self.imagesCollectionView.register(UINib.init(nibName: NibNames.PopoverCollectionViewCell.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.PopoverImagesCollectionViewCellIdentifier.rawValue)
        self.imagesCollectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PopoverViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.animalsDataObjectsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imagesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.PopoverImagesCollectionViewCellIdentifier.rawValue, for: indexPath) as? PopoverCollectionViewCell
        imagesCollectionViewCell?.animal = self.animalsDataObjectsArray[indexPath.item]
        imagesCollectionViewCell?.updateItemAt(indexPath: indexPath)
        return imagesCollectionViewCell ?? PopoverCollectionViewCell()
    }
}

extension PopoverViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height - 128)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

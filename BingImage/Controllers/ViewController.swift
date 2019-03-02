//
//  ViewController.swift
//  BingImage
//

import UIKit

enum CellIdentifiers: String {
    case ImagesCollectionViewCellIdentifier = "imagesCollectionViewCellIdentifier"
    case PopoverImagesCollectionViewCellIdentifier = "popoverImagesCollectionViewCellIdentifier"
}

enum NibNames: String {
    case ImagesCollectionViewCell = "ImagesCollectionViewCell"
    case PopoverCollectionViewCell = "PopoverCollectionViewCell"
}

class ViewController: UIViewController {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var animalsDataObjectsArray: [Animal] = []
    var filteredAnimalsDataObjectsArray: [Animal] = []
    var searchString: String = "cat"
    var isSearchON = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
        // Do any additional setup after loading the view, typically from a nib.
        self.getBingImagesforSearch(string: self.searchString, offset: 0, count: 10)
    }
    
    func prepareView() {
        self.imagesCollectionView.register(UINib.init(nibName: NibNames.ImagesCollectionViewCell.rawValue, bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.ImagesCollectionViewCellIdentifier.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func getBingImagesforSearch(string: String, offset: Int, count: Int) {
        
        let parameters: [String: String] = ["searchString": string,
                                            "offset": "\(offset)",
                                            "count": "\(count)"]
        BIHTTPSessionManager.getBingImagesFor(parameters, { (response, data) in
            print("Response %@", data)
            if let responseData = data as? [String: Any] {
                if let dataArray = responseData["value"] as? [[String: Any]] {
                    for dict in dataArray {
                        if dict.isEmpty == false {
                            let animal = Animal.init(with: dict)
                            self.animalsDataObjectsArray.append(animal)
                        }
                    }
                    if self.animalsDataObjectsArray.count > 0 {
                        DispatchQueue.main.async {
                            self.imagesCollectionView.reloadData()
                        }
                    }
                }
            }
        }) { (respose, error) in
            print("Error", error ?? "")
        }
    }
    
    //MARK: Keyboard Listeners
    @objc func keyBoardWillShow(notification: NSNotification) {
        //handle appearing of keyboard here
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.imagesCollectionView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: keyboardSize.height+10, right: 0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
                
            }, completion: { (completed:Bool) in
                
            })
        }
    }
    
    @objc func keyBoardWillHide(notification: NSNotification) {
        //handle dismiss of keyboard here
        self.imagesCollectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom:10, right: 10)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
        }, completion: { (completed:Bool) in
            
        })
    }
    
    @IBAction func dismissKeyboardOnTap(_ sender: Any) {
        self.view.endEditing(true)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.animalsDataObjectsArray.count - 1 {  //numberofitem count
            self.getBingImagesforSearch(string: self.searchString, offset: self.animalsDataObjectsArray.count, count: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let popOverViewController = self.storyboard?.instantiateViewController(withIdentifier: "PopoverViewController") as? PopoverViewController {
            popOverViewController.animalsDataObjectsArray = self.animalsDataObjectsArray
            popOverViewController.selectedIndexPath = indexPath
            self.present(popOverViewController, animated: true) {
                
            }
        }
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchON ? self.filteredAnimalsDataObjectsArray.count : self.animalsDataObjectsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imagesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.ImagesCollectionViewCellIdentifier.rawValue, for: indexPath) as? ImagesCollectionViewCell
        imagesCollectionViewCell?.animal = isSearchON ? self.filteredAnimalsDataObjectsArray[indexPath.item] : self.animalsDataObjectsArray[indexPath.item]
        imagesCollectionViewCell?.updateItemAt(indexPath: indexPath)
        return imagesCollectionViewCell ?? ImagesCollectionViewCell()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 20, height: 150)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:10, left:10, bottom:10, right:10)
    }

}

extension ViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredAnimalsDataObjectsArray = self.animalsDataObjectsArray.filter{$0.name.contains(searchText)}
        if searchBar.text == "" {
            isSearchON = false
        } else {
            isSearchON = true
        }
        self.imagesCollectionView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearchON = false
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.imagesCollectionView))! && touch.view != self.imagesCollectionView {
            return false
        }
        return true
    }
}


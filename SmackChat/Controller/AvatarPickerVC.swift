//
//  AvatarPickerVC.swift
//  SmackChat
//
//  Created by sanchez on 01.12.17.
//  Copyright © 2017 KOT. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var avatarCellType = AvatarType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AVATAR_CELL_ID, for: indexPath) as? AvatarCell {
            cell.configureCell(index: indexPath.item, type: avatarCellType)
            return cell
        }
        return AvatarCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numOfColumns: CGFloat = 3
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        if UIScreen.main.bounds.width > 320 {
            numOfColumns = 4
        }
        
        let cellDimension = ((collectionView.bounds.width - padding) - (numOfColumns - 1) * spaceBetweenCells) / numOfColumns
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarCellType == .dark {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        } else {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            avatarCellType = .dark
        } else {
            avatarCellType = .light
        }
        collectionView.reloadData()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

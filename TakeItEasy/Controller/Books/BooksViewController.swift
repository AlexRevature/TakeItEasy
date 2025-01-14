//
//  BooksViewController.swift
//  TakeItEasy
//
//  Created by admin on 1/14/25.
//

import UIKit

class BooksViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var searchBarTitleOrAuthor: UISearchBar!
    @IBOutlet weak var collectionRecipes: UICollectionView!
    @IBOutlet weak var collectionTechnical: UICollectionView!
    @IBOutlet weak var collectionGeneral: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

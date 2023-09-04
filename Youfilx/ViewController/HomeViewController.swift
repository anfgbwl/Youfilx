//
//  HomeViewController.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/04.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Variables
    private var thumbnail: [UIImage] = []

    // MARK: - UI Components
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HomeViewCell.self, forCellWithReuseIdentifier: HomeViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...25 {
            thumbnail.append(UIImage(named: "1")!)
            thumbnail.append(UIImage(named: "2")!)
        }

        setupUI()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    // MARK: - setupUI
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "닉네임"
        
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnail.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewCell.identifier, for: indexPath) as? HomeViewCell else {
            fatalError("ERROR")
        }
        let image = self.thumbnail[indexPath.row]
        let title = "영상 타이틀"
        cell.configure(with: image, and: title)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width/2) - 6
        return CGSize(width: size, height: 100)
//        let size = self.view.frame.width
//        return CGSize(width: size, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
}

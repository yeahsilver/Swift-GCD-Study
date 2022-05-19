//
//  ViewController.swift
//  Concurrency
//
//  Created by Allen on 2020/02/04.
//  Copyright © 2020 allen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    
    private let reuseIdentifier = "PhotoCell"
    
    private let cellSpacing: CGFloat = 1
    private let columns: CGFloat = 3
    
    private var urls: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Photos.plist에서 뽑아내서, urls에 저장하기
        // Target Membership설정
        guard let url = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
            let contents = try? Data(contentsOf: url),
            let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
            let serialUrls = serial as? [String]
            else { return print("무엇인가 잘못되었습니다...") }
        
        urls = serialUrls.compactMap { URL(string: $0) }
        
        setupCollectionView()
        setupLayouts()
        
    }
    
    func setupCollectionView() {
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        let width = (UIScreen.main.bounds.width - cellSpacing * 2) / columns
        layout.itemSize = CGSize(width: width , height: width)
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
    }
    
    private func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        cell.display(image: nil)
        
//        downloadWithGlobalQueue(at: indexPath)
        downloadWithUrlSession(at: indexPath)
        
        return cell
    }
    
    private func downloadWithGlobalQueue(at indexPath: IndexPath) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            let url = self.urls[indexPath.row]
            
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                if let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoCell {
                    cell.display(image: image)
                }
            }
            
        }
    }
    
    private func downloadWithUrlSession(at indexPath: IndexPath) {
        URLSession.shared.dataTask(with: urls[indexPath.item]) { [weak self] data, response, error in
            
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                if let cell = self.collectionView.cellForItem(at: indexPath) as? PhotoCell {
                    cell.display(image: image)
                }
            }
        }.resume()
    }
}

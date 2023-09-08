//
//  DImageView.swift
//  Youfilx
//
//  Created by hong on 2023/09/08.
//

import UIKit

class DImageView: UIImageView {
    private var imageURL: String?
    private let apiManager = APIManager.shared
    init(_ imageURL: String? = nil) {
        self.imageURL = imageURL
        super.init(frame: .zero)
        if let imageURL {
            fetchImage(imageURL)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchImage(_ imageURL: String) {
        apiManager.request(ImageAPI.image(imageURL)) { [weak self] result in
            switch result {
            case let .success(data):
                self?.image = UIImage(data: data)
            case let .failure(error):
                print(error)
            }
        }
    }
    
}

//
//  CheckableButton.swift
//  Youfilx
//
//  Created by hong on 2023/09/06.
//

import UIKit

class ImageChangableWhenSelectedButton: UIButton {

    private var isChecked = false
    
    private let normalImage: UIImage?
    private let selectedImage: UIImage?
    private var checked: ((Bool) -> Void)?
    
    init(normalImage: UIImage?, selectedImage: UIImage?, checked: ((Bool) -> Void)? = nil) {
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.checked = checked
        super.init(frame: .zero)
        setImage(normalImage, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        isChecked = !isChecked
        setImage(isChecked ? selectedImage : normalImage, for: .normal)
        checked?(isChecked)
    }

}

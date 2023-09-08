//
//  BackgroundChangableWhenTappedUIStackView.swift
//  Youfilx
//
//  Created by hong on 2023/09/06.
//

import UIKit

class BackgroundColorAlphaChangeLikeUIButtonWhenTappedUIStackView: UIStackView {
    
    var touched: (() -> Void)?

    init(_ touched: (() -> Void)? = nil) {
        self.touched = touched
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = backgroundColor?.withAlphaComponent(0.5)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = backgroundColor?.withAlphaComponent(1.0)
        touched?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = backgroundColor?.withAlphaComponent(1.0)
    }
  
}

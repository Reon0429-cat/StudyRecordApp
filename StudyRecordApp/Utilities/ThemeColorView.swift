//
//  ThemeColorView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/11.
//

import UIKit

protocol ThemeColorViewDelegate: AnyObject {
    func themeColorViewDidTapped(nextSelectedView: UIView)
}

final class ThemeColorView: UIView {
    
    weak var delegate: ThemeColorViewDelegate?
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: .eyedropper)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.themeColorViewDidTapped(nextSelectedView: self)
    }
    
    func setup() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func hideImage(_ isHidden: Bool) {
        imageView.isHidden = isHidden
    }
    
}

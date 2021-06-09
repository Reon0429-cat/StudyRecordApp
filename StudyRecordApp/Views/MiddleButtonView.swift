//
//  MiddleButton.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/04.
//

import UIKit

protocol MiddleButtonViewDelegate: UIViewController {
    func didTapped()
}

extension MiddleButtonViewDelegate {
    func didTapped() {
        let additionalStudyRecordVC = AdditionalStudyRecordViewController.instantiate()
        present(additionalStudyRecordVC, animated: true, completion: nil)
    }
}

final class MiddleButtonView: UIView {
    
    var delegate: MiddleButtonViewDelegate?
    
    @IBOutlet weak var middleButton: UIButton! {
        didSet {
            middleButton.tintColor = .white
            middleButton.imageView?.contentMode = .scaleAspectFit
            middleButton.contentHorizontalAlignment = .fill
            middleButton.contentVerticalAlignment = .fill
            middleButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    private func loadNib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.6
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .blue
        self.layer.cornerRadius = self.frame.size.width / 2
        self.addSubview(view)
    }
    
    @IBAction private func middleButtonDidTapped(_ sender: Any) {
        delegate?.didTapped()
    }
    
}

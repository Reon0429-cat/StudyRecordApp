//
//  CategoryKeyboardView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/18.
//

import UIKit

protocol CategoryKeyboardViewDelegate: AnyObject {
    func categoryButtonDidTapped()
}

final class CategoryKeyboardView: UIView {

    weak var delegate: CategoryKeyboardViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()

    }

    private func setup() {
        backgroundColor = .secondarySystemGroupedBackground

        let categoryButton = UIButton()
        categoryButton.setTitle(L10n.largeCategory + " >")
        categoryButton.titleLabel?.font = .systemFont(ofSize: 20)
        categoryButton.addTarget(self,
                                 action: #selector(categoryButtonDidTapped),
                                 for: .touchUpInside)
        categoryButton.setTitleColor(.dynamicColor(light: .black, dark: .white),
                                     for: .normal)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(categoryButton)
        NSLayoutConstraint.activate([
            categoryButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }

    @objc
    private func categoryButtonDidTapped() {
        delegate?.categoryButtonDidTapped()
    }

}

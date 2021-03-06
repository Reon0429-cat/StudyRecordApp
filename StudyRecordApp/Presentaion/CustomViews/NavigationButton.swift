//
//  NavigationButton.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/20.
//

import UIKit

enum NavigationButtonType {
    case save
    case dismiss
    case edit
    case completion

    var title: String {
        switch self {
        case .save: return L10n.save
        case .dismiss: return L10n.close
        case .edit: return L10n.edit
        case .completion: return L10n.done
        }
    }
}

protocol NavigationButtonDelegate: AnyObject {
    func titleButtonDidTapped(type: NavigationButtonType)
}

final class NavigationButton: UIButton {

    @IBOutlet private weak var titleButton: UIButton!
    @IBOutlet private weak var bottomView: UIView!

    weak var delegate: NavigationButtonDelegate?
    var type: NavigationButtonType? {
        didSet {
            if let type = type {
                titleButton.setTitle(type.title)
            }
        }
    }

    @IBAction private func titleButtonDidTapped(_ sender: Any) {
        if let type = type {
            delegate?.titleButtonDidTapped(type: type)
        }
    }

    func isEnabled(_ bool: Bool) {
        titleButton.isEnabled = bool
        bottomView.backgroundColor = bool ? .black : .gray
    }

    func changeType(to type: NavigationButtonType) {
        self.type = type
    }

    func isType(_ type: NavigationButtonType) -> Bool {
        self.type == type
    }

    func changeTitle(_ title: String) {
        titleButton.setTitle(title)
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
        guard let view = UINib(
            nibName: String(describing: Swift.type(of: self)),
            bundle: nil
        ).instantiate(
            withOwner: self,
            options: nil
        ).first as? UIView else {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
        setup()
    }

    private func setup() {
        bottomView.backgroundColor = .black
        self.setShadow()
        titleButton.setTitle(type?.title ?? "")
    }

}

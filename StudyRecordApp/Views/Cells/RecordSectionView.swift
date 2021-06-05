//
//  RecordSectionView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

protocol RecordSectionViewDelegate: UIViewController {
    func didTapped()
}

extension RecordSectionViewDelegate {
    func didTapped() {
        // MARK: - ToDo 画面遷移
    }
}

final class RecordSectionView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var memoButton: UIButton!
    @IBOutlet private weak var todayStudyTimeLabel: UILabel!
    @IBOutlet private weak var totalStudyTimeLabel: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    var didClickedButton: (() -> Void)?
    private var isExpanded = false
    var delegate: RecordSectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseView.layer.cornerRadius = 10
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTapped))
        baseView.addGestureRecognizer(tapGR)
        
    }
    
    @IBAction private func memoButtonDidTapped(_ sender: Any) {
        UIView.setAnimationsEnabled(false)
        memoButton.setTitle("\(isExpanded ? "▼" : "▲") メモ", for: .normal)
        memoButton.layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
        isExpanded.toggle()
        didClickedButton?()
    }
    
    func configure(record: Record, didClickedButton: @escaping () -> Void) {
        self.didClickedButton = didClickedButton
        titleLabel.text = record.title
        todayStudyTimeLabel.text = "今日: \(record.time.today)分"
        totalStudyTimeLabel.text = "合計: \(record.time.total)分"
    }
    
    @objc private func didTapped() {
        delegate?.didTapped()
    }
    
}

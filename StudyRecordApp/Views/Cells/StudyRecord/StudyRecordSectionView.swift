//
//  StudyRecordSectionView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/06/05.
//

import UIKit

private enum MemoState {
    case expanded
    case shrinked
    var title: String {
        switch self {
            case .expanded: return "▲ メモ"
            case .shrinked: return "▼ メモ"
        }
    }
    mutating func toggle() {
        switch self {
            case .expanded: self = .shrinked
            case .shrinked: self = .expanded
        }
    }
}

protocol StudyRecordSectionViewDelegate: AnyObject {
    func baseViewDidTapped()
}

final class StudyRecordSectionView: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var memoButton: UIButton!
    @IBOutlet private weak var todayStudyTimeLabel: UILabel!
    @IBOutlet private weak var totalStudyTimeLabel: UILabel!
    
    var didClickedButton: (() -> Void)?
    var delegate: StudyRecordSectionViewDelegate?
    private var memoState: MemoState = .shrinked
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBaseView()
        
    }
    
    @IBAction private func memoButtonDidTapped(_ sender: Any) {
        memoState.toggle()
        memoButton.setTitle(memoState.title)
        didClickedButton?()
    }
    
    func configure(record: Record,
                   didClickedButton: @escaping () -> Void) {
        self.didClickedButton = didClickedButton
        setupTitleLabel(record: record)
        setupTimeLabel(record: record)
        setupMemoButton(record: record)
    }
    
    @objc private func baseViewDidTapped() {
        delegate?.baseViewDidTapped()
    }
    
}

// MARK: - setup
private extension StudyRecordSectionView {
    
    func setupBaseView() {
        baseView.layer.cornerRadius = 10
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(baseViewDidTapped))
        baseView.addGestureRecognizer(tapGR)
    }
    
    func setupTitleLabel(record: Record) {
        titleLabel.text = record.title
    }
    
    func setupTimeLabel(record: Record) {
        todayStudyTimeLabel.text = {
            if record.time.today >= 60 {
                return "今日: \(record.time.today / 60)時間"
            }
            return "今日: \(record.time.today)分"
        }()
        totalStudyTimeLabel.text = {
            if record.time.total >= 60 {
                return "合計: \(record.time.total / 60)時間"
            }
            return "合計: \(record.time.total)分"
        }()
    }
    
    func setupMemoButton(record: Record) {
        memoState = record.isExpanded ? .expanded : .shrinked
        memoButton.setTitle(memoState.title)
        if record.memo.isEmpty {
            memoButton.isHidden = true
        } else {
            memoButton.isHidden = false
        }
    }
    
}

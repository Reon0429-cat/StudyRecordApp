//
//  RecordTableViewCell.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/19.
//

import UIKit

protocol RecordTableViewCellDelegate: AnyObject {
    func baseViewTapDidRecognized(row: Int)
    func baseViewLongPressDidRecognized()
    func memoButtonDidTapped(row: Int)
    func deleteButtonDidTappped(row: Int)
}

final class RecordTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var memoButton: UIButton!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var todayStudyTimeLabel: UILabel!
    @IBOutlet private weak var totalStudyTimeLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var memoTextView: UITextView!
    
    private enum MemoState {
        case expanded
        case shrinked
        var title: String {
            switch self {
                case .expanded: return "▲ " + LocalizeKey.memo.localizedString()
                case .shrinked: return "▼ " + LocalizeKey.memo.localizedString()
            }
        }
        mutating func toggle() {
            switch self {
                case .expanded: self = .shrinked
                case .shrinked: self = .expanded
            }
        }
    }
    private var memoState: MemoState = .shrinked
    weak var delegate: RecordTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        setupBaseView()
        setupDeleteButton()
        setBorderColor()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setBorderColor()
        }
    }
    
    @IBAction private func memoButtonDidTapped(_ sender: Any) {
        memoState.toggle()
        memoButton.setTitle(memoState.title)
        delegate?.memoButtonDidTapped(row: self.tag)
    }
    
    @IBAction private func deleteButtonDidTappped(_ sender: Any) {
        delegate?.deleteButtonDidTappped(row: self.tag)
    }
    
    func configure(record: Record) {
        setupTitleLabel(record: record)
        setupTimeLabel(record: record)
        setupMemoButton(record: record)
        setupMemoTextView(record: record)
    }
    
    func changeMode(isEdit: Bool, isEvenIndex: Bool) {
        if isEdit {
            deleteButton.setFade(.in)
            baseView.vibrate(.start, isEvenIndex: isEvenIndex)
        } else {
            deleteButton.setFade(.out)
            baseView.vibrate(.stop)
        }
    }
    
    private func isToday(_ history: History) -> Bool {
        // MARK: - ToDo ローカライズする
        let historyDate = "\(history.year)年\(history.month)月\(history.day)日"
        let today = Converter.convertToString(from: Date(), format: "yyyy年M月d日")
        return historyDate == today
    }
    
}

// MARK: - setup
private extension RecordTableViewCell {
    
    func setupBaseView() {
        baseView.layer.cornerRadius = 20
        let tapGR = UITapGestureRecognizer(target: self,
                                           action: #selector(baseViewTapDidRecognized))
        baseView.addGestureRecognizer(tapGR)
        let longPressGR = UILongPressGestureRecognizer(target: self,
                                                       action: #selector(baseViewLongPressDidRecognized))
        longPressGR.minimumPressDuration = 1
        baseView.addGestureRecognizer(longPressGR)
        baseView.layer.borderWidth = 1
    }
    
    @objc
    func baseViewTapDidRecognized() {
        delegate?.baseViewTapDidRecognized(row: self.tag)
    }
    
    @objc
    func baseViewLongPressDidRecognized() {
        delegate?.baseViewLongPressDidRecognized()
    }
    
    func setupDeleteButton() {
        deleteButton.isHidden = true
        deleteButton.cutToCircle()
        guard let image = UIImage(systemName: "xmark.circle.fill") else { return }
        deleteButton.setImage(image.setColor(.dynamicColor(light: .black, dark: .white)))
    }
    
    func setupTitleLabel(record: Record) {
        titleLabel.text = record.title
    }
    
    func setupTimeLabel(record: Record) {
        let todayText = LocalizeKey.today.localizedString()
        let hourText = LocalizeKey.shortHour.localizedString()
        let minuteText = LocalizeKey.shortMinute.localizedString()
        let totalText = LocalizeKey.total.localizedString()
        var today: Int = {
            record.histories?.forEach { history in
                if isToday(history) {
                    today += (history.hour * 60 + history.minutes)
                }
            }
            return today
        }()
        todayStudyTimeLabel.text = {
            if today >= 60 {
                return todayText + ": " + "\(today / 60) " + hourText
            }
            return todayText + ": " + "\(today / 60) " + minuteText
        }()
        var total: Int = {
            record.histories?.forEach { history in
                total += (history.hour * 60 + history.minutes)
            }
            return total
        }()
        totalStudyTimeLabel.text = {
            if total >= 60 {
                return totalText + ": " + "\(total / 60) " + hourText
            }
            return totalText + ": " + "\(total / 60) " + minuteText
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
    
    func setupMemoTextView(record: Record) {
        memoTextView.layer.cornerRadius = 10
        memoTextView.isEditable = false
        memoTextView.backgroundColor = .clear
        memoTextView.layer.borderWidth = 1
        memoTextView.text = record.memo
    }
    
    func setBorderColor() {
        memoTextView.layer.borderColor = UIColor.dynamicColor(light: .black, dark: .white).cgColor
        baseView.layer.borderColor = UIColor.dynamicColor(light: .black, dark: .white).cgColor
    }
    
}

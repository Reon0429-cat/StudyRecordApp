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
    
    weak var delegate: RecordTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        setupBaseView()
        setupDeleteButton()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: self.traitCollection) {
            setColor()
        }
    }
    
    func configure(record: Record,
                   studyTime: (todayText: String,
                               totalText: String)) {
        setupTitleLabel(record: record)
        setupTimeLabel(record: record,
                       studyTime: studyTime)
        setupMemoButton(record: record)
        setupMemoTextView(record: record)
        setColor()
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
    
}

// MARK: - IBAction func
private extension RecordTableViewCell {
    
    @IBAction func memoButtonDidTapped(_ sender: Any) {
        delegate?.memoButtonDidTapped(row: self.tag)
    }
    
    @IBAction func deleteButtonDidTappped(_ sender: Any) {
        delegate?.deleteButtonDidTappped(row: self.tag)
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
        baseView.backgroundColor = .dynamicColor(light: .white,
                                                 dark: .secondarySystemGroupedBackground)
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
    }
    
    func setupTitleLabel(record: Record) {
        titleLabel.text = record.title
    }
    
    func setupTimeLabel(record: Record,
                        studyTime: (todayText: String,
                                    totalText: String)) {
        todayStudyTimeLabel.text = studyTime.todayText
        totalStudyTimeLabel.text = studyTime.totalText
    }
    
    func setupMemoButton(record: Record) {
        let titleTriangle = record.isExpanded ?  "▲ " : "▼ "
        memoButton.setTitle(titleTriangle + LocalizeKey.memo.localizedString())
        memoButton.isHidden = record.memo.isEmpty
    }
    
    func setupMemoTextView(record: Record) {
        memoTextView.layer.cornerRadius = 10
        memoTextView.isEditable = false
        memoTextView.text = record.memo
        memoTextView.clipsToBounds = false
        memoTextView.backgroundColor = .dynamicColor(light: .white,
                                                     dark: .secondarySystemGroupedBackground)
    }
    
    func setColor() {
        baseView.setShadow(color: .dynamicColor(light: .accentColor ?? .black,
                                                dark: .accentColor ?? .white),
                           radius: 3,
                           opacity: 0.8,
                           size: (width: 2, height: 2))
        memoTextView.setShadow(color: .dynamicColor(light: .accentColor ?? .black,
                                                    dark: .accentColor ?? .white),
                               radius: 3,
                               opacity: 0.8,
                               size: (width: 2, height: 2))
        guard let image = UIImage(systemName: "xmark.circle.fill") else { return }
        let color: UIColor = .dynamicColor(light: .mainColor ?? .black,
                                           dark: .mainColor ?? .white)
        deleteButton.setImage(image.setColor(color))
    }
    
}

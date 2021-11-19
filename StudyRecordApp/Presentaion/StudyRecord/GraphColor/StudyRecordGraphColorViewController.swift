//
//  StudyRecordGraphColorViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

protocol StudyRecordGraphColorVCDelegate: AnyObject {
    func graphColorDidSelected(color: UIColor)
}

final class StudyRecordGraphColorViewController: UIViewController {

    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var decisionButton: UIButton!
    @IBOutlet private weak var graphColorView: UIView!
    @IBOutlet private weak var graphColorTileView: GraphColorTileView!

    private var selectedTileView: TileView?
    weak var delegate: StudyRecordGraphColorVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGraphColorView()
        setupGraphColorTileView()
        setupDidmissButton()
        setupTitleLabel()
        setupDidmissButton()
        setupDecisionButton()

    }

}

// MARK: - IBAction func
private extension StudyRecordGraphColorViewController {

    @IBAction func saveButtonDidTapped(_ sender: Any) {
        let color = selectedTileView?.backgroundColor ?? .clear
        delegate?.graphColorDidSelected(color: color)
        dismiss(animated: true)
    }

    @IBAction func dismissButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }

}

// MARK: - GraphColorTileViewDelegate
extension StudyRecordGraphColorViewController: GraphColorTileViewDelegate {

    func findSameColor(selectedView: TileView) {
        self.selectedTileView = selectedView
    }

    func tileViewDidTapped(selectedView: TileView) {
        if self.selectedTileView != selectedView {
            UIView.animate(withDuration: 0.1) {
                if let selectedTileView = self.selectedTileView {
                    selectedTileView.change(state: .square)
                }
            }
        }
        switch selectedView.getState() {
        case .circle:
            self.selectedTileView = nil
        case .square:
            self.selectedTileView = selectedView
        }
    }

}

// MARK: - setup
private extension StudyRecordGraphColorViewController {

    func setupGraphColorView() {
        graphColorView.layer.cornerRadius = 10
        graphColorView.backgroundColor = .dynamicColor(light: .white,
                                                       dark: .secondarySystemGroupedBackground)
    }

    func setupGraphColorTileView() {
        graphColorTileView.delegate = self
    }

    func setupDidmissButton() {
        dismissButton.setTitle(L10n.close)
    }

    func setupTitleLabel() {
        titleLabel.text = L10n.graphColor
    }

    func setupDecisionButton() {
        decisionButton.setTitle(L10n.decision)
    }

}

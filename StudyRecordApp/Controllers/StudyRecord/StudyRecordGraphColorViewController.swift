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
    
    @IBOutlet private weak var graphColorView: UIView!
    @IBOutlet private weak var graphColorTileView: GraphColorTileView!
    
    private var selectedTileView: UIView?
    weak var delegate: StudyRecordGraphColorVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGraphColorView()
        setupGraphColorTileView()
        
    }
    
}

// MARK: - IBAction func
private extension StudyRecordGraphColorViewController {
    
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        let color = selectedTileView?.backgroundColor ?? .white
        delegate?.graphColorDidSelected(color: color)
        dismiss(animated: true)
    }
    
    @IBAction func dismissButtonDidTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

// MARK: - GraphColorTileViewDelegate
extension StudyRecordGraphColorViewController: GraphColorTileViewDelegate {
    
    func findSameColor(selectedView: UIView) {
        self.selectedTileView = selectedView
    }
    
    func tileViewDidTapped(selectedView: UIView) {
        if self.selectedTileView != selectedView {
            UIView.animate(withDuration: 0.1) {
                if let selectedTileView = self.selectedTileView as? TileView {
                    selectedTileView.layer.cornerRadius = 0
                    selectedTileView.state = .square
                }
            }
        }
        if let selectedTileView = selectedView as? TileView {
            switch selectedTileView.state {
                case .circle:
                    self.selectedTileView = nil
                case .square:
                    self.selectedTileView = selectedView
            }
        }
    }
    
}

// MARK: - setup
private extension StudyRecordGraphColorViewController {
    
    func setupGraphColorView() {
        graphColorView.layer.cornerRadius = 10
    }
    
    func setupGraphColorTileView() {
        graphColorTileView.delegate = self
    }
    
}

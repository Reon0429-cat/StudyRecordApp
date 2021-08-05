//
//  StudyRecordGraphColorViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/07/31.
//

import UIKit

final class StudyRecordGraphColorViewController: UIViewController {
    
    @IBOutlet private weak var graphColorView: UIView! {
        didSet { graphColorView.layer.cornerRadius = 10 }
    }
    @IBOutlet private weak var graphColorTileView: GraphColorTileView!
    
    private var selectedTileView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphColorTileView.delegate = self
        
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func dismissButtonDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    static func instantiate() -> StudyRecordGraphColorViewController {
        let storyboard = UIStoryboard(name: "StudyRecordGraphColor", bundle: nil)
        let studyRecordGraphColorVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! StudyRecordGraphColorViewController
        studyRecordGraphColorVC.modalPresentationStyle = .overCurrentContext
        studyRecordGraphColorVC.modalTransitionStyle = .crossDissolve
        return studyRecordGraphColorVC
    }
    
}

extension StudyRecordGraphColorViewController: GraphColorTileViewDelegate {
    
    func tileViewDidTapped(selectedView: UIView) {
        if self.selectedTileView != selectedView {
            UIView.animate(withDuration: 0.1) {
                self.selectedTileView?.layer.cornerRadius = 0
            }
        }
        self.selectedTileView = selectedView
    }
    
}

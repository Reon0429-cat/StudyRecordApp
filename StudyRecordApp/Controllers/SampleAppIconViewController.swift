//
//  SampleAppIconViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/19.
//

import UIKit

// MARK: - ToDo 消す
final class SampleAppIconViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var topWaveView: WaveView!
    @IBOutlet private weak var bottomWaveView: WaveView!
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    
    enum ImageType: String, CaseIterable {
        case heartWings
        case wings
        case wing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topWaveView.create(isFill: true, marginY: 50)
        bottomWaveView.create(isFill: false, marginY: 30)
        self.view.backgroundColor = .dynamicColor(light: .white, dark: .black)
        imageView.tintColor = .mainColor
        segmentedControl.create(ImageType.allCases.map { $0.rawValue }, selectedIndex: 0)
        
    }
    
    @IBAction private func segmentedControlDidChanged(_ sender: Any) {
        let imageType = ImageType.allCases[segmentedControl.selectedSegmentIndex]
        imageView.image = UIImage(named: imageType.rawValue)
    }
    
}

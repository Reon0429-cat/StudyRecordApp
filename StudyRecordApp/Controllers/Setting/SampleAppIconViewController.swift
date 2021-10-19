//
//  SampleAppIconViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/19.
//

import UIKit

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
        imageView.tintColor = .dynamicColor(light: .black, dark: .white)
        segmentedControl.create(ImageType.allCases.map { $0.rawValue }, selectedIndex: 0)
        
    }
    
    @IBAction private func segmentedControlDidChanged(_ sender: Any) {
        let imageType = ImageType.allCases[segmentedControl.selectedSegmentIndex]
        imageView.image = UIImage(named: imageType.rawValue)
    }
    
    @IBAction private func changeIconButtonDidTapped(_ sender: Any) {
        changeIcon(name: "Yellow-Wings-Black")
    }
    
    private func changeIcon(name: String) {
        UIApplication.shared.setAlternateIconName(name) { error in
            if let error = error {
                print("DEBUG_PRINT: 失敗 :\(name)", error.localizedDescription)
                return
            }
            print("DEBUG_PRINT: 成功 :\(name)")
        }
    }
    
}

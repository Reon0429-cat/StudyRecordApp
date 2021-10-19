//
//  AppIconViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/10/19.
//

import UIKit

final class AppIconViewController: UIViewController {
    
    @IBOutlet private weak var subCustomNavigationBar: SubCustomNavigationBar!
    private let imageAssets = Asset.allImages
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubCustomNavigationBar()
        
    }
    
}

// MARK: - func
private extension AppIconViewController {
    
    func changeIcon(name: String) {
        UIApplication.shared.setAlternateIconName(name) { error in
            if let error = error {
                print("DEBUG_PRINT: 失敗 :\(name)", error.localizedDescription)
                return
            }
            print("DEBUG_PRINT: 成功 :\(name)")
        }
    }
    
}

// MARK: - SubCustomNavigationBarDelegate
extension AppIconViewController: SubCustomNavigationBarDelegate {
    
    func saveButtonDidTapped() { }
    
    func dismissButtonDidTapped() {
        dismiss(animated: true)
    }
    
    var navTitle: String {
        return L10n.appIcon
    }
    
}

// MARK: - setup
private extension AppIconViewController {
    
    func setupSubCustomNavigationBar() {
        subCustomNavigationBar.delegate = self
        subCustomNavigationBar.saveButton(isHidden: true)
    }
    
}

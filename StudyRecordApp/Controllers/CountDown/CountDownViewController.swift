//
//  CountDownViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/15.
//

import UIKit

protocol CountDownVCDelegate: AnyObject {
    func viewWillAppear(index: Int)
}

final class CountDownViewController: UIViewController {
    
    weak var delegate: CountDownVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.viewWillAppear(index: self.view.tag)

    }
    
}

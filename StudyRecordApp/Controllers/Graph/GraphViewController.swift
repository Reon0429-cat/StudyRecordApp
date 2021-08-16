//
//  GraphViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/08/15.
//

import UIKit

protocol GraphVCDelegate: AnyObject {
    func viewWillAppear(index: Int)
}

final class GraphViewController: UIViewController {
    
    weak var delegate: GraphVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        delegate?.viewWillAppear(index: self.view.tag)

    }
    
    static func instantiate() -> GraphViewController {
        let storyboard = UIStoryboard(name: "Graph", bundle: nil)
        let graphVC = storyboard.instantiateViewController(
            identifier: String(describing: self)
        ) as! GraphViewController
        return graphVC
    }
    
}

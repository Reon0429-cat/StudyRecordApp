//
//  GraphKindSelectingViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/08.
//

import UIKit

enum SelectedGraphType: Int, CaseIterable {
    case line
    case bar
    case dot
    
    var title: String {
        switch self {
            case .line: return "ライン"
            case .bar: return "バー"
            case .dot: return "ドット"
        }
    }
}

final class GraphKindSelectingViewController: UIViewController {
    
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    @IBOutlet private weak var lineShapeSwitch: UISwitch!
    @IBOutlet private weak var fillAreaSwitch: UISwitch!
    @IBOutlet private weak var addDotsSwitch: UISwitch!
    @IBOutlet private weak var dotShapeSwitch: UISwitch!
    @IBOutlet private weak var widthSlider: UISlider!
    
    private var graphUseCase = GraphUseCase(
        repository: GraphRepository(
            dataStore: RealmGraphDataStore()
        )
    )
    private var isSmooth: Bool = false
    private var isFilled: Bool = false
    private var withDots: Bool = true
    private var isSquare: Bool = false
    private var width: Float = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControl()
        
        isSmooth = graphUseCase.graph.line.isSmooth
        isFilled = graphUseCase.graph.line.isFilled
        withDots = graphUseCase.graph.line.withDots
        isSquare = graphUseCase.graph.dot.isSquare
        width = graphUseCase.graph.bar.width
        
    }
    
    @IBAction private func segmentedControlDidTapped(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction private func saveButtonDidTapped(_ sender: Any) {
        // 更新処理
    }
    
    @IBAction private func lineShapeSwitchDidToggled(_ sender: Any) {
    }
    
    @IBAction private func fillAreaSwitchDidToggled(_ sender: Any) {
    }
    
    @IBAction private func addDotsSwitchDidToggled(_ sender: Any) {
    }
    
    @IBAction private func dotShapeSwitchDidToggled(_ sender: Any) {
    }
    
    @IBAction private func widthSliderValueDidChanged(_ sender: Any) {
    }
    
    private func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        SelectedGraphType.allCases.enumerated().forEach { index, graphType in
            segmentedControl.insertSegment(withTitle: graphType.title,
                                           at: index,
                                           animated: false)
        }
        segmentedControl.selectedSegmentIndex = graphUseCase.graph.selectedType.rawValue
    }
    
}

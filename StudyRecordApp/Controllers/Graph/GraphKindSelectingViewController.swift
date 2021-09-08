//
//  GraphKindSelectingViewController.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/08.
//

import UIKit

// MARK: - ToDo この画面リファクタリング
// MARK: - ToDo 動作確認
// MARK: - ToDo 動作確認OKならこの画面のデザインを考える

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
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var lineShapeSwitch: CustomSwitch!
    @IBOutlet private weak var fillAreaSwitch: CustomSwitch!
    @IBOutlet private weak var addDotsSwitch: CustomSwitch!
    @IBOutlet private weak var dotShapeSwitch: CustomSwitch!
    @IBOutlet private weak var widthSlider: CustomSlider!
    @IBOutlet private weak var sliderLabel: UILabel!
    
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
        
        isSmooth = graphUseCase.graph.line.isSmooth
        isFilled = graphUseCase.graph.line.isFilled
        withDots = graphUseCase.graph.line.withDots
        isSquare = graphUseCase.graph.dot.isSquare
        width = graphUseCase.graph.bar.width
        
        setupSegmentedControl()
        setupStackView()
        setupSlider()
        setupSwitch()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupSwitchLayout()
        
    }
    
}

// MARK: - IBAction func
private extension GraphKindSelectingViewController {
    
    @IBAction func segmentedControlDidTapped(_ sender: UISegmentedControl) {
        filterStackView(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        let selectedType = SelectedGraphType.allCases[segmentedControl.selectedSegmentIndex]
        let graph = Graph(selectedType: selectedType,
                          line: Line(isSmooth: isSmooth,
                                     isFilled: isFilled,
                                     withDots: withDots),
                          bar: Bar(width: width),
                          dot: Dot(isSquare: isSquare))
        graphUseCase.update(graph: graph)
    }
    
    @IBAction func lineShapeSwitchDidToggled(_ sender: UISwitch) {
        isSmooth = sender.isOn
    }
    
    @IBAction func fillAreaSwitchDidToggled(_ sender: UISwitch) {
        isFilled = sender.isOn
    }
    
    @IBAction func addDotsSwitchDidToggled(_ sender: UISwitch) {
        withDots = sender.isOn
    }
    
    @IBAction func dotShapeSwitchDidToggled(_ sender: UISwitch) {
        isSquare = sender.isOn
    }
    
    @IBAction func widthSliderValueDidChanged(_ sender: UISlider) {
        width = sender.value
        sliderLabel.text = String(Int(width))
    }
    
}

// MARK: - func
private extension GraphKindSelectingViewController {
    
    func filterStackView(index: Int) {
        let graphType = SelectedGraphType.allCases[index]
        switch graphType {
            case .line:
                stackView.arrangedSubviews.enumerated().forEach { index, view in
                    if index == 4 {
                        view.isHidden = true
                    } else {
                        view.isHidden = false
                    }
                }
            case .bar:
                stackView.arrangedSubviews.enumerated().forEach { index, view in
                    if index == 4 {
                        view.isHidden = false
                    } else {
                        view.isHidden = true
                    }
                }
            case .dot:
                stackView.arrangedSubviews.enumerated().forEach { index, view in
                    if index == 3 {
                        view.isHidden = false
                    } else {
                        view.isHidden = true
                    }
                }
        }
    }
    
}

// MARK: - setup
private extension GraphKindSelectingViewController {
    
    func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        SelectedGraphType.allCases.enumerated().forEach { index, graphType in
            segmentedControl.insertSegment(withTitle: graphType.title,
                                           at: index,
                                           animated: false)
        }
        segmentedControl.selectedSegmentIndex = graphUseCase.graph.selectedType.rawValue
    }
    
    func setupStackView() {
        let index = graphUseCase.graph.selectedType.rawValue
        filterStackView(index: index)
        segmentedControl.selectedSegmentIndex = index
    }
    
    func setupSwitch() {
        lineShapeSwitch.isOn = isSmooth
        fillAreaSwitch.isOn = isFilled
        addDotsSwitch.isOn = withDots
        dotShapeSwitch.isOn = isSquare
    }
    
    func setupSlider() {
        widthSlider.value = width
        sliderLabel.text = String(Int(width))
    }
    
    func setupSwitchLayout() {
        lineShapeSwitch.setCircle()
        fillAreaSwitch.setCircle()
        addDotsSwitch.setCircle()
        dotShapeSwitch.setCircle()
    }
    
}


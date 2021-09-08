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
    var stackViewSubViewTypes: [StackViewSubViewType] {
        switch self {
            case .line: return [.lineShape, .fillArea, .addDots, .dotShape]
            case .bar: return [.width]
            case .dot: return [.dotShape]
        }
    }
}

enum StackViewSubViewType: CaseIterable {
    case lineShape
    case fillArea
    case addDots
    case dotShape
    case width
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
        NotificationCenter.default.post(name: .graphSaveButtonDidTappped, object: nil)
        dismiss(animated: true)
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
        StackViewSubViewType.allCases.enumerated().forEach { index, stackViewSubViewType in
            if graphType.stackViewSubViewTypes.contains(stackViewSubViewType) {
                stackView.arrangedSubviews[index].isHidden = false
            } else {
                stackView.arrangedSubviews[index].isHidden = true
            }
        }
    }
    
}

// MARK: - setup
private extension GraphKindSelectingViewController {
    
    func setupSegmentedControl() {
        let titles = SelectedGraphType.allCases.map { $0.title }
        let index = graphUseCase.graph.selectedType.rawValue
        segmentedControl.create(titles, selectedIndex: index)
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
    
}

// MARK: - setup layout
private extension GraphKindSelectingViewController {
    
    func setupSwitchLayout() {
        lineShapeSwitch.setCircle()
        fillAreaSwitch.setCircle()
        addDotsSwitch.setCircle()
        dotShapeSwitch.setCircle()
    }
    
}


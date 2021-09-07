//
//  ScrollableGraphView.swift
//  StudyRecordApp
//
//  Created by 大西玲音 on 2021/09/08.
//

import ScrollableGraphView

enum SelectedGraphType: Int, CaseIterable {
    case line
    case bar
    case dot
}

protocol CustomScrollableGraphViewDelegate: AnyObject {
    func value(at index: Int) -> Double
    func label(at index: Int) -> String
    func numberOfPoints() -> Int
}

final class CustomScrollableGraphView: UIView {
    
    private var graphView: ScrollableGraphView!
    weak var delegate: CustomScrollableGraphViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createGraphView()
        createReferenceLines()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        createGraphView()
        createReferenceLines()
        
    }
    
    func set(to view: UIView) {
        graphView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: view.topAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func create(color: UIColor, identifier: String, graph: Graph) {
        switch graph.selectedType {
            case .line:
                createLine(color: color,
                           isFilled: graph.line.isFilled,
                           isSmooth: graph.line.isSmooth,
                           identifier: identifier)
                if graph.line.withDots {
                    createDot(color: color,
                              isSquare: graph.dot.isSquare,
                              identifier: identifier)
                }
            case .bar:
                createBar(color: color,
                          width: CGFloat(graph.bar.width),
                          identifier: identifier)
            case .dot:
                createDot(color: color,
                          isSquare: graph.dot.isSquare,
                          identifier: identifier)
        }
    }
    
}

// MARK: - create func
private extension CustomScrollableGraphView {
    
    func createGraphView() {
        let frame = CGRect(x: 0,
                           y: 0,
                           width: self.frame.width,
                           height: self.frame.height)
        graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.rangeMin = 24
        graphView.rangeMax = 0
        graphView.rightmostPointPadding = 20
        graphView.backgroundFillColor = .clear
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.topMargin = 10
        graphView.dataPointSpacing = 30
    }
    
    func createReferenceLines() {
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = .boldSystemFont(ofSize: 10)
        referenceLines.dataPointLabelFont = .boldSystemFont(ofSize: 10)
        referenceLines.referenceLineColor = .black
        referenceLines.includeMinMax = false
        referenceLines.positionType = .absolute
        referenceLines.absolutePositions = [Int](0...24).map { Double($0) }
        graphView.addReferenceLines(referenceLines: referenceLines)
    }
    
    func createLine(color: UIColor, isFilled: Bool, isSmooth: Bool, identifier: String) {
        let linePlot = LinePlot(identifier: identifier)
        linePlot.lineColor = color
        linePlot.adaptAnimationType = .easeOut
        linePlot.animationDuration = 0.1
        if isFilled {
            linePlot.fillColor = color
            linePlot.shouldFill = true
        }
        if isSmooth {
            linePlot.lineStyle = .smooth
            linePlot.fillType = .gradient
            linePlot.fillGradientType = .linear
            linePlot.fillGradientStartColor = color
            linePlot.fillGradientEndColor = color.withAlphaComponent(0.6)
        }
        graphView.addPlot(plot: linePlot)
    }
    
    func createDot(color: UIColor, isSquare: Bool, identifier: String) {
        let dotPlot = DotPlot(identifier: identifier)
        dotPlot.dataPointType = .circle
        dotPlot.dataPointSize = 5
        dotPlot.dataPointFillColor = color
        dotPlot.adaptAnimationType = .easeOut
        dotPlot.animationDuration = 0.1
        if isSquare {
            dotPlot.dataPointType = .square
        }
        graphView.addPlot(plot: dotPlot)
    }
    
    func createBar(color: UIColor, width: CGFloat, identifier: String) {
        let barPlot = BarPlot(identifier: identifier)
        barPlot.adaptAnimationType = .easeOut
        barPlot.animationDuration = 0.1
        barPlot.barWidth = width
        barPlot.barLineWidth = 2
        barPlot.barColor = color
        barPlot.barLineColor = color.withAlphaComponent(0.6)
    }
    
}

// MARK: - ScrollableGraphViewDataSource
extension CustomScrollableGraphView: ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot,
               atIndex pointIndex: Int) -> Double {
        return delegate.value(at: pointIndex)
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return delegate.label(at: pointIndex)
    }
    
    func numberOfPoints() -> Int {
        return delegate.numberOfPoints()
    }
    
}

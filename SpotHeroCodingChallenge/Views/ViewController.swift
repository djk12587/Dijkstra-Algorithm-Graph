//
//  ViewController.swift
//  SpotHeroCodingChallenge
//
//  Created by Dan Koza on 8/5/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController
{
    weak var firstSelectedNodeView: NodeView?
    weak var secondSelectedNodeView: NodeView?
    var nodeViews: [NodeView] = []
    var totalNodes = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addRandomeNodeViews()
        addRandomConnections()
    }
    
    private func addRandomConnections()
    {
        nodeViews.forEach { (nodeView) in
            nodeView.addConnections(to: getRandomNodeViews(total: Int(arc4random_uniform(UInt32(3))), excluding: nodeView))
        }
    }
    
    private func getRandomNodeViews(total: Int, excluding nodeToExclude: NodeView) -> [Node]
    {
        var randomNodeIndex: Set<NodeView> = [nodeToExclude]
        while randomNodeIndex.count <= total {
            let randomIndex = arc4random_uniform(UInt32(totalNodes))
            randomNodeIndex.insert(nodeViews[Int(randomIndex)])
        }
        randomNodeIndex.remove(nodeToExclude)
        return Array(randomNodeIndex)
    }
    
    private func addRandomeNodeViews()
    {
        for i in 0..<totalNodes
        {
            let nodeView = NodeView(frame: CGRect(x: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 25))),
                                                  y: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height - (25 + UIApplication.shared.statusBarFrame.height)))),
                                                  width: 25,
                                                  height: 25),
                                    identifier: i,
                                    delegate: self)
            nodeView.layer.borderColor = UIColor.black.cgColor
            nodeView.layer.borderWidth = 1.0
            nodeView.backgroundColor = .cyan
            view.addSubview(nodeView)
            nodeViews.append(nodeView)
        }
    }
}

extension ViewController: NodeViewDelegate
{
    func nodeViewWasTapped(nodeView: NodeView, isSelected: Bool)
    {
        handleNodeSelection(nodeView: nodeView, isSelected: isSelected)
        colorConnectingNodeViews()
        clearAnyConnectingNodeViews()
    }
    
    private func handleNodeSelection(nodeView: NodeView, isSelected: Bool)
    {
        if isSelected
        {
            switch (firstSelectedNodeView, secondSelectedNodeView)
            {
            case (.none, _):
                firstSelectedNodeView = nodeView
            case (_, .none):
                secondSelectedNodeView = nodeView
            case (.some, .some):
                nodeViews.forEach { $0.backgroundColor = .cyan }
                nodeView.backgroundColor = .red
                firstSelectedNodeView = nodeView
                secondSelectedNodeView = nil
            }
        }
        else
        {
            if firstSelectedNodeView?.identifier == nodeView.identifier
            {
                firstSelectedNodeView = nil
            }
            if secondSelectedNodeView?.identifier == nodeView.identifier
            {
                secondSelectedNodeView = nil
            }
        }
    }
    
    private func colorConnectingNodeViews()
    {
        if let firstNodeView = firstSelectedNodeView, let secondNodeView = secondSelectedNodeView
        {
            let path = firstNodeView.node.findPath(to: secondNodeView.node)
            
            path.filter({![firstSelectedNodeView?.node, secondSelectedNodeView?.node].contains($0)}).forEach { (nodeInPath) in
                if let nodeViewInPath = nodeViews.first(where: { $0.node == nodeInPath })
                {
                    nodeViewInPath.backgroundColor = .yellow
                }
            }
        }
    }
    
    private func clearAnyConnectingNodeViews()
    {
        if firstSelectedNodeView == nil || secondSelectedNodeView == nil
        {
            nodeViews.filter({ $0.backgroundColor == .yellow }).forEach { $0.backgroundColor = .cyan }
        }
    }
}

@discardableResult
func drawLineFromPoint(start: CGPoint, toPoint end: CGPoint, ofColor lineColor: UIColor, inView view: UIView) -> CAShapeLayer
{    
    //design the path
    let path = UIBezierPath()
    path.move(to: start)
    path.addLine(to: end)
    
    //design path in layer
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.strokeColor = lineColor.cgColor
    shapeLayer.lineWidth = 5.0
    view.layer.insertSublayer(shapeLayer, at: 0)
    
    return shapeLayer
}

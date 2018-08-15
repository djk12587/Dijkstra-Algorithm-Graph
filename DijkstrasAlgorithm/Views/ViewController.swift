//
//  ViewController.swift
//  SpotHeroCodingChallenge
//
//  Created by Dan Koza on 8/5/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import UIKit
import GameplayKit
import Alamofire

class ViewController: UIViewController
{
    weak var firstSelectedNodeView: NodeView?
    weak var secondSelectedNodeView: NodeView?
    var nodeViews: [NodeView] = []
    var totalNodes = 10
    var nodeViewHeight: CGFloat = 25
    var nodeViewWidth: CGFloat = 100
    var nameRequest: Request?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addNodes()
    }
    
    private func addNodes()
    {
        addRandomNodeViews()
        addRandomConnections()
        
        nameRequest = RandomNameApi.GetRandomNames(amount: 10).request { (outcome: Outcome<[Name]>) in
            switch outcome
            {
            case .success(let names):
                guard names.count == self.nodeViews.count else { return }
                
                self.nodeViews.enumerated().forEach { (indexedNodeView) in
                    indexedNodeView.element.label.text = names[indexedNodeView.offset].name
                }
            case .failure(let error):
                guard (error as NSError).code != NSURLErrorCancelled else { return }
                let alert = UIAlertController(title: "Error", message: "Something went wrong fetching names", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func resetPressed(_ sender: UIButton)
    {
        nameRequest?.cancel()
        
        view.subviews.forEach {
            if $0 is Node
            {
                $0.removeFromSuperview()
            }
        }
        
        nodeViews.removeAll()
        
        view.layer.sublayers?.forEach {
            if $0 is CAShapeLayer
            {
                $0.removeFromSuperlayer()
            }
        }
        
        addNodes()
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
    
    private func addRandomNodeViews()
    {
        for i in 0..<totalNodes
        {
            let nodeView = NodeView(frame: CGRect(x: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - nodeViewWidth))),
                                                  y: CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height - nodeViewHeight))),
                                                  width: nodeViewWidth,
                                                  height: nodeViewHeight),
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
            
            path.filter({ ![firstSelectedNodeView?.node, secondSelectedNodeView?.node].contains($0) }).forEach { (nodeInPath) in
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

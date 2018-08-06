//
//  NodeView.swift
//  SpotHeroCodingChallenge
//
//  Created by Dan Koza on 8/5/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import UIKit
import GameplayKit

protocol Node: class
{
    var node: GKGraphNode { get }
    var identifier: Int { get }
    var centerCoordinate: CGPoint { get }
    func addConnections(to otherNodeViews: [Node])
}

extension Node where Self: UIView
{
    var centerCoordinate: CGPoint
    {
        return center
    }
    
    func addConnections(to otherNodeViews: [Node])
    {
        guard let superview = superview else { return }
        
        node.addConnections(to: otherNodeViews.compactMap { $0.node }, bidirectional: true)
        otherNodeViews.forEach { (otherNode) in
            drawLineFromPoint(start: center, toPoint: otherNode.centerCoordinate, ofColor: .red, inView: superview)
        }
    }
}

protocol NodeViewDelegate: class
{
    func nodeViewWasTapped(nodeView: NodeView, isSelected: Bool)
}

class NodeView: UIView, Node {

    var connectionLayers: [CAShapeLayer] = []
    weak var delegate: NodeViewDelegate?
    var identifier: Int
    
    var node: GKGraphNode = GKGraphNode()
    
    convenience init(frame: CGRect, identifier: Int, delegate: NodeViewDelegate?)
    {
        self.init(frame: frame)
        self.identifier = identifier
        self.delegate = delegate
        let idLabel = UILabel(frame: bounds)
        idLabel.text = String(identifier)
        idLabel.textAlignment = .center
        addSubview(idLabel)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nodeWasTapped)))
    }
    
    @objc func nodeWasTapped()
    {
        backgroundColor = backgroundColor == .red ? .cyan : .red
        delegate?.nodeViewWasTapped(nodeView: self, isSelected: backgroundColor == .red)
    }
    
    private override init(frame: CGRect)
    {
        identifier = 0
        super.init(frame: frame)
        layer.cornerRadius = bounds.size.width/2
        layer.masksToBounds = true
    }
    
    internal required init?(coder aDecoder: NSCoder)
    {
        identifier = 0
        super.init(coder: aDecoder)
    }
}

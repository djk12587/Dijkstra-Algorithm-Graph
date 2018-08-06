//
//  Helpers.swift
//  SpotHeroCodingChallenge
//
//  Created by Dan Koza on 8/5/18.
//  Copyright © 2018 Dan Koza. All rights reserved.
//

import Foundation
import UIKit

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

extension UIView
{
    func constrainToSuperViewFullScreen()
    {
        translatesAutoresizingMaskIntoConstraints = false
        
        constrainTo(constraintAttribute: .top)
        constrainTo(constraintAttribute: .bottom)
        constrainTo(constraintAttribute: .leading)
        constrainTo(constraintAttribute: .trailing)
    }
    
    func constrainTo(view: UIView? = nil, constraintAttribute: NSLayoutAttribute)
    {
        let view = view ?? superview
        view?.addConstraint(NSLayoutConstraint(item: self, attribute: constraintAttribute, relatedBy: .equal, toItem: view, attribute: constraintAttribute, multiplier: 1.0, constant: 0))
    }
}

extension CGFloat
{
    static var random: CGFloat
    {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor
{
    static var random: UIColor
    {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}


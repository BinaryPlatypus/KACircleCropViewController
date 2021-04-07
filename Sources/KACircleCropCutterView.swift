//
//  KACircleCropCutterView.swift
//  Circle Crop View Controller
//
//  Created by Keke Arif on 21/02/2016.
//  Copyright © 2016 Keke Arif. All rights reserved.
//

import UIKit

open class KACircleCropCutterView: UIView {
    override open var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open var circle: UIBezierPath!
    open var circleView: UIView = UIView()
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isOpaque = false
    }

    override open func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 245.0/255.0, alpha: 1.0).setFill()
        UIRectFill(rect)
        
        circle = UIBezierPath(ovalIn: CGRect(x: rect.size.width/2 - 210/2, y: rect.size.height/2 - 210/2, width: 210, height: 210))
        context?.setBlendMode(.clear)
        UIColor.clear.setFill()
        circle.fill()
        
        self.addArrowImages()
    }
    
    open func addArrowImages() {
        let image1 = UIImageView(image: UIImage(named: "arrowTopLeft"))
        image1.frame = CGRect(x: circle.bounds.minX - 37, y: circle.bounds.minY, width: 37, height: 37)
        addSubview(image1)
        
        let image2 = UIImageView(image: UIImage(named: "arrowTopRight"))
        image2.frame = CGRect(x: circle.bounds.maxX, y: circle.bounds.minY, width: 37, height: 37)
        addSubview(image2)
        
        let image3 = UIImageView(image: UIImage(named: "arrowBottomLeft"))
        image3.frame = CGRect(x: circle.bounds.minX - 37, y: circle.bounds.maxY - 37, width: 37, height: 37)
        addSubview(image3)
        
        let image4 = UIImageView(image: UIImage(named: "arrowBottomRight"))
        image4.frame = CGRect(x: circle.bounds.maxX, y: circle.bounds.maxY - 37, width: 37, height: 37)
        addSubview(image4)

        circleView.frame = CGRect(x: circle.bounds.maxX, y: image1.frame.minX + 190, width: 37, height: 37)
        addSubview(circleView)
    }
    
    
    //Allow touches through the circle crop cutter view
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }

}


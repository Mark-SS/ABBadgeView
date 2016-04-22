//
//  ViewController.swift
//  BadgeView
//
//  Created by gongliang on 16/4/21.
//  Copyright © 2016年 AB. All rights reserved.
//

import UIKit

let kNumBadges = 2
let kViewBackgroundColor = UIColor(red: 0.357, green: 0.757, blue: 0.357, alpha: 1)
let kSquareSideLength: CGFloat = 64.0
let kSquareCornerRadius: CGFloat = 10.0
let kMarginBetwwenSquares: CGFloat = 60.0
let kSquareColor = UIColor(red: 0.004, green: 0.349, blue: 0.616, alpha: 1)

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = kViewBackgroundColor
        let scrollView = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollView)
        
        let viewWidth = self.view.bounds.width
        
        let numberOfSquaresPerRow = Int(viewWidth / (kSquareSideLength + kMarginBetwwenSquares))
        let kInitialXOffset = (viewWidth - (CGFloat(numberOfSquaresPerRow) * kSquareSideLength)) / CGFloat(numberOfSquaresPerRow)
        
        var xOffset = kInitialXOffset
        
        let kInitialYOffset = kInitialXOffset
        
        var yOffset = kInitialYOffset
        let rectangleBounds = CGRectMake(0, 0, kSquareSideLength, kSquareSideLength)
        
        let rectangleShadowPath = UIBezierPath(roundedRect: rectangleBounds, byRoundingCorners: .AllCorners, cornerRadii: CGSizeMake(kSquareCornerRadius, kSquareCornerRadius)).CGPath
        
        for i in 0 ..< kNumBadges {
            let rectangle = UIView(frame: CGRectIntegral(CGRectMake(40 + xOffset, 10 + yOffset, rectangleBounds.width, rectangleBounds.height)))
            rectangle.backgroundColor = kSquareColor
            rectangle.layer.cornerRadius = kSquareCornerRadius
            rectangle.layer.shadowColor = UIColor.blackColor().CGColor;
            rectangle.layer.shadowOffset = CGSizeMake(0.0, 3.0)
            rectangle.layer.shadowOpacity = 0.4
            rectangle.layer.shadowRadius = 1.0
            rectangle.layer.shadowPath = rectangleShadowPath
            
            let badgeView = ABBadgeView(parentView: rectangle, alignment: ABBadgeViewAlignment.TopRight)
            badgeView.badgeText = String(i)
            
            scrollView.addSubview(rectangle)
            scrollView.sendSubviewToBack(rectangle)
            
            xOffset += kSquareSideLength + kMarginBetwwenSquares
            
            if xOffset > self.view.bounds.width - kSquareSideLength {
                xOffset = kInitialXOffset
                yOffset += kSquareSideLength + kMarginBetwwenSquares
            }

        }
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, yOffset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


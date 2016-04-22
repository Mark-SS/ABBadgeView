//
//  ABBadgeView.swift
//  BadgeView
//
//  Created by gongliang on 16/4/21.
//  Copyright © 2016年 AB. All rights reserved.
//

import UIKit

let JSBadgeViewShadowRadius: CGFloat = 1.0
let JSBadgeViewHeight: CGFloat = 16.0
let JSBadgeViewTextSideMargin: CGFloat = 8.0
let JSBadgeViewCornerRadius: CGFloat = 10.0

enum ABBadgeViewAlignment: Int  {
    case TopLeft = 1
    case TopRight
    case TopCenter
    case CenterLeft
    case CenterRight
    case BottomLeft
    case BottomRight
    case BottomCenter
    case Center
}

class ABBadgeView: UIView {
    
    var badgeText: String = "" {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var badgeAlignment: ABBadgeViewAlignment = .TopRight {
        didSet {
            if oldValue != badgeAlignment {
                self.setNeedsLayout()
            }
        }
    }
    
    dynamic var badgeTextColor = UIColor.whiteColor() {
        didSet {
            if oldValue != badgeTextColor {
            self.setNeedsDisplay()
            }
        }
    }
    dynamic var badgeTextShadowOffset = CGSizeZero {
        didSet {
            if oldValue != badgeTextShadowOffset {
            self.setNeedsDisplay()
            }
        }
    }
    dynamic var badgeTextShadowColor = UIColor.yellowColor() {
        didSet {
            if oldValue != badgeTextShadowColor {
            self.setNeedsDisplay()
            }
        }
    }
    dynamic var badgeTextFont = UIFont.boldSystemFontOfSize(UIFont.systemFontSize()) {
        didSet {
            if oldValue != badgeTextFont {
            self.setNeedsLayout()
            self.setNeedsLayout()
            }
        }
    }
    dynamic var badgeBackgroundColor = UIColor.redColor() {
        didSet {
            if oldValue != badgeBackgroundColor {
            self.setNeedsDisplay()
            }
        }
    }
    dynamic var badgeOverlayColor = UIColor.clearColor() {
        didSet {
            if oldValue != badgeOverlayColor {
            self.setNeedsLayout()
            self.setNeedsDisplay()
            }
        }
    }
    dynamic var badgeShadowColor = UIColor.clearColor()
    dynamic var badgeShadowSize = CGSizeZero {
        didSet {
            if oldValue != badgeShadowSize {
                self.setNeedsDisplay()}
        }
    }
    dynamic var badgeStrokeWidth: CGFloat =  0.0
    dynamic var badgeStrokeColor = UIColor.redColor() {
        didSet {
            if oldValue != badgeStrokeColor {
            self.setNeedsDisplay()
            }
        }
    }
    dynamic var badgePostionAdjustment = CGPointZero {
        didSet {
            if oldValue != badgePostionAdjustment {
            self.setNeedsLayout()
            }
        }
    }
    
    dynamic var frameToPostionInRelationWith = CGRectZero
    dynamic var badgeMinWidth: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(parentView: UIView, alignment: ABBadgeViewAlignment) {
        self.init(frame: CGRectZero)
        self.badgeAlignment = alignment
        self.backgroundColor = UIColor.clearColor()
        parentView.addSubview(self)
    }
    
    override func layoutSubviews() {
        var newFrame = self.frame
        let superViewBounds = CGRectIsEmpty(self.frameToPostionInRelationWith) ? self.superview?.bounds : self.frameToPostionInRelationWith
        let textWidth = self.sizeOfTextForCurrentSettings().width
        let marginToDrawInside = self.marginToDrawInside()
        let viewWidth = max(self.badgeMinWidth, textWidth + JSBadgeViewTextSideMargin + (marginToDrawInside * 2))
        let viewHeight = JSBadgeViewHeight + (marginToDrawInside * 2)
        let superviewWidth = superViewBounds!.width
        let superviewHeight = superViewBounds!.height
        
        newFrame.size = CGSizeMake(max(viewWidth, viewHeight), viewHeight)
        
        switch self.badgeAlignment {
        case .TopLeft:
            newFrame.origin.x = -viewWidth / 2.0
            newFrame.origin.y = -viewHeight / 2.0
        case .TopRight:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0)
            newFrame.origin.y = -viewHeight / 2.0
        case .TopCenter:
            newFrame.origin.x = (superviewWidth - viewWidth) / 2.0
            newFrame.origin.y = -viewHeight / 2.0
        case .CenterLeft:
            newFrame.origin.x = -viewWidth / 2.0
            newFrame.origin.y = (superviewHeight - viewHeight) / 2.0
        case .CenterRight:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0)
            newFrame.origin.y = (superviewHeight - viewHeight) / 2.0
        case .BottomLeft:
            newFrame.origin.x = -viewWidth / 2.0
            newFrame.origin.y = superviewHeight - (viewHeight / 2.0)
        case .BottomRight:
            newFrame.origin.x = superviewWidth - (viewWidth / 2.0)
            newFrame.origin.y = superviewHeight - (viewHeight / 2.0)
        case .BottomCenter:
            newFrame.origin.x = (superviewWidth - viewWidth) / 2.0
            newFrame.origin.y = superviewHeight - (viewHeight / 2.0)
        case .Center:
            newFrame.origin.x = (superviewWidth - viewWidth) / 2.0
            newFrame.origin.y = (superviewHeight - viewHeight) / 2.0
        }
        
        newFrame.origin.x += self.badgePostionAdjustment.x
        newFrame.origin.y += self.badgePostionAdjustment.y
        
        self.bounds = CGRectIntegral(CGRectMake(0, 0, newFrame.width, newFrame.height))
        self.center = CGPointMake(CGRectGetMidX(newFrame), CGRectGetMidY(newFrame))
        
        self.setNeedsDisplay()
    }
    
    func marginToDrawInside() -> CGFloat {
        return self.badgeStrokeWidth * 2.0
    }
    
    private func sizeOfTextForCurrentSettings() -> CGSize {
        let myString: NSString = self.badgeText
        return myString.sizeWithAttributes([NSFontAttributeName: self.badgeTextFont])
    }
    
    override func drawRect(rect: CGRect) {
        let anyTextToDraw = self.badgeText.characters.count > 0
        if anyTextToDraw {
            let ctx = UIGraphicsGetCurrentContext()
            let marginToDrawInside = self.marginToDrawInside()
            let rectToDraw = CGRectInset(rect, marginToDrawInside, marginToDrawInside)
            
            let borderPath = UIBezierPath(roundedRect: rectToDraw, byRoundingCorners: .AllCorners, cornerRadii: CGSizeMake(JSBadgeViewCornerRadius, JSBadgeViewCornerRadius))
            
            /* Background and shadow */
            CGContextSaveGState(ctx)
            CGContextAddPath(ctx, borderPath.CGPath)
            CGContextSetFillColorWithColor(ctx, self.badgeBackgroundColor.CGColor)
            CGContextSetShadowWithColor(ctx, self.badgeShadowSize, JSBadgeViewCornerRadius, self.badgeShadowColor.CGColor)
            CGContextDrawPath(ctx, .Fill)
            CGContextRestoreGState(ctx)
            
            let colorForOverlayPresent = !(self.badgeOverlayColor == UIColor.clearColor())
            if colorForOverlayPresent {
                /* gradient overlay */
                CGContextSaveGState(ctx)
                CGContextAddPath(ctx, borderPath.CGPath)
                CGContextClip(ctx)
                
                let height = rectToDraw.height
                let width = rectToDraw.width
                
                let rectForOverlayCircle = CGRectMake(rectToDraw.origin.x,
                                                      rectToDraw.origin.y - height * 0.5,
                                                      width,
                                                      height)
                CGContextAddEllipseInRect(ctx, rectForOverlayCircle)
                CGContextSetFillColorWithColor(ctx, self.badgeOverlayColor.CGColor)
                
                CGContextDrawPath(ctx, .Fill)
                
                CGContextRestoreGState(ctx)
            }
            
            /* Stroke */
            CGContextSaveGState(ctx)
            CGContextAddPath(ctx, borderPath.CGPath)
            CGContextSetLineWidth(ctx, self.badgeStrokeWidth)
            CGContextSetStrokeColorWithColor(ctx, self.badgeStrokeColor.CGColor)
            CGContextDrawPath(ctx, .Stroke)
            CGContextRestoreGState(ctx)
            
            /* Text */
            CGContextSaveGState(ctx)
            CGContextSetShadowWithColor(ctx, self.badgeTextShadowOffset, 3.0, self.badgeTextShadowColor.CGColor)
            var textFrame = rectToDraw
            let textSize = self.sizeOfTextForCurrentSettings()
            textFrame.size.height = textSize.height
            textFrame.origin.y = rectToDraw.origin.y + (rectToDraw.height - textFrame.height) / 2.0
            let drawText: NSString = self.badgeText
            
            let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = NSTextAlignment.Center
            
            drawText.drawInRect(textFrame, withAttributes: [NSFontAttributeName: self.badgeTextFont,
                                                            NSParagraphStyleAttributeName: textStyle,
                                                            NSForegroundColorAttributeName: self.badgeTextColor])
            CGContextRestoreGState(ctx)
        }
    }
    
}



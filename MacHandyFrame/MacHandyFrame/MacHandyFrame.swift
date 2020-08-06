//
//  MacHandyFrame.swift
//  MacHandyFrame
//
//  Created by casa on 2020/8/6.
//  Copyright © 2020 casa. All rights reserved.
//

import Foundation
import AppKit

public class HandyFrameView {
    private let targetView:NSView

    public lazy var safeAreaBottomGap:CGFloat = {
        return 0
    }()

    public lazy var safeAreaTopGap:CGFloat = {
        return 0
    }()

    public lazy var safeAreaLeftGap:CGFloat = {
        return 0
    }()

    public lazy var safeAreaRightGap:CGFloat = {
        return 0
    }()

    init(_ targetView:NSView) {
        self.targetView = targetView
    }
}

public protocol HandyFrameExtended {
    var hf: HandyFrameView { get }
}

public extension HandyFrameExtended {
    var hf: HandyFrameView {
        get {
            return HandyFrameView(self as! NSView)
        }
    }
}

extension NSView: HandyFrameExtended {}

// MARK: Size: width, height, size
public extension HandyFrameView {
    func width() -> CGFloat {
        return targetView.frame.size.width
    }

    func setWidth(_ width:CGFloat) {
        targetView.frame.size.width = width
    }

    func height() -> CGFloat {
        return targetView.frame.size.height
    }

    func setHeight(_ height:CGFloat) {
        targetView.frame.size.height = height
    }

    func size() -> CGSize {
        return targetView.frame.size
    }

    func setSize(_ size:CGSize) {
        targetView.frame.size = size
    }
}

// MARK: add width or height
public extension HandyFrameView {
    enum HorizontalSide {
        case left,right
    }
    enum VerticalSide {
        case top,bottom
    }
    func addWidth(_ widthToAdd:CGFloat, on side:HorizontalSide) {
        switch side {
        case .left:
            targetView.frame.size.width += widthToAdd
            targetView.frame.origin.x -= widthToAdd
        case .right:
            targetView.frame.size.width += widthToAdd
        }
    }

    func addHeight(_ heightToAdd:CGFloat, on side:VerticalSide) {
        switch side {
        case .top:
            targetView.frame.size.height += heightToAdd
            targetView.frame.origin.y -= heightToAdd
        case .bottom:
            targetView.frame.size.height += heightToAdd
        }
    }
}

// MARK: Position: x, y, centerX, centerY, center
public extension HandyFrameView {
    func x() -> CGFloat {
        return targetView.frame.origin.x
    }

    func setX(_ x:CGFloat) {
        targetView.frame.origin.x = x
    }

    func y() -> CGFloat {
        return targetView.frame.origin.y
    }

    func setY(_ y:CGFloat) {
        targetView.frame.origin.y = y
    }

    func centerX() -> CGFloat {
        return targetView.center().x
    }

    func setCenterX(_ centerX:CGFloat) {
        let deltaX = centerX - targetView.center().x
        targetView.hf.setX(targetView.hf.x()+deltaX)
    }

    func centerY() -> CGFloat {
        return targetView.center().y
    }

    func setCenterY(_ centerY:CGFloat) {
        let deltaY = centerY - targetView.center().y
        targetView.hf.setY(targetView.hf.y()+deltaY)
    }

    func center() -> CGPoint {
        return targetView.center()
    }

    func setCenter(_ center:CGPoint) {
        targetView.hf.setCenterX(center.x)
        targetView.hf.setCenterY(center.y)
    }
}

// MARK: Center related to other view
public extension HandyFrameView {
    func setCenterXEqualToView(_ view:NSView?) {
        guard let view = view else { return }
        
        let viewSuperView = view.superview ?? view
        let topView = fetchTopView()

        let viewCenterPoint = viewSuperView.convert(view.center(), to:topView)
        let centerPoint = topView.convert(viewCenterPoint, to:targetView.superview)
        setCenterX(centerPoint.x)
    }

    func setCenterYEqualToView(_ view:NSView?) {
        guard let view = view else { return }
        
        let viewSuperView = view.superview ?? view
        let topView = fetchTopView()

        let viewCenterPoint = viewSuperView.convert(view.center(), to:topView)
        let centerPoint = topView.convert(viewCenterPoint, to:targetView.superview)
        setCenterY(centerPoint.y)
    }

    func setCenterEqualToView(_ view:NSView?) {
        guard let view = view else { return }
        
        let viewSuperView = view.superview ?? view
        let topView = fetchTopView()

        let viewCenterPoint = viewSuperView.convert(view.center(), to:topView)
        let centerPoint = topView.convert(viewCenterPoint, to:targetView.superview)
        setCenter(centerPoint)
    }
}

// MARK: Positon: left, right, top, bottom
public extension HandyFrameView {
    func left() -> CGFloat {
        return targetView.frame.origin.x
    }

    func setLeft(_ left:CGFloat, shouldResize:Bool) {
        if shouldResize {
            targetView.frame.size.width = targetView.frame.origin.x - left + targetView.frame.size.width
        }
        targetView.frame.origin.x = left
    }

    func right() -> CGFloat {
        return targetView.frame.origin.x + targetView.frame.size.width
    }

    func setRight(_ right:CGFloat, shouldResize:Bool) {
        if shouldResize {
            targetView.frame.size.width = right - targetView.frame.origin.x
        } else {
            targetView.frame.origin.x = right - targetView.frame.size.width
        }
    }

    func bottom() -> CGFloat {
        return targetView.frame.origin.y + targetView.frame.size.height
    }

    func setBottom(_ bottom:CGFloat, shouldResize:Bool) {
        if shouldResize {
            targetView.frame.size.height = bottom - targetView.frame.origin.y
        } else {
            targetView.frame.origin.y = bottom - targetView.frame.size.height
        }
    }

    func top() -> CGFloat {
        return targetView.frame.origin.y
    }

    func setTop(_ top:CGFloat, shouldResize:Bool) {
        if shouldResize {
            targetView.frame.size.height = targetView.frame.size.height - top + targetView.frame.origin.y
        }
        targetView.frame.origin.y = top
    }
}

// MARK: Position equal to view
public extension HandyFrameView {
    func topEqualToView(_ view:NSView?) {
        guard let view = view else { return }
        
        let viewSuperView = view.superview ?? view
        let topSuperView = fetchTopView()
        let viewOriginPoint = viewSuperView.convert(view.frame.origin, to:topSuperView)
        let newOriginPoint = topSuperView.convert(viewOriginPoint, to: targetView.superview)
        targetView.frame.origin.y = newOriginPoint.y
    }

    func bottomEqualToView(_ view:NSView?) {
        guard let view = view else { return }
        
        let viewSuperView = view.superview ?? view
        let topSuperView = fetchTopView()
        let viewOriginPoint = viewSuperView.convert(view.frame.origin, to:topSuperView)
        let newOriginPoint = topSuperView.convert(viewOriginPoint, to: targetView.superview)
        targetView.frame.origin.y = newOriginPoint.y + view.frame.size.height - targetView.frame.size.height
    }

    func leftEqualToView(_ view:NSView?) {
        guard let view = view else { return }

        let viewSuperView = view.superview ?? view
        let topSuperView = fetchTopView()
        let viewOriginPoint = viewSuperView.convert(view.frame.origin, to:topSuperView)
        let newOriginPoint = topSuperView.convert(viewOriginPoint, to: targetView.superview)
        targetView.frame.origin.x = newOriginPoint.x
    }

    func rightEqualToView(_ view:NSView?) {
        guard let view = view else { return }
        
        let viewSuperView = view.superview ?? view
        let topSuperView = fetchTopView()
        let viewOriginPoint = viewSuperView.convert(view.frame.origin, to:topSuperView)
        let newOriginPoint = topSuperView.convert(viewOriginPoint, to: targetView.superview)
        targetView.frame.origin.x = newOriginPoint.x + view.frame.size.width - targetView.frame.size.width
    }
}

// MARK: inner gap with superview
/*
        ---------------------------------------------
        | superview          top                    |
        |                    gap                    |
        |          ----------------------           |
        |          |                    |           |
        |          |                    |           |
        |          |                    |           |
        |   left   |        VIEW        |   right   |
        |   gap    |                    |    gap    |
        |          |                    |           |
        |          |                    |           |
        |          ----------------------           |
        |                  bottom                   |
        |                    gap                    |
        ---------------------------------------------
 */
public extension HandyFrameView {
    func setInnerTopGap(_ topGap:CGFloat, shouldResize:Bool) {
        if shouldResize {
            targetView.frame.size.height = targetView.frame.origin.y - topGap + targetView.frame.size.height
        }
        targetView.frame.origin.y = topGap
    }

    func setInnerBottomGap(_ bottomGap:CGFloat, shouldResize:Bool) {
        guard let superview = targetView.superview else { return }
        if shouldResize {
            targetView.frame.size.height = superview.frame.size.height - bottomGap - targetView.frame.origin.y - safeAreaBottomGap
        } else {
            targetView.frame.origin.y = superview.frame.size.height - targetView.frame.size.height - bottomGap - safeAreaBottomGap
        }
    }

    func setInnerLeftGap(_ leftGap:CGFloat, shouldResize:Bool) {
        if shouldResize {
            targetView.frame.size.width = targetView.frame.origin.x - leftGap + targetView.frame.size.width
        }
        targetView.frame.origin.x = leftGap
    }

    func setInnerRightGap(_ rightGap:CGFloat, shouldResize:Bool) {
        guard let superview = targetView.superview else { return }
        if shouldResize {
            targetView.frame.size.width = superview.frame.size.width - rightGap - targetView.frame.origin.x
        } else {
            targetView.frame.origin.x = superview.frame.size.width - targetView.frame.size.width - rightGap
        }
    }
}

// MARK: gap with other view
/*
               |                   |
               |                   |
               ---------------------
                      top gap
  ---          ---------------------           ---
    |          |                   |           |
    |          |                   |           |
    |          |                   |           |
    | left gap |        VIEW       | right gap |
    |          |                   |           |
    |          |                   |           |
    |          |                   |           |
  ---          ---------------------           ---
                    bottom gap
               ---------------------
               |                   |
               |                   |
 */
public extension HandyFrameView {
    func setTopGap(_ topGap:CGFloat, fromView:NSView?) {
        guard let fromView = fromView else { return }
        
        let fromViewSuperView = fromView.superview ?? fromView
        let topView = fetchTopView()
        let viewOriginPoint = fromViewSuperView.convert(fromView.frame.origin, to: topView)
        let newOriginPoint = topView.convert(viewOriginPoint, to:targetView.superview)
        targetView.frame.origin.y = newOriginPoint.y + topGap + fromView.frame.size.height
    }

    func setBottomGap(_ bottomGap:CGFloat, fromView:NSView?) {
        guard let fromView = fromView else { return }
        
        let fromViewSuperView = fromView.superview ?? fromView
        let fromViewOriginPoint = fromViewSuperView.convert(fromView.frame.origin, to:targetView.superview)
        targetView.frame.origin.y = fromViewOriginPoint.y - bottomGap - targetView.frame.size.height
    }

    func setLeftGap(_ leftGap:CGFloat, fromView:NSView?) {
        guard let fromView = fromView else { return }
        
        let fromViewSuperView = fromView.superview ?? fromView
        let topView = fetchTopView()
        let fromViewOriginPoint = fromViewSuperView.convert(fromView.frame.origin, to:topView)
        let newOriginPoint = topView.convert(fromViewOriginPoint, to: targetView.superview)
        targetView.frame.origin.x = newOriginPoint.x + leftGap + fromView.frame.size.width
    }

    func setRightGap(_ rightGap:CGFloat, fromView:NSView?) {
        guard let fromView = fromView else { return }
        
        let fromViewSuperView = fromView.superview ?? fromView
        let topView = fetchTopView()
        let fromViewOriginPoint = fromViewSuperView.convert(fromView.frame.origin, to:topView)
        let newOriginPoint = topView.convert(fromViewOriginPoint, to: targetView.superview)
        targetView.frame.origin.x = newOriginPoint.x - rightGap - fromView.frame.size.width
    }
}

// MARK: Fill
public extension HandyFrameView {
    func fillWidth() {
        guard let superview = targetView.superview else { return }
        targetView.frame.size.width = superview.frame.size.width
        targetView.frame.origin.x = 0
    }

    func fillHeight() {
        guard let superview = targetView.superview else { return }
        targetView.frame.size.height = superview.frame.size.height
        targetView.frame.origin.y = 0
    }

    func fill() {
        guard let superview = targetView.superview else { return }
        let height = superview.frame.size.height - safeAreaBottomGap
        targetView.frame = CGRect(x: 0, y: 0, width: superview.frame.size.width, height: height)
    }
}

// MARK: helper methods
public extension HandyFrameView {
    func fetchTopView() -> NSView {
        var result = targetView

        while result.superview != nil {
            result = result.superview ?? result
        }

        return result
    }
}

public extension NSView {
    func center() -> CGPoint {
        return CGPoint(x: NSMidX(frame), y: NSMidY(frame))
    }
}

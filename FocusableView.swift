//
//  FocusableView.swift
//  FocusLab
//
//  Created by Dev Team on 3/14/16.
//  Copyright © 2016 Pluralsight. All rights reserved.
//

import UIKit

#if os(tvOS)
    
public enum FocusableViewBackgroundStyle: Equatable {
    case None
    case Blur(UIBlurEffectStyle)
    case Color(UIColor)
}

public enum FocusableViewFocusStyle: Equatable {
    case None
    case Grow(scale: CGFloat)
    
    public static let defaultScale: CGFloat = 1.10
}

public struct FocusableViewWiggleDirection: OptionSetType {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    public static let Vertical = FocusableViewWiggleDirection(rawValue: 1)
    public static let Horizontal = FocusableViewWiggleDirection(rawValue: 2)
}

public enum FocusableViewWiggleStyle: Equatable {
    case PerspectiveRotation
    case Translation
}

public struct FocusableViewWiggle: Equatable {
    public let style: FocusableViewWiggleStyle
    public let direction: FocusableViewWiggleDirection
    
    public init(style: FocusableViewWiggleStyle, direction: FocusableViewWiggleDirection) {
        self.style = style
        self.direction = direction
    }
}

public protocol FocusableViewDelegate: class {
    func focusableViewWasSelected(focusableView: FocusableView)
}

public class FocusableView: UIView {
    
    private static let maxTranslation: CGFloat = 15
    
    public weak var delegate: FocusableViewDelegate?
    
    public var focusedBackgroundStyle: FocusableViewBackgroundStyle = .None {
        didSet {
            if oldValue != focusedBackgroundStyle {
                updateBackgroundStyle()
            }
        }
    }
    
    public var focusStyle: FocusableViewFocusStyle = .None {
        didSet {
            if focused && oldValue != focusStyle {
                addFocus()
            }
        }
    }
    
    public var wiggle: FocusableViewWiggle? = nil {
        didSet {
            if focused && oldValue != wiggle {
                addFocus()
            }
        }
    }
    
    public var showsShadowOnFocus = false {
        didSet {
            if focused && oldValue != showsShadowOnFocus {
                addFocus()
            }
        }
    }
    
    public var enabled = true
    
    private let backgroundView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func canBecomeFocused() -> Bool {
        return enabled
    }
    
    public override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        guard let nextFocusedView = context.nextFocusedView else { return }
        if nextFocusedView == self {
            self.becomeFocusedUsingAnimationCoordinator(coordinator)
            self.addParallaxMotionEffects()
        } else {
            self.resignFocusUsingAnimationCoordinator(coordinator)
            self.motionEffects = []
        }
    }
    
    public override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        super.pressesBegan(presses, withEvent: event)
        
        guard delegate != nil else {
            return
        }
        
        UIView.animateWithDuration(0.08, delay: 0.0, options: .BeginFromCurrentState, animations: {
            self.transform = CGAffineTransformMakeScale(1.02, 1.02)
            }, completion: nil)
    }
    
    public override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        super.pressesEnded(presses, withEvent: event)
        
        guard delegate != nil else {
            return
        }
        
        if focused {
            UIView.animateWithDuration(0.1, delay: 0.0, options: .BeginFromCurrentState, animations: addFocus, completion: nil)
            delegate?.focusableViewWasSelected(self)
        }
    }
    
    public override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        super.pressesCancelled(presses, withEvent: event)
        
        guard delegate != nil else {
            return
        }
        
        if focused {
            UIView.animateWithDuration(0.1, delay: 0.0, options: .BeginFromCurrentState, animations: addFocus, completion: nil)
        }
    }
    
}

private extension FocusableView {
    
    func setup() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.alpha = 0.0
        addSubview(backgroundView)
        
        backgroundView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        backgroundView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        backgroundView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        backgroundView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
    }
    
    func updateBackgroundStyle() {
        backgroundView.subviews.forEach { $0.removeFromSuperview() }
        
        switch focusedBackgroundStyle {
        case .None:
            return
        case .Blur(let blurStyle):
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
            blurView.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.addSubview(blurView)
            
            blurView.leadingAnchor.constraintEqualToAnchor(backgroundView.leadingAnchor).active = true
            blurView.trailingAnchor.constraintEqualToAnchor(backgroundView.trailingAnchor).active = true
            blurView.topAnchor.constraintEqualToAnchor(backgroundView.topAnchor).active = true
            blurView.bottomAnchor.constraintEqualToAnchor(backgroundView.bottomAnchor).active = true
        case .Color(let color):
            backgroundView.backgroundColor = color
        }
    }
    
    func addParallaxMotionEffects(tiltValue: CGFloat = 0.025, panValue: CGFloat = 5) {
        
        guard let wiggle = self.wiggle else {
            return
        }
        
        var effects: [UIMotionEffect] = []
        
        if wiggle.direction.contains(.Horizontal) {
            var xPan = UIInterpolatingMotionEffect()
            xPan = UIInterpolatingMotionEffect(keyPath: "center.x", type:     .TiltAlongHorizontalAxis)
            xPan.minimumRelativeValue = -panValue
            xPan.maximumRelativeValue = panValue
            effects.append(xPan)
            
            if wiggle.style == .PerspectiveRotation {
                var xTilt = UIInterpolatingMotionEffect()
                xTilt = UIInterpolatingMotionEffect(keyPath: "layer.transform.rotation.y", type: .TiltAlongHorizontalAxis)
                xTilt.minimumRelativeValue = tiltValue
                xTilt.maximumRelativeValue = -tiltValue
                effects.append(xTilt)
            }
        }
        
        if wiggle.direction.contains(.Vertical) {
            var yPan = UIInterpolatingMotionEffect()
            yPan = UIInterpolatingMotionEffect(keyPath: "center.y", type:    .TiltAlongVerticalAxis)
            yPan.minimumRelativeValue = -panValue
            yPan.maximumRelativeValue = panValue
            effects.append(yPan)
            
            if wiggle.style == .PerspectiveRotation {
                var yTilt = UIInterpolatingMotionEffect()
                yTilt = UIInterpolatingMotionEffect(keyPath: "layer.transform.rotation.x", type: .TiltAlongVerticalAxis)
                yTilt.minimumRelativeValue = -tiltValue
                yTilt.maximumRelativeValue = tiltValue
                effects.append(yTilt)
            }
        }
        
        motionEffects.forEach { removeMotionEffect($0) }
        
        guard effects.count > 0 else {
            return
        }
        
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = effects
        addMotionEffect(motionGroup)
    }
    
    func addFocus() {
        insertSubview(backgroundView, atIndex: 0)
        
        var transform: CATransform3D = CATransform3DIdentity
        
        if case FocusableViewFocusStyle.Grow(let scale) = focusStyle {
            transform = CATransform3DMakeScale(scale, scale, 1.0)
        }
        
        if let wiggleStyle = wiggle?.style where wiggleStyle == .PerspectiveRotation {
            transform.m34 = 1.0 / -500.0
        }
        
        layer.transform = transform
        
        if showsShadowOnFocus {
            backgroundView.layer.shadowColor = UIColor.blackColor().CGColor
            backgroundView.layer.shadowOffset = CGSizeMake(0, 25)
            backgroundView.layer.shadowOpacity = 0.4
            backgroundView.layer.shadowRadius = 25
        } else {
            backgroundView.layer.shadowColor = nil
            backgroundView.layer.shadowOffset = CGSizeZero
        }
        
        backgroundView.alpha = 1.0
    }
    
    func removeFocus() {
        transform = CGAffineTransformIdentity
        backgroundView.layer.shadowColor = nil
        backgroundView.layer.shadowOffset = CGSizeZero
        backgroundView.alpha = 0.0
    }
    
    func becomeFocusedUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations(addFocus, completion: nil)
    }
    
    func resignFocusUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations(removeFocus, completion: nil)
    }
    
}

public func ==(lhs: FocusableViewFocusStyle, rhs: FocusableViewFocusStyle) -> Bool {
    switch (lhs, rhs) {
    case (.None, .None):
        return true
    case (.Grow(let lScale), .Grow(let rScale)):
        return lScale == rScale
    default:
        return false
    }
}

public func ==(lhs: FocusableViewWiggleStyle, rhs: FocusableViewWiggleStyle) -> Bool {
    switch (lhs, rhs) {
    case (.PerspectiveRotation, .PerspectiveRotation):
        return true
    case (.Translation, .Translation):
        return true
    default:
        return false
    }
}

public func ==(lhs: FocusableViewWiggle, rhs: FocusableViewWiggle) -> Bool {
    return lhs.style == rhs.style && lhs.direction == rhs.direction
}

public func ==(lhs: FocusableViewBackgroundStyle, rhs: FocusableViewBackgroundStyle) -> Bool {
    switch (lhs, rhs) {
    case (.None, .None):
        return true
    case let (.Blur(lBlur), .Blur(rBlur)):
        return lBlur == rBlur
    case let (.Color(lColor), .Color(rColor)):
        return lColor == rColor
    default:
        return false
    }
}

#endif

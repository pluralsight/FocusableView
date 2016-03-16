//
//  ViewController.swift
//  FocusView
//
//  Created by Dev Team on 3/16/16.
//  Copyright © 2016 Pluralsight. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var topLeftView: FocusableView!
    @IBOutlet weak var topMiddleView: FocusableView!
    @IBOutlet weak var topRightView: FocusableView!

    @IBOutlet weak var bottomLeftView: FocusableView!
    @IBOutlet weak var bottomMiddleView: FocusableView!
    @IBOutlet weak var bottomRightView: FocusableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topLeftView.focusedBackgroundStyle = .Blur(UIBlurEffectStyle.Dark)
        topLeftView.focusStyle = .None
        topLeftView.wiggle = FocusableViewWiggle(style: .Translation, direction: [.Vertical])
        topLeftView.showsShadowOnFocus = true
        topLeftView.enabled = true
        
        topMiddleView.focusedBackgroundStyle = .Blur(UIBlurEffectStyle.Light)
        topMiddleView.focusStyle = .Grow(scale: FocusableViewFocusStyle.defaultScale)
        topMiddleView.wiggle = FocusableViewWiggle(style: .PerspectiveRotation, direction: [.Horizontal])
        topMiddleView.showsShadowOnFocus = true
        topMiddleView.enabled = true
        
        topRightView.focusedBackgroundStyle = .Blur(UIBlurEffectStyle.ExtraLight)
        topRightView.focusStyle = .Grow(scale: 1.5)
        topRightView.wiggle = FocusableViewWiggle(style: .PerspectiveRotation, direction: [.Horizontal])
        topRightView.showsShadowOnFocus = false
        topRightView.enabled = true
        
        bottomLeftView.focusedBackgroundStyle = .Color(UIColor.blueColor())
        bottomLeftView.focusStyle = .Grow(scale: FocusableViewFocusStyle.defaultScale)
        bottomLeftView.wiggle = FocusableViewWiggle(style: .PerspectiveRotation, direction: [.Horizontal, .Vertical])
        bottomLeftView.showsShadowOnFocus = true
        bottomLeftView.enabled = true
        
        bottomMiddleView.focusedBackgroundStyle = .None
        bottomMiddleView.focusStyle = .Grow(scale: FocusableViewFocusStyle.defaultScale)
        bottomMiddleView.wiggle = FocusableViewWiggle(style: .PerspectiveRotation, direction: [.Horizontal, .Vertical])
        bottomMiddleView.showsShadowOnFocus = false
        bottomMiddleView.enabled = true
        
        bottomRightView.focusedBackgroundStyle = .Color(UIColor.blackColor())
        bottomRightView.focusStyle = .Grow(scale: FocusableViewFocusStyle.defaultScale)
        bottomRightView.wiggle = FocusableViewWiggle(style: .PerspectiveRotation, direction: [.Horizontal, .Vertical])
        bottomRightView.showsShadowOnFocus = false
        bottomRightView.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


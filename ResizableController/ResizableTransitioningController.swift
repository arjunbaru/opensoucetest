//
//  ResizableTransitioningController.swift
//  EQCore
//
//  Created by Arjun Baru on 25/04/20.
//  Copyright © 2020 Paytm Money 🚀. All rights reserved.
//

import UIKit

public class ResizableTransitioningController: NSObject, UIViewControllerTransitioningDelegate {

    private let animationDuration: TimeInterval
    private var gestureRecoganiser: ResizableControllerObserver!

    private var initialTopOffset: CGFloat
    private var estimatedFinalTopOffset = ResizableConstants.maximumTopOffset {
        didSet {
            self.transitionincontroller?.estimatedFinalTopOffset = estimatedFinalTopOffset
        }
    }

    private lazy var transitionincontroller = ResizableAnimatedController(
        initialTopOffset: initialTopOffset,
        animationDuration: animationDuration,
        isPresenting: true,
        estimatedFinalTopOffset: estimatedFinalTopOffset)

    public init?(initialTopOffset: CGFloat,
         animationDuration: TimeInterval) {
        guard initialTopOffset >= ResizableConstants.maximumTopOffset else { return nil }

        self.animationDuration = animationDuration
        self.initialTopOffset = initialTopOffset
    }

    public convenience init?(fixedTopOffset: CGFloat = ResizableConstants.maximumTopOffset,
                            animationDuration: TimeInterval = ResizableConstants.animationDuration) {
        self.init(initialTopOffset: fixedTopOffset, animationDuration: animationDuration)

        self.estimatedFinalTopOffset = fixedTopOffset
    }

    public func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {

        if let presentedVc = presented as? ResizableControllerPositionHandler {
            gestureRecoganiser = ResizableControllerObserver(withSwipeDelegate: presentedVc, duration: animationDuration)
            gestureRecoganiser.estimatedFinalTopOffset = presentedVc.finalTopOffset
            gestureRecoganiser.estimatedInitialTopOffset = presentedVc.initialTopOffset
            gestureRecoganiser.presentingVC = presenting

            self.transitionincontroller = ResizableAnimatedController(
                initialTopOffset: presentedVc.initialTopOffset,
                animationDuration: animationDuration,
                isPresenting: true,
                estimatedFinalTopOffset: estimatedFinalTopOffset)
        } else if estimatedFinalTopOffset != initialTopOffset {
            gestureRecoganiser = ResizableControllerObserver(in: presented.view, duration: animationDuration)
            gestureRecoganiser.estimatedFinalTopOffset = estimatedFinalTopOffset
            gestureRecoganiser.estimatedInitialTopOffset = initialTopOffset
            gestureRecoganiser.presentingVC = presenting
        }

        transitionincontroller?.isPresenting = true
        return transitionincontroller
    }

    public func animationController(forDismissed dismissed: UIViewController)
      -> UIViewControllerAnimatedTransitioning? {
        transitionincontroller?.isPresenting = false
        return transitionincontroller
    }
}

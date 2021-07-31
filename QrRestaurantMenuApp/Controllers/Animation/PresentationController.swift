//
//  PresentationController.swift
//  QRRestarantMenuApp
//
//  Created by ryan on 6/12/21.
//

import UIKit

class PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        let halfHeight = bounds.height / 2.2
        return CGRect(x: 0,
                             y: halfHeight,
                             width: bounds.width,
                             height: bounds.height/1.5)
    }
    override func presentationTransitionWillBegin() {
            super.presentationTransitionWillBegin()
            containerView?.addSubview(presentedView!)
        }

    override func containerViewDidLayoutSubviews() {
            super.containerViewDidLayoutSubviews()
            presentedView?.frame = frameOfPresentedViewInContainerView
        }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}



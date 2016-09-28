//
//  MarkerSelectFeedbackCalloutView.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 28.09.16.
//  Copyright © 2016 rmnblm. All rights reserved.
//

import UIKit
import Mapbox

class MarkerSelectFeedbackCalloutView : UIView, MGLCalloutView {
    
    public var representedObject: MGLAnnotation
    public var leftAccessoryView = UIView()
    public var rightAccessoryView = UIView()
    
    weak public var delegate: MGLCalloutViewDelegate?
    
    private let tipHeight: CGFloat = 10.0
    private let tipWidth: CGFloat = 20.0
    
    private let mainBody: UIButton
    
    init(annotation: MGLAnnotation) {
        self.representedObject = annotation
        self.mainBody = UIButton(type: .system)
        
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.clear
        
        mainBody.backgroundColor = UIColor.white
        mainBody.tintColor = UIColor.white
        mainBody.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        mainBody.layer.cornerRadius = 4.0
        
        addSubview(mainBody)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedView: UIView, animated: Bool) {
        if !representedObject.responds(to: #selector(getter: representedObject.title)) {
            return
        }
        
        view.addSubview(self)
        
        mainBody.setTitle(representedObject.title!, for: .normal)
        mainBody.sizeToFit()
        
        if isCalloutTappable() {
            mainBody.addTarget(self, action: #selector(MarkerSelectFeedbackCalloutView.calloutTapped), for: .touchUpInside)
        } else {
            mainBody.isUserInteractionEnabled = false
        }
        
        let frameWidth = mainBody.bounds.size.width
        let frameHeight = mainBody.bounds.size.height + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - frameHeight
        frame = CGRect(x: frameOriginX, y: frameOriginY, width: frameWidth, height: frameHeight)
        
        if animated {
            alpha = 0
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.alpha = 1
            }
        }
    }
    
    public func dismissCallout(animated: Bool) {
        if (superview != nil) {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.removeFromSuperview()
                    })
            } else {
                removeFromSuperview()
            }
        }
    }
    
    func isCalloutTappable() -> Bool {
        if let delegate = delegate {
            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }
    
    
    func calloutTapped() {
        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }
}

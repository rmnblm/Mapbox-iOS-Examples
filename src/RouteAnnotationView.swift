//
//  DraggableAnnotationView.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 06.03.17.
//  Copyright © 2017 rmnblm. All rights reserved.
//

import Mapbox

class RouteAnnotationView: MGLAnnotationView {

    weak var delegate: RouteAnnotationViewDelegate?

    private func commonInit(_ size: CGFloat) {
        isDraggable = true
        scalesWithViewingDistance = false

        frame = CGRect(x: 0, y: 0, width: size, height: size)

        backgroundColor = .red

        layer.cornerRadius = size / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOpacity = 0.1
    }

    init(reuseIdentifier: String, size: CGFloat) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit(size)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(frame.width)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit(frame.width)
    }

    override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)

        switch dragState {
        case .starting:
            startDragging()
        case .ending, .canceling:
            endDragging()
        case .dragging:
            delegate?.didDrag(self)
        case .none:
            return
        }
    }

    func startDragging() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 0.8
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        }, completion: nil)

        delegate?.dragStarted(self)
    }

    func endDragging() {
        transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 1
            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        }, completion: nil)

        delegate?.dragEnded(self)
    }
}

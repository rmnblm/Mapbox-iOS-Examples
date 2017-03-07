//
//  DraggableAnnotationViewDelegate.swift
//  Mapbox-iOS-Examples
//
//  Created by Roman Blum on 06.03.17.
//  Copyright © 2017 rmnblm. All rights reserved.
//

import Foundation

protocol RouteAnnotationViewDelegate: class {
    func dragStarted(_ annotationView: RouteAnnotationView)
    func didDrag(_ annotationView: RouteAnnotationView)
    func dragEnded(_ annotationView: RouteAnnotationView)
}

extension RouteAnnotationViewDelegate {
    func dragStarted(_ annotationView: RouteAnnotationView) { }
    func didDrag(_ annotationView: RouteAnnotationView) { }
    func dragEnded(_ annotationView: RouteAnnotationView) { }
}

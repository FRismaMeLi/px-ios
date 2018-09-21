//
//  PXHookComponent.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 11/28/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

/** :nodoc: */
@objc internal protocol PXHookComponent: NSObjectProtocol {
    func hookForStep() -> PXHookStep
    @objc func configViewController() -> UIViewController
    @objc optional func shouldSkipHook(hookStore: PXCheckoutStore) -> Bool
    @objc optional func didReceive(hookStore: PXCheckoutStore)
    @objc optional func navigationHandlerForHook(navigationHandler: PXHookNavigationHandler)
}

@objc public protocol PXPreReviewScreen: NSObjectProtocol {
    @objc func configViewController() -> UIViewController
    @objc func shouldSkipHook(hookStore: PXCheckoutStore) -> Bool
    @objc optional func didReceive(hookStore: PXCheckoutStore)
    @objc optional func navigationHandlerForHook(navigationHandler: PXHookNavigationHandler)
}

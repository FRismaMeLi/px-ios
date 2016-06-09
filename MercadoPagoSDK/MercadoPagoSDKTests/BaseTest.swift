//
//  BaseCase.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 21/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class BaseTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        MercadoPagoContext.setPublicKey(MockBuilder.MOCK_PUBLIC_KEY)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func simulateViewDidLoadFor(viewController : UIViewController){
        MercadoPagoUIViewController.loadFont(MercadoPago.DEFAULT_FONT_NAME)
        let nav = UINavigationController()
        nav.pushViewController(viewController, animated: false)
        let _ = viewController.view
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
    }
    
    
    
}
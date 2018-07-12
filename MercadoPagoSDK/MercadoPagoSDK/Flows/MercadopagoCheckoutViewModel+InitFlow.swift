//
//  MercadopagoCheckoutViewModel+InitFlow.swift
//  MercadoPagoSDK
//
//  Created by Juan sebastian Sanzone on 4/7/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

// MARK: Init Flow
extension MercadoPagoCheckoutViewModel {

    func createInitFlow() {
        // Create init flow props.
        let initFlowNavHandler = PXNavigationHandler.init(navigationController: UINavigationController())
        let initFlowProperties: InitFlowProperties
        initFlowProperties.checkoutPreference = self.checkoutPreference
        initFlowProperties.paymentData = self.paymentData
        initFlowProperties.paymentResult = self.paymentResult
        initFlowProperties.paymentMethodPlugins = self.paymentMethodPlugins
        initFlowProperties.paymentPlugin = self.paymentPlugin
        initFlowProperties.paymentMethodSearchResult = self.search
        initFlowProperties.chargeRules = self.chargeRules
        initFlowProperties.campaigns = self.campaigns
        initFlowProperties.directDiscountSearchStatus = paymentData.isComplete()
        initFlowProperties.loadPreferenceStatus = isPreferenceLoaded()

        // Create init flow.
        initFlow = InitFlow(navigationHandler: initFlowNavHandler, flowProperties: initFlowProperties, finishCallback: { paymentMethodSearchResponse in
            self.updateCheckoutModel(paymentMethodSearch: paymentMethodSearchResponse)
            self.initFlowProtocol?.didFinishInitFlow()
        }, errorCallback: { initFlowError in
            self.initFlowProtocol?.didFailInitFlow(flowError: initFlowError)
        })
    }

    func setInitFlowProtocol(flowInitProtocol: InitFlowProtocol) {
        initFlowProtocol = flowInitProtocol
    }

    func startInitFlow() {
        initFlow?.start()
    }

    func updateInitFlow() {
        initFlow?.updateModel(paymentPlugin: self.paymentPlugin, paymentMethodPlugins: self.paymentMethodPlugins)
    }
}

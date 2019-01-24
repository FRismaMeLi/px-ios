//
//  PXPaymentConfigurationServices.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 27/11/18.
//

import UIKit

class PXPaymentConfigurationServices {
    
    private var configurations: Set<PXPaymentMethodConfiguration> = []
    private var defaultDiscountConfiguration: PXDiscountConfiguration?

    // Payer Costs for Payment Method
    func getPayerCostsForPaymentMethod(_ id: String) -> [PXPayerCost]? {
        if let configuration = configurations.first(where: {$0.paymentOptionID == id}) {
            if let paymentOptionConfiguration = configuration.paymentOptionsConfigurations.first(where: {$0.id == configuration.selectedAmountConfiguration}) {
                return paymentOptionConfiguration.payerCostConfiguration?.payerCosts
            }
        }
        return nil
    }

    // Selected Payer Cost for Payment Method
    func getSelectedPayerCostsForPaymentMethod(_ id: String) -> PXPayerCost? {
        if let configuration = configurations.first(where: {$0.paymentOptionID == id}) {
            if let paymentOptionConfiguration = configuration.paymentOptionsConfigurations.first(where: {$0.id == configuration.selectedAmountConfiguration}) {
                return paymentOptionConfiguration.payerCostConfiguration?.selectedPayerCost
            }
        }
        return nil
    }

    // Discount Info for Payment Method
    func getDiscountInfoForPaymentMethod(_ id: String) -> String? {
        if let configuration = configurations.first(where: {$0.paymentOptionID == id}) {
            return configuration.discountInfo
        }
        return nil
    }

    // Discount Configuration for Payment Method
    func getDiscountConfigurationForPaymentMethod(_ id: String) -> PXDiscountConfiguration? {
        if let configuration = configurations.first(where: {$0.paymentOptionID == id}) {
            if let paymentOptionConfiguration = configuration.paymentOptionsConfigurations.first(where: {$0.id == configuration.selectedAmountConfiguration}) {
                let discountConfiguration = paymentOptionConfiguration.discountConfiguration
                return discountConfiguration
            }
        }
        return nil
    }

    // Discount Configuration for Payment Method or Default
    func getDiscountConfigurationForPaymentMethodOrDefault(_ id: String?) -> PXDiscountConfiguration? {
        if let id = id, let pmDiscountConfiguration = getDiscountConfigurationForPaymentMethod(id) {
            return pmDiscountConfiguration
        }
        return getDefaultDiscountConfiguration()
    }

    // Default Discount Configuration
    func getDefaultDiscountConfiguration() -> PXDiscountConfiguration? {
        return self.defaultDiscountConfiguration
    }

    // All Configurations
    func getConfigurationsForPaymentMethod(_ id: String) -> [PXPaymentOptionConfiguration]? {
        if let config = configurations.first(where: {$0.paymentOptionID == id}) {
            return config.paymentOptionsConfigurations
        }
        return nil
    }

    func setConfigurations(_ configurations: Set<PXPaymentMethodConfiguration>) {
        self.configurations = configurations
    }

    func setDefaultDiscountConfiguration(_ discountConfiguration: PXDiscountConfiguration?) {
        self.defaultDiscountConfiguration = discountConfiguration
    }
}

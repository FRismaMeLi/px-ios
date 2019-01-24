//
//  PXAmountHelper.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 29/5/18.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

internal struct PXAmountHelper {

    internal let preference: PXCheckoutPreference
    internal let paymentData: PXPaymentData
    internal let chargeRules: [PXPaymentTypeChargeRule]?
    internal let consumedDiscount: Bool
    internal let paymentConfigurationService: PXPaymentConfigurationServices

    var discount: PXDiscount? {
        get {
            return paymentData.discount
        }
    }

    var campaign: PXCampaign? {
        get {
            return paymentData.campaign
        }
    }

    var preferenceAmount: Double {
        get {
            return self.preference.getTotalAmount()
        }
    }

    var preferenceAmountWithCharges: Double {
        get {
            return preferenceAmount + chargeRuleAmount
        }
    }

    var amountToPay: Double {
        get {
            if let payerCost = paymentData.payerCost {
                return payerCost.totalAmount
            }
            if let couponAmount = paymentData.discount?.couponAmount {
                return preferenceAmount - couponAmount + chargeRuleAmount
            } else {
                return preferenceAmount + chargeRuleAmount
            }
        }
    }

    var amountToPayWithoutPayerCost: Double {
        get {
            if let couponAmount = paymentData.discount?.couponAmount {
                return preferenceAmount - couponAmount + chargeRuleAmount
            } else {
                return preferenceAmount + chargeRuleAmount
            }
        }
    }

    var amountOff: Double {
        get {
            guard let discount = self.paymentData.discount else {
                return 0
            }
            return discount.couponAmount
        }
    }

    var maxCouponAmount: Double? {
        get {
            if let maxCouponAmount = paymentData.campaign?.maxCouponAmount, maxCouponAmount > 0.0 {
                return maxCouponAmount
            }
            return nil
        }
    }

    internal var chargeRuleAmount: Double {
        get {
            guard let rules = chargeRules else {
                return 0
            }
            for rule in rules {
                if rule.paymentMethdodId == paymentData.paymentMethod?.paymentTypeId {
                    return rule.amountCharge
                }
            }
            return 0
        }
    }
}

//
//  PXPaymentFlow+Services.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 16/07/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation

internal extension PXPaymentFlow {
    func createPaymentWithPlugin(plugin: PXPaymentProcessor?) {
        guard let paymentData = model.paymentData, let plugin = plugin else {
            return
        }

        plugin.didReceive?(checkoutStore: PXCheckoutStore.sharedInstance)

        plugin.startPayment?(checkoutStore: PXCheckoutStore.sharedInstance, errorHandler: self as PXPaymentProcessorErrorHandler, successWithBusinessResult: { [weak self] businessResult in
            self?.model.businessResult = businessResult
            self?.executeNextStep()
            }, successWithPaymentResult: { [weak self] paymentPluginResult in

                if paymentPluginResult.statusDetail == PXRejectedStatusDetail.INVALID_ESC.rawValue {
                    self?.paymentErrorHandler?.escError()
                    return
                }

                let paymentResult = PaymentResult(status: paymentPluginResult.status, statusDetail: paymentPluginResult.statusDetail, paymentData: paymentData, payerEmail: nil, paymentId: paymentPluginResult.receiptId, statementDescription: nil)
                self?.model.paymentResult = paymentResult
                self?.executeNextStep()
        })

    }

    func createPayment() {
        guard let paymentData = model.paymentData, let checkoutPreference = model.checkoutPreference else {
            return
        }

        var paymentBody: [String: Any]
        let mpPayment = MPPayment(preferenceId: checkoutPreference.preferenceId, publicKey: model.mercadoPagoServicesAdapter.mercadoPagoServices.merchantPublicKey, paymentData: paymentData, binaryMode: model.checkoutPreference?.isBinaryMode() ?? false)
        paymentBody = mpPayment.toJSON()

        model.mercadoPagoServicesAdapter.createPayment(url: URLConfigs.MP_API_BASE_URL, uri: URLConfigs.MP_PAYMENTS_URI + "?api_version=" + URLConfigs.API_VERSION, paymentData: paymentBody as NSDictionary, query: nil, callback: { (payment) in
            guard let paymentData = self.model.paymentData else {
                return
            }
            let paymentResult = PaymentResult(payment: payment, paymentData: paymentData)
            self.model.paymentResult = paymentResult
            self.executeNextStep()

        }, failure: { [weak self] (error) in

            let mpError = MPSDKError.convertFrom(error, requestOrigin: ApiUtil.RequestOrigin.CREATE_PAYMENT.rawValue)

            // ESC error
            if let apiException = mpError.apiException, apiException.containsCause(code: ApiUtil.ErrorCauseCodes.INVALID_PAYMENT_WITH_ESC.rawValue) {
                self?.paymentErrorHandler?.escError()

                // Identification number error
            } else if let apiException = mpError.apiException, apiException.containsCause(code: ApiUtil.ErrorCauseCodes.INVALID_PAYMENT_IDENTIFICATION_NUMBER.rawValue) {
                self?.paymentErrorHandler?.identificationError?()

            } else {
                self?.showError(error: mpError)
            }

        })
    }

    func getInstructions() {
        guard let paymentResult = model.paymentResult else {
            fatalError("Get Instructions - Payment Result does no exist")
        }

        guard let paymentId = paymentResult.paymentId else {
            fatalError("Get Instructions - Payment Id does no exist")
        }

        guard let paymentTypeId = paymentResult.paymentData?.getPaymentMethod()?.paymentTypeId else {
            fatalError("Get Instructions - Payment Method Type Id does no exist")
        }

        model.mercadoPagoServicesAdapter.getInstructions(paymentId: paymentId, paymentTypeId: paymentTypeId, callback: { [weak self] (instructionsInfo) in
            self?.model.instructionsInfo = instructionsInfo
            self?.executeNextStep()

            }, failure: {[weak self] (error) in

                let mpError = MPSDKError.convertFrom(error, requestOrigin: ApiUtil.RequestOrigin.GET_INSTRUCTIONS.rawValue)
                self?.showError(error: mpError)

        })
    }
}
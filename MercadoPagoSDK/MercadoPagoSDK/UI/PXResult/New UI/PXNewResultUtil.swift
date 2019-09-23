//
//  PXNewResultUtil.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 19/09/2019.
//

import Foundation
import MLBusinessComponents

class PXNewResultUtil {

    static let shouldUseMockedData = true

    //HEADER DATA
    class func getDataForHeaderView(color: UIColor?, title: String, icon: UIImage?, iconURL: String?, badgeImage: UIImage?, closeAction: (() -> Void)?) -> PXNewResultHeaderData {

        return PXNewResultHeaderData(color: color, title: title, icon: icon, iconURL: iconURL, badgeImage: badgeImage, closeAction: closeAction)
    }

    //PAYMENT METHOD ICON
    class func getPaymentMethodIcon(paymentMethod: PXPaymentMethod) -> UIImage? {
        let defaultColor = paymentMethod.paymentTypeId == PXPaymentTypes.ACCOUNT_MONEY.rawValue && paymentMethod.paymentTypeId != PXPaymentTypes.PAYMENT_METHOD_PLUGIN.rawValue
        var paymentMethodImage: UIImage? =  ResourceManager.shared.getImageForPaymentMethod(withDescription: paymentMethod.id, defaultColor: defaultColor)
        // Retrieve image for payment plugin or any external payment method.
        if paymentMethod.paymentTypeId == PXPaymentTypes.PAYMENT_METHOD_PLUGIN.rawValue {
            paymentMethodImage = paymentMethod.getImageForExtenalPaymentMethod()
        }
        return paymentMethodImage
    }

    //PAYMENT METHOD DATA
    class func getDataForPaymentMethodView(paymentData: PXPaymentData, amountHelper: PXAmountHelper) -> PXNewCustomViewData? {
        guard let paymentMethod = paymentData.paymentMethod else {
            return nil
        }

        let totalAmountAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: Utils.getSemiBoldFont(size: PXLayout.XS_FONT),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.45)
        ]

        let interestRateAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: Utils.getSemiBoldFont(size: PXLayout.XS_FONT),
            NSAttributedString.Key.foregroundColor: ThemeManager.shared.noTaxAndDiscountLabelTintColor()
        ]

        let discountAmountAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: Utils.getSemiBoldFont(size: PXLayout.XS_FONT),
            NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.45),
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue
        ]

        let image = getPaymentMethodIcon(paymentMethod: paymentMethod)
        let currency = SiteManager.shared.getCurrency()

        let firstString: NSMutableAttributedString = NSMutableAttributedString()
        let secondString: NSAttributedString?
        var thirdString: NSAttributedString?

        // First String
        if let payerCost = paymentData.payerCost {
            if payerCost.installments > 1 {
                let titleString = String(payerCost.installments) + "x " + Utils.getAmountFormated(amount: payerCost.installmentAmount, forCurrency: currency)
                let attributedTitle = NSAttributedString(string: titleString, attributes: PXNewCustomView.titleAttributes)
                firstString.append(attributedTitle)

                // Installment Rate
                if payerCost.installmentRate == 0.0 {
                    let interestRateString = " " + "Sin\u{00a0}interés".localized.lowercased()
                    let attributedInsterest = NSAttributedString(string: interestRateString, attributes: interestRateAttributes)
                    firstString.appendWithSpace(attributedInsterest)
                }

                // Total Amount
                let totalString = Utils.getAmountFormated(amount: payerCost.totalAmount, forCurrency: currency, addingParenthesis: true)
                let attributedTotal = NSAttributedString(string: totalString, attributes: totalAmountAttributes)
                firstString.appendWithSpace(attributedTotal)
            } else {
                let titleString = Utils.getAmountFormated(amount: payerCost.totalAmount, forCurrency: currency)
                let attributedTitle = NSAttributedString(string: titleString, attributes: PXNewCustomView.titleAttributes)
                firstString.append(attributedTitle)
            }
        } else {
            // Caso account money

            if let splitAccountMoneyAmount = paymentData.getTransactionAmountWithDiscount() {
                let string = Utils.getAmountFormated(amount: splitAccountMoneyAmount, forCurrency: currency)
                let attributed = NSAttributedString(string: string, attributes: PXNewCustomView.titleAttributes)
                firstString.append(attributed)
            } else {
                let string = Utils.getAmountFormated(amount: amountHelper.amountToPay, forCurrency: currency)
                let attributed = NSAttributedString(string: string, attributes: PXNewCustomView.titleAttributes)
                firstString.append(attributed)
            }
        }

        // Discount
        if let discount = paymentData.getDiscount(), let transactionAmount = paymentData.transactionAmount {
            let transactionAmount = Utils.getAmountFormated(amount: transactionAmount.doubleValue, forCurrency: currency)
            let attributedAmount = NSAttributedString(string: transactionAmount, attributes: discountAmountAttributes)

            firstString.appendWithSpace(attributedAmount)

            let discountString = discount.getDiscountDescription()
            let attributedString = NSAttributedString(string: discountString, attributes: interestRateAttributes)

            firstString.appendWithSpace(attributedString)
        }

        // Second String
        var pmDescription: String = ""
        let paymentMethodName = paymentMethod.name ?? ""

        if paymentMethod.isCard {
            if let lastFourDigits = (paymentData.token?.lastFourDigits) {
                pmDescription = paymentMethodName + " " + "terminada en ".localized + lastFourDigits
            }
        } else {
            pmDescription = paymentMethodName
        }

        let attributedSecond = NSMutableAttributedString(string: pmDescription, attributes: PXNewCustomView.subtitleAttributes)
        secondString = attributedSecond

        // Third String
        if let issuer = paymentData.getIssuer(), let issuerName = issuer.name, !issuerName.isEmpty, issuerName.lowercased() != paymentMethodName.lowercased() {

            let issuerAttributedString = NSMutableAttributedString(string: issuerName, attributes: PXNewCustomView.subtitleAttributes)

            thirdString = issuerAttributedString
        }

        let data = PXNewCustomViewData(firstString: firstString, secondString: secondString, thirdString: thirdString, icon: image, iconURL: nil, action: nil, color: .pxWhite)
        return data
    }

    //RECEIPT DATA
    class func getDataForReceiptView(paymentId: String?) -> PXNewCustomViewData? {
        guard let paymentId = paymentId else {
            return nil
        }

        let attributedTitle = NSAttributedString(string: "Operación".localized + " #" + paymentId, attributes: PXNewCustomView.titleAttributes)

        let date = Date()
        let attributedSubtitle = NSAttributedString(string: Utils.getFormatedStringDate(date), attributes: PXNewCustomView.subtitleAttributes)

        let data = PXNewCustomViewData(firstString: attributedTitle, secondString: attributedSubtitle, thirdString: nil, icon: nil, iconURL: nil, action: nil, color: nil)
        return data
    }

    //POINTS DATA
    class func getDataForPointsView(points: Points?) -> MLBusinessLoyaltyRingData? {
        if shouldUseMockedData {
            let mockData = LoyaltyRingData()
            return mockData
        }
        guard let points = points else {
            return nil
        }
        let data = PXRingViewData(points: points)
        return data
    }

    //DISCOUNTS DATA
    class func getDataForDiscountsView(discounts: Discounts?) -> MLBusinessDiscountBoxData? {
        if shouldUseMockedData {
            let mockData = DiscountData()
            return mockData
        }
        guard let discounts = discounts else {
            return nil
        }
        let data = PXDiscountsBoxData(discounts: discounts)
        return data
    }

    //DISCOUNTS ACCESSORY VIEW
    class func getDataForDiscountsAccessoryViewData(discounts: Discounts?) -> ResultViewData? {
        guard let discounts = discounts else {
            return nil
        }
        if MLBusinessAppDataService().isMpAlreadyInstalled() {
            let button = PXOutlinedSecondaryButton()
            button.buttonTitle = discounts.discountsAction.label

            button.add(for: .touchUpInside) {
                //open deep link
                PXDeepLinkManager.open(discounts.discountsAction.target)
            }
            return ResultViewData(view: button, verticalMargin: PXLayout.M_MARGIN, horizontalMargin: PXLayout.L_MARGIN)
        } else if MLBusinessAppDataService().isMeli() {
            let downloadAppDelegate = PXDownloadAppData(discounts: discounts)
            let downloadAppView = MLBusinessDownloadAppView(downloadAppDelegate)
            downloadAppView.addTapAction { (deepLink) in
                //open deep link
                PXDeepLinkManager.open(deepLink)
            }
            return ResultViewData(view: downloadAppView, verticalMargin: PXLayout.M_MARGIN, horizontalMargin: PXLayout.L_MARGIN)
        } else {
            return nil
        }
    }

    //CROSS SELLING VIEW
    class func getDataForCrossSellingView(crossSellingItems: [PXCrossSellingItem]?) -> [MLBusinessCrossSellingBoxData]? {
        if shouldUseMockedData {
            let mockData = CrossSellingBoxData()
            return [mockData]
        }
        guard let crossSellingItems = crossSellingItems else {
            return nil
        }
        var data = [MLBusinessCrossSellingBoxData]()
        for item in crossSellingItems {
            data.append(PXCrossSellingItemData(item: item))
        }
        return data
    }
}

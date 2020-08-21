//
//  PXPaymentCongratsViewModel.swift
//  Pods
//
//  Created by Franco Risma on 28/07/2020.
//

import Foundation

class PXPaymentCongratsViewModel {
    
    private let paymentCongrats: PXPaymentCongrats

    init(paymentCongrats: PXPaymentCongrats) {
        self.paymentCongrats = paymentCongrats
    }
    
    func launch() {
        let vc = PXNewResultViewController(viewModel: self)
        paymentCongrats.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Private methods
    private func createPaymentMethodReceiptData(from paymentInfo: PXCongratsPaymentInfo) -> PXNewCustomViewData {
        let firstString = PXNewResultUtil.formatPaymentMethodFirstString(paymentInfo: paymentInfo)
        
        let secondString = PXNewResultUtil.formatPaymentMethodSecondString(paymentMethodName: paymentInfo.paymentMethodName,
                                                                           paymentMethodLastFourDigits: paymentInfo.paymentMethodLastFourDigits,
                                                                           paymentType: paymentInfo.paymentMethodType)
        
        let thirdString = PXNewResultUtil.formatPaymentMethodThirdString(paymentInfo.paymentMethodDescription)
        
        let icon = PXNewResultUtil.getPaymentMethodIcon(paymentType: paymentInfo.paymentMethodType, paymentMethodId: paymentInfo.paymentMethodId, externalPaymentMethodImage: paymentInfo.externalPaymentMethodImage)
        
        return PXNewCustomViewData(firstString: firstString, secondString: secondString, thirdString: thirdString, icon: icon, iconURL: nil, action: nil, color: .white)
    }
}

extension PXPaymentCongratsViewModel: PXNewResultViewModelInterface {
    
    // HEADER
    func getHeaderColor() -> UIColor {
        guard let color = paymentCongrats.headerColor else {
            return ResourceManager.shared.getResultColorWith(status: paymentCongrats.type.getDescription())
        }
        return color
    }
    
    func getHeaderTitle() -> String {
        return paymentCongrats.headerTitle
    }
    
    func getHeaderIcon() -> UIImage? {
        return paymentCongrats.headerImage
    }
    
    func getHeaderURLIcon() -> String? {
        return paymentCongrats.headerURL
    }
    
    func getHeaderBadgeImage() -> UIImage? {
        guard let image = paymentCongrats.headerBadgeImage else {
            return ResourceManager.shared.getBadgeImageWith(status: paymentCongrats.type.getDescription())
        }
        return image
    }
    
    func getHeaderCloseAction() -> (() -> Void)? {
        return paymentCongrats.headerCloseAction
    }
    
    //RECEIPT
    func mustShowReceipt() -> Bool {
        return paymentCongrats.shouldShowReceipt
    }
    
    func getReceiptId() -> String? {
        return paymentCongrats.receiptId
    }
    
    //POINTS AND DISCOUNTS
    ///POINTS
    func getPoints() -> PXPoints? {
        return paymentCongrats.points
    }
    
    // This implementation is the same accross PXBusinessResultViewModel and PXResultViewModel, so it's ok to do it here
    func getPointsTapAction() -> ((String) -> Void)? {
        let action: (String) -> Void = { (deepLink) in
            //open deep link
            PXDeepLinkManager.open(deepLink)
            MPXTracker.sharedInstance.trackEvent(path: TrackingPaths.Events.Congrats.getSuccessTapScorePath())
        }
        return action
    }
    
    ///DISCOUNTS
    func getDiscounts() -> PXDiscounts? {
        return paymentCongrats.discounts
    }
    
    // This implementation is the same accross PXBusinessResultViewModel and PXResultViewModel, so it's ok to do it here
    func getDiscountsTapAction() -> ((Int, String?, String?) -> Void)? {
        let action: (Int, String?, String?) -> Void = { (index, deepLink, trackId) in
            //open deep link
            PXDeepLinkManager.open(deepLink)
            PXCongratsTracking.trackTapDiscountItemEvent(index, trackId)
        }
        return action
    }
    
    // This implementation is the same accross PXBusinessResultViewModel and PXResultViewModel, so it's ok to do it here
    func didTapDiscount(index: Int, deepLink: String?, trackId: String?) {
        PXDeepLinkManager.open(deepLink)
        PXCongratsTracking.trackTapDiscountItemEvent(index, trackId)
    }
    
    ///EXPENSE SPLIT VIEW
    func getExpenseSplit() -> PXExpenseSplit? {
        return paymentCongrats.expenseSplit
    }
    
    // This implementation is the same accross PXBusinessResultViewModel and PXResultViewModel, so it's ok to do it here
    func getExpenseSplitTapAction() -> (() -> Void)? {
        let action: () -> Void = { [weak self] in
            PXDeepLinkManager.open(self?.paymentCongrats.expenseSplit?.action.target)
            MPXTracker.sharedInstance.trackEvent(path: TrackingPaths.Events.Congrats.getSuccessTapDeeplinkPath(), properties: PXCongratsTracking.getDeeplinkProperties(type: "money_split", deeplink: self?.paymentCongrats.expenseSplit?.action.target ?? ""))
        }
        return action
    }
    
    func getCrossSellingItems() -> [PXCrossSellingItem]? {
        return paymentCongrats.crossSelling
    }
    
    ///CROSS SELLING
    // This implementation is the same accross PXBusinessResultViewModel and PXResultViewModel, so it's ok to do it here
    func getCrossSellingTapAction() -> ((String) -> Void)? {
        let action: (String) -> Void = { (deepLink) in
            //open deep link
            PXDeepLinkManager.open(deepLink)
            MPXTracker.sharedInstance.trackEvent(path: TrackingPaths.Events.Congrats.getSuccessTapCrossSellingPath())
        }
        return action
    }
    
    ////VIEW RECEIPT ACTION
    func getViewReceiptAction() -> PXRemoteAction? {
        return paymentCongrats.receiptAction
    }
    
    ////TOP TEXT BOX
    func getTopTextBox() -> PXText? {
        return nil
    }
    
    ////CUSTOM ORDER
    func getCustomOrder() -> Bool? {
        return paymentCongrats.hasCustomSorting
    }
    
    //INSTRUCTIONS
    func hasInstructions() -> Bool {
        return paymentCongrats.instructionsView != nil
    }
    
    func getInstructionsView() -> UIView? {
        return paymentCongrats.instructionsView
    }
    
    // PAYMENT METHOD
    func shouldShowPaymentMethod() -> Bool {
        return paymentCongrats.shouldShowPaymentMethod
    }
    
    func getPaymentViewData() -> PXNewCustomViewData? {
        guard let paymentInfo = paymentCongrats.paymentInfo else { return nil }
        return createPaymentMethodReceiptData(from: paymentInfo)
    }
    
    #warning("Desacoplar payment data del VC de Congrats")
    func getPaymentData() -> PXPaymentData? {
        // TODO
        return nil
    }
    
    #warning("Desacoplar ammount helper del VC de Congrats")
    func getAmountHelper() -> PXAmountHelper? {
        // TODO
        return nil
    }
    
    // SPLIT PAYMENT METHOD
    func getSplitPaymentViewData() -> PXNewCustomViewData? {
        guard let paymentInfo = paymentCongrats.splitPaymentInfo else { return nil }
        return createPaymentMethodReceiptData(from: paymentInfo)
    }
    
    #warning("Desacoplar payment data del VC de Congrats")
    func getSplitPaymentData() -> PXPaymentData? {
        // TODO
        return nil
    }
    
    #warning("Desacoplar ammount helper del VC de Congrats")
    func getSplitAmountHelper() -> PXAmountHelper? {
        // TODO
        return nil
    }
    
    // REJECTED BODY
    func shouldShowErrorBody() -> Bool {
        return paymentCongrats.errorBodyView != nil
    }
    
    func getErrorBodyView() -> UIView? {
        return paymentCongrats.errorBodyView
    }
    
    // REMEDY
    #warning("Chequear como la vista pasada va a recibir esos protocols que deberia ser la misma clase PXNewResultViewController")
    func getRemedyView(animatedButtonDelegate: PXAnimatedButtonDelegate?, remedyViewProtocol: PXRemedyViewProtocol?) -> UIView? {
         if isPaymentResultRejectedWithRemedy() {
            return paymentCongrats.remedyView
        }
        return nil
    }
    
    func getRemedyButtonAction() -> ((String?) -> Void)? {
        return paymentCongrats.remedyButtonAction
    }
    
    func isPaymentResultRejectedWithRemedy() -> Bool {
        return paymentCongrats.remedyView != nil
    }
    
    // FOOTER
    func getFooterMainAction() -> PXAction? {
        return paymentCongrats.mainAction
    }
    
    func getFooterSecondaryAction() -> PXAction? {
        return paymentCongrats.secondaryAction
    }
    
    // CUSTOM VIEWS
    func getImportantView() -> UIView? {
        return paymentCongrats.importantView
    }
    
    func getCreditsExpectationView() -> UIView? {
        guard paymentCongrats.paymentInfo?.paymentMethodId == "consumer_credits" else { return nil }
        return paymentCongrats.creditsExpectationView
    }
    
    func getTopCustomView() -> UIView? {
        return paymentCongrats.topView
    }
    
    func getBottomCustomView() -> UIView? {
        return paymentCongrats.bottomView
    }
    
    //CALLBACKS & TRACKING
    // TODO
    #warning("remove this when checkout uses payment congrats")
    func setCallback(callback: @escaping (PaymentResult.CongratsState, String?) -> Void) {
    }
    
    func getTrackingProperties() -> [String : Any] {
        return paymentCongrats.trackingValues
    }
    
    func getTrackingPath() -> String {
        var screenPath = ""
        if paymentCongrats.trackingValues != nil {
            let paymentStatus = paymentCongrats.type.getRawValue()
            if paymentStatus == PXPaymentStatus.APPROVED.rawValue || paymentStatus == PXPaymentStatus.PENDING.rawValue {
                screenPath = TrackingPaths.Screens.PaymentResult.getSuccessPath()
            } else if paymentStatus == PXPaymentStatus.IN_PROCESS.rawValue {
                screenPath = TrackingPaths.Screens.PaymentResult.getFurtherActionPath()
            } else if paymentStatus == PXPaymentStatus.REJECTED.rawValue {
                screenPath = TrackingPaths.Screens.PaymentResult.getErrorPath()
            }
        }
        
        return screenPath
    }
    
    func getFlowBehaviourResult() -> PXResultKey {
        if let result = paymentCongrats.flowBehaviourResult {
            return result
        }
        
        switch paymentCongrats.type {
        case .APPROVED:
            return .SUCCESS
        case .REJECTED:
            return .FAILURE
        case .PENDING:
            return .PENDING
        case .IN_PROGRESS:
            return .PENDING
        }
    }
    
    #warning("TBD")
    func shouldAutoReturn() -> Bool {
        return false
    }
    
    #warning("TBD")
    func getBackUrl() -> URL? {
        return nil
    }
    
    #warning("TBD")
    func getRedirectUrl() -> URL? {
        return nil
    }
}

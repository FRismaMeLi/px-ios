//
//  PXCongratsPayment.swift
//  MercadoPagoSDKV4
//
//  Created by Franco Risma on 14/07/2020.
//

import Foundation

// Este va a ser el builder
@objcMembers
public class PXCongratsBuilder {
    private var data: PXCongratsData
    
    public init() {
        data = PXCongratsData()
    }
    
    public func setStatus(_ status: PXBusinessResultStatus) -> PXCongratsBuilder {
        data.status = status
        return self
    }
    
    public func setHeaderTitle(_ title: String) -> PXCongratsBuilder {
        data.headerTitle = title
        return self
    }
     
    public func shouldShowReceipt(_ shouldShow: Bool, receiptId: String?) -> PXCongratsBuilder {
        data.shouldShowReceipt = shouldShow
        data.receiptId = receiptId
        return self
    }
    
    public func headerImage(_ image: UIImage?, orURL url: String?) -> PXCongratsBuilder {
        data.headerImage = image
        data.headerURL = url
        return self
    }
    
    public func addPointsData(percentage: Double, levelColor: String, levelNumber: Int, title: String, actionLabel: String, actionTarget: String) -> PXCongratsBuilder {
        let action = PXRemoteAction(label: actionLabel, target: actionTarget)
        data.pointsData = PXPoints(progress: PXPointsProgress(percentage: percentage, levelColor: levelColor, levelNumber: levelNumber), title: title, action: action)
        return self
    }
    
    public func addDiscounts() -> PXCongratsBuilder {
        data.discounts = PXDiscounts(title: "Descuentos por tu nivel", subtitle: "", discountsAction: PXRemoteAction(label: "Ver todos los descuentos", target: "mercadopago://discount_center_payers/list#from=/px/congrats"), downloadAction: PXDownloadAction(title: "Exclusivo con la app de Mercado Libre", action: PXRemoteAction(label: "Descargar", target: "https://852u.adj.st/discount_center_payers/list?adjust_t=ufj9wxn&adjust_deeplink=mercadopago%3A%2F%2Fdiscount_center_payers%2Flist&adjust_label=px-ml")), items: [PXDiscountsItem(icon: "https://mla-s1-p.mlstatic.com/766266-MLA32568902676_102019-O.jpg", title: "Hasta", subtitle: "20 % OFF", target: "mercadopago://discount_center_payers/detail?campaign_id=1018483&user_level=1&mcc=1091102&distance=1072139&coupon_used=false&status=FULL&store_id=13040071&sections=%5B%7B%22id%22%3A%22header%22%2C%22type%22%3A%22header%22%2C%22content%22%3A%7B%22logo%22%3A%22https%3A%2F%2Fmla-s1-p.mlstatic.com%2F766266-MLA32568902676_102019-O.jpg%22%2C%22title%22%3A%22At%C3%A9%20R%24%2010%22%2C%22subtitle%22%3A%22Nutty%20Bavarian%22%7D%7D%5D#from=/px/congrats", campaingId: "1018483"),PXDiscountsItem(icon: "https://mla-s1-p.mlstatic.com/826105-MLA32568902631_102019-O.jpg", title: "Hasta", subtitle: "20 % OFF", target: "mercadopago://discount_center_payers/detail?campaign_id=1018457&user_level=1&mcc=4771701&distance=543968&coupon_used=false&status=FULL&store_id=30316240&sections=%5B%7B%22id%22%3A%22header%22%2C%22type%22%3A%22header%22%2C%22content%22%3A%7B%22logo%22%3A%22https%3A%2F%2Fmla-s1-p.mlstatic.com%2F826105-MLA32568902631_102019-O.jpg%22%2C%22title%22%3A%22At%C3%A9%20R%24%2015%22%2C%22subtitle%22%3A%22Drogasil%22%7D%7D%5D#from=/px/congrats", campaingId: "1018457"),PXDiscountsItem(icon: "https://mla-s1-p.mlstatic.com/761600-MLA32568902662_102019-O.jpg", title: "Hasta", subtitle: "10 % OFF", target:  "mercadopago://discount_center_payers/detail?campaign_id=1018475&user_level=1&mcc=5611201&distance=654418&coupon_used=false&status=FULL&store_id=30108872&sections=%5B%7B%22id%22%3A%22header%22%2C%22type%22%3A%22header%22%2C%22content%22%3A%7B%22logo%22%3A%22https%3A%2F%2Fmla-s1-p.mlstatic.com%2F761600-MLA32568902662_102019-O.jpg%22%2C%22title%22%3A%22At%C3%A9%20R%24%2010%22%2C%22subtitle%22%3A%22McDonald%5Cu0027s%22%7D%7D%5D#from=/px/congrats", campaingId:"1018475") ], touchpoint: nil)
        return self
    }
    
    public func addCrossSelling() -> PXCongratsBuilder {
        data.crossSelling = [PXCrossSellingItem(title: "Gane 200 pesos por sus pagos diarios", icon: "https://mobile.mercadolibre.com/remote_resources/image/merchengine_mgm_icon_ml?density=xxhdpi&locale=es_AR", contentId: "cross_selling_mgm_ml", action: PXRemoteAction(label: "Invita a más amigos a usar la aplicación", target: "meli://invite/wallet"))]
        return self
    }
    
    public func addViews(important: UIView?, top: UIView?, bottom: UIView?) -> PXCongratsBuilder {
        data.importantView = important
        data.topView = top
        data.bottomView = bottom
        return self
    }
    
    public func start(using navController: UINavigationController) -> PXCongratsData {
        data.navigationController = navController
        return data
    }
    
//    public func setCloseCallback(_ closeAction: (PaymentResult.CongratsState, String?) -> ()) -> PXCongratsBuilder {
//        data.closeCallback = closeAction
//    }
}

public class PXCongratsData {
    
    // HEADER
    var status: PXBusinessResultStatus = .REJECTED
    var headerTitle: String = ""
    var headerImage: UIImage?
    var headerURL: String?
    
    // POINTS
    var pointsData: PXPoints?
    
    // DISCOUNTS
    var discounts: PXDiscounts?
    
    // CROSSSELLING
    var crossSelling: [PXCrossSellingItem]?
    
    // CUSTOM VIEWS
    var topView: UIView?
    var importantView: UIView?
    var bottomView: UIView?
    
    var closeCallback: (PaymentResult.CongratsState, String?) -> () = { state, text in
        print("congrats state \(state) and text \(text)")
    }
    var shouldShowReceipt: Bool = false
    var receiptId: String?
    var mainAction: PXAction? = PXAction(label: "MainAction") {
        print("congrats main action")
    }
    var secondaryAction: PXAction? = PXAction(label: "SecondAction") {
        print("congrats secondary action")
    }
    var errorMessage: String? = "Esto es un error"
    public var navigationController: UINavigationController!
    
    public init() {}
    
    
    
    // Esto no debería hacerse
    private func getErrorComponent() -> PXErrorComponent? {
        guard let labelInstruction = errorMessage else {
            return nil
        }

        let title = PXResourceProvider.getTitleForErrorBody()
        let props = PXErrorProps(title: title.toAttributedString(), message: labelInstruction.toAttributedString())

        return PXErrorComponent(props: props)
    }
}

extension PXCongratsData: PXNewResultViewModelInterface {
    func getHeaderColor() -> UIColor {
        return ResourceManager.shared.getResultColorWith(status: self.status.getDescription())
    }
    
    func getHeaderTitle() -> String {
        return headerTitle
    }
    
    func getHeaderIcon() -> UIImage? {
        return headerImage
    }
    
    func getHeaderURLIcon() -> String? {
        return headerURL
    }
    
    func getHeaderBadgeImage() -> UIImage? {
        return ResourceManager.shared.getBadgeImageWith(status: status.getDescription())
    }
    
    func getHeaderCloseAction() -> (() -> Void)? {
        let action = { [weak self] in
            if let callback = self?.closeCallback {
                callback(PaymentResult.CongratsState.EXIT, nil)
            }
        }
        return action
    }
    
    func mustShowReceipt() -> Bool {
        return shouldShowReceipt
    }
    
    func getReceiptId() -> String? {
        return receiptId
    }
    
    func getPoints() -> PXPoints? {
        return pointsData
    }
    
    func getPointsTapAction() -> ((String) -> Void)? {
        let action: (String) -> Void = { (deepLink) in
            //open deep link
            PXDeepLinkManager.open(deepLink)
            MPXTracker.sharedInstance.trackEvent(path: TrackingPaths.Events.Congrats.getSuccessTapScorePath())
        }
        return action
    }
    
    func getDiscounts() -> PXDiscounts? {
        return discounts
    }
    
    func getDiscountsTapAction() -> ((Int, String?, String?) -> Void)? {
        let action: (Int, String?, String?) -> Void = { (index, deepLink, trackId) in
            //open deep link
            PXDeepLinkManager.open(deepLink)
            PXCongratsTracking.trackTapDiscountItemEvent(index, trackId)
        }
        return action
    }
    
    func didTapDiscount(index: Int, deepLink: String?, trackId: String?) {
        PXDeepLinkManager.open(deepLink)
        PXCongratsTracking.trackTapDiscountItemEvent(index, trackId)
    }
    
    func getExpenseSplit() -> PXExpenseSplit? {
        // TODO
        return nil
//        return pointsAndDiscounts?.expenseSplit
    }
    
    func getExpenseSplitTapAction() -> (() -> Void)? {
        // TODO
//        let action: () -> Void = { [weak self] in
//            PXDeepLinkManager.open(self?.pointsAndDiscounts?.expenseSplit?.action.target)
//            MPXTracker.sharedInstance.trackEvent(path: TrackingPaths.Events.Congrats.getSuccessTapDeeplinkPath(), properties: PXCongratsTracking.getDeeplinkProperties(type: "money_split", deeplink: self?.pointsAndDiscounts?.expenseSplit?.action.target ?? ""))
//        }
//        return action
        return nil
    }
    
    func getCrossSellingItems() -> [PXCrossSellingItem]? {
        return crossSelling
    }
    
    func getCrossSellingTapAction() -> ((String) -> Void)? {
        let action: (String) -> Void = { (deepLink) in
            //open deep link
            PXDeepLinkManager.open(deepLink)
            MPXTracker.sharedInstance.trackEvent(path: TrackingPaths.Events.Congrats.getSuccessTapCrossSellingPath())
        }
        return action
    }
    
    func getViewReceiptAction() -> PXRemoteAction? {
        // TODO
        return nil
//        return pointsAndDiscounts?.viewReceiptAction
    }
    
    func getTopTextBox() -> PXText? {
        // TODO
        return nil
//        return pointsAndDiscounts?.topTextBox
    }
    
    func getCustomOrder() -> Bool? {
        // TODO
        return nil
//        return pointsAndDiscounts?.customOrder
    }
    
    func hasInstructions() -> Bool {
        return false
    }

    func getInstructionsView() -> UIView? {
        return nil
    }
    
    // Para que muestre el payment method, tenemos que devolver ademas paymentData
    func shouldShowPaymentMethod() -> Bool {
        #warning("logica especifica para comparar PXBusinessResultStatus con PXPaymentStatus")
        let isApproved = status.getDescription().lowercased() == PXPaymentStatus.APPROVED.rawValue.lowercased()
        return !hasInstructions() && isApproved
    }
    
    func getPaymentData() -> PXPaymentData? {
        // TODO
        return nil
//        return paymentData
    }
    
    func getAmountHelper() -> PXAmountHelper? {
        // TODO
        return nil
//        return amountHelper
    }
    
    func getSplitPaymentData() -> PXPaymentData? {
        // TODO
        return nil
//        return amountHelper.splitAccountMoney
    }
    
    func getSplitAmountHelper() -> PXAmountHelper? {
        // TODO
        return nil
//        return amountHelper
    }
    
    func shouldShowErrorBody() -> Bool {
        return getErrorComponent() != nil
    }
    
    func getErrorBodyView() -> UIView? {
        // TODO
        return nil
//        if let errorComponent = getErrorComponent() {
//            return errorComponent.render()
//        }
//        return nil
    }
    
    func getRemedyView(animatedButtonDelegate: PXAnimatedButtonDelegate?, remedyViewProtocol: PXRemedyViewProtocol?) -> UIView? {
        return nil
    }
    
    func getRemedyButtonAction() -> ((String?) -> Void)? {
        // TODO
        return nil
    }
    
    func isPaymentResultRejectedWithRemedy() -> Bool {
        return false
    }
    
    func getFooterMainAction() -> PXAction? {
        return mainAction
    }
    
    func getFooterSecondaryAction() -> PXAction? {
//        let linkAction = secondaryAction != nil ? businessResult.getSecondaryAction() : PXCloseLinkAction()
//        return linkAction
        // TODO
        return secondaryAction
    }
    
    func getImportantView() -> UIView? {
        return importantView
    }
    
    func getCreditsExpectationView() -> UIView? {
        // TODO
//        if let resultInfo = amountHelper.getPaymentData().getPaymentMethod()?.creditsDisplayInfo?.resultInfo,
//            let title = resultInfo.title,
//            let subtitle = resultInfo.subtitle,
//            businessResult.isApproved() {
//            return PXCreditsExpectationView(title: title, subtitle: subtitle)
//        }
        return nil
    }
    
    func getTopCustomView() -> UIView? {
        return topView
    }
    
    func getBottomCustomView() -> UIView? {
        return bottomView
    }
    
    func setCallback(callback: @escaping (PaymentResult.CongratsState, String?) -> Void) {
        // TODO
    }
    
    func getTrackingProperties() -> [String : Any] {
        // TODO
        return ["Franco": "Franco"]
    }
    
    func getTrackingPath() -> String {
        // TODO
        return "trackingPath"
    }
    
    func getFlowBehaviourResult() -> PXResultKey {
        switch status {
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
        
}

//
//  CongratsSelectorViewController.swift
//  ExampleSwift
//
//  Created by Daniel Alexander Silva on 8/6/20.
//  Copyright © 2020 Juan Sebastian Sanzone. All rights reserved.
//

import Foundation
import UIKit

#if PX_PRIVATE_POD
    import MercadoPagoSDKV4
#else
    import MercadoPagoSDK
#endif

class CongratsSelectorViewController: UITableViewController {
    
    private lazy var frismaCongrats: CongratsType = {
        let points = PXPoints(progress: PXPointsProgress(percentage: 0.85, levelColor: "#4063EA", levelNumber: 4),title: "Ud ganó 2.000 puntos", action: PXRemoteAction(label: "Ver mis beneficios", target: "meli://loyalty/webview?url=https%3A%2F%2Fwww.mercadolivre.com.br%2Fmercado-pontos%2Fv2%2Fhub%23origin%3Dcongrats"))
        let discounts = PXDiscounts(title: "Descuentos por tu nivel", subtitle: "", discountsAction: PXRemoteAction(label: "Ver todos los descuentos", target: "mercadopago://instore/buyer_qr"), downloadAction: PXDownloadAction(title: "Exclusivo con la app de Mercado Libre", action: PXRemoteAction(label: "Descargar", target: "https://852u.adj.st/discount_center_payers/list?adjust_t=ufj9wxn&adjust_deeplink=mercadopago%3A%2F%2Fdiscount_center_payers%2Flist&adjust_label=px-ml")), items: [PXDiscountsItem(icon: "https://mla-s1-p.mlstatic.com/766266-MLA32568902676_102019-O.jpg", title: "Hasta", subtitle: "20 % OFF", target: "mercadopago://discount_center_payers/detail?campaign_id=1018483&user_level=1&mcc=1091102&distance=1072139&coupon_used=false&status=FULL&store_id=13040071&sections=%5B%7B%22id%22%3A%22header%22%2C%22type%22%3A%22header%22%2C%22content%22%3A%7B%22logo%22%3A%22https%3A%2F%2Fmla-s1-p.mlstatic.com%2F766266-MLA32568902676_102019-O.jpg%22%2C%22title%22%3A%22At%C3%A9%20R%24%2010%22%2C%22subtitle%22%3A%22Nutty%20Bavarian%22%7D%7D%5D#from=/px/congrats", campaingId: "1018483"),PXDiscountsItem(icon: "https://mla-s1-p.mlstatic.com/826105-MLA32568902631_102019-O.jpg", title: "Hasta", subtitle: "20 % OFF", target: "mercadopago://discount_center_payers/detail?campaign_id=1018457&user_level=1&mcc=4771701&distance=543968&coupon_used=false&status=FULL&store_id=30316240&sections=%5B%7B%22id%22%3A%22header%22%2C%22type%22%3A%22header%22%2C%22content%22%3A%7B%22logo%22%3A%22https%3A%2F%2Fmla-s1-p.mlstatic.com%2F826105-MLA32568902631_102019-O.jpg%22%2C%22title%22%3A%22At%C3%A9%20R%24%2015%22%2C%22subtitle%22%3A%22Drogasil%22%7D%7D%5D#from=/px/congrats", campaingId: "1018457"),PXDiscountsItem(icon: "https://mla-s1-p.mlstatic.com/761600-MLA32568902662_102019-O.jpg", title: "Hasta", subtitle: "10 % OFF", target:  "mercadopago://discount_center_payers/detail?campaign_id=1018475&user_level=1&mcc=5611201&distance=654418&coupon_used=false&status=FULL&store_id=30108872&sections=%5B%7B%22id%22%3A%22header%22%2C%22type%22%3A%22header%22%2C%22content%22%3A%7B%22logo%22%3A%22https%3A%2F%2Fmla-s1-p.mlstatic.com%2F761600-MLA32568902662_102019-O.jpg%22%2C%22title%22%3A%22At%C3%A9%20R%24%2010%22%2C%22subtitle%22%3A%22McDonald%5Cu0027s%22%7D%7D%5D#from=/px/congrats", campaingId:"1018475")], touchpoint: nil)
        let expenseSplitText: PXText = PXText(message: "Expense split", backgroundColor: "#FFFFFF", textColor: "#000000", weight: nil)
        let expenseSplitAction = PXRemoteAction(label: "Expense Split Action", target: nil)
        let expenseSplitImage = "https://mla-s2-p.mlstatic.com/600619-MLA32239048138_092019-O.jpg"
        let crossSelling = [PXCrossSellingItem(title: "Gane 200 pesos por sus pagos diarios", icon: "https://mobile.mercadolibre.com/remote_resources/image/merchengine_mgm_icon_ml?density=xxhdpi&locale=es_AR", contentId: "cross_selling_mgm_ml", action: PXRemoteAction(label: "Invita a más amigos a usar la aplicación", target: "meli://invite/wallet"))]
        
        return CongratsType(congratsName: "FRisma", congratsData: PXPaymentCongrats()
            .withStatus(.APPROVED)
            .withHeaderTitle("¡Listo! Ya le pagaste a SuperMarket")
            .withHeaderImage(nil, orURL: "https://mla-s2-p.mlstatic.com/600619-MLA32239048138_092019-O.jpg")
                    .withHeaderCloseAction {
                        self.navigationController?.popViewController(animated: true)
            }
            .shouldShowReceipt(true, receiptId: "1234567890")
            .withPoints(points)
            .withDiscounts(discounts)
            .withExpenseSplit(expenseSplitText, action: expenseSplitAction, imageURL: expenseSplitImage)
            .withCrossSelling(crossSelling)
            .withViewReceiptAction(action: PXRemoteAction(label: "View Receipt Action", target: nil))
            .shouldHaveCustomOrder(true)
            .shouldShowInstructionView(false)
            .withInstructionView(UILabel())
            .withMainAction(label: "Continuar", action: {
                self.navigationController?.popViewController(animated: true)
            })
            .withSecondaryAction(label: "Tuve un problema", action: {
                self.navigationController?.popViewController(animated: true)
            })
            .withCustomViews(important: nil, top: nil, bottom: nil)
            .withCreditsExpectationView(UILabel())
            .withPaymentMethodInfo(PXCongratsPaymentInfo(paidAmount: "$ 10,133.64", transactionAmount: nil, paymentMethodName: "American Express", paymentMethodLastFourDigits: "1151", paymentMethodExtraInfo: nil, paymentMethodId: "amex", paymentMethodType: .CREDIT_CARD, hasInstallments: true, installmentsRate: 52.3, installmentsCount: 18, installmentAmount: "$ 562.98", hasDiscount: false, discountName: nil))
            .withSplitPaymenInfo(PXCongratsPaymentInfo(paidAmount: "$ 500", transactionAmount: "$ 5000", paymentMethodName: "Dinero en cuenta", paymentMethodLastFourDigits: "", paymentMethodExtraInfo: nil, paymentMethodId: "account_money", paymentMethodType: .ACCOUNT_MONEY)))
    }()
    
    private var congratsData : [CongratsType] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fillCongratsData()
        
        let gradient = CAGradientLayer()
        gradient.frame = tableView.bounds
        let col1 = UIColor(red: 34.0/255.0, green: 211/255.0, blue: 198/255.0, alpha: 1)
        let col2 = UIColor(red: 145/255.0, green: 72.0/255.0, blue: 203/255.0, alpha: 1)
        gradient.colors = [col1.cgColor, col2.cgColor]
        tableView.backgroundView?.layer.insertSublayer(gradient, at: 0)
        
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.layer.insertSublayer(gradient, at: 0)
        tableView.backgroundView = backgroundView
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return congratsData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "congratsRow", for: indexPath)

        cell.textLabel?.text = congratsData[indexPath.row].congratsName
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navController = navigationController else { return }
        congratsData[indexPath.row].congratsData.start(using: navController)
    }

    func fillCongratsData() {
        guard let navController = navigationController else { return }
        
        congratsData.append(CongratsType(congratsName: "Congrats Comun",
             congratsData: PXPaymentCongrats()
                .withStatus(.APPROVED)
                .withHeaderTitle("¡Listo! Ya le pagaste a SuperMarket")
                .withHeaderImage(nil, orURL: "https://mla-s2-p.mlstatic.com/600619-MLA32239048138_092019-O.jpg")
                .withHeaderCloseAction {
                    navController.popViewController(animated: true)
            }
                .shouldShowReceipt(true, receiptId: "123")
                .withMainAction(label: "Continuar", action: {
                    navController.popViewController(animated: true)
                })
                .withSecondaryAction(label: "Tuve un problema", action: {
                    navController.popViewController(animated: true)
                })
                .withPoints(PXPoints(progress: PXPointsProgress(percentage: 0.85, levelColor: "#4063EA", levelNumber: 4),title: "Ud ganó 2.000 puntos", action: PXRemoteAction(label: "Ver mis beneficios", target: "meli://loyalty/webview?url=https%3A%2F%2Fwww.mercadolivre.com.br%2Fmercado-pontos%2Fv2%2Fhub%23origin%3Dcongrats")))
                .withDiscounts(PXDiscounts(title: "Descuentos por tu nivel", subtitle: "", discountsAction: PXRemoteAction(label: "Ver todos los descuentos", target: "mercadopago://discount_center_payers/list#from=/px/congrats"), downloadAction: PXDownloadAction(title: "Exclusivo con la app de Mercado Libre", action: PXRemoteAction(label: "Descargar", target: "https://852u.adj.st/discount_center_payers/list?adjust_t=ufj9wxn&adjust_deeplink=mercadopago%3A%2F%2Fdiscount_center_payers%2Flist&adjust_label=px-ml")), items: [PXDiscountsItem(icon: "https://mla-s1-p.mlstatic.com/766266-MLA32568902676_102019-O.jpg", title: "Hasta", subtitle: "20 % OFF", target: "mercadopago://discount_center_payers/detail?campaign_id=1018483&user_level=1&mcc=1091102&distance=1072139&coupon_used=false&status=FULL&store_id=13040071&sections=%5B%7B%22id%22%3A%22header%22%2C%22type%22%3A%22header%22%2C%22content%22%3A%7B%22logo%22%3A%22https%3A%2F%2Fmla-s1-p.mlstatic.com%2F766266-MLA32568902676_102019-O.jpg%22%2C%22title%22%3A%22At%C3%A9%20R%24%2010%22%2C%22subtitle%22%3A%22Nutty%20Bavarian%22%7D%7D%5D#from=/px/congrats", campaingId: "1018483"),PXDiscountsItem(icon: "https://mla-s1-p.mlstatic.com/826105-MLA32568902631_102019-O.jpg", title: "Hasta", subtitle: "20 % OFF", target: "mercadopago://discount_center_payers/detail?campaign_id=1018457&user_level=1&mcc=4771701&distance=543968&coupon_used=false&status=FULL&store_id=30316240&sections=%5B%7B%22id%22%3A%22header%22%2C%22type%22%3A%22header%22%2C%22content%22%3A%7B%22logo%22%3A%22https%3A%2F%2Fmla-s1-p.mlstatic.com%2F826105-MLA32568902631_102019-O.jpg%22%2C%22title%22%3A%22At%C3%A9%20R%24%2015%22%2C%22subtitle%22%3A%22Drogasil%22%7D%7D%5D#from=/px/congrats", campaingId: "1018457"),PXDiscountsItem(icon: "https://mla-s1-p.mlstatic.com/761600-MLA32568902662_102019-O.jpg", title: "Hasta", subtitle: "10 % OFF", target:  "mercadopago://discount_center_payers/detail?campaign_id=1018475&user_level=1&mcc=5611201&distance=654418&coupon_used=false&status=FULL&store_id=30108872&sections=%5B%7B%22id%22%3A%22header%22%2C%22type%22%3A%22header%22%2C%22content%22%3A%7B%22logo%22%3A%22https%3A%2F%2Fmla-s1-p.mlstatic.com%2F761600-MLA32568902662_102019-O.jpg%22%2C%22title%22%3A%22At%C3%A9%20R%24%2010%22%2C%22subtitle%22%3A%22McDonald%5Cu0027s%22%7D%7D%5D#from=/px/congrats", campaingId:"1018475") ], touchpoint: nil))
                .withCrossSelling([PXCrossSellingItem(title: "Gane 200 pesos por sus pagos diarios", icon: "https://mobile.mercadolibre.com/remote_resources/image/merchengine_mgm_icon_ml?density=xxhdpi&locale=es_AR", contentId: "cross_selling_mgm_ml", action: PXRemoteAction(label: "Invita a más amigos a usar la aplicación", target: "meli://invite/wallet"))])))
            
        congratsData.append(CongratsType(congratsName: "Congrats sin Puntos, ni descuentos",
         congratsData: PXPaymentCongrats()
            .withStatus(.APPROVED)
            .withHeaderTitle("¡Listo! Ya le pagaste a SuperMarket")
            .withHeaderImage(nil, orURL: "https://mla-s2-p.mlstatic.com/600619-MLA32239048138_092019-O.jpg")
            .withHeaderCloseAction {
                navController.popViewController(animated: true)
        }
            .shouldShowReceipt(true, receiptId: "123")
            .withMainAction(label: "Continuar", action: {
                navController.popViewController(animated: true)
            })
            .withSecondaryAction(label: "Tuve un problema", action: {
                navController.popViewController(animated: true)
            })
            .withCrossSelling([PXCrossSellingItem(title: "Gane 200 pesos por sus pagos diarios", icon: "https://mobile.mercadolibre.com/remote_resources/image/merchengine_mgm_icon_ml?density=xxhdpi&locale=es_AR", contentId: "cross_selling_mgm_ml", action: PXRemoteAction(label: "Invita a más amigos a usar la aplicación", target: "meli://invite/wallet"))])))
        
        
        let instructionView = UIView(frame: .zero)
        let instructionLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 50, height: 50))
        instructionLabel.text = "TEST"
        instructionLabel.contentMode = .scaleToFill
        instructionLabel.textColor = .black
        instructionView.addSubview(instructionLabel)
        
        congratsData.append(CongratsType(congratsName: "Congrats con instrucciones",
         congratsData: PXPaymentCongrats()
            .withStatus(.APPROVED)
            .withHeaderTitle("¡Listo! Ya le pagaste a SuperMarket")
            .withHeaderImage(nil, orURL: "https://mla-s2-p.mlstatic.com/600619-MLA32239048138_092019-O.jpg")
            .withHeaderCloseAction {
                navController.popViewController(animated: true)
            }
        .withInstructionView(instructionView)
            .withMainAction(label: "Continuar", action: {
                navController.popViewController(animated: true)
            })
            .withSecondaryAction(label: "Tuve un problema", action: {
                navController.popViewController(animated: true)
            })))
        
        congratsData.append(frismaCongrats)
    }
    
    private struct CongratsType {
        let congratsName : String
        let congratsData : PXPaymentCongrats
    }
}

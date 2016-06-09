//
//  PaymentVaultViewControllerTest.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 22/1/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import XCTest

class PaymentVaultViewControllerTest: BaseTest {
    
    var paymentVaultViewController : MockPaymentVaultViewController?
    
    override func setUp() {
        super.setUp()

        self.paymentVaultViewController = MockPaymentVaultViewController(amount: 7.5, currencyId: "MXN", purchaseTitle: "Purchase title", excludedPaymentTypes: nil, excludedPaymentMethods: nil, defaultPaymentMethodId: nil, installments: 1, defaultInstallments: 1, callback: { (paymentMethod, tokenId, issuer, installments) -> Void in
            
        })
        MPFlowController.createNavigationControllerWith(self.paymentVaultViewController!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertEqual(paymentVaultViewController!.merchantBaseUrl, MercadoPagoContext.baseURL())
        XCTAssertEqual(paymentVaultViewController!.publicKey, MercadoPagoContext.publicKey())
        XCTAssertEqual(paymentVaultViewController!.merchantAccessToken,  MercadoPagoContext.merchantAccessToken())
        XCTAssertNil(paymentVaultViewController?.currentPaymentMethodSearch)
        XCTAssertNil(paymentVaultViewController?.paymentMethods)
        
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        
        XCTAssertNotNil(self.paymentVaultViewController?.currentPaymentMethodSearch)
        XCTAssertTrue(self.paymentVaultViewController?.currentPaymentMethodSearch!.count > 1)
        XCTAssertNotNil(paymentVaultViewController?.paymentMethods)
        XCTAssertNotNil(paymentVaultViewController?.paymentMethods.count > 1)
        XCTAssertNotNil(self.paymentVaultViewController?.paymentsTable)
        // Verify preference description row
        XCTAssertTrue(self.paymentVaultViewController?.paymentsTable.numberOfRowsInSection(0) == 0)
        // Payments options
        XCTAssertTrue(self.paymentVaultViewController?.paymentsTable.numberOfRowsInSection(1) > 0)

    }
    
    func testDrawingCards(){
    
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        let preferenceDescriptionCell = self.paymentVaultViewController!.tableView(self.paymentVaultViewController!.paymentsTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! PreferenceDescriptionTableViewCell
        XCTAssertNotNil(preferenceDescriptionCell)
        
        XCTAssertTrue(self.paymentVaultViewController!.currentPaymentMethodSearch.count > 0)
        
        let cardsOption = self.paymentVaultViewController!.currentPaymentMethodSearch[0] as PaymentMethodSearchItem
        let cardsGroupCell = self.paymentVaultViewController!.tableView(self.paymentVaultViewController!.paymentsTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! PaymentSearchCell
        
        XCTAssertEqual(cardsGroupCell.paymentTitle.text, cardsOption.description)
        
        let cardsChildren = cardsOption.children
        
        // Select cards
        self.paymentVaultViewController!.tableView(self.paymentVaultViewController!.paymentsTable, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1))
        
        let paymentVault = PaymentVaultViewController(amount: 7.5, currencyId: "MXN", purchaseTitle: "Purchase Title", paymentMethodSearchItem: cardsChildren, paymentMethodSearchParent: cardsOption, paymentMethods: self.paymentVaultViewController!.paymentMethods, title: "VC Title") { (paymentMethod, cardToken, issuer, installments) in
            
        }
        
        self.simulateViewDidLoadFor(paymentVault)
        XCTAssertEqual(paymentVault.title, "VC Title")
        let debitCardOptionCell = paymentVault.paymentsTable.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as! PaymentTitleViewCell
        XCTAssertEqual(debitCardOptionCell.paymentTitle.text, cardsChildren[0].description)
    }
    
    func testDrawinfOfflinePaymentsCells(){
    
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        
        XCTAssertTrue(self.paymentVaultViewController!.currentPaymentMethodSearch.count > 1)
        
        let bankTransferOptionSelected = self.paymentVaultViewController!.currentPaymentMethodSearch[1] as PaymentMethodSearchItem
        let bankTransferCell = self.paymentVaultViewController!.tableView(self.paymentVaultViewController!.paymentsTable, cellForRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 1)) as! PaymentSearchCell
        
        XCTAssertEqual(bankTransferCell.paymentTitle.text, bankTransferOptionSelected.description)

        let bankTransferOptions = bankTransferOptionSelected.children
        
        let paymentVault = PaymentVaultViewController(amount: 7.5, currencyId: "MXN", purchaseTitle: "Purchase Title", paymentMethodSearchItem: bankTransferOptions, paymentMethodSearchParent: bankTransferOptionSelected, paymentMethods: self.paymentVaultViewController!.paymentMethods, title: "VC Title") { (paymentMethod, cardToken, issuer, installments) in
            
        }
    
        
        self.simulateViewDidLoadFor(paymentVault)
        XCTAssertEqual(paymentVault.title, "VC Title")
        XCTAssertEqual(paymentVault.currentPaymentMethodSearch, bankTransferOptions)

    }
    
    func testDrawinfOfflinePaymentMethodCell(){
        
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        
        XCTAssertTrue(self.paymentVaultViewController!.currentPaymentMethodSearch.count > 1)
        
        let bankTransferOptionSelected = self.paymentVaultViewController!.currentPaymentMethodSearch[1] as PaymentMethodSearchItem
        let bankTransferOptions = bankTransferOptionSelected.children
        XCTAssertTrue(bankTransferOptions.count > 0)
        
        let offlinePaymentMethods = PaymentMethodSearch.fromJSON(MockManager.getMockFor("groups")!).groups[1].children

        let paymentVault = PaymentVaultViewController(amount: 7.5, currencyId: "MXN", purchaseTitle: "Purchase Title", paymentMethodSearchItem: bankTransferOptions, paymentMethodSearchParent: bankTransferOptionSelected, paymentMethods: self.paymentVaultViewController!.paymentMethods, title: "VC Title") { (paymentMethod, cardToken, issuer, installments) in
            
        }
        
        
        
        self.simulateViewDidLoadFor(paymentVault)
        XCTAssertEqual(paymentVault.title, "VC Title")
        XCTAssertEqual(paymentVault.currentPaymentMethodSearch, bankTransferOptions)
        let bankTransferOptionCell = paymentVault.tableView(paymentVault.paymentsTable, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)) as! OfflinePaymentMethodCell
        XCTAssertNotNil(bankTransferOptionCell)
        XCTAssertEqual(bankTransferOptionCell.comment.text, offlinePaymentMethods[0].comment)
        
    }
    
    func testViewWillDissapear(){
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        self.paymentVaultViewController!.viewWillDisappear(true)
        XCTAssertTrue(self.paymentVaultViewController!.mpStylesCleared)
    }

    func testPaymentsTableConstraints(){
        
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        
       XCTAssertEqual(self.paymentVaultViewController!.numberOfSectionsInTableView(self.paymentVaultViewController!.paymentsTable), 3)
       self.paymentVaultViewController!.displayPreferenceDescription = false
       XCTAssertEqual(self.paymentVaultViewController?.tableView(self.paymentVaultViewController!.paymentsTable, numberOfRowsInSection: 0), 0)
       self.paymentVaultViewController!.displayPreferenceDescription = true
       XCTAssertEqual(self.paymentVaultViewController?.tableView(self.paymentVaultViewController!.paymentsTable, numberOfRowsInSection: 0), 1)
        
       XCTAssertEqual(self.paymentVaultViewController?.tableView(self.paymentVaultViewController!.paymentsTable, numberOfRowsInSection: 1), self.paymentVaultViewController?.currentPaymentMethodSearch.count)

        XCTAssertEqual(self.paymentVaultViewController?.tableView(self.paymentVaultViewController!.paymentsTable, heightForHeaderInSection: 0), 0)
        XCTAssertEqual(self.paymentVaultViewController?.tableView(self.paymentVaultViewController!.paymentsTable, heightForHeaderInSection: 1), 10)
        
        XCTAssertEqual(self.paymentVaultViewController?.tableView(self.paymentVaultViewController!.paymentsTable, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)), 120)
        self.paymentVaultViewController!.displayPreferenceDescription = false
        XCTAssertEqual(self.paymentVaultViewController?.tableView(self.paymentVaultViewController!.paymentsTable, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0)), 0)
        
        XCTAssertEqual(self.paymentVaultViewController?.tableView(self.paymentVaultViewController!.paymentsTable, heightForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 1)), 52)
    }

    func testTogglePreference(){
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        self.paymentVaultViewController!.togglePreferenceDescription(self.paymentVaultViewController!.paymentsTable)
        XCTAssertTrue(self.paymentVaultViewController!.displayPreferenceDescription)
    }
    
    func testExecuteBack(){
        self.paymentVaultViewController!.executeBack()
        XCTAssertTrue(self.paymentVaultViewController!.mpStylesCleared)
    }
    
    func testOptionSelectedPaymentMethodOffline(){
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        let pmSearchItem = PaymentMethodSearchItem()
        pmSearchItem.comment = "comment"
        pmSearchItem.idPaymentMethodSearchItem = "oxxo"
        pmSearchItem.type = PaymentMethodSearchItemType.PAYMENT_METHOD
        
        self.paymentVaultViewController?.callback = {(paymentMethod: PaymentMethod, cardToken:CardToken?, issuer: Issuer?, installments: Int) -> Void in
        }
        
        self.paymentVaultViewController!.optionSelected(pmSearchItem)
        //XCTAssertTrue(paymentMethodOffSelected)
    }
    
    func testOptionSelectedCard() {
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        let pmSearchItem = PaymentMethodSearchItem()
        pmSearchItem.comment = "comment"
        pmSearchItem.idPaymentMethodSearchItem = "credit_card"
        pmSearchItem.type = PaymentMethodSearchItemType.PAYMENT_TYPE
        
        self.paymentVaultViewController!.optionSelected(pmSearchItem)
        XCTAssertTrue(self.paymentVaultViewController!.cardFlowStarted)
    }
    
    func testOptionSelectedOfflinePaymentMethod(){
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        let pmSearchItem = PaymentMethodSearchItem()
        pmSearchItem.comment = "comment"
        pmSearchItem.idPaymentMethodSearchItem = "oxxo"
        pmSearchItem.type = PaymentMethodSearchItemType.PAYMENT_METHOD

        self.paymentVaultViewController?.callback = {(paymentMethod: PaymentMethod, cardToken:CardToken?, issuer: Issuer?, installments: Int) -> Void in
            
        }
        self.paymentVaultViewController!.optionSelected(pmSearchItem)
        //TODO: TEST EXPECTATION DE CALLBACK :|

    }
    
    func testOptionSelectedBitcoin(){

        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        let pmSearchItem = PaymentMethodSearchItem()
        pmSearchItem.comment = "comment"
        pmSearchItem.idPaymentMethodSearchItem = "bitcoin"
        pmSearchItem.type = PaymentMethodSearchItemType.PAYMENT_METHOD
        
        self.paymentVaultViewController?.callback = {(paymentMethod: PaymentMethod, cardToken:CardToken?, issuer: Issuer?, installments: Int) -> Void in
           
        }
        self.paymentVaultViewController!.optionSelected(pmSearchItem)
    }
        
    func testOptionSelectedPaymentGroup(){
        
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        let pmSearchItem = PaymentMethodSearchItem()
        pmSearchItem.comment = "comment"
        pmSearchItem.idPaymentMethodSearchItem = "ticket"
        pmSearchItem.type = PaymentMethodSearchItemType.PAYMENT_TYPE
        
        self.paymentVaultViewController!.optionSelected(pmSearchItem)
    }
    
    func testCardFlow(){
        self.simulateViewDidLoadFor(self.paymentVaultViewController!)
        self.paymentVaultViewController!.cardFlow(MockBuilder.buildPaymentType(), animated: true)
        XCTAssertTrue(self.paymentVaultViewController!.cardFlowStarted)
        
    }
}


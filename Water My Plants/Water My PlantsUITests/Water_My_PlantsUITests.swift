//
//  Water_My_PlantsUITests.swift
//  Water My PlantsUITests
//
//  Created by Alex Thompson on 3/8/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest

class WaterMyPlantsUITests: XCTestCase {
    func testLoggingIn() {
        // i belive test may be failing because of the launch screen and then cant find what i specified
        let app = XCUIApplication()
        app.launch()
        
        let textFieldUsername = app.textFields["Username"]
        textFieldUsername.tap()
        textFieldUsername.typeText("John Smith")
        
        let textFieldPassword = app.secureTextFields["Password"]
        textFieldPassword.tap()
        textFieldPassword.typeText("myprecious")
        app.buttons["Sign in"].tap()
        
        let title = app.navigationBars["Welcome"].staticTexts["Welcome"]
        
        XCTAssert(title.exists)
        
    }
    
    func testAddPlant() {
        let app = XCUIApplication()
        app.launch()
        
        let textFieldUsername = app.textFields["Username"]
        textFieldUsername.tap()
        textFieldUsername.typeText("John Smith")
        
        let textFieldPassword = app.secureTextFields["Password"]
        textFieldPassword.tap()
        textFieldPassword.typeText("myprecious")
        app.buttons["LOG IN"].tap()
        
        
        app.textFields["Username"].tap()
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("myprecious")
        app.buttons["Sign In"].tap()
        app.alerts["User logged in"].scrollViews.otherElements.buttons["👍"].tap()
        app.buttons["Add plants"].tap()
        
        
        
        let saveButton = app.navigationBars["Add Plant"].buttons["Save"]
        saveButton.tap()
        
        let alert = app.alerts["Missing some fields"]
        XCTAssert(alert.exists)
    }
    
    func testSignupAlert() {
        
        let app = XCUIApplication()
        app.launch()
        
        let signUpButton = app.buttons["Create Account"]
        signUpButton.tap()
        
        let signinButton = app.buttons["Sign in"]
        signinButton.tap()
        
        let alert = app.alerts["Missing some fields."]
        XCTAssert(alert.exists)
    }
    
    func testSigninAlert() {
        let app = XCUIApplication()
        app.launch()
        
        let signInButton = app.buttons["Sign In"]
        signInButton.tap()
        
        let alert = app.alerts["Missing some fields."]
        XCTAssert(alert.exists)
    }
}

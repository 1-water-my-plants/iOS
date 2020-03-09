//
//  Water_My_PlantsTests.swift
//  Water My PlantsTests
//
//  Created by Alex Thompson on 3/8/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import Water_My_Plants

class WaterMyPlantsTests: XCTestCase {

    func testLoginCorrectUsernameAndPassword() {
        let loginExpectation = XCTestExpectation(description: "Login expectation")
        
        let loginController = LoginController()
        let loginRequest = LoginRequest(username: "John Smith", password: "myprecious")
        loginController.login(with: loginRequest) { error in
            XCTAssertNil(error)
            loginExpectation.fulfill()
        }
        
        wait(for: [loginExpectation], timeout: 10.0)
    }
    
    func testLoginIncorrectUsernameAndPassword() {
        let loginExpectation = XCTestExpectation(description: "Incorrect login")
        let loginController = LoginController()
        let loginRequest = LoginRequest(username: "Alex1", password: "wow1")
        loginController.login(with: loginRequest) { error in
            XCTAssertNotNil(error)
            loginExpectation.fulfill()
        }
        
        wait(for: [loginExpectation], timeout: 10.0)
    }
    
    func testLoginNoUsername() {
        let loginExpectation = XCTestExpectation(description: "Incorrect login")
        
        let loginController = LoginController()
        let loginRequest = LoginRequest(username: "", password: "stuff")
        loginController.login(with: loginRequest) { error in
            XCTAssertNotNil(error)
            loginExpectation.fulfill()
        }
        
        wait(for: [loginExpectation], timeout: 10.0)
    }
    
    func testSignupSuccessful() {
        let loginExpectation = XCTestExpectation(description: "Login expectation")
        
        let signupController = SignUpController()
        let signUpRequest = SignUpRequest(username: UUID().uuidString, password: "test1", phoneNumber: "12345")
        signupController.signUp(with: signUpRequest) { error in
            XCTAssertNil(error)
            loginExpectation.fulfill()
        }
        
        wait(for: [loginExpectation], timeout: 10.0)
    }
    
    func testSignupFailNoUsername() {
        let loginExpectation = XCTestExpectation(description: "Login expectation")
        
        let signupController = SignUpController()
        let signupRequest = SignUpRequest(username: "", password: "test1", phoneNumber: "12345")
        signupController.signUp(with: signupRequest) { error in
            XCTAssertNotNil(error)
            loginExpectation.fulfill()
        }
        
        wait(for: [loginExpectation], timeout: 10.0)
    }
    
    func testSignupFailNoPassword() {
        let loginExpecttation = XCTestExpectation(description: "Login expectation")
        
        let signupController = SignUpController()
        let signupRequest = SignUpRequest(username: UUID().uuidString, password: "", phoneNumber: "12345")
        signupController.signUp(with: signupRequest) { error in
            XCTAssertNotNil(error)
            loginExpecttation.fulfill()
        }
        
        wait(for: [loginExpecttation], timeout: 10.0)
    }
    
    func testSignupFailNoPhone() {
        let loginExpectation = XCTestExpectation(description: "Login expectation")
        let signupController = SignUpController()
        let signupRequest = SignUpRequest(username: UUID().uuidString, password: "test1", phoneNumber: "")
        signupController.signUp(with: signupRequest) { error in
            XCTAssertNotNil(error)
            loginExpectation.fulfill()
        }
        wait(for: [loginExpectation], timeout: 10.0)
    }
    func testSignupFailNoPhoneNoPassword() {
        let loginExpectation = XCTestExpectation(description: "Login expectation")
        let signupController = SignUpController()
        let signupRequest = SignUpRequest(username: UUID().uuidString, password: "", phoneNumber: "")
        signupController.signUp(with: signupRequest) { error in
            XCTAssertNotNil(error)
            loginExpectation.fulfill()
        }
        wait(for: [loginExpectation], timeout: 10.0)
    }
    func testSignupFailSameUsername() {
        let loginExpectation = XCTestExpectation(description: "Login expectation")
        let signupController = SignUpController()
        let signupRequest = SignUpRequest(username: "alex2", password: "test1", phoneNumber: "12345")
        signupController.signUp(with: signupRequest) { error in
            XCTAssertNotNil(error)
            loginExpectation.fulfill()
        }
        wait(for: [loginExpectation], timeout: 10.0)
    }
    
    func testLoginFailNoCredentials() {
        let loginExpectation = XCTestExpectation(description: "No credentials")
        
        let loginController = LoginController()
        let logingRequest = LoginRequest(username: "", password: "")
        loginController.login(with: logingRequest) { error in
            XCTAssertNotNil(error)
            loginExpectation.fulfill()
        }
        wait(for: [loginExpectation], timeout: 10.0)
    }
}

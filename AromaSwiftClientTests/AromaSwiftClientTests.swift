//
//  AromaSwiftClientTests.swift
//  AromaSwiftClientTests
//
//  Created by Wellington Moreno on 4/4/16.
//  Copyright © 2016 RedRoma, Inc. All rights reserved.
//

import AlchemyGenerator
import AlchemyTest
import XCTest
@testable import AromaSwiftClient

let TEST_TOKEN_ID = "321e4a08-c2d7-4776-b525-6d13ada716cd"

class AromaSwiftClientTests: AlchemyTest
{
    
    override var defaultAsyncTimeout: TimeInterval { return 10.0 }
    
    fileprivate var message: AromaRequest!
   
    override func beforeEachTest()
    {
        message = AromaRequest()
        message.title = "some title"
        message.body = AlchemyGenerator.alphabeticString(ofSize: Int.random(in: 10...100))
        message.priority = .low
        
        testDefaultValues()
        AromaClient.TOKEN_ID = TEST_TOKEN_ID
        AromaClient.enabled = true
    }

    override func tearDown()
    {
        super.tearDown()
        
        AromaClient.TOKEN_ID = ""
    }

    fileprivate func testDefaultValues()
    {
        XCTAssertNotNil(AromaClient.hostname)
        XCTAssertNotNil(AromaClient.port)
        XCTAssert(AromaClient.port > 0)

        XCTAssert(AromaClient.TOKEN_ID.isEmpty)
    }

    func testThriftClient()
    {
        let client = AromaClient.createThriftClient()
        XCTAssertNotNil(client)
    }

    func testMessageSend()
    {
        asyncTest
        { promise in
            AromaClient.send(message: message, onError: onError)
            {
                promise.fulfill()
            }
        }

    }

    func testBeginWithTitle()
    {
        let result = AromaClient.beginMessage(withTitle: message.title)
        assertNotNil(result)
    }
    
    func testSendHighPriorityMessage()
    {
        asyncTest
        { promise in
            
            AromaClient.sendHighPriorityMessage(withTitle: "High Priority Test", withBody: message.body, onError: onError)
            {
                promise.fulfill()
            }
        }
        
    }
    
    func testSendMediumPriorityMessage()
    {
        asyncTest
        { promise in
            
            AromaClient.sendMediumPriorityMessage(withTitle: "Medium Priority Test", onError: onError)
            {
                promise.fulfill()
            }
        }
        
    }
    
    func testSendLowPriorityMessage()
    {
        asyncTest
        { promise in
            
            AromaClient.sendLowPriorityMessage(withTitle: "Low Priority Test", onError: onError)
            {
                promise.fulfill()
            }
        }
    }
    
    func testWhenDisabled()
    {
        AromaClient.disable()
        
        var called = false
        AromaClient.sendLowPriorityMessage(withTitle: "Title") {
            called = true
        }
        
        assertThat(called)
    }
    
    fileprivate func onError(_ ex: Error)
    {
        XCTFail("Failed to send message: \(ex)")
    }
    
}

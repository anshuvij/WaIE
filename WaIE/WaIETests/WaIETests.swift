//
//  WaIETests.swift
//  WaIETests
//
//  Created by Anshu Vij on 18/03/23.
//

import XCTest
@testable import WaIE


 class WaIETests: XCTestCase {
     private var astronomyVM : AstronomyViewModel!
    override func setUp() {
        self.astronomyVM = AstronomyViewModel()
       
        
    }

    func test_should_have_valid_values_in_online_mode() {
        
        astronomyVM.requestTodayImages(isOnlineMode: true)
        astronomyVM?.reloadOnData = { [weak self] in
            
            guard let self = self else { return }
            XCTAssertNotNil(self.astronomyVM.astronomyDataViewModel?.title)
            
            
        }
    }
     
     func test_should_have_valid_values_in_offline_mode() {
         
         //only test this when app is first launched in offline mode, this shows offline mode status
         astronomyVM.requestTodayImages(isOnlineMode: false)
         astronomyVM.networkOffline = {[weak self] result in
             guard let self = self else { return }
             if self.astronomyVM.astronomyDataViewModel?.title.count ?? 0 == 0 {
                 XCTAssertEqual(result, CustomError.Offline)
             }
         }
     }
      
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class OfflineTest : WaIETests {
    private var astronomyVM : AstronomyViewModel!
    override func setUp()  {
        super.setUp()
        test_makeDeviceOffline()
    }
    
    func test_makeDeviceOffline() {
        astronomyVM?.reloadOnData = { [weak self] in
            
            guard let self = self else { return }
            XCTAssertNotNil(self.astronomyVM.astronomyDataViewModel?.title)
            
            
        }
    }
}

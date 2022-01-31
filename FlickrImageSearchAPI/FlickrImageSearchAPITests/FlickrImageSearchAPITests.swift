//
//  FlickrImageSearchAPITests.swift
//  FlickrImageSearchAPITests
//
//  Created by Vinay B. Naikade on 31/01/22.
//

import XCTest
@testable import FlickrImageSearchAPI

class FlickrImageSearchAPITests: XCTestCase {

    private var photosViewModel = PhotosViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoadNextBatch() {
        let expectation = self.expectation(description: "Awaiting For Flickr Photos")
        photosViewModel.loadNextBatch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            if self?.photosViewModel.count ?? 0 > 0 {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TimeInterval(timeOutIntervalForApi))
        XCTAssertTrue(photosViewModel.count > 0)
    }
    
    func testLoadNextBatchWithSearchedText() {
        let expectation = self.expectation(description: "Awaiting For Flickr Photos")
        photosViewModel.searchingText = "Crciket"
        photosViewModel.reset()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            if self?.photosViewModel.count ?? 0 > 0 {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: TimeInterval(timeOutIntervalForApi))
        XCTAssertTrue(photosViewModel.count > 0)
    }

}

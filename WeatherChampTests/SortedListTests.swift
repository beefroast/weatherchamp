//
//  SortedListTests.swift
//  WeatherChampTests
//
//  Created by Benjamin Frost on 5/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import XCTest
@testable import WeatherChamp


class SortedListTests: XCTestCase {

    lazy var numberSort: ((Int, Int) -> Bool) = { (a, b) in return a < b }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func isSorted(array: [Int]) -> Bool {
        
        // Start at the second element in
        var index = 1
        
        // Compare pairwise elements
        while index < array.count {
            if array[index] < array[index-1] {
                return false
            }
            index = index + 1
        }
        
        return true
    }

    func testInitialiser() {
        
        // Test initial elements are sorted
        
        let unsortedArray = [5, 4, 3, 2, 1]
        
        let sortedList = SortedList.init(elements: unsortedArray, orderedBefore: numberSort)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
    
    func testCount() {
        
        let unsortedArray = [5, 4, 3, 2, 1]
        
        let sortedList = SortedList.init(elements: unsortedArray, orderedBefore: numberSort)
        
        XCTAssertEqual(sortedList.count, unsortedArray.count)
        
    }
    
    func testArrayIndexAccess() {
        
        let array = [1, 2, 3, 4, 5]
        
        let sortedList = SortedList.init(elements: array, orderedBefore: numberSort)

        XCTAssertEqual(sortedList[0], array[0])
        XCTAssertEqual(sortedList[1], array[1])
        XCTAssertEqual(sortedList[2], array[2])
        XCTAssertEqual(sortedList[3], array[3])
        XCTAssertEqual(sortedList[4], array[4])
        
    }

    func testInsertionA() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 1)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
    
    func testInsertionB() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 2)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
    
    func testInsertionC() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 3)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
    
    func testInsertionD() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 4)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
    
    func testInsertionE() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 5)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }

    func testInsertionF() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 6)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
    
    func testInsertionG() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 7)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
    
    func testInsertionH() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 8)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }

    func testInsertionI() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 9)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }

    func testInsertionJ() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 10)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
    
    func testInsertionK() {
        
        let sortedList = SortedList.init(
            elements: [2, 4, 6, 8, 10],
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 11)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
    
    func testInsertionHuge() {
        
        let sortedList = SortedList.init(
            elements: (0...1000000).map({ return $0 }) ,
            orderedBefore: numberSort
        )
        
        sortedList.insert(element: 1234)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
    
    func testDelete() {
        
        let testElements = (0...1000000).map({ return $0 })
        
        let sortedList = SortedList.init(elements: testElements, orderedBefore: numberSort)
        
        sortedList.remove(index: 1000)
        
        XCTAssertEqual(sortedList[999], 999)
        XCTAssertEqual(sortedList[1000], 1001)
        
        XCTAssertEqual(testElements.count - 1, sortedList.count)
    }
    
    func testChaningSortOrder() {
        
        let testElements = (0...1000000).reversed().map({ return $0 })
        
        // Create a backwards sorted list where each element is smaller
        // than the previous
        let backwardsSortedList = SortedList.init(elements: testElements) { (a, b) -> Bool in
            a > b
        }
        
        let sortedList = backwardsSortedList.withOrderedBefore(orderedBefore: numberSort)
        
        XCTAssert(isSorted(array: sortedList.asArray))
    }
}

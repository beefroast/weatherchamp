//
//  SortedList.swift
//  WeatherChamp
//
//  Created by Benjamin Frost on 5/3/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation

// Very simple sorted list implementation that takes advantage of Swift's sort
class SortedList<T> {

    var elements: [T]
    let orderedBefore: ((T, T) -> Bool)
    
    init(elements: [T], orderedBefore: @escaping ((T, T) -> Bool)) {
        self.orderedBefore = orderedBefore
        self.elements = elements.sorted(by: orderedBefore)
    }
    
    func indexToInsert(element: T) -> Int {
        
        var lower = 0
        var upper = self.elements.count
        
        while lower < upper {
            
            let mid = (lower+upper)/2
            
            if orderedBefore(element, elements[mid]) {
                // The element comes before mid in the list
                upper = mid - 1
                
            } else if orderedBefore(elements[mid], element) {
                // The element comes after mid in the list
                lower = mid + 1
                
            } else {
                // The element at the mid and the inserting element
                // have the same sort value, so we can insert here
                return mid
            }
        }
        
        return lower
    }
    
    func insert(element: T) -> Int {
        let idx = self.indexToInsert(element: element)
        self.elements.insert(element,  at: idx)
        return idx
    }
    
    subscript(index: Int) -> T {
        get { return elements[index] }
    }
    
    func remove(index: Int) {
        self.elements.remove(at: index)
    }
    
    var count: Int {
        return self.elements.count
    }

    func withOrderedBefore(orderedBefore: @escaping ((T, T) -> Bool)) -> SortedList {
        return SortedList.init(
            elements: self.elements,
            orderedBefore: orderedBefore
        )
    }
    
}

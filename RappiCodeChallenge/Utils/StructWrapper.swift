//
//  StructWrapper.swift
//  RappiCodeChallenge
//
//  Created by Vincent Villalta on 11/8/21.
//

import Foundation
class StructWrapper<T>: NSObject {

    var value: T

    init(_ _struct: T) {
        self.value = _struct
    }
}

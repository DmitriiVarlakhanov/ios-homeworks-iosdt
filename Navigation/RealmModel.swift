//
//  RealmModel.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/6/26.
//

import Foundation
import RealmSwift

class RealmModel: Object {

    @Persisted var categories: List<String> = List<String>()
    @Persisted var value: String = ""
    @Persisted var date: Date = Date()
}

//
//  Suggesting.swift
//  SampleSuggestion
//
//  Created by Thahir Maheen on 9/4/18.
//  Copyright © 2018 thahir. All rights reserved.
//

import Foundation
import Eureka

protocol Suggesting: Equatable, InputTypeInitiable {
	var suggestion: String { get }
}

extension String: Suggesting {
	var suggestion: String {
		return self
	}
}

protocol SuggestingTableViewCell {
	associatedtype Suggestion: Suggesting

	func setupForValue(_ value: Suggestion)
}

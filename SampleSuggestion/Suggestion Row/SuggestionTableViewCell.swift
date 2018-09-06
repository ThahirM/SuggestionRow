//
//  SuggestionTableViewCell.swift
//  SampleSuggestion
//
//  Created by Thahir Maheen on 9/6/18.
//  Copyright © 2018 thahir. All rights reserved.
//

import UIKit

class SuggestionTableViewCell<S: Suggesting>: UITableViewCell, SuggestingTableViewCell {
	typealias Suggestion = S

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		configureView()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		configureView()
	}

	func configureView() {
		textLabel?.minimumScaleFactor = 0.8
		textLabel?.adjustsFontSizeToFitWidth = true
	}

	func setupForValue(_ value: S) {
		textLabel?.text = value.suggestion
	}
}

//
//  SuggestionRow.swift
//  SampleSuggestion
//
//  Created by Thahir Maheen on 9/4/18.
//  Copyright © 2018 thahir. All rights reserved.
//

import Foundation
import Eureka

/// Generic suggestion row superclass that defines how to get a list of suggestions based on user input.
class SuggestionRow<Cell: CellType>: FieldRow<Cell> where Cell: BaseCell, Cell: TextFieldCell, Cell.Value: Suggesting {

	var numberOfSuggestions: Int = 2
	var filterFunction: ((String) -> [Cell.Value])?

	required init(tag: String?) {
		super.init(tag: tag)

		displayValueFor = { value in
			return value?.suggestion
		}
	}
}

/// Row that lets the user choose a suggestion option from a table below the row.
final class SuggestionTableRow<T: Suggesting>: SuggestionRow<SuggestionTableCell<T, SuggestionTableViewCell<T>>>, RowType {
	required init(tag: String?) {
		super.init(tag: tag)
	}
}

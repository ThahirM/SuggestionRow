//
//  SuggestionCell.swift
//  SampleSuggestion
//
//  Created by Thahir Maheen on 9/4/18.
//  Copyright © 2018 thahir. All rights reserved.
//

import Foundation
import Eureka

/// General suggestion cell
class SuggestionCell<Suggestion: Suggesting>: _FieldCell<Suggestion>, CellType {

	let identifier = "SuggestionTableViewCell"

	var suggestions: [Suggestion]?

	required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override open func setup() {
		super.setup()

		textField.autocorrectionType = .no
		textField.autocapitalizationType = .sentences
	}

	override func textFieldDidBeginEditing(_ textField: UITextField) {
		formViewController()?.beginEditing(of: self)
		formViewController()?.textInputDidBeginEditing(textField, cell: self)
		textField.selectAll(nil)

		if let text = textField.text {
			setSuggestions(text)
		}
	}

	override func textFieldDidChange(_ textField: UITextField) {
		super.textFieldDidChange(textField)

		if let text = textField.text {
			setSuggestions(text)
		}
	}

	override func textFieldDidEndEditing(_ textField: UITextField) {
		formViewController()?.endEditing(of: self)
		formViewController()?.textInputDidEndEditing(textField, cell: self)
		textField.text = row.displayValueFor?(row.value)
	}

	func setSuggestions(_ string: String) { }

	func reload() { }
}

class SuggestionTableCell<Suggestion, SuggestingCell: UITableViewCell>: SuggestionCell<Suggestion>, UITableViewDelegate, UITableViewDataSource where SuggestingCell: SuggestingTableViewCell, SuggestingCell.Suggestion == Suggestion {

	var tableView: UITableView?

	required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func setup() {
		super.setup()

		tableView = UITableView(frame: .zero)
		tableView?.autoresizingMask = .flexibleHeight
		tableView?.isHidden = true
		tableView?.delegate = self
		tableView?.dataSource = self
		tableView?.backgroundColor = UIColor.white
		tableView?.register(SuggestingCell.self, forCellReuseIdentifier: identifier)
	}

	func showTableView() {
		guard let controller = formViewController() else { return }

		if let tableView = tableView, tableView.superview == nil {
			controller.view.addSubview(tableView)
		}

		let frame = controller.tableView?.convert(self.frame, to: controller.view) ?? self.frame
		tableView?.frame = CGRect(x: 0, y: frame.origin.y + frame.height, width: contentView.frame.width, height: CGFloat(44 * ((row as? SuggestionRow<SuggestionTableCell>)?.numberOfSuggestions ?? 5)))
		tableView?.isHidden = false
	}

	func hideTableView() {
		tableView?.isHidden = true
	}

	override func reload() {
		tableView?.reloadData()
	}

	override func setSuggestions(_ string: String) {
		guard let filterFunction = (row as? SuggestionRow<SuggestionTableCell>)?.filterFunction else { return }

		suggestions = filterFunction(string)
		reload()
	}

	override func textFieldDidBeginEditing(_ textField: UITextField) {
		super.textFieldDidBeginEditing(textField)

		showTableView()
	}

	open override func textFieldDidEndEditing(_ textField: UITextField) {
		super.textFieldDidEndEditing(textField)

		hideTableView()
	}

	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = suggestions?.count ?? 0
		tableView.isHidden = count <= 0
		return count
	}

	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SuggestingCell else { return UITableViewCell() }

		if let prediction = suggestions?[indexPath.row] {
			cell.setupForValue(prediction)
		}
		return cell
	}

	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let prediction = suggestions?[indexPath.row] {
			row.value = prediction
			_ = cellResignFirstResponder()
		}
	}
}

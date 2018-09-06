//
//  FirstViewController.swift
//  SampleSuggestion
//
//  Created by Thahir Maheen on 9/4/18.
//  Copyright © 2018 thahir. All rights reserved.
//

import UIKit
import Eureka

class FirstViewController: FormViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let users: [Scientist] = [Scientist(id: 1, firstName: "Albert", lastName: "Einstein"),
								  Scientist(id: 2, firstName: "Isaac", lastName: "Newton"),
								  Scientist(id: 3, firstName: "Galileo", lastName: "Galilei"),
								  Scientist(id: 4, firstName: "Marie", lastName: "Curie"),
								  Scientist(id: 5, firstName: "Louis", lastName: "Pasteur"),
								  Scientist(id: 6, firstName: "Michael", lastName: "Faraday")]

		form +++ Section("Input accessory view suggestions")
			+++ Section("Table suggestions")
			<<< SuggestionTableRow<Scientist>() {
				$0.filterFunction = { text in
					guard !text.isEmpty else { return users }
					return users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
				}
				$0.placeholder = "Search for a famous scientist"
		}
	}
}


struct Scientist: Suggesting {
	var id: Int
	var firstName: String
	var lastName: String


	var suggestion: String {
		return "\(firstName) \(lastName)"
	}

	init(id: Int, firstName: String, lastName: String) {
		self.firstName = firstName
		self.lastName = lastName
		self.id = id
	}

	init?(string stringValue: String) {
		return nil
	}
}

func == (lhs: Scientist, rhs: Scientist) -> Bool {
	return lhs.id == rhs.id
}

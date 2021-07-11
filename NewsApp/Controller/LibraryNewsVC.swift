//
//  LibraryNewsVC.swift
//  NewsApp
//
//  Created by Alexandr on 08.07.2021.
//

import UIKit
import CoreData

final class LibraryNewsVC: UIViewController {

	private var articles = [ArticleCoreDataModel]()
	private let dataModel = CoreDataModel()
	
	@IBOutlet private weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupTable()
    }
	
	override func viewWillLayoutSubviews() {
		articles = dataModel.getData()
		tableView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "libraryDetailVC" {
			let vc = segue.destination as! DetailVC
			guard let indexPath = tableView.indexPathForSelectedRow else {
				print("Don't index")
				return
			}
			let article = articles[indexPath.row]
			vc.url = URL(string: article.urlToArticle!)
		}
	}
}

private extension LibraryNewsVC {
	func setupTable() {
		tableView.delegate = self
		tableView.dataSource = self
		
		let cellNib = UINib(nibName: "NewsCell", bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: "libraryNewsCell")
	}
}

//MARK: -UITableViewDelegate, UITableViewDataSource

extension LibraryNewsVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return articles.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let article = articles[indexPath.row]
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "libraryNewsCell", for: indexPath) as! NewsCell
		cell.configureCell(article: article)
		cell.saveButton.isHidden = true
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "libraryDetailVC", sender: nil)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

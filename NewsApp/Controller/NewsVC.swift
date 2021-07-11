//
//  NewsVC.swift
//  NewsApp
//
//  Created by Alexandr on 08.07.2021.
//

import UIKit
import CoreData

enum SearchType: Int {
	case category = 1
	case country = 2
	case source = 3
	case keyword = 4
}

final class NewsVC: UIViewController {

	private var articles: News?
	private var currentPage = 1
	private var timer = Timer()
	private var searchType = SearchType(rawValue: 4)
	
	@IBOutlet weak var pageLabel: UILabel!
	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet private weak var tableView: UITableView!
	
	@IBAction func moreButtomPressed(_ sender: UIButton) {
		self.currentPage += 1
		let url = self.getURL(page: currentPage)
		
		NewsAPI.getNews(urlLink: url) { result in
			DispatchQueue.main.async {
				self.articles = result
				self.tableView.reloadData()
			}
		}
		
		tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
		pageLabel.text = "Page \(currentPage)"
		
		
	}
	
	@IBAction func searchButtonPressed(_ sender: UIButton) {
		searchBar.text = nil

		searchType = SearchType(rawValue: sender.tag)
		
		switch searchType! {
		case .category:
			searchBar.placeholder = "Example: business"
		case .country:
			searchBar.placeholder = "Example: us"
		case .source:
			searchBar.placeholder = "Example: bbc"
		case .keyword:
			searchBar.placeholder = "Example: apple"
		}
		
		searchBar.becomeFirstResponder()
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		
		searchBar.delegate = self
		setupTable()
		
//		completion = {
//			self.currentPage += 1
//			let url = self.getURL(page: self.currentPage)
//
//			self.api.getNews(urlLink: url) { result in
//
//				DispatchQueue.main.async {
//					self.articles = result
//					self.tableView.reloadData()
//				}
//			}
//			self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//
//		}
		
		
		NewsAPI.getNews(urlLink: getURL()) { result in
			DispatchQueue.main.async {
				self.articles = result
				self.tableView.reloadData()

			}
		}
    }
}

private extension NewsVC {
	 func getURL(page: Int = 1) -> String {
		return "https://newsapi.org/v2/everything?page=\(page)&pageSize=10&q=all&sortBy=publishedAt&apiKey=5ea95f893efb4d079742945245fa8226"
	}
	
	 func setupTable() {
		let cellNib = UINib(nibName: "NewsCell", bundle: nil)
		tableView.register(cellNib, forCellReuseIdentifier: "newsCell")
		tableView.delegate = self
		tableView.dataSource = self
	}
}

//MARK: -UITableViewDelegate, UITableViewDataSource

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return articles?.articles.count ?? 10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
		
		let article = articles?.articles[indexPath.row]
		if let article = article {
			cell.configureCell(article: article)
			cell.source.isHidden = false
			cell.articleDescription.isHidden = false
			cell.saveButton.isHidden = false
			cell.articleImage.isHidden = false
		} else {
			cell.title.text = "Don't Information"
			cell.source.isHidden = true
			cell.articleDescription.isHidden = true
			cell.saveButton.isHidden = true
			cell.articleImage.isHidden = true
		}
		
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "detailVC", sender: self)
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "detailVC" {
			guard let indexPath = tableView.indexPathForSelectedRow else {
				print("Dont indeex")
				return
			}
			let vc = segue.destination as! DetailVC
			let article = articles?.articles[indexPath.row]
			vc.url = URL(string: article?.url ?? "")
		}
	}
}

// MARK: -UISearchBarDelegate

extension NewsVC: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		let url = search(type: searchType!, text: searchText)
		
		timer.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {_ in
			NewsAPI.getNews(urlLink: url) { result in
				DispatchQueue.main.async {
					self.articles = result
					self.tableView.reloadData()

				}
			}
		}
	}
	
	func search(type: SearchType, text: String) -> String {
		switch type {
		case .category:
			return "https://newsapi.org/v2/everything?q=\(text.lowercased())&apiKey=5ea95f893efb4d079742945245fa8226"
		case .country:
			return "https://newsapi.org/v2/top-headlines?country=\(text.lowercased())&apiKey=5ea95f893efb4d079742945245fa8226"
		case .source:
			return "https://newsapi.org/v2/top-headlines?sources=\(text.lowercased())-news&apiKey=5ea95f893efb4d079742945245fa8226"
		case .keyword:
			return "https://newsapi.org/v2/everything?q=\(text.lowercased())&apiKey=5ea95f893efb4d079742945245fa8226"
		}
	}
}

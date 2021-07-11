//
//  NewsAPI.swift
//  NewsApp
//
//  Created by Alexandr on 08.07.2021.
//

import UIKit

final class NewsAPI {
	
	static func getNews(urlLink: String, completion: @escaping ((News) -> Void)) {
		guard let urlLink = URL(string: urlLink) else {
			print("Invalid URL")
			return
		}
		
		URLSession.shared.dataTask(with: urlLink) { data, response, error in
			guard error == nil else {
				print("Error: \(String(describing: error?.localizedDescription))")
				return
			}
			guard let data = data else {
				print("Don't data")
				return
			}
			
			do {
				let result = try JSONDecoder().decode(News.self, from: data)
				completion(result)
			} catch {
				print("Error: \(error.localizedDescription)")
			}
			
		}.resume()
	}
}

	


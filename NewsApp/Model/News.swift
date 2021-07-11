//
//  News.swift
//  NewsApp
//
//  Created by Alexandr on 08.07.2021.
//

import Foundation

// MARK: - News
struct News: Decodable {
	let status: String
	let totalResults: Int
	let articles: [Article]
}

// MARK: - Welcome
struct Welcome: Codable {
	let status: String
	let totalResults: Int
	let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
	let source: Source?
	let author: String?
	let title: String?
	let url: String?
	let urlToImage: String?
	let publishedAt: String?
	let content: String?

}

// MARK: - Source
struct Source: Codable {
	let id: String?
	let name: String
}

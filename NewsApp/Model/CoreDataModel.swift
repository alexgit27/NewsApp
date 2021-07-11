//
//  CoreDataModel.swift
//  NewsApp
//
//  Created by Alexandr on 09.07.2021.
//

import UIKit
import CoreData

final class CoreDataModel {
	
	private let appDelegate: AppDelegate
	private let context: NSManagedObjectContext
	
	init() {
		appDelegate = UIApplication.shared.delegate as! AppDelegate
		context = appDelegate.persistentContainer.viewContext
	}
	
	func saveData(articleDescription: String, author: String, source: String, title: String, urlToArticle: String, urlToImage: String) {
		guard let entity = NSEntityDescription.entity(forEntityName: "ArticleCoreDataModel", in: context) else { return }
		let articleObject = ArticleCoreDataModel(entity: entity, insertInto: context)
			
		articleObject.article = articleDescription
		articleObject.author = author
		articleObject.source = source
		articleObject.title = title
		articleObject.urlToArticle = urlToArticle
		articleObject.urlToImage = urlToImage
		
		do {
			try context.save()
			print("SAVED!")
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
	
	 func getData() -> [ArticleCoreDataModel] {
		var articleId = [ArticleCoreDataModel]()
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		let fetchRequest: NSFetchRequest<ArticleCoreDataModel> = ArticleCoreDataModel.fetchRequest()
		do {
			articleId = try context.fetch(fetchRequest)
		} catch {
			print(error.localizedDescription)
		}
		return articleId
	}
	
	func deleteAllData() {
		let fetchRequest: NSFetchRequest<ArticleCoreDataModel> = ArticleCoreDataModel.fetchRequest()
		fetchRequest.includesPropertyValues = false

		do {
			let articleId = try context.fetch(fetchRequest)
			for item in articleId {
				context.delete(item)
			}
			try context.save()
			print("DELETD")

		} catch {
			print("Error: \(error.localizedDescription)")
		}
	}
}

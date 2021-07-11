//
//  NewsCell.swift
//  NewsApp
//
//  Created by Alexandr on 08.07.2021.
//

import UIKit
import SDWebImage
import CoreData

final class NewsCell: UITableViewCell {

    private let coreDataModel = CoreDataModel()
	
	private var articleDescriptionPropertie = ""
	private var authorPropertie = ""
	private var sourcePropertie = ""
	private var titlePropertie = ""
	private var urlToArticle = ""
	private var urlToImagePropertie = ""
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var source: UILabel!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var articleDescription: UILabel!
	@IBOutlet weak var articleImage: UIImageView!
	@IBOutlet weak var saveButton: UIButton!

	@IBAction func addPressed(_ sender: UIButton) {
		coreDataModel.saveData(articleDescription: articleDescriptionPropertie, author: authorPropertie, source: sourcePropertie, title: titlePropertie, urlToArticle: urlToArticle, urlToImage: urlToImagePropertie)
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func layoutSubviews() {
		activityIndicator.stopAnimating()
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func configureCell(article: Article) {
		guard let source = article.source?.name, let author = article.author, let title = article.title, let stringlToArticle = article.url, let stringToImage = article.urlToImage, let content = article.content, let urlToImage = URL(string: stringToImage), let _ = URL(string: stringlToArticle) else {
			print("Some properties nil")
			return
		}
		
		self.articleImage.sd_setImage(with:urlToImage)
		self.source.text = source
		self.title.text = title
		self.articleDescription.text = content
		
		articleDescriptionPropertie = content
		authorPropertie = author
		sourcePropertie = source
		titlePropertie = title
		urlToArticle = stringlToArticle
		urlToImagePropertie = stringToImage
		
		activityIndicator.stopAnimating()
		activityIndicator.isHidden = true
	}
	
	func configureCell(article: ArticleCoreDataModel) {
		guard let source = article.source, let author = article.author, let title = article.title, let stringlToArticle = article.urlToArticle, let stringToImage = article.urlToImage, let urlToImage = URL(string: stringToImage), let _ = URL(string: stringlToArticle) else {
			print("Some properties nil")
			return
		}
		
		self.articleImage.sd_setImage(with:urlToImage)
		self.source.text = article.source
		self.title.text = article.title
		self.articleDescription.text = article.article
		
		articleDescriptionPropertie = description
		authorPropertie = author
		sourcePropertie = source
		titlePropertie = title
		urlToArticle = stringlToArticle
		urlToImagePropertie = stringToImage
		
		activityIndicator.stopAnimating()
		activityIndicator.isHidden = true
	}
}

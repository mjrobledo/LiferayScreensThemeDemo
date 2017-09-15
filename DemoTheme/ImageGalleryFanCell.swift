//
//  ImageGalleryFanCell.swift
//  LiferayScreens
//
//  Created by Victor Galán on 21/09/16.
//  Copyright © 2016 Liferay. All rights reserved.
//

import UIKit
import LiferayScreens
import Kingfisher

public class ImageGalleryFanCell: UICollectionViewCell {

	@IBOutlet private weak var previewImage: UIImageView!

	private var placeholderImage: UIImage?

	private var startAnchorPoint: CGPoint?

	public var imageUrl: String  {
		get {
			return ""
		}
		set {
			previewImage.lr_setImageWithURL(
				NSURL(string: newValue)! as URL,
				placeholderImage:  placeholderImage,
				optionsInfo: [.backgroundDecode])
		}
	}

	public var image: UIImage {
		get {
			return UIImage()
		}
		set {
			previewImage.image = newValue
		}
	}

	public override func awakeFromNib() {
		super.awakeFromNib()
		startAnchorPoint = self.layer.anchorPoint

		previewImage.clipsToBounds = true
		previewImage.kf.indicatorType = .activity
		previewImage.layer.allowsEdgeAntialiasing = true

		placeholderImage = Bundle.imageInBundles(
			name: "default-placeholder-image",
			currentClass: type(of: self))

		layer.cornerRadius = 10
		layer.borderWidth = 1
		layer.borderColor = UIColor.black.cgColor

		backgroundColor = .white
	}

	public override func prepareForReuse() {
		super.prepareForReuse()

		previewImage.image = placeholderImage
	}

	override public func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
	  	super.apply(layoutAttributes)

		guard let circularlayoutAttributes = layoutAttributes as? FanCollectionViewLayoutAttributes
		else {
			self.center.y = layoutAttributes.center.y
			self.layer.anchorPoint = startAnchorPoint!
			return

		}
		self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
		self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) *
				self.bounds.height
	}
}

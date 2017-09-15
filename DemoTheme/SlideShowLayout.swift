/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import UIKit

public class SlideShowLayout : UICollectionViewFlowLayout {

	let DistanceBetweenCenters = CGFloat(233)
	let ZoomFactor = CGFloat(0.8)
	let TranslateFactor = CGFloat(100)

	internal var visibleRect: CGRect {
		let visibleRectOrigin = self.collectionView!.contentOffset
		let visibleRectSize = self.collectionView!.bounds.size

		return CGRect(origin: visibleRectOrigin, size: visibleRectSize)
	}

	override init() {
		super.init()
		initialize()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}

	public override func layoutAttributesForElements(
		in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
			
		guard let attributesArray = super.layoutAttributesForElements(in: rect)
		else {
			return []
		}

		let attributesCopy = attributesArray.map { $0.copy() as! UICollectionViewLayoutAttributes }

		for attributes in attributesCopy {
			if attributes.frame.intersects(rect) {
				setAttributes(attributes: attributes, visibleRect: visibleRect)
			}
		}

		return attributesCopy
	}

	public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}

	public override func layoutAttributesForItem(
		at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

		guard let attributes = super.layoutAttributesForItem(at: indexPath as IndexPath)
		else {
			return nil
		}

		let attributesCopy = attributes.copy() as! UICollectionViewLayoutAttributes

		setAttributes(attributes: attributesCopy, visibleRect: visibleRect)

		return attributesCopy
	}

	public override func targetContentOffset(
		forProposedContentOffset proposedContentOffset: CGPoint,
			withScrollingVelocity velocity: CGPoint) -> CGPoint {

		var offsetAdjustment = CGFloat(MAXFLOAT)
		let horizontalCenter = proposedContentOffset.x + collectionView!.bounds.width / 2

		let targetRect = CGRect(
				x: proposedContentOffset.x,
				y: 0,
				width: collectionView!.bounds.width,
				height:  collectionView!.bounds.width)

		let attributes = super.layoutAttributesForElements(in: targetRect)

		// Look for the closest image to the center
		for attribute in attributes! {
			let itemHorizontalCenter = attribute.center.x

			if abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment) {

				offsetAdjustment = itemHorizontalCenter - horizontalCenter
			}
		}

		return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
	}

	internal func initialize() {
		itemSize = CGSize(width: 133, height: 173)
		scrollDirection = .horizontal
		minimumLineSpacing = 100
		minimumInteritemSpacing = 1000
		sectionInset = UIEdgeInsets(top: 10, left: 100, bottom: 10, right: 100)
	}

	internal func setAttributes(attributes attributes: UICollectionViewLayoutAttributes, visibleRect: CGRect) {
		let distanceToCenter = visibleRect.midX - attributes.center.x
		let normalizedDistance = distanceToCenter / DistanceBetweenCenters

		if abs(distanceToCenter) < DistanceBetweenCenters {
			// rangeValue 1-0, 1 means in the center of the screen
			let rangeValue = 1 - abs(normalizedDistance)

			let zoom = 1 + ZoomFactor * rangeValue
			let alpha = rangeValue + 0.5

			let scaleTransform = CATransform3DMakeScale(zoom, zoom, 1.0)

			attributes.center.y = self.collectionView!.bounds.height/2
			attributes.transform3D = scaleTransform
			attributes.alpha = alpha
			attributes.zIndex = 1
		}
		else {
			attributes.center.y = self.collectionView!.bounds.height/2
			attributes.alpha = 0.5
			attributes.transform3D = CATransform3DIdentity
			attributes.zIndex = 0
		}

	}

}

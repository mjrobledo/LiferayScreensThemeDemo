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
import LiferayScreens


public class ImageGalleryView_demo : ImageGalleryCollectionViewBase {

	let imageCellId = "imageCellId"

	// MARK: BaseListCollectionView

	public override func doConfigureCollectionView(_ collectionView: UICollectionView) {
		collectionView.backgroundColor = .black
	}

	public override func doRegisterCellNibs() {
		if let imageGalleryGridCellNib = Bundle.nibInBundles(
			name: "ImageGalleryFanCell",
			currentClass: type(of: self)) {

			collectionView?.register(
				imageGalleryGridCellNib,
				forCellWithReuseIdentifier: imageCellId)
		}
	}

	public override func doCreateLayout() -> UICollectionViewLayout {
		return FanLayout()
	}

	override public func doFillLoadedCell(
		indexPath indexPath: IndexPath,
		          cell: UICollectionViewCell,
		          object:AnyObject) {

		guard let imageCell = cell as? ImageGalleryFanCell, let entry = object as? ImageEntry else {
			return
		}

		if let image = entry.image {
			imageCell.image = image
		}
		else {
			imageCell.imageUrl = entry.imageUrl
		}
	}

	public override func doGetCellId(indexPath indexPath: IndexPath, object: AnyObject?) -> String {
		return imageCellId
	}

	public override func collectionView(
		_ collectionView: UICollectionView,
		didSelectItemAt indexPath: IndexPath) {

		if collectionView.collectionViewLayout.isKind(of: SlideShowLayout.self) {
			collectionView.setCollectionViewLayout(FanLayout(), animated: true)
			collectionView.setContentOffset(CGPoint.zero, animated: true)
		}
		else {
			collectionView.setCollectionViewLayout(SlideShowLayout(), animated: true)
		}

	}

}

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
import Foundation

extension String {

	public var isLargeEnough: Bool {
		return self.characters.count > 5
	}

	public var hasDigits: Bool {
		let nonDigits = NSCharacterSet.decimalDigits.inverted
		let numbers = self.components(separatedBy: nonDigits)
		return (numbers.joined(separator: "") != "")
	}

	public var hasUppercase: Bool {
		let nonUpperCase = CharacterSet.uppercaseLetters.inverted
		let letters = self.components(separatedBy: nonUpperCase)
		return (letters.joined(separator: "") != "")
	}

	public var hasLowercase: Bool {
		let nonLowerCase = CharacterSet.lowercaseLetters.inverted
		let letters = self.components(separatedBy: nonLowerCase)
		return (letters.joined(separator: "") != "")
	}

	public var passwordStrengh: Double {
		var strengh = 0.0

		if self.isLargeEnough {
			strengh += 0.1
		}

		if hasLowercase {
			strengh += 0.1
		}

		if hasUppercase {
			strengh += 0.1
		}

		if hasDigits {
			strengh += 0.1
		}

		return strengh
	}

}

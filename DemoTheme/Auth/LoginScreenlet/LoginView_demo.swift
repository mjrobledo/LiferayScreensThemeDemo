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


@IBDesignable open class LoginView_demo: LoginView_default, KeyboardLayoutable {

	@IBOutlet internal var emailMark: UIImageView?
	@IBOutlet internal var passwordMark: UIImageView?

	@IBOutlet internal var emailFail: UIImageView?
	@IBOutlet internal var passwordFail: UIImageView?

	@IBOutlet internal var emailFailMsg: UILabel?
	@IBOutlet internal var passwordFailMsg: UILabel?

	@IBOutlet internal var emailLabel: UILabel?
	@IBOutlet internal var passwordLabel: UILabel?

	@IBOutlet internal var scrollView: UIScrollView?

	@IBOutlet weak var spinner: UIActivityIndicatorView?
	@IBOutlet weak var progressView: UIView?

	internal var keyboardManager = KeyboardManager()
	internal var originalFrame: CGRect?
	internal var textInput: UITextField?

	internal var valid = false


	//MARK: SignUpView

	override open func onSetTranslations() {
		userNameField!.placeholder = LocalizedString("demo", key: "signup-email", obj: self)
		passwordField!.placeholder = LocalizedString("demo", key: "signup-password", obj: self)
		emailLabel!.text = LocalizedString("demo", key: "signup-email-title", obj: self)
		passwordLabel!.text = LocalizedString("demo", key: "signup-password-title", obj: self)
		emailFailMsg!.text = LocalizedString("demo", key: "signup-email-error", obj: self)
	}

	override open func onCreated() {
		scrollView?.contentSize = scrollView!.frame.size

		initialSetup((emailMark!, emailFail!, emailFailMsg!))
		initialSetup((passwordMark!, passwordFail!, passwordFailMsg!))
        
        userNameField?.pintaLinea()
        passwordField?.pintaLinea()
       
	}

    
    
	override open func createProgressPresenter() -> ProgressPresenter {
		if let spinner = self.spinner {
			return DemoProgressPresenter(spinner: spinner, progressView: progressView)
		}

		return super.createProgressPresenter()
	}

	override open func onShow() {
		keyboardManager.registerObserver(self)
	}

	override open func onHide() {
		keyboardManager.unregisterObserver()
	}

	override open func onPreAction(name: String?, sender: AnyObject?) -> Bool {
		if name == "login-action" {
			if !valid {
				shakeEffect()
			}

			return valid
		}

		return true
	}

	fileprivate func shakeEffect() {
		let shake = CABasicAnimation(keyPath: "position")
		shake.duration = 0.08
		shake.repeatCount = 4
		shake.autoreverses = true

		shake.fromValue = NSValue(cgPoint: CGPoint(x: loginButton!.center.x - 5,
		                                           y: loginButton!.center.y))

		shake.toValue = NSValue(cgPoint: CGPoint(x: loginButton!.center.x + 5,
		                                         y: loginButton!.center.y))
		
		loginButton?.layer.add(shake, forKey: "position")
	}

	fileprivate func initialSetup(_ images: (mark: UIImageView, fail: UIImageView, msg: UILabel)) {
		images.msg.frame.origin.x = self.frame.size.width + 5

		images.mark.alpha = 0
		images.mark.frame.origin.x = -20

		images.fail.alpha = 0
		images.fail.frame.origin.x = 10
	}

	@IBAction internal func simpleTap() {
		self.endEditing(true)
	}

	open func layoutWhenKeyboardShown( _ keyboardHeight: CGFloat,
	                                     animation:(time: NSNumber, curve: NSNumber)) {
		
		var keyboardHeight = keyboardHeight
		let absoluteFrame = convert(frame, to: window!)

		if textInput?.autocorrectionType == UITextAutocorrectionType.default ||
			textInput?.autocorrectionType == UITextAutocorrectionType.yes {

			keyboardHeight += KeyboardManager.defaultAutocorrectionBarHeight
		}

		if (absoluteFrame.origin.y + absoluteFrame.size.height >
				UIScreen.main.bounds.height - keyboardHeight) || originalFrame != nil {

			let newHeight = UIScreen.main.bounds.height -
					keyboardHeight - absoluteFrame.origin.y

			if Int(newHeight) != Int(self.frame.size.height) {
				if originalFrame == nil {
					originalFrame = frame
				}

				UIView.animate(withDuration: animation.time.doubleValue,
						delay: 0.0,
						options: UIViewAnimationOptions(rawValue: animation.curve.uintValue),
						animations: {
							self.frame = CGRect(x: self.frame.origin.x,
							                    y: self.frame.origin.y,
							                    width: self.frame.size.width, 
							                    height: newHeight)
						},
						completion: { (completed: Bool) in
						})
			}
		}

	}

	public func layoutWhenKeyboardHidden() {
		if let originalFrameValue = originalFrame {
			self.frame = originalFrameValue
			originalFrame = nil
		}
	}


	//MARK: UITextFieldDelegate

	public func textFieldDidBeginEditing(textField: UITextField) {
		textInput = textField
	}

	public func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange,
			replacementString string: String) -> Bool {

		let newText = textField.text!

		var mark: UIImageView?
		var fail: UIImageView?
		var label: UILabel?
		var msg: UILabel?
		var preValidation = false
		var keepMessage = false

		let bundle = Bundle(for: type(of: self))

		switch textField {
			case userNameField!:
				mark = emailMark
				fail = emailFail
				label = emailLabel
				msg = emailFailMsg
        		valid = newText.isValidEmail

				preValidation = true
				keepMessage = false

			case passwordField!:
				mark = passwordMark
				fail = passwordFail
				label = passwordLabel
				msg = passwordFailMsg

				if newText.characters.count < 3 {
					valid = false
					passwordFailMsg!.text = NSLocalizedString("demo-login-password-error-1",
					                                          tableName: "demo",
					                                          bundle: bundle,
					                                          value: "",
					                                          comment: "")
					passwordFailMsg!.textColor = UIColor.red
				}
				else {
					valid = true
					passwordFailMsg!.text = NSLocalizedString("demo-login-password-error-2",
					                                          tableName: "demo",
					                                          bundle: bundle,
					                                          value: "",
					                                          comment: "")
					passwordFailMsg!.textColor = passwordLabel!.textColor
				}

				preValidation = true
				keepMessage = true

			default: ()
		}

		if valid {
			hideValidationError(controls: (mark!, fail!, label!, msg!), keepMessage: keepMessage)
		}
		else {
			showValidationError(controls: (mark!, fail!, label!, msg!), preValidation: preValidation)
		}

		return true
	}

	private func showValidationError(
			controls: (mark: UIImageView, fail: UIImageView, label: UILabel, msg: UILabel),
			preValidation: Bool) {

		if controls.mark.frame.origin.x > 0 {
			// change mark by fail

			UIView.animate(withDuration: 0.2,
					delay: 0,
					options: UIViewAnimationOptions.curveEaseInOut,
					animations: {
						controls.mark.alpha = 0.0
					},
					completion: { Bool -> Void  in
						UIView.animate(withDuration: 0.3,
							delay: 0,
							options: UIViewAnimationOptions.curveEaseInOut,
							animations: {
								controls.fail.alpha = 1.0
								controls.msg.frame.origin.x =
										self.frame.size.width - controls.msg.frame.size.width - 10
							},
							completion: nil)
					})
		}
		else if preValidation {
			// in cross
			controls.fail.frame.origin.x = -20

			UIView.animate(withDuration: 0.3,
					delay: 0,
					options: UIViewAnimationOptions.curveEaseInOut,
					animations: {
						controls.fail.alpha = 1.0
						controls.mark.frame.origin.x = controls.label.frame.origin.x
						controls.fail.frame.origin.x = controls.label.frame.origin.x
						controls.label.frame.origin.x = controls.label.frame.origin.x + 20
						controls.msg.frame.origin.x =
								self.frame.size.width - controls.msg.frame.size.width - 10
					},
					completion: nil)
		}
	}

	private func hideValidationError(
			controls: (mark: UIImageView, fail: UIImageView, label: UILabel, msg: UILabel),
			keepMessage: Bool) {

		if controls.mark.frame.origin.x < 0 {
			// in

			UIView.animate(withDuration: 0.3,
					delay: 0,
					options: UIViewAnimationOptions.curveEaseInOut,
					animations: {
						controls.mark.alpha = 1.0
						controls.mark.frame.origin.x = controls.label.frame.origin.x
						controls.label.frame.origin.x = controls.label.frame.origin.x + 20
					},
					completion: nil)
		}
		else {
			if controls.fail.alpha == 1.0 {
				// change fail by mark

				UIView.animate(withDuration: 0.2,
					delay: 0,
					options: UIViewAnimationOptions.curveEaseInOut,
					animations: {
						controls.fail.alpha = 0.0
						if !keepMessage {
							controls.msg.frame.origin.x = self.frame.size.width + 5
						}
					},
					completion: { Bool -> Void  in
						UIView.animate(withDuration: 0.3,
							delay: 0,
							options: UIViewAnimationOptions.curveEaseInOut,
							animations: {
								controls.mark.alpha = 1.0
							},
							completion: nil)
					})
			}
		}
	}
}

extension UITextField{
    func pintaLinea(){
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 1.0
        
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 3, y: Double(self.frame.height) - width, width: Double(self.frame.width)-6, height: width)
        
        borderLine.backgroundColor = UIColor(red: 170/255, green: 170/255, blue:170/255, alpha: 1)
        self.addSubview(borderLine)
    }
}

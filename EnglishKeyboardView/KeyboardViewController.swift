//
//  KeyboardViewController.swift
//  EnglishKeyboardView
//
//  Created by Maryam Amer Bin Siddique on 24/06/1446 AH.
//

import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        
        let KeyboardViewController = UIHostingController(rootView: MainEnglishKeyboard(proxy: self.textDocumentProxy))
        let MainEnglishKeyboard = KeyboardViewController.view!
        MainEnglishKeyboard.translatesAutoresizingMaskIntoConstraints = false
        MainEnglishKeyboard.backgroundColor = .systemGray4
        addChild(KeyboardViewController)
        view.addSubview(MainEnglishKeyboard)
        NSLayoutConstraint.activate([
            MainEnglishKeyboard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            MainEnglishKeyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            MainEnglishKeyboard.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            MainEnglishKeyboard.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75) // Takes up 65% of the height
        ]);
        KeyboardViewController.didMove(toParent: self)
        
        
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    
    }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}

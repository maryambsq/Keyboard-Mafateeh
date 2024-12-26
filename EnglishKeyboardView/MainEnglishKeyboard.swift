//
//  MainEnglishKeyboard.swift
//  EnglishKeyboardView
//
//  Created by Maryam Amer Bin Siddique on 24/06/1446 AH.
//

import SwiftUI

struct MainEnglishKeyboard: View {
    @State var proxy: UITextDocumentProxy
    @State private var enlargedKeys: [String] = [] // Enlarged keys
    @State private var showEnlargedKeys = false // Toggle view state
    @State private var isUppercase = false // Track Shift state
    @State private var predictions: [String] = ["", ""]
    
    // Grouped Keys (Lowercase)
    let group1Lower: [(String, [String])] = [
        ("q  w  e                    a  s  d", ["q", "w", "e", "a", "s", "d"]),
        ("r  t  y  u                 f  g  h", ["r", "t", "y", "u", "f", "g", "h"]),
        ("i  o  p                    j  k  l", ["i", "o", "p", "j", "k", "l"])
    ]

    let group2Lower: [(String, [String])] = [
        ("z  x  c  v  b  n  m", ["z", "x", "c", "v", "b", "n", "m"])
    ]

    // Grouped Keys (Uppercase)
    let group1Upper: [(String, [String])] = [
        ("Q  W  E                    A  S  D", ["Q", "W", "E", "A", "S", "D"]),
        ("R  T  Y  U                 F  G  H", ["R", "T", "Y", "U", "F", "G", "H"]),
        ("I  O  P                    J  K  L", ["I", "O", "P", "J", "K", "L"])
    ]

    let group2Upper: [(String, [String])] = [
        ("Z  X  C  V  B  N  M", ["Z", "X", "C", "V", "B", "N", "M"])
    ]
    
    var body: some View {
        VStack(spacing: 5) {
            // Top Bar Section with Predictive Text and Clipboard Button
            TopBarView(proxy: proxy, predictions: $predictions)
                .padding(.bottom)
            // Enlarged Keys View
            if showEnlargedKeys {
                VStack {
                    ZStack {
                        if enlargedKeys.count == 6 {
                            templateOne(keys: enlargedKeys, proxy: proxy, showEnlargedKeys: $showEnlargedKeys)
                        } else {
                            templateTwo(keys: enlargedKeys, proxy: proxy, showEnlargedKeys: $showEnlargedKeys)
                        }
                        VStack {
                            // Back Button
                            Button(action:  {
                                showEnlargedKeys = false
                            }) {
                                Image(systemName: "arrowshape.turn.up.right")
                                    .frame(width: 61, height: 55)
                                    .background(Color(.systemGray2))
                                    .font(.system(size: 30))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.top)
                                    .padding(.leading)
                            }
                            // Backspace
                            Button(action: {
                                proxy.deleteBackward()
                            }) {
                                Image(systemName: "delete.left")
                                    .frame(width: 72, height: 46)
                                    .background(Color(.systemGray2))
                                    .font(.system(size: 25))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                            }
                        }
                        .padding(.top, 100)
                        .padding(.leading, 290)
                    }
                    
                    

                    
                    HStack {
                        // Shift Button
                        Button(action: {
                            isUppercase.toggle() // Toggle between uppercase and lowercase
                        }) {
                            Image(systemName: isUppercase ? "shift.fill" : "shift")
                                .font(.system(size: 30))
                                .frame(width: 56, height: 55)
                                .background(isUppercase ? Color(.white) : Color(.systemGray2))
                                .cornerRadius(8)
                                .foregroundStyle(.black)
                                .padding(.leading, -5)
                        }

                        // Space Bar
                        Button("space") {
                            proxy.insertText(" ")
                        }
                        .frame(maxWidth: .infinity, maxHeight: 56)
                        .background(Color(.white))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        
                        // Return Key
                        Button("return") {
                            proxy.insertText("\n")
                        }
                        .frame(width: 111, height: 55)
                        .background(Color(.systemGray2))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        .padding(.trailing, -5)
                    }
                    .padding(.horizontal)

                }
            } else {
                // Main Keyboard Layout
                VStack(spacing: 10) {
                    // Grouped Keys (Rows)
                    let group1 = isUppercase ? group1Upper : group1Lower
                    let group2 = isUppercase ? group2Upper : group2Lower
                    
                    VStack {
                        HStack {
                            ForEach(group1, id: \.0) { key, keys in
                                Button(action: {
                                    enlargedKeys = keys // Preserves the exact key order
                                    showEnlargedKeys = true
                                }) {
                                    Text(key) // Displays the group label
                                        .frame(width: 119, height: 108)
                                        .font(.system(size: 30))
                                        .background(Color(.white))
                                        .cornerRadius(8)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                        
                        HStack {
                            // Shift Button
                            Button(action: {
                                isUppercase.toggle() // Toggle between uppercase and lowercase
                            }) {
                                Image(systemName: isUppercase ? "shift.fill" : "shift")
                                    .font(.system(size: 30))
                                    .frame(width: 55.5, height: 108)
                                    .background(isUppercase ? Color(.white) : Color(.systemGray2))                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.trailing, 10)
                            }
                            VStack {
                                ForEach(group2, id: \.0) { key, keys in
                                    Button(action: {
                                        enlargedKeys = keys
                                        showEnlargedKeys = true
                                    }) {
                                        Text(key)
                                            .frame(width: 290, height: 61)
                                            .background(Color(.white))
                                            .font(.system(size: 30))
                                            .cornerRadius(8)
                                            .foregroundStyle(.black)
                                    }
                                }
                                // Bottom Row Buttons
                                HStack {
                                    
                                    // Numbers Keyboard
                                    Button("123") {
                                        proxy.insertText("123")
                                    }
                                    .frame(width: 125, height: 46)
                                    .background(Color(.systemGray2))
                                    .font(.system(size: 20))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.trailing, 10)

                                    
                                    // Symbols Keyboard
                                    Button("#+=") {
                                        proxy.insertText("#+=")
                                    }
                                    .frame(width: 67, height: 46)
                                    .background(Color(.systemGray2))
                                    .font(.system(size: 20))
                                    .cornerRadius(8)
                                    .foregroundStyle(.black)
                                    .padding(.trailing, 5)
                                    
                                    // Backspace
                                    Button(action: {
                                        proxy.deleteBackward()
                                    }) {
                                        Image(systemName: "delete.left")
                                            .frame(width: 72, height: 46)
                                            .background(Color(.systemGray2))
                                            .font(.system(size: 25))
                                            .cornerRadius(8)
                                            .foregroundStyle(.black)
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    // Emoji, Space, Return
                    HStack {
                        // Emoji Button
                        Button(action: {
                            // Placeholder for emoji action
                        }) {
                            Image(systemName: "face.smiling")
                                .frame(width: 56, height: 55)
                                .background(Color(.systemGray2))
                                .font(.system(size: 25))
                                .cornerRadius(8)
                                .foregroundStyle(.black)
                                .padding(.leading, -5)
                        }
                        
                        // Space Bar
                        Button("space") {
                            proxy.insertText(" ")
                        }
                        .frame(maxWidth: .infinity, maxHeight: 56)
                        .background(Color(.white))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        
                        // Return Key
                        Button("return") {
                            proxy.insertText("\n")
                        }
                        .frame(width: 111, height: 55)
                        .background(Color(.systemGray2))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                        .padding(.trailing, -5)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onChange(of: proxy.documentContextBeforeInput) { newValue in
            updatePredictions(from: newValue)
        }
    }
    
    // MARK: - Top Bar View
    struct TopBarView: View {
        @State var proxy: UITextDocumentProxy
        @Binding var predictions: [String]

        var body: some View {
            HStack {
                // Left Predictive Text
                Button(predictions[0]) {
                                proxy.insertText(predictions[0] + " ")
                }
                .frame(maxWidth: .infinity, maxHeight: 46)
                .foregroundStyle(.black)
                .font(.system(size: 25))
                
                // Divider Line
                Divider()
                    .frame(height: 30)
                    .background(Color(.systemGray3))

                // Clipboard Button
                Button(action: {
                    if let clipboardText = UIPasteboard.general.string {
                        proxy.insertText(clipboardText) // Inserts clipboard text
                    }
                }) {
                    Image(systemName: "list.clipboard")
                        .font(.system(size: 30))
                        .frame(width: 56, height: 55)
                        .background(Color(.systemGray2))
                        .cornerRadius(8)
                        .foregroundStyle(.black)
                }
                .padding(.horizontal)

                // Divider Line
                Divider()
                    .frame(height: 30)
                    .background(Color(.systemGray3))

                // Right Predictive Text
                Button(predictions[1]) {
                    proxy.insertText(predictions[1] + " ")
                }
                .frame(maxWidth: .infinity, maxHeight: 46)
                .foregroundStyle(.black)
                .font(.system(size: 25))
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
    
    
    // Prediction Logic
    func updatePredictions(from context: String?) {
        guard let context = context, !context.isEmpty else {
            predictions = ["I", "We"] // Default predictions
            return
        }

        let words = context.split(separator: " ")
        let lastWord = words.last?.lowercased() ?? ""

        // Example static predictions based on the last word
        switch lastWord {
        case "i":
            predictions = ["I'm", "is"]
        case "h":
            predictions = ["hi", "hello"]
        case "you":
            predictions = ["are", "will"]
        case "we":
            predictions = ["are", "can"]
        case "he":
            predictions = ["is", "was"]
        case "she":
            predictions = ["is", "was"]
        case "it":
            predictions = ["is", "will"]
        default:
            predictions = ["I", "The"]
        }
    }
}

    // Enlarged Keys Templates
    func templateOne(keys: [String], proxy: UITextDocumentProxy, showEnlargedKeys: Binding<Bool>) -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                ForEach(keys.prefix(3), id: \.self) { key in
                    Button(key) {
                        proxy.insertText(key)
                    }
                    .frame(width: 75, height: 95)
                    .background(Color.white)
                    .font(.system(size: 45))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
                }
            }
            HStack(spacing: 20) {
                ForEach(keys.suffix(3), id: \.self) { key in
                    Button(key) {
                        proxy.insertText(key)
                    }
                    .frame(width: 75, height: 95)
                    .background(Color.white)
                    .font(.system(size: 45))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
                }
            }
            .padding(.leading, -100)

        }
    }

    func templateTwo(keys: [String], proxy: UITextDocumentProxy, showEnlargedKeys: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                ForEach(keys.prefix(4), id: \.self) { key in
                    Button(key) {
                        proxy.insertText(key)
                    }
                    .frame(width: 75, height: 95)
                    .background(Color.white)
                    .font(.system(size: 45))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
                }
            }
            HStack(spacing: 20)  {
                ForEach(keys.suffix(3), id: \.self) { key in
                    Button(key) {
                        proxy.insertText(key)
                    }
                    .frame(width: 75, height: 95)
                    .background(Color.white)
                    .font(.system(size: 45))
                    .cornerRadius(8)
                    .foregroundStyle(.black)
                }
            }
        }
        .padding(.bottom, 20)
    }


//
//  ContentView.swift
//  WordScramble
//
//  Created by Lanre ESAN on 29/03/2020.
//  Copyright © 2020 tomisinesan.com. All rights reserved.
//

import SwiftUI
struct ContentView: View {
    @State private var usedWord = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var isShowing = false
    
    
     var body: some View {
        NavigationView {
            VStack {
                TextField("Enter new word", text: $newWord, onCommit:addNewWord).textFieldStyle(RoundedBorderTextFieldStyle()).autocapitalization(.none).padding()
                List(usedWord, id: \.self) {
                    Image(systemName:"\($0.count).circle")
                    Text($0)
                }
            }.navigationBarTitle(rootWord).navigationBarItems(leading: Button(action: startGame){
                Text("Restart")
            }).onAppear(perform: startGame)
                .alert(isPresented: $isShowing){
                    Alert(title:Text(errorTitle),message: Text(errorMessage),dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard  answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title:"Word Used Already", message:"Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
                  wordError(title:"Word not recognized", message:"You can't make this words up you know")
                  return
              }
        
        guard isReal(word: answer) else {
                  wordError(title:"Word Not Possible", message:"That is not a real word")
                  return
              }
        
        usedWord.insert(answer, at:0)
        newWord = ""
    }
    
    func startGame(){
        if let startWordsUrl =  Bundle.main.url(forResource:"start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsUrl){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkWorm"
                
                return
            }
        }
        
        fatalError("could not load data from bundle")
    }
    
    func isOriginal(word:String) -> Bool {
        !usedWord.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let pos = tempWord.firstIndex(of:letter){
                tempWord.remove(at: pos)
            }
            else {
                return false
            }
        }
        return true
    }
    
    func wordError(title: String, message:String){
        errorTitle = title
        errorMessage = message
        isShowing = true
    }
    
    func isReal(word:String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound && word.count > 2 && rootWord != word
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 struct ContentView: View {
     var body: some View {
         List {
                Text("Hello Wolrd")
                Text("Hello Wolrd")
                Text("Hello Wolrd")
             
             ForEach(0..<5){
                 Text("Dynamic row \($0)")
             }
         }.listStyle(GroupedListStyle())
     }
 }

 */

/*
 struct ContentView: View {
     var body: some View {
         List(0..<5) {
             Text("Dynamic row \($0)")
             
         }.listStyle(GroupedListStyle())
     }
 }
 */

/*
 struct ContentView: View {
     let people = ["Finn", "Grace", "Tola"]
     var body: some View {
         List(people, id: \.self) {
             Text("Dynamic row \($0)")
             
         }.listStyle(GroupedListStyle())
     }
 }
 */

/*
 if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
     // we found the file in our bundle!
 if let fileContents = try? String(contentsOf: fileURL) {
     // we loaded the file into a string!
 }
 }
 
 */

/*
 let input = "a b c"
 let letters = input.components(separatedBy: " ")
 
 
 let input = """
             a
             b
             c
             """
 let letters = input.components(separatedBy: "\n")
 let letter = letters.randomElement()
 let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
 */

/*
 let word = "swift"
 let checker = UITextChecker()
 let range = NSRange(location: 0, length: word.utf16.count)
 let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
 let allGood = misspelledRange.location == NSNotFound
 */

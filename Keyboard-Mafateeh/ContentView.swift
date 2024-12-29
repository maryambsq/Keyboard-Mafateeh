//
//  ContentView.swift
//  Keyboard-Mafateeh
//
//  Created by Maryam Amer Bin Siddique on 24/06/1446 AH.
//
import SwiftUI
import SwiftData

@Model
class Phrase: Identifiable {
    @Attribute(.unique) var content: String

    init(content: String) {
        self.content = content
    }
}

var sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Phrase.self,
    ])

    let appGroupURL = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: "group.com.yourapp.mafateeh" // Replace with your App Group ID
    )!.appendingPathComponent("SharedDatabase.sqlite")

    let modelConfiguration = ModelConfiguration(
        schema: schema,
        url: appGroupURL // Shared storage location
    )

    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var savedPhrases: [Phrase]
    @State private var showSheet: Bool = false
    @State private var newPhrase: String = ""
    @State private var editingPhrase: Phrase?
    @State private var selectedItems: Set<Phrase> = [] // Multi-selection

    @Environment(\.editMode) private var editMode

    var body: some View {
        NavigationView {
            ZStack {
                Color("BG")
                    .edgesIgnoringSafeArea(.all)

                if savedPhrases.isEmpty {
                        emptyStateView()
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        // Sub-header
                        Text("SAVED")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 35)
                            .padding(.top, 40)
                        
                        List(selection: $selectedItems) {
                            ForEach(savedPhrases, id: \.self) { phrase in
                                Text(phrase.content)
                                    .onTapGesture {
                                        if editMode?.wrappedValue == .inactive {
                                            newPhrase = phrase.content
                                            editingPhrase = phrase
                                            showSheet = true
                                        }
                                    }
                            }
                            // Swipe-to-delete works only when not in Edit Mode
                            .onDelete(perform: editMode?.wrappedValue == .inactive ? swipeToDelete : nil)
                        }
                        .environment(\.editMode, editMode)
                        .listStyle(PlainListStyle())
                        .padding(.top, 5)
                        .padding(.horizontal, 20)
                    }

                    if editMode?.wrappedValue == .active {
                        bottomDeleteButton()
                    } else {
                        VStack {
                            Spacer()
                            bottomAddButton()
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(false)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent()
            }
            .sheet(isPresented: $showSheet) {
                AddPhraseSheet(
                    newPhrase: $newPhrase,
                    editingPhrase: $editingPhrase
                )
            }
            .onChange(of: savedPhrases) {
                if savedPhrases.isEmpty {
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                }
            }
        }
    }

    // MARK: - Views
    
    @ViewBuilder
    private func emptyStateView() -> some View {
        VStack {
            Spacer()
            VStack(spacing: 16) {
                Text("💬")
                    .font(.system(size: 90))
                    .offset(x: -5, y: 30)
                Text("⚡️")
                    .font(.system(size: 90))
                    .offset(x: 30, y: -150)
                Text("You have no saved phrases")
                    .fontWeight(.semibold)
                    .font(.body)
                    .padding(.top, -100)
                    .overlay(
                        Rectangle()
                            .foregroundStyle(Color("BG"))
                            .frame(width: 1000, height: 500)
                            .offset(y: -40)
                            .opacity(0.5)
                    )
            }
            Spacer()
            bottomAddButton()
        }
    }
    
    @ViewBuilder
    private func bottomAddButton() -> some View {
        Button(action: {
            newPhrase = ""
            editingPhrase = nil
            showSheet = true
        }) {
            Text("Add Phrase")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color("Button"))
                .foregroundColor(.white)
                .cornerRadius(25)
                .padding(.horizontal, 20)
        }
        .padding(.bottom, 40)
    }
    
    @ViewBuilder
    private func bottomDeleteButton() -> some View {
        VStack {
            Spacer()
            Button(action: {
                deleteSelectedPhrases()
            }) {
                Text("Delete")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding(.horizontal, 20)
            }
            .disabled(selectedItems.isEmpty) // Disable until a phrase is selected
            .opacity(selectedItems.isEmpty ? 0.5 : 1.0) // Visually indicate disabled state
            .padding(.bottom, 40)
        }
    }

    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("My Clipboard")
                .font(.system(size: 24, weight: .semibold))
                .padding(.top, 30)
        }
        if !savedPhrases.isEmpty {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(editMode?.wrappedValue == .active ? "Done" : "Select") {
                    withAnimation {
                        editMode?.wrappedValue = editMode?.wrappedValue == .active ? .inactive : .active
                        selectedItems.removeAll()
                    }
                }
                .padding(.top, 30)
            }
        }
        if editMode?.wrappedValue == .active && !savedPhrases.isEmpty {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Select All") {
                    if selectedItems.count == savedPhrases.count {
                        selectedItems.removeAll()
                    } else {
                        selectedItems = Set(savedPhrases)
                    }
                }
                .padding(.top, 35)
            }
        }
    }

    // MARK: - Functions
    
    func deleteSelectedPhrases() {
        withAnimation {
            for phrase in selectedItems {
                modelContext.delete(phrase)
            }
            selectedItems.removeAll()
            
            if savedPhrases.isEmpty {
                withAnimation {
                    editMode?.wrappedValue = .inactive
                }
            }
        }
    }

    func swipeToDelete(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let phrase = savedPhrases[index]
                modelContext.delete(phrase)
            }
            
            if savedPhrases.isEmpty {
                withAnimation {
                    editMode?.wrappedValue = .inactive
                }
            }
        }

    }
}

struct AddPhraseSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Binding var newPhrase: String
    @Binding var editingPhrase: Phrase?

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .font(.system(size: 20, weight: .medium))
                        .padding()
                }
                Spacer()
                Button("Save") {
                    if !newPhrase.isEmpty {
                        // Check for duplicates
                        if let _ = try? modelContext.fetch(FetchDescriptor<Phrase>(predicate: #Predicate { $0.content == newPhrase })).first {
                            print("Duplicate content detected. Phrase already exists.")
                        } else {
                            if let phrase = editingPhrase {
                                phrase.content = newPhrase
                            } else {
                                let newPhraseModel = Phrase(content: newPhrase)
                                modelContext.insert(newPhraseModel)
                                try? modelContext.save()
                            }
                            newPhrase = ""
                            editingPhrase = nil
                            dismiss()
                        }
                    }
                }
                .padding()
                .disabled(newPhrase.isEmpty)
            }
            TextEditor(text: $newPhrase)
                .frame(width: 356, height: 199)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 0.20)
                )
                .padding()

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}


//import SwiftUI
//import SwiftData
//
//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}

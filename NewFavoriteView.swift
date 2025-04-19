//
//  NewFavoriteView.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-18.
//

import SwiftUI

struct NewFavoriteView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var region: String = ""
    @State private var instructions: String = ""
    
    var onSave: (String, String, String, String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Dish Info")) {
                    TextField("Dish Name", text: $name)
                    TextField("Category", text: $category)
                    TextField("Region", text: $region)
                }
                Section(header: Text("Instructions")){
                    TextEditor(text: $instructions)
                        .frame(minHeight: 100)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.4))
                        }
                }
                Button("Save"){
                    onSave(name, category, region, instructions)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || category.isEmpty || region.isEmpty || instructions.isEmpty)
            }
            .navigationTitle("Add Favorite")
            .navigationBarItems(trailing: Button("Cancel"){
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

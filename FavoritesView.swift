//
//  FavoritesView.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-18.
//

import SwiftUI

struct FavoritesView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteRecipe.name, ascending: true)],
        animation: .default
    )
    private var favoriteRecipes: FetchedResults<FavoriteRecipe>

    @State private var showingAddSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(favoriteRecipes, id: \.self) { recipe in
                    HStack(alignment: .top, spacing: 12) {
                        if let imageURL = recipe.imageURL,
                           let url = URL(string: imageURL),
                           !imageURL.isEmpty {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(10)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text(recipe.name ?? "Unknown")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Category: \(recipe.category ?? "N/A")")
                                .font(.subheadline)
                            Text("Area: \(recipe.area ?? "N/A")")
                                .font(.subheadline)
                            if let instructions = recipe.instructions, !instructions.isEmpty {
                                Text("Instructions: \(instructions)")
                                    .font(.footnote)
                                    .lineLimit(3)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .onDelete(perform: deleteRecipes)
            }
            .navigationTitle("Favorite Recipes")
            .navigationBarItems(trailing: Button(action: {
                showingAddSheet = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddSheet) {
                NewFavoriteView { name, category, region, instructions in
                    addRecipe(name: name, category: category, region: region, instructions: instructions)
                }
            }
        }
    }

    private func addRecipe(name: String, category: String, region: String, instructions: String) {
        let newRecipe = FavoriteRecipe(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.name = name
        newRecipe.category = category
        newRecipe.area = region
        newRecipe.instructions = instructions
        newRecipe.imageURL = "" // Can update UI to allow manual URL input if needed

        do {
            try viewContext.save()
        } catch {
            print("❌ Failed to save new recipe: \(error.localizedDescription)")
        }
    }

    private func deleteRecipes(offsets: IndexSet) {
        withAnimation {
            offsets.map { favoriteRecipes[$0] }
                .forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("❌ Failed to delete recipes: \(error.localizedDescription)")
            }
        }
    }
}

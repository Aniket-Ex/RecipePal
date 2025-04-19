//
//  HomeView.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-18.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = RecipeViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchTerm: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    TextField("Search recipes...", text: $searchTerm, onCommit: {
                        viewModel.fetchRecipes(for: searchTerm)
                    })
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Button(action: {
                        viewModel.fetchRecipes(for: searchTerm)
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding(.trailing)
                    }
                }
                .padding(.top)
                
                // Recipes List
                List(viewModel.recipes) { recipe in
                    HStack(alignment: .top, spacing: 12) {
                        AsyncImage(url: URL(string: recipe.strMealThumb ?? "")) { phase in
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
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(recipe.strMeal)
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            if let category = recipe.strCategory {
                                Text("Category: \(category)")
                                    .font(.subheadline)
                            }
                            if let area = recipe.strArea {
                                Text("Area: \(area)")
                                    .font(.subheadline)
                            }
                            
                            Button(action: {
                                addToFavorites(recipe)
                            }){
                                HStack{
                                    Image(systemName: "heart.fill")
                                    Text("Add to favorites")
                                }
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .padding(.top, 6)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Recipes")
        }
        .onAppear {
            print("📲 HomeView appeared — fetching recipes...")
            viewModel.fetchRecipes()
        }
    }
    
    private func addToFavorites(_ recipe: Recipe){
        let newFavorite = FavoriteRecipe(context: viewContext)
        newFavorite.id = UUID()
        newFavorite.name = recipe.strMeal
        newFavorite.category = recipe.strCategory ?? "Unknown"
        newFavorite.area = recipe.strArea ?? "Unknown"
        newFavorite.instructions = recipe.strInstructions ?? "No instructions provided."
        newFavorite.imageURL = recipe.strMealThumb ?? ""
        
        do {
            try viewContext.save()
            print("✅ Added \(recipe.strMeal) to favorites.")
        } catch {
            print("❌ Error saving to favorite: \(error.localizedDescription) ")
        }
    }
}

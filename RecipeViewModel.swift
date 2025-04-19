//
//  RecipeViewModel.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-18.
//

import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchRecipes(for searchTerm: String = "chicken") {
        print("🌐 fetchRecipes called with search term: \(searchTerm)")
        let urlString = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(searchTerm)"
        guard let url = URL(string: urlString) else {
            print("❗️Invalid URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("iOSApp/1.0", forHTTPHeaderField: "User-Agent")
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .retry(2)
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            .map { $0.meals ?? [] }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("❌ Error fetching recipes: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] recipes in
                print("✅ Recipes loaded: \(recipes.count)")
                self?.recipes = recipes
            })
            .store(in: &cancellables)
    }
}

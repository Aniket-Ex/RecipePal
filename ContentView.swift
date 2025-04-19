//
//  ContentView.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-15.
//
import SwiftUI

struct ContentView: View {
    
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            
            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
        }
    }
}


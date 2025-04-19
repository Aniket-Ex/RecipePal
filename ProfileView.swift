//
//  ProfileView.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-18.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showingSignIn = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack{
            if authViewModel.isAuthenticated {
                Text("Welcome, \(authViewModel.user?.email ?? "User")!")
                    .font(.title3)
                
                Button("Sign Out"){
                    authViewModel.signOut() { success, error in
                        if success {
                            print("Signed out successfully.")
                        } else {
                            errorMessage = error
                        }
                    }
                }
                .foregroundColor(.red)
            } else {
                Text("You're not signed in.")
                    .font(.title3)
                    .padding()
                
                Button("Sign In / Sign Up") {
                    showingSignIn = true
                }
                .foregroundColor(.blue)
            }
        }
        .sheet(isPresented: $showingSignIn) {
            SignInView(authViewModel: authViewModel)
        }
    }
}

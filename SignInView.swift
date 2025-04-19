//
//  SignInView.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-18.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack(spacing: 20){
            
            Text(isSignUp ? "Create Account" : "Sign In")
                .font(.title)
                .bold()
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                if isSignUp {
                    authViewModel.signUp(email: email, password: password) { success, error in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            errorMessage = error
                        }
                    }
                } else {
                    authViewModel.signIn(email: email, password: password) { success, error in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            errorMessage = error
                        }
                    }
                }
            }) {
                Text(isSignUp ? "Sign Up" : "Sign In")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button(action: {
                isSignUp.toggle()
                errorMessage = nil
            }) {
                Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                    .font(.footnote)
            }
            
            Spacer()
        }
        .padding()
    }
}

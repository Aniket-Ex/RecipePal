//
//  AuthViewModel.swift
//  RecipePal
//
//  Created by Aniket Saxena on 2025-04-18.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject{
    @Published var user: User?
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    var isAuthenticated: Bool {
        return user != nil
    }
    
    init(){
        authStateHandle = Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("❌ Login Failed: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping(Bool, String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("❌ Registeration Failed: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            completion(true, nil)
        }
    }
    
    func signOut(completion: @escaping(Bool, String?) -> Void){
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch let error {
            print("❌ Sign-Out Failed: \(error.localizedDescription)")
            completion(false, error.localizedDescription)
        }
    }
}

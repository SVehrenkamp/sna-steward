import SwiftUI
import Foundation
import Combine

// Import required models
// @testable import sna_steward

struct SignInView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showForgotPassword = false
    @State private var showSignUp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    // Logo or App Title
                    Text("SNA Steward")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    // Sign in form
                    VStack(spacing: 15) {
                        TextField("Email", text: $viewModel.email)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $viewModel.password)
                            .textContentType(.password)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        // Error message
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.horizontal)
                        }
                        
                        // Sign in button
                        Button(action: {
                            Task {
                                await viewModel.signIn()
                            }
                        }) {
                            Text("Sign In")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }
                        
                        // Forgot password link
                        Button("Forgot Password?") {
                            showForgotPassword = true
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.top, 5)
                        
                        Divider()
                            .padding()
                        
                        // Magic link button
                        Button(action: {
                            Task {
                                await viewModel.sendMagicLink()
                            }
                        }) {
                            Text("Sign in with Magic Link")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                                .padding(.horizontal)
                        }
                        
                        // Biometric authentication button (if available)
                        if viewModel.showBiometricSignIn {
                            Button(action: {
                                Task {
                                    await viewModel.signInWithBiometrics()
                                }
                            }) {
                                HStack {
                                    Image(systemName: BiometricAuthHelper.shared.biometricType() == .faceID ? "faceid" : "touchid")
                                    Text("Sign in with \(BiometricAuthHelper.shared.biometricType().description)")
                                }
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Don't have an account? link
                    HStack {
                        Text("Don't have an account?")
                        Button("Sign Up") {
                            showSignUp = true
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.bottom, 20)
                }
                
                // Loading state
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            // Navigation links
            .sheet(isPresented: $showForgotPassword) {
                PasswordResetView(viewModel: viewModel)
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView(viewModel: viewModel)
            }
            .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
                if viewModel.isFirstTimeUser {
                    SelectSnaSiteView(viewModel: viewModel)
                } else {
                    // Main app content goes here
                    MainContentView(viewModel: viewModel)
                }
            }
        }
    }
}

// Preview
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        // Setup mock environment for preview
        return SignInView(viewModel: PreviewHelper.createMockAuthViewModel())
    }
} 
import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var confirmPassword = ""
    @State private var passwordsMatch = true
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 30)
                    
                    VStack(spacing: 15) {
                        TextField("Email", text: $viewModel.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $viewModel.password)
                            .textContentType(.newPassword)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textContentType(.newPassword)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .onChange(of: confirmPassword) { newValue in
                                passwordsMatch = viewModel.password == newValue || newValue.isEmpty
                            }
                        
                        // Password match error
                        if !passwordsMatch {
                            Text("Passwords do not match")
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.horizontal)
                        }
                        
                        // Error message from viewModel
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.horizontal)
                        }
                        
                        Button(action: {
                            guard viewModel.password == confirmPassword else {
                                passwordsMatch = false
                                return
                            }
                            
                            Task {
                                await viewModel.signUp()
                            }
                        }) {
                            Text("Create Account")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                                .padding(.horizontal)
                        }
                        .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty || confirmPassword.isEmpty || !passwordsMatch)
                        .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    // Already have an account? link
                    HStack {
                        Text("Already have an account?")
                        Button("Sign In") {
                            dismiss()
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        // Setup mock environment for preview
        DotEnv.setupForPreviews()
        
        return SignUpView(viewModel: AuthViewModel())
    }
} 
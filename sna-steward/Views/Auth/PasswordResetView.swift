import SwiftUI

struct PasswordResetView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var resetEmail = ""
    @State private var resetSent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    Text("Reset Password")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 30)
                    
                    if resetSent {
                        // Success view
                        VStack(spacing: 20) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.green)
                                .padding()
                            
                            Text("Password Reset Email Sent")
                                .font(.headline)
                            
                            Text("Please check your inbox at \(resetEmail) for instructions to reset your password.")
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Button("Return to Sign In") {
                                dismiss()
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        .padding()
                    } else {
                        // Reset form
                        VStack(spacing: 15) {
                            Text("Enter your email address and we'll send you a link to reset your password.")
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            TextField("Email", text: $resetEmail)
                                .textContentType(.emailAddress)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .keyboardType(.emailAddress)
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
                            
                            Button(action: {
                                // In a real app, connect to Supabase resetPassword function
                                // For now, we'll simulate success
                                viewModel.email = resetEmail
                                Task {
                                    await viewModel.sendMagicLink()
                                    resetSent = true
                                }
                            }) {
                                Text("Send Reset Link")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                            }
                            .padding(.top, 10)
                            
                            Button("Cancel") {
                                dismiss()
                            }
                            .padding(.top, 10)
                        }
                    }
                    
                    Spacer()
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

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView(viewModel: AuthViewModel())
    }
} 
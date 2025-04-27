import SwiftUI

struct SelectSnaSiteView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    // Example SNA sites - replace with real data fetch
    private let exampleSites = [
        "Green Valley SNA",
        "Blue River SNA",
        "Eagle Mountain SNA",
        "Lakeside Preserve SNA",
        "Pinewood Forest SNA"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Select Your SNA Site")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 30)
                    
                    Text("Welcome to SNA Steward! Please select the SNA site you will be stewarding.")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Picker("SNA Site", selection: $viewModel.selectedSnaSite) {
                        Text("Select a site").tag(Optional<String>(nil))
                        ForEach(exampleSites, id: \.self) { site in
                            Text(site).tag(Optional(site))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
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
                        Task {
                            await viewModel.saveSnaSite()
                        }
                    }) {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    .disabled(viewModel.selectedSnaSite == nil)
                    
                    Spacer()
                    
                    // Sign out option at bottom
                    Button(action: {
                        Task {
                            await viewModel.signOut()
                        }
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
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
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SelectSnaSiteView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a viewModel with isFirstTimeUser set to true
        let viewModel = AuthViewModel()
        SelectSnaSiteView(viewModel: viewModel)
    }
} 
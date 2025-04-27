import SwiftUI

struct MainContentView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to SNA Steward!")
                    .font(.title)
                    .padding()
                
                if let snaSite = viewModel.selectedSnaSite {
                    Text("Your SNA Site: \(snaSite)")
                        .font(.headline)
                        .padding()
                }
                
                Spacer()
                
                // Sign out button
                Button(action: {
                    Task {
                        await viewModel.signOut()
                    }
                }) {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("SNA Steward")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Setup mock environment for preview
        DotEnv.setupForPreviews()
        
        let viewModel = AuthViewModel()
        viewModel.selectedSnaSite = "Green Valley SNA" // Set sample data
        return MainContentView(viewModel: viewModel)
    }
} 

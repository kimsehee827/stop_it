import Foundation
import Firebase
import GoogleSignIn

class ContentViewModel: ObservableObject {
    @Published var isSignIn = false
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func onAppear() {
        
        // auto login
        if let user = Auth.auth().currentUser {
            User.shared.loginHandler(uid: user.uid, email: user.email!)
        }
        
        isSignIn = User.shared.isSignIn
        
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            print("state change")
            
            guard let user = user else { return }
            
            self?.isSignIn = true
            
            User.shared.loginHandler(uid: user.uid, email: user.email!)
            
            return
        }
    }
    
    func onDisappear() {
        Auth.auth().removeStateDidChangeListener(handle!)
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("sign out error: \(signOutError.localizedDescription)")
        }
    }
    
    func googleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootViewController, callback: { user, error in
            if let error = error  {
                print("\(error.localizedDescription)")
                return
            }
            
            guard let auth = user?.authentication,
                  let idToken = auth.idToken else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in

            }
        })
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        User.shared.logOutHandler()
        self.isSignIn = false
    }
}

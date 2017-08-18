

import UIKit
import Firebase
import FirebaseAuth
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        
        
        
        
        
        
        
//        FIRAuth.auth()?.signIn(withEmail: "olmaditekrar@gmail.com", password: "123123124", completion:{ (user : FIRUser?, error :Error?) in
//            if error == nil {
//                print(user?.email)
//            }else {
//                print(error?.localizedDescription )
//            }
//        })
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
            }

    func applicationDidEnterBackground(_ application: UIApplication) {
           }

    func applicationWillEnterForeground(_ application: UIApplication) {
            }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
            }


}




import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProcastinativeTableViewController: UITableViewController {

    var currentUser : FIRUser?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FIRAuth.auth()?.addStateDidChangeListener({ (auth : FIRAuth,user : FIRUser?) in
            if let user = user {
                print("Welcome \(user.email)")
                self.currentUser = user
                self.startObservingDB()
                
            }else {
                print ("You need to Sign Up or Log In first .")
            }
        })
    }
    @IBAction func loginOrSignUpButtonPressed(_ sender: Any) {
        let userAlert = UIAlertController(title: "Login In/Sign Up", message: "Please enter e-mail and password", preferredStyle: .alert)
        userAlert.addTextField { (textfield :UITextField) in
            textfield.placeholder = "Enter your e-mail ."
        }
        userAlert.addTextField { (textfield : UITextField) in
            textfield.placeholder = "Enter your password"
            textfield.isSecureTextEntry = true
            
        }
        userAlert.addAction(UIAlertAction(title: "Log In", style: .default, handler: { (UIAlertAction) in
            let eMailTextField = userAlert.textFields?.first!
            let passwordTextField = userAlert.textFields?.last!
            FIRAuth.auth()?.signIn(withEmail: (eMailTextField?.text!)!, password: (passwordTextField?.text!)!, completion: { (user : FIRUser?, error :Error?) in
                if error != nil{
                    print(error?.localizedDescription)
                }
            })
        }))
        userAlert.addAction(UIAlertAction(title:
            "Sign Up", style: .default, handler: { (UIAlertAction) in
            let eMailTextField = userAlert.textFields?.first!
            let passwordTextField = userAlert.textFields?.last!
            FIRAuth.auth()?.createUser(withEmail: (eMailTextField?.text!)!, password: (passwordTextField?.text!)!, completion: { (user : FIRUser?, error : Error?) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                
            })
            
        }))
        self.present(userAlert, animated: true, completion: nil) 
    }
    var doThisArray = [DoThis]()
    var dbRef : FIRDatabaseReference!
    func startObservingDB(){
        
        dbRef.observe( FIRDataEventType.value ,  with: { (snapshot :FIRDataSnapshot) in
            var newDoThisArray = [DoThis]()
            
            for doThis in snapshot.children{
                //
                let newDoThisObject = DoThis(snapshot: (doThis as? FIRDataSnapshot)!)
                //
                newDoThisArray.append(newDoThisObject)
                //
            }
            self.doThisArray = newDoThisArray
            self.tableView.reloadData()
        }) { (error : Error) in
            print(error.localizedDescription)
        }
   
    }
    @IBAction func addItem(_ sender: Any) {
        //Creating an alert view to hold the new tasks value
        let doAlert = UIAlertController(title: "New To Do", message: "Please Add a New Item To Do List", preferredStyle: .alert
        )
        doAlert.addTextField { (textField : UITextField) in
            textField.placeholder = "Do your homework tonight !"
        }
        doAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action : UIAlertAction) in
            //Getting the info from text field and implementing into the newContent
            if let newContent = doAlert.textFields?.first?.text {
                //Creating a new DoThis Object using the info from newContent
                let newDoThis = DoThis(content: newContent, addedByUser: (self.currentUser?.email)! )
                //A new database referance for a child of the root to view the new task.
                let newDoThisRef = self.dbRef.child(newContent.lowercased())
                //Setting the value of this child info from newDoThis Object
                newDoThisRef.setValue(newDoThis.toAnyObject())
                
            }
            
        }))
        //Present the  alert view
        self.present(doAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference().child("Do Items")
        startObservingDB()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
          }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doThisArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! TableViewCell
        let doThisObject = doThisArray[indexPath.row]
        cell.titleLabel.text = String(doThisObject.content)
        cell.subTitleLabel.text = String(doThisObject.addedByUser)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let doThisObjectToDelete = doThisArray[indexPath.row]
        doThisObjectToDelete.itemRef?.removeValue()

    }
}

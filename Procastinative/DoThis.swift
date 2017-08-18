
import Foundation
import FirebaseDatabase

struct DoThis {
    var key : String!
    var content : String!
    var addedByUser : String!
    var itemRef : FIRDatabaseReference?
    
    
    init(content : String , addedByUser :String , key : String = "" ) {
        
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
        
    }
    //Snapshot : Gives us the data in a particular moment .
    init(snapshot : FIRDataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        if let contentItem = snapshot.childSnapshot(forPath: "content").value as? String{
            content = contentItem
        }else {
            content = ""
        }
        if let user = snapshot.childSnapshot(forPath: "addedByUser").value as? String{
            addedByUser = user
        }else {
            addedByUser = ""
        }
    

        
    }
    
    func toAnyObject () -> Any{
        return ["content" : content , "addedByUser" : addedByUser]
        
    }
    
}

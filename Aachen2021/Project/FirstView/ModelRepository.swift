//
//  ModelRepository.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 12.05.21.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import Combine
import FirebaseStorage


class ModelRepository : ObservableObject {
    
    @Published var fierModel : [BraviFier] = []
    @Published var authModel : [AuthModel] = []
    @Published var allModels : [AuthAll]   = []
    @Published var downloadURL : String = ""
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid)")
    let userID = Auth.auth().currentUser?.uid

    
   
    init() {
//     chackOnLine()
        loadAllPeerOnLine()
//        loadAllModels()
//        loadFromFier()
    }
    
    deinit {
//        chackOffLine()
    }
    
 
    func chackOnLine(){
        
        print("on On .. ")
       

            do{
                let _ = try! db.collection("Allauth").document(Auth.auth().currentUser!.uid).updateData(["isInLine": true, "dataPack": Data()]) { err in
                    if err != nil {
                        print((err?.localizedDescription)!)
                        return
                    }
                }
            }catch{}
      


    }
    
    
    func chackOffLine() {
        
        
        print("of off.. ")
        do{
            let _ = try! db.collection("Allauth").document(Auth.auth().currentUser!.uid).updateData(["isInLine": false]) { err in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
            }
        }catch{}

    }
    
    func loadAllPeerOnLine() {

        db.collection("Allauth").whereField("isInLine", isEqualTo: true).addSnapshotListener{ [self] (snapShot, err) in
    
            guard let document = snapShot?.documents else { return }
            print("document.count = \(document.count)")
            self.allModels = document.compactMap{ doc -> AuthAll in
               
                do{
                    let arda = try! doc.data(as: AuthAll.self)
                    return arda!
                    
                }catch{
                    print("error..>>")
                }
            }
        }
    }
    
    
    func loadAllModels() {
        
//        let userID = Auth.auth().currentUser?.uid
        db.collection("Allauth").addSnapshotListener{ [self] (snapShot, err) in
            guard let document = snapShot?.documents else { return }
            
            self.allModels = document.compactMap{ doc -> AuthAll in
                do{
                    let arda = try! doc.data(as: AuthAll.self)
                    return arda!
                    
                }catch{
                    print("error..>>")
                }
            }
        }
    }
    
    func loadFromFier() {
        
        
        let userID = Auth.auth().currentUser?.uid
        db.collection(userID!).addSnapshotListener{ [self] (snapShot, err) in
            guard let document = snapShot?.documents else { return }
        
            self.fierModel = document.compactMap{ docf -> BraviFier in
                do{
                    let ardaf = try! docf.data(as: BraviFier.self)
                    return ardaf!

                }catch{
                    print("error..>>")
                }
            }
        }
    }
    
    func saveToAllModels(_ col: String, _ model: AuthModel) {
        do{
            let _ = try! db.collection(col).addDocument(from: model)
        }catch{
             print("error>>>")
        }
    }
    
//    func saveToStore(_ data: Data) {
//        
//        do{
//            
//            let _ = try! storageRef.putData(data, metadata: nil) { (metadata , error ) in
//                
//                guard let metadata = metadata else {
//                    print("error metadada ...")
//                    return
//                }
//                let size = metadata.size
//                
//                print("size = \(size)")
//                DispatchQueue.main.async { [self] in
//                    storageRef.downloadURL{( url , err ) in
//                        guard let downloadURL = url else {
//                            print("error .. >> url")
//                            return
//                        }
//                        print("url >> \(downloadURL.relativeString)")
//                        self.downloadURL = "\(downloadURL)"
//                        
//                        for mod in allModels {
//                            print("dossi = \(mod.authNumber)")
//                            let model = AuthModel(authNumber: "\(mod.authNumber)", authPhone: "\(mod.authPhone)", title: "\(downloadURL)", fromPEER: "\(UIDevice.current.name)", toPEER: "self.fromPeer", index_H: "2")
//                                saveToAllModels("\(mod.authNumber)", model)
//                        }
//                    }
//                }
//            }
//        }catch{
//            print("error putData ...")
//        } 
//    }
    
}

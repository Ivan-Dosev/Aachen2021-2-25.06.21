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
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CryptoData_Array.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CryptoData_Array.data_event, ascending: true)]) var cryptoDataArray: FetchedResults<CryptoData_Array>
   
    init() {

        loadAllPeerOnLine()

    }
    
    deinit {
        chackOffLine()
    }
    
 
    func chackOnLine(){
        
        print("on On .. ")
       

            do{
                let _ = try! db.collection("Allauth").document(Auth.auth().currentUser!.uid).updateData(["isInLine": true,
                                                                                                         "title": "",
                                                                                                         "fromPEER": "",
                                                                                                         "toPEER": "",
                                                                                                         "isDownloud": false]) { err in
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
    
//    func saveToCoreData(){
//
//        db.collection("Allauth").document(Auth.auth().currentUser!.uid).addSnapshotListener{ [self] (document, err ) in
//
//            print("<.>   ,<.>  \(document)")
//            document.map{ doc in
//                doc.data().map{ pro in
//                   let a = pro["isDownloud"] as! Bool
//                    if a  {
//
//                        let title = pro["title"] as! String
//                        let dataFromUrl : Data = title.loadData()
//                        let textData = CryptoData_Array(context: moc)
//                        textData.peer_To_peer  = pro["fromPEER"] as! String
//                        textData.name_Title    = pro["toPEER"] as! String
//                        textData.crypt_Date    = dataFromUrl
//                        textData.data_event    = pro["data_event"] as! String
//                        textData.date_term     = pro["date_term"] as! String
//                        textData.minuteMM      =  pro["minuteMM"] as! String
//                        textData.index_F       = String(2)
//
//                    do {
//                        try self.moc.save()
//
//                        }catch {}
//                        print("ok .......... ok")
//                    }
//                }
//            }
//        }
//    }
    
    
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
    
    func saveToPeerInFierbase(user: String, title: String, fromPEER: String, toPEER: String, idDownloud: Bool, data_event: String, date_term : String, minuteMM: String) {
        
        do{
            let _ = try! db.collection("Allauth").document(user).updateData([ "title": title,
                                                                              "fromPEER": fromPEER,
                                                                              "toPEER": toPEER,
                                                                              "isDownloud": true,
                                                                              "data_event": data_event,
                                                                              "date_term": date_term,
                                                                              "minuteMM": minuteMM ]) { err in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
            }
        }catch{}
        
    }
    
    func loadData(url: String) -> Data {
        
        let klu4 = UIImage(named: "klu4")!.jpegData(compressionQuality: 1.0)
        
        do{
            guard  let url = URL(string: url) else {
                print(" guard  let url = URL(string: self)")
                return  klu4! }
            let data : Data = try Data(contentsOf: url)
            return data
            
        }catch{
            print("error image")
            return klu4!
        }
       
    }
    
}

//
//  Adress.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct Adress: View {
    
    let db = Firestore.firestore()
  
    @State var isShow : Bool   = false
    @State var text   : String = ""
    @State var ccode  : String = ""
    @State var no     : String = ""
    @State var code   : String = ""
    @State var ID     : String = ""
    @State var alert  : Bool   = false
    @State var msg    : String = ""
  
    
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .center, spacing: -(spacing_block + lineWidth_block)) {

                VStack(spacing: 0){
                 
                    HStack{
                        Text("Software from LDD - Ltd")
                        Spacer()
                        Button(action: {
                             auth100()
                        }) {
                            Text("auth")
                                .padding()
                        }
                    }

                    
                    }
                    .font(.system(size: 20))
                    .padding()
                    .frame(width: width_block, height:  height_block, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color(colorBackground2))
                    .mask( BlockTop())
                    .overlay( BlockTop().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                
                VStack(spacing: 0){
                    

                 
                    Text("За да използвате приложението\n трябва да се регистрирате\n с вашия телефонен номер")
                        .padding()
                    Text("Ако регистрацията е успешна \nще получите код за достъп")
                        .padding()
                    HStack(alignment: .center) {
                        TextField("+cod", text: $ccode)
                            .frame(width: 50)
 
                        TextField("phone namber", text: $no)
                            .frame(width: 150)

                        Button(action: {
                                                  authentication()
                        }) {
                            Text(" send ")
                                .padding()
                                .font(.custom("", size: 12 * button_index ))
                                .frame(width: 70 * button_index, height: 30 * button_index, alignment: .center)
                                .modifier(PrimaryButton(indexRadius: indexRadius))
                        }
                    }
                    
                    }
                    .font(.system(size: 14))
                    .padding()
                    .frame(width: width_block, height:  height_block + 200, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color(colorBackground2))
                    .mask( BlockMidle())
                    .overlay( BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                
                if isShow {
                    VStack(spacing: 0){


                        HStack(alignment: .center) {
                            
                            Button(action: {

                                              self.isShow = false
                            }) {
                                Text("cancel")
                                    .padding()
                                    .font(.custom("", size: 12 * button_index ))
                                    .frame(width: 70 * button_index, height: 30 * button_index, alignment: .center)
                                    .modifier(PrimaryButton(indexRadius: indexRadius))
                            }
     
                            TextField("CODE", text: $code)
                                .frame(width: 130)

                            Button(action: {
                                               veryfication()
                            }) {
                                Text("verify")
                                    .padding()
                                    .font(.custom("", size: 12 * button_index ))
                                    .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                    .modifier(PrimaryButton(indexRadius: indexRadius))
                            }
                        }
                        
                        }
                        .font(.system(size: 14))
                        .padding()
                        .frame(width: width_block, height:  height_block , alignment: .center)
                        .foregroundColor(.white)
                        .background(Color(colorBackground2))
                        .mask( BlockMidle())
                        .overlay( BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                }

            }
            
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("ok"), action: { self.alert.toggle()}))
        }
    }
    func authentication(){
        PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.ccode+self.no, uiDelegate: nil) { (ID, err) in
            
            if err != nil {
                self.msg = (err?.localizedDescription)!
                self.alert.toggle()
                return
            }
            self.ID = ID!
            self.isShow = true
        }
    }
    
    func veryfication(){
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
        
        Auth.auth().signIn(with: credential) { (res, err) in
            if err != nil {
                self.msg = (err?.localizedDescription)!
                self.alert.toggle()
                return
            }
            guard let user =  res?.user else { return}
            let allData = AuthAll(authNumber: user.uid, authPhone: user.phoneNumber!, isInLine: true, dataPack: Data())
            
            do{
                let _ = try db.collection("Allauth").addDocument(from: allData)
                
            }catch{
                fatalError("unable to encoding task")
            }
            UserDefaults.standard.setValue(true, forKey: "status")
            NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
        }
    }
    
    func auth100(){
        
        Auth.auth().signInAnonymously() { [self]( autoResult ,err ) in
            if err != nil {
                print("errot signInAnonymously")
                return
            }
            guard let user =  autoResult?.user else { return}

//            let allData = AuthAll(authNumber: user.uid, authPhone: "\(UIDevice.current.name)", isInLine: true)
          
                
                do{
                    let _ = try db.collection("Allauth").document(user.uid).setData([
                        "id": UUID().uuidString,
                        "authNumber" : user.uid,
                        "authPhone" : "\(UIDevice.current.name)",
                        "isInLine": false,
                        "dataPack": Data()
                    ])
                   
                    UserDefaults.standard.setValue(true, forKey: "status")
                    NotificationCenter.default.post(name: Notification.Name("statusChange"), object: nil)
                  
                    print("user.uid = \(user.uid)")
                    print("Auth.auth().currentUser!.uid = \(Auth.auth().currentUser!.uid)")
                    
                }catch{
                    fatalError("unable to encoding task")
                }
      

            

        }
    }
    
}
struct Adress_Previews: PreviewProvider {
    static var previews: some View {
        Adress()
    }
}

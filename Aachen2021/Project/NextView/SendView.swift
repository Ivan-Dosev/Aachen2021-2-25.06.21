//
//  SendView.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//

import SwiftUI
import CryptoKit
import MultipeerConnectivity
import FirebaseStorage
import FirebaseAuth

struct SendView: View {
    @ObservedObject var models       = ModelRepository()
    @StateObject var colorService = ColorService()
    @State   var peerString     : String = ""
    @Binding var image          : UIImage?
    @Binding var isWitness      : Bool
    @Binding var isShowingImage : Bool
    @Binding var witness        : Witness
    @Binding var buttonColor    : Int
    let storageRef = Storage.storage().reference().child(Auth.auth().currentUser!.uid + "/" + "\(Date())")
    
    @State          var index = -1
    
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CryptoData_Array.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CryptoData_Array.data_event, ascending: true)]) var cryptoDataArray: FetchedResults<CryptoData_Array>
    
    @Environment(\.presentationMode) var pMode
    
    var privateID_Key : Curve25519.Signing.PrivateKey {
     
         if let data = UserDefaults.standard.data(forKey: "PrivateKey") {
             
               return try! Curve25519.Signing.PrivateKey(rawRepresentation: data)
             
         }else{
               let kay = Curve25519.Signing.PrivateKey()
                         UserDefaults.standard.set( kay.rawRepresentation, forKey: "PrivateKey")
            return kay
         }
     }
     var privateAgreement_Key : Curve25519.KeyAgreement.PrivateKey {
         if let data = UserDefaults.standard.data(forKey: "AgreementKey") {
             
             return try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: data)
             
         }else{
             let kay = Curve25519.KeyAgreement.PrivateKey()
                         UserDefaults.standard.set( kay.rawRepresentation, forKey: "AgreementKey")
            return kay
         }
     }
    @State var fromPeer        : String = ""
    @State var peertopeer      : String = ""
    @State var signingID       : String = ""
    @State var agreementID     : String = ""
    @State var agreement__ID   =  Data()
    @State var signing__ID     =  Data()
    
    @State var dateNow     : Date = Date()
    @State var dateFutuer  : Date = Date()
    @State var selectedDateText : String = ""
    @State var text        : String = ""
    @State var isOnOffSend : Bool = false
    @State var isOk        : Bool = false
    @State var isAnswerOk  : Bool = false
    @State var isOkSend    : Bool = false
    @State var isSendStart : Bool = true

    
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .center, spacing: -(spacing_block + lineWidth_block)) {

                VStack(spacing: 0){
                 
                    HStack {
                        
// MARK: - Button exit
                        
                        Button(action: {
                            colorService.stopService()
                            pMode.wrappedValue.dismiss()
                        }) {
                            Text("⏎")
                                .padding()
                                .font(.custom("", size: 12 * button_index ))
                                .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                .modifier(PrimaryButton(indexRadius: indexRadius))
                        }
                        
                        Spacer()
 
                    }

                    
                    }
                    .font(.system(size: 20))
                    .padding()
                    .frame(width: width_block, height:  height_block, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color(colorBackground2))
                    .mask( BlockTop())
                    .overlay( BlockTop().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                
                
// MARK: - Date validation
                
                VStack(spacing: 0){
                    HStack{
                        Text("Current date")
                            .font(.custom("", size: 14 * button_index))
                            .padding(.horizontal, 20)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(selectedDateText)")
                            .padding(.horizontal, 20)
                            .font(.custom("", size: 14 * button_index))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Validity period")
                            .padding(.horizontal, 20)
                            .font(.custom("", size: 14 * button_index))
                            .foregroundColor(.white)
                        DatePicker(selection: $dateNow, in: Date()... , displayedComponents: .date) {}
                            .padding(.horizontal, 20)
                            .accentColor(.white)
                    }
                    

                }
                .font(.system(size: 20))
                .padding()
                .frame(width: width_block, height:  height_block, alignment: .center)
                .foregroundColor(.white)
                .background(Color(colorBackground2))
                .mask( BlockMidle())
                .overlay( BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                
                

                
                
                ScrollView(.vertical) {
                    VStack(alignment: .center, spacing: -(spacing_block + lineWidth_block)) {
                        
                        ForEach(Array(zip(colorService.peers, colorService.peers.indices)) , id:\.0) { (peer , index )in
                            
                            VStack(spacing: 0){
                                
                                ScrollView{
                                    
                                    Text(peer.displayName)
                                        .foregroundColor(.white)
                                    if  self.isOkSend && self.peerString == peer.displayName {
                                        HStack{
                                            Text("☑️")
                                            Spacer()
                                        }
                                    }
                                    if isOk && self.peerString == peer.displayName{
                                        HStack{
                                            Text("☑️")
                                                .onAppear(){
                                                          DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                                          pMode.wrappedValue.dismiss()
                                                              }
                                                           }
                                            Spacer()
                                        }
                                    }
                                    
                                    Spacer()
                                        .frame( height: 30)
                                    
// MARK: - Button send
                                    
                                    ZStack{
                                        if isWitness{
                                            Button(action: {
                                                witnessSend()
                                                isWitness = false
                                                
                                            }) {
                                                Text("send")
                                                    .padding()
                                                    .font(.custom("", size: 12 * button_index ))
                                                    .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                                    .modifier(PrimaryButton(indexRadius: indexRadius))
                                            }
                                        }else{
                                            if isShowingImage && isSendStart {
                                                
                                                Button(action: {
                                                    
                                                    self.signingID = ""
                                                    self.agreementID = ""
                                                    
                                                    colorService.sendToFistPeer(data: senderSigningPublic(), peerID: peer)
                                                    
                                                    self.isOnOffSend.toggle()
                                                    self.isSendStart = false
                                                    
                                                    
                                                }) {
                                                    Text("Send")
                                                        .padding()
                                                        .font(.custom("", size: 12 * button_index ))
                                                        .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                                        .modifier(PrimaryButton(indexRadius: indexRadius))
                                                }
                                            }
                                            

                                        }
                                        

                                        
                                    }
                                    
                                    
                                }
                                
                            }
                            .font(.system(size: 20))
                            .padding()
                            .frame(width: width_block, height:  self.index == index ? height_block + 50 : height_block, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color(colorBackground2))
                            .mask( BlockMidle())
                            .overlay( BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                            .onTapGesture {
                                if self.index == index {
                                    self.index = -1
                                }else{
                                    self.index = index
                                }
                            }
                            .onAppear(){
                                self.colorService.delegate = self
                                colorService.invitePeer(peer)
                            }
                            .onDisappear(){
                                self.isOkSend = false
                            }
                        }
                        
                        VStack(spacing: 0){
                                            Text("end block")
                        }
                        .font(.system(size: 20))
                        .padding()
                        .frame(width: width_block, height:  height_block, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color(colorBackground2))
                        .mask( BlockBottom())
                        .overlay( BlockBottom().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                    }

                }

                
            }
            .padding(.top, 20)
            .onAppear(){setDateString()}
            .onDisappear(){colorService.stopService()}
        }
    }
    
    
    func senderSigningPublic() -> Data {
        let model = Model(peerID: privateID_Key.publicKey.rawRepresentation, massige: Data(),isSender: true ,dateNow: dateNow, dateFutuer: dateFutuer, peerTopeer: "", witness: Data())
        let modelData = try! JSONEncoder().encode(model)
       return modelData
    }
    
    func keyAgreenentPublic() -> Data {
        let model = Model(peerID: privateAgreement_Key.publicKey.rawRepresentation, massige: Data(),isSender: false,dateNow: dateNow, dateFutuer: dateFutuer, peerTopeer: "\(UIDevice.current.name)", witness: Data())
        let modelData = try! JSONEncoder().encode(model)
       return modelData
    }
    
    func senderData() -> Data {
        
        let data = image?.jpegData(compressionQuality: 0.5)
        let receiverEncryptionPublicKey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: agreement__ID)
        let sealedMessage = try! encrypt(data!, to: receiverEncryptionPublicKey, signedBy: privateID_Key)

  let model = Model(peerID: Data(), massige: sealedMessage, isSender: true,dateNow: dateNow, dateFutuer: dateFutuer, peerTopeer: self.peertopeer, witness: Data())
        
    let modelData = try! JSONEncoder().encode(model)
        return modelData
    }
    
    func saveToCoreData(peer : MCPeerID, onSelect: () -> Void) {
        let data = image?.jpegData(compressionQuality: 1.0)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let minute = DateFormatter()
            minute.dateFormat = "HH:mm:ss"
//                    self.selectedDateText = formatter.string(from: self.dateNow)
        
        let textData = CryptoData_Array(context: moc)
            textData.peer_To_peer  = ""
            textData.name_Title    = peer.displayName
            textData.key_agreement = self.agreement__ID
            textData.key_public    = self.signing__ID
            textData.crypt_Date    = data
            textData.data_event    = formatter.string(from: self.dateNow)
            textData.date_term     = formatter.string(from: self.dateFutuer)
            textData.minuteMM      = minute.string(from: self.dateNow)
            textData.index_F       = String(3)

          
        do {
                 try self.moc.save()
            
                          onSelect()
        }catch {}
    }
     
    func witnessSend() {
        
        for peer in colorService.peers {
            if peer.displayName == witness.peerTopeer {
                colorService.sendToFistPeer(data: witnessSet(), peerID: peer)
            }
        }
    }
    
    func witnessSet()-> Data {
        
         let witnessData =  try! JSONEncoder().encode(witness)
         let model = Model(peerID: Data(), massige: Data(), isSender: false ,dateNow: dateNow, dateFutuer: dateFutuer, peerTopeer: self.peertopeer, witness: witnessData )
         let modelData = try! JSONEncoder().encode(model)
         return modelData
    }
    
    
    func   saveToFireBase(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let minute = DateFormatter()
            minute.dateFormat = "HH:mm:ss"
        
        let data = image?.jpegData(compressionQuality: 0.5)
        let receiverEncryptionPublicKey = try! Curve25519.KeyAgreement.PublicKey(rawRepresentation: agreement__ID)
        let sealedMessage = try! encrypt(data!, to: receiverEncryptionPublicKey, signedBy: privateID_Key)
        
        do{
            
            let _ = try! storageRef.putData( sealedMessage, metadata: nil) { (metadata , error ) in
                
                guard let metadata = metadata else {
                    print("error metadada ...")
                    return
                }
                let size = metadata.size
                
                print("size = \(size)")
                DispatchQueue.main.async { [self] in
                    storageRef.downloadURL{( url , err ) in
                        guard let downloadURL = url else {
                            print("error .. >> url")
                            return
                        }
                        print("url >> \(downloadURL.relativeString)")
                        
                        for mod in models.allModels {
                            print("dossi = \(mod.authNumber)")

                            models.saveToPeerInFierbase(user: mod.authNumber, title: "\(downloadURL)", fromPEER: "\(UIDevice.current.name)", toPEER: self.fromPeer, idDownloud: true, data_event: formatter.string(from: self.dateNow),date_term: formatter.string(from: self.dateFutuer), minuteMM:  minute.string(from: self.dateNow))
                        }
                    }
                }
            }
        }catch{
            print("error putData ...")
        }
    }
    
    
    private func setDateString() {
      let formatter = DateFormatter()
      formatter.dateFormat = "HH:mm MMM dd, yyyy"
      self.selectedDateText = formatter.string(from: self.dateNow)
    }
}

struct SendView_Previews: PreviewProvider {
    static var previews: some View {
//        SendView()
        Text("aa")
    }
}

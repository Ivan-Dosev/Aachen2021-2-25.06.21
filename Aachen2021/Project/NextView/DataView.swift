//
//  DataView.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//

import SwiftUI
import CryptoKit

struct DataView: View {
    
    @Environment(\.presentationMode) var pMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CryptoData_Array.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CryptoData_Array.data_event, ascending: true)]) var cryptoDataArray: FetchedResults<CryptoData_Array>
 
   
    @State var isTapGesture : Bool = false
    @State var agreem       : String = ""
    @State var publik       : String = ""
    
    @State var textSearch   : String = ""
    @State var pickerNumber : Int = 0
    @State var peckerTexts   : [String] = [" All ","Received","Observer","Sended","Witness","Denied"]
    
    @Binding var image          : UIImage?
    @Binding var isWitness      : Bool
    @Binding var isShowingImage : Bool
    @Binding var witness        : Witness
    @Binding var buttonColor    : Int
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .center, spacing: -(spacing_block + lineWidth_block)) {
                
// MARK: - Button exit Data
                
                VStack(spacing: 0){
                    ZStack{
                        HStack {
                            
                            // MARK: - Button exit
                            
                            Button(action: {
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
                        Text("Block Chane")
                            .foregroundColor(.white)
                            .font(.custom("", size: 14 * button_index))
                    }

                    
                    
                }
                .font(.system(size: 20))
                .padding()
                .frame(width: width_block, height:  height_block, alignment: .center)
                .foregroundColor(.white)
                .background(Color(colorBackground2))
                .mask( BlockTop())
                .overlay( BlockTop().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                
// MARK: - searching
                                
                                VStack(spacing: 0){
                                    HStack(spacing: 0){
                                        Text("✏︎")
                                        TextField("Search...", text: $textSearch)
                                            .padding(.horizontal, 40)
                                            .foregroundColor(.white)
                                        Spacer()
                                        if self.textSearch != "" {
                                            Button(action: {
                                                self.textSearch = ""
                                            }) {
                                                Text("⌫")
                                                    .padding(.horizontal, 40)
                                                    .foregroundColor(.white)
                                            }
                                        }

                                    }
                                }
                                .font(.system(size: 20))
                                .padding()
                                .frame(width: width_block, height:  height_block, alignment: .center)
                                .foregroundColor(.white)
                                .background(Color(colorBackground2))
                                .mask( BlockMidle())
                                .overlay( BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
  
// MARK: - picker
                                
                                VStack(spacing: 0){
                                    HStack(alignment: .center,  spacing: 0 ){
                                        
                                        HStack{
                                            Text("\(peckerTexts[pickerNumber])")
                                                .font(.custom("", size: 20 * button_index ))
                                                .padding(.horizontal, 20)
                                        }
                                        .clipped()
                                        .id(pickerNumber)
                                        .transition(rollTransition)

                                        Spacer()
                                        
                                        Button(action: {
                                            withAnimation{
                                                pickerNumber = (pickerNumber + 1 ) % peckerTexts.count
                                            }
                                           
                                        }) {
                                            Text("select")
                                                .padding()
                                                .font(.custom("", size: 12 * button_index ))
                                                .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                                .modifier(PrimaryButton(indexRadius: indexRadius))
                                        }
                                        .contextMenu{ contextMenu }
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
                        if pickerNumber == 0 {
                            
                            ForEach(Array(zip(cryptoDataArray.indices ,cryptoDataArray.filter{self.textSearch.isEmpty ? true :  $0.name_Title!.lowercased().contains(self.textSearch.lowercased())} )), id:\.0) { ( number , index ) in
                                BlockView(number: number, crypto: index, buttonColor: buttonColor)
                                        .onTapGesture {
                                            deleteItem(indexSet: number)
                                        }
                                }
                            
                        }else{
                            
                            ForEach(Array(zip(cryptoDataArray.indices ,cryptoDataArray.filter{$0.index_F?.contains(String(self.pickerNumber)) as! Bool }.filter{self.textSearch.isEmpty ? true : $0.name_Title!.lowercased().contains(self.textSearch.lowercased())})),id:\.0) { ( number , index ) in
                                BlockView(number: number, crypto: index, buttonColor: buttonColor)
                                    .onTapGesture {
                                        if index.index_F == "1" {
                                            let receiverEncryptionKey  = try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: index.key_agreement!)
                                            let senderSigningPublicKey =   try! Curve25519.Signing.PublicKey(rawRepresentation: index.key_public!)
                                            let decryptedMessage = try? decrypt( index.crypt_Date!, using: receiverEncryptionKey, from: senderSigningPublicKey)
                                            image = UIImage(data: decryptedMessage!)
                                            pMode.wrappedValue.dismiss()
                                        }
                                        
                                        if index.index_F == "3" {
                                                image = UIImage(data: index.crypt_Date!) 
                                                pMode.wrappedValue.dismiss()
                                        }
                                        
                                        if index.index_F == "2"{
                                                image = UIImage(named: "klu4")   // lock file
                                                self.isWitness      = true
                                                self.isShowingImage = false
                                                witness =   Witness(minuteMinute: index.minuteMM!, dateEvent: index.data_event!, dateTerm: index.date_term!, peerTopeer: index.peer_To_peer!, cryptWitness: index.crypt_Date!)
                                                pMode.wrappedValue.dismiss()
                                        }
                                        
                                        if index.index_F == "4"{
                                            
                                            witnessDecrypt(index: index)
                                            pMode.wrappedValue.dismiss()
                                        }

                                }
                              

                                }
                            
                        }
                        VStack(spacing: 0){
                                            Text("end block")
                        }
                        .font(.system(size: 14))
                        .padding()
                        .frame(width: width_block, height:  height_block, alignment: .center)
                        .foregroundColor(.white)
                        .background(Color(colorBackground2))
                        .mask( BlockBottom())
                        .overlay( BlockBottom().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                    }
                }
                

                
            }.padding(.top, 20)
        }
    }
    
    var rollTransition : AnyTransition {
        AnyTransition.asymmetric(insertion: .offset(x: 0, y: 20 * button_index), removal: .offset(x: 0, y: -(20 * button_index)))
    }
    
    @ViewBuilder
    var contextMenu : some View {
        ForEach(Array(zip(peckerTexts, peckerTexts.indices)), id:\.0) {  pick , number in
            PickerButtonView(number: number, text: pick, pickerNumber: $pickerNumber, index: button_index, rediusR: indexRadius)
        }
    }
    
    func deleteItem(indexSet: Int) {
        let deleteItem = self.cryptoDataArray[indexSet]
                         self.moc.delete(deleteItem)
        
        do{ try! self.moc.save() }
    }
    
    func witnessDecrypt(index: CryptoData_Array) {
        
        for crypt in cryptoDataArray {
            if crypt.minuteMM  == index.minuteMM &&  crypt.data_event  == index.data_event && crypt.date_term  == index.date_term  && crypt.index_F == "1" {
                let receiverEncryptionKey  = try! Curve25519.KeyAgreement.PrivateKey(rawRepresentation: crypt.key_agreement!)
                let senderSigningPublicKey =   try! Curve25519.Signing.PublicKey(rawRepresentation: crypt.key_public!)
                let decryptedMessage = try? decrypt( index.crypt_Date!, using: receiverEncryptionKey, from: senderSigningPublicKey)
                image = UIImage(data: decryptedMessage!)
            }
        }
        
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
//        DataView()
        Text("bb")
    }
}

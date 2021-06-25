//
//  FirebaseView.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 14.05.21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct FirebaseView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CryptoData_Array.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CryptoData_Array.data_event, ascending: true)]) var cryptoDataArray: FetchedResults<CryptoData_Array>
    @Environment(\.presentationMode) var pMode
    @StateObject                  var models       = ModelRepository()
    @State var textSearch   : String = ""
    @Binding var image          : UIImage?
    let userID = Auth.auth().currentUser?.uid
    @State          var index = -1
    let db = Firestore.firestore()
    
    @State var allPeerOn : Bool = false
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .center, spacing: -(spacing_block + lineWidth_block)) {
                VStack(spacing: 0){
                    ZStack{
                        HStack {
                            
                            // MARK: - Button exit
                            
                            Button(action: {
                                models.chackOffLine()
                                pMode.wrappedValue.dismiss()
                            }) {
                                Text("⏎")
                                    .padding()
                                    .font(.custom("", size: 12 * button_index ))
                                    .frame(width: 70 * button_index , height: 30 * button_index , alignment: .center)
                                    .modifier(PrimaryButton(indexRadius: indexRadius))
                            }
                            
                            Spacer()
                            Toggle(isOn: $allPeerOn) {
                                HStack {
                                    Spacer()
                                    Text("See all peers ")
                                        .font(.custom("", size: 12 * button_index ))
                                }
                            }
                            
                        }
//                        Text("Block Chane")
//                            .foregroundColor(.white)
//                            .font(.custom("", size: 14 * button_index))
                    }

                    
                    
                }
                .font(.system(size: 20))
                .padding()
                .frame(width: width_block, height:  height_block, alignment: .center)
                .foregroundColor(.white)
                .background(Color(colorBackground2))
                .mask( BlockTop())
                .overlay( BlockTop().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                
// MARK: - searching fierbase
                                                
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
                
                ScrollView(.vertical) {
                    VStack(alignment: .center, spacing: -(spacing_block + lineWidth_block)) {
                        
                        
                        ForEach(Array(zip(models.allModels, models.allModels.indices)) , id:\.0) { (modelfier , index) in
                            
                            if self.allPeerOn {
                                if modelfier.authNumber != userID {
                                    
                                    VStack {
                                        ScrollView(.vertical) {
                                            HStack {
                                                Text("\(modelfier.authPhone)")
                                                    .padding()
                                                
                                                
                                            }
                                            // MARK: - sendind Data to peer
                                        }
                                    }
                                    .font(.system(size: 14))
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
                                }
                            }else{
                                if modelfier.authNumber == userID {
                                    
                                    
                                    VStack {
                                        ScrollView(.vertical) {
                                            ZStack {
                                                if  modelfier.isDownloud {
                                                    HStack {
                                                        Text("☑️")
                                                        Spacer()
                                                    }
                                                    .onAppear(perform: {
                                                        print("onAppear....................")
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                            let dataFromUrl : Data = modelfier.title.loadData()
//toPEER
                                                            let textData = CryptoData_Array(context: moc)
                                                            textData.peer_To_peer  = modelfier.toPEER
                                                            textData.name_Title    = modelfier.fromPEER
                                                            textData.crypt_Date    = dataFromUrl
                                                            textData.data_event    = modelfier.data_event
                                                            textData.date_term     = modelfier.date_term
                                                            textData.minuteMM      = modelfier.minuteMM
                                                            textData.index_F       = String(2)

                                                        do {
                                                            try self.moc.save()
                                                            pMode.wrappedValue.dismiss()
                                                            }catch {}
                                                           
                                                           
                                                        }
                                                    })
                                                }
                                                Text("\(modelfier.authPhone)")
                                            }
                                            .padding()
                                        }
                                    }
                                    .font(.system(size: 14))
                                    .padding()
                                    .frame(width: width_block, height:  self.index == index ? height_block + 50 : height_block, alignment: .center)
                                    .foregroundColor(.gray)
                                    .background(Color( mayColor ))
                                    .mask( BlockMidle())
                                    .overlay( BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                                    .onTapGesture {
                                        if self.index == index {
                                            self.index = -1
                                        }else{
                                            self.index = index
                                        }
                                    }
                                }
                            }
                        }
                        
// MARK: - end block fierbase
                        
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
                
            }

        }
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: "2001-01-01") // replace Date String
    }
    
}

struct FirebaseView_Previews: PreviewProvider {
    static var previews: some View {
//        FirebaseView()
       Text("b")
    }
}

extension String {
    
    func load() -> UIImage {
        do{
            
            guard  let url = URL(string: self) else {
                print("klu4 >>>>>>>>>>>>>>>>>>>>>>>>")
                return  UIImage(named: "klu4")! }
            let data : Data = try Data(contentsOf: url)
            return UIImage(data: data) ??  UIImage(named: "klu3")!
            
        }catch{
            print("error image")
        }
        return UIImage()
    }
    
    func loadData() -> Data {
        
        let klu4 = UIImage(named: "klu4")!.jpegData(compressionQuality: 1.0)
        
        do{
            
            guard  let url = URL(string: self) else {
                print(" guard  let url = URL(string: self)")
                return  klu4! }
            let data : Data = try Data(contentsOf: url)
            print(".......................................")
            print(data)
            print(">>...................................>>")
            return data
            
        }catch{
            print("error image")
            return klu4!
        }
       
    }
    
}

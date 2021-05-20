//
//  StartView.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//

import SwiftUI

struct StartView: View {
    
    @Environment(\.managedObjectContext) var moc
    @ObservedObject                  var models       = ModelRepository()
    @State var image          : Image?
    @State var showingImage   : Bool = false
    @State var isShowingImage : Bool = false
    @State var isWitness      : Bool = false
    @State var inportImage    : UIImage?
    @State var witness        : Witness = Witness(minuteMinute: "", dateEvent: "", dateTerm: "", peerTopeer: "", cryptWitness: Data())
    @State var isView         : Bool   = false
    @State var isSend         : Bool   = false
    @State var isFirebase     : Bool   = false
    @State var isImage        : Bool   = false
    @State var isFireView     : Bool   = false
    @State var imageView      : String = "Ok"
    @State var buttonColor    : Int = 1
    
    var body: some View {
        
        ZStack {
            
            VStack(alignment: .center, spacing: -(spacing_block + lineWidth_block)) {
                
// MARK: - BlockTop
                
                VStack(spacing: 0){ Text("On Tap to Select a Picture") }
                    .font(.system(size: 20))
                    .padding()
                    .frame(width: width_block, height:  height_block, alignment: .center)
                    .foregroundColor(.white)
                    .background(Color(colorBackground2))
                    .mask( BlockTop())
                    .overlay( BlockTop().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
// MARK: - Image
                
                ZStack{
                    if image != nil {
                        BlockMidle()
                            .overlay( image!.resizable().clipShape( BlockMidle()))
                            .frame(width: width_block, height:  height_block + 300, alignment: .center)
                    }else{
                        Image("26620")
                            .resizable()
                            .frame(width: width_block, height:  height_block + 300, alignment: .center)
                    }
                }
                .padding()
                .frame(width: width_block, height:  height_block + 300, alignment: .center)
                .foregroundColor(.white)
                .background(Color(colorBackground2))
                .mask( BlockMidle())
                .overlay( BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                .onTapGesture {
                    self.isWitness      = false
                    self.showingImage   = true
                    self.isShowingImage = true}
                .sheet(isPresented: $showingImage, onDismiss: loadImage) { ImagePicker(image: $inportImage)}
// MARK: - Button send
                
                VStack(spacing: 0){
                    Button(action: {
                                         self.isSend.toggle()
                    }) {
                        Text("Send Data")
                    }
                }
                .font(.system(size: 20))
                .padding()
                .frame(width: width_block, height:  height_block, alignment: .center)
                .foregroundColor(.white)
                .background(Color(colorBackground2))
                .mask( BlockMidle())
                .overlay( BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                .sheet(isPresented: self.$isSend, onDismiss: loadImage) {
                    SendView(image: $inportImage, isWitness: $isWitness, isShowingImage: $isShowingImage, witness: $witness, buttonColor: $buttonColor)
                }
                
                
// MARK: - Button Firebase view
                
                VStack(spacing: 0){
                    Button(action: {
                             models.chackOnLine()
                             self.isFirebase.toggle()
                           
                    }) {
                        Text("Firebase view")
                    }
                }
                .font(.system(size: 20))
                .padding()
                .frame(width: width_block, height:  height_block, alignment: .center)
                .foregroundColor(.white)
                .background(Color(colorBackground2))
                .mask( BlockMidle())
                .overlay( BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                .sheet(isPresented: self.$isFirebase, onDismiss: loadImage){
                    FirebaseView( image: $inportImage)
                }
                
// MARK: - Button view
                
                VStack(spacing: 0){
                    Button(action: {
                                         self.isView.toggle()
                    }) {
                        Text("Database View")
                    }
                }
                .font(.system(size: 20))
                .padding()
                .frame(width: width_block, height:  height_block, alignment: .center)
                .foregroundColor(.white)
                .background(Color(colorBackground2))
                .mask( BlockBottom())
                .overlay( BlockBottom().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
                .sheet(isPresented: self.$isView, onDismiss: loadImage){
                    DataView(image: $inportImage, isWitness: $isWitness, isShowingImage: $isShowingImage, witness: $witness, buttonColor: $buttonColor).environment(\.managedObjectContext , moc)
                }
                
                
            }
        }
        
    }
    
    func loadImage() {
        guard let inportImage = inportImage else {return}
            image = Image(uiImage: inportImage)
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

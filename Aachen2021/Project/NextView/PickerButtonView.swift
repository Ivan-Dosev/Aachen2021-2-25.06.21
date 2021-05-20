//
//  PickerButtonView.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//

import SwiftUI

struct PickerButtonView: View {
    
         var number       : Int
         var text         : String
@Binding var pickerNumber : Int
         var index        : CGFloat
         var rediusR      : CGFloat
    
    var body: some View {
        VStack {
            Button(action: {
                self.pickerNumber = number
                
            }) {
                if self.pickerNumber == number {
                    Text("\(text)")
//                        .padding()
                        .font(.system(size: 12 * index))
                        .frame(width: 65 * index , height: 25 * index , alignment: .center)
                        .background(
                            ZStack {
                                Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)

                                RoundedRectangle(cornerRadius: 5 * rediusR , style: .continuous)
                                    .foregroundColor(.white)
                                    .blur(radius: 4.0)
                                    .offset(x: -8.0, y: -8.0) })

                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 5 * rediusR  , style: .continuous))
                }else{
                    Text("\(text)")
//                        .padding()
                        .foregroundColor(.white)
                        .font(.system(size: 12 * index))
                        .frame(width: 65 * index , height: 25 * index , alignment: .center)
                     
                }

            }
            
           
        }
    }
}

struct PickerButtonView_Previews: PreviewProvider {
    static var previews: some View {
//        PickerButtonView()
        Text("mm")
    }
}

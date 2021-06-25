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
                    Text("\(text)")
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

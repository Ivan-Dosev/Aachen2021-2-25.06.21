//
//  PopoverView.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 20.06.21.
//

import SwiftUI

struct PopoverView: View {
    var body: some View {
        Form{

                poptitle

           
        }.frame(minWidth: 100,minHeight: 100)
    }
    var buttonYes : some View {
        Button("Yes"){
            
        }
    }
    
    var buttonNo : some View {
        Button("No"){
            
        }
    }
    var poptitle  : some View {
        Text("Select Yes / No")
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView()
    }
}

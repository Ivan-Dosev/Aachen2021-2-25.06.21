//
//  BlockFierbaseView.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 15.05.21.
//

import SwiftUI

struct BlockFierbaseView: View {
    
    var model : BraviFier
    
    var body: some View {
        
        
        HStack(spacing: 0){
            
            Image("klu4")
                .resizable()
                .frame(width: 40 , height:  40)
            Spacer()
            VStack{
                Text("from: \(model.fromPEER)")
                Text("to: \(model.toPEER)")
            }

        }
        .font(.system(size: 14))
        .padding()
        .frame(width: width_block, height:  height_block, alignment: .center)
        .foregroundColor(.white)
        .background(Color(groupColor[3]))
        .mask(  BlockMidle())
        .overlay(  BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
    }
}

struct BlockFierbaseView_Previews: PreviewProvider {
    static var previews: some View {
//        BlockFierbaseView()
        Text("m")
    }
}

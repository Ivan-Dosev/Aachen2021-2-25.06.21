//
//  BlockView.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//

import SwiftUI

struct BlockView: View {
    
    var number : Int
    var crypto : CryptoData_Array
    var index  : Int  {
        guard  let i = Int( crypto.index_F!) else {return 0 }
        print("...i..ii...iii...\(i)")
        return     i 
    } // [0,1,2] izprateno , polucheno , svidetel
 
    var buttonColor : Int
    
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack{

                Image("klu\(index)")
                    .resizable()

                    .frame(width: index == 1 || index == 4 ? 40 : 30, height: index == 1 || index == 4  ? 40 : 40)
                VStack {
                    HStack {
                        Text(index == 3 ? "         to:" : "     from:")
                            .font(.custom("", size: 12 * button_index ))
                        Text("\(crypto.name_Title!)")
                            .font(.custom("", size: 12 * button_index ))
//                            .frame(width: 200)

                        Spacer()
                    }
//   ogranichava texta na 200
//                    .frame(width: 400)
                    .foregroundColor(index == 3 ? .white : .black)
                    .offset(x: index == 1 ? 50 : 50)
                    if index != 1 && !crypto.peer_To_peer!.isEmpty {
                        HStack {
                            
                            Text("         to:")
                                .font(.custom("", size: 12 * button_index ))
                            Text("\(crypto.peer_To_peer!)")
                                .font(.custom("", size: 12 * button_index ))

                            Spacer()
                        }
//   ogranichava texta na 200
//                        .frame(width: 400)
                        .foregroundColor(index == 3 ? .white : .black)
                        .offset(x: index == 1 ? 50 : 50)
                     
                    }

                }.offset(x: -20)
                Spacer()
                VStack{
//                    Text("\(crypto.minuteMM!)")
                    Text(crypto.minuteMM != nil ? "\(crypto.minuteMM!)" : "")
                        .offset(x: -12, y: -5)
                        .font(.custom("", size: 12 * button_index ))
//                    Text(" \(crypto.date_term!)    ")
                    Text(crypto.data_event != nil ? "\(crypto.data_event!)" : "")
                        .font(.custom("", size: 12 * button_index ))
                        .offset(x: -12, y: -2)
                    Text(crypto.date_term != nil ? "\(crypto.date_term!)" : "")
                        .offset(x: -12, y: -2)
                        .font(.custom("", size: 12 * button_index ))
//                    Text(" \(crypto.data_event!)    ")

                }
            }
        }
        .font(.system(size: 20))
        .padding()
        .frame(width: width_block, height:  height_block, alignment: .center)
        .foregroundColor(.white)
        .background(Color(groupColor[index]))
//        .background(Color(groupColor[1]))
        .mask( BlockMidle())
        .overlay( BlockMidle().stroke(lineWidth: 2).foregroundColor(.gray).blur(radius: 1.0))
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
//        BlockView()
        Text("22")
    }
}

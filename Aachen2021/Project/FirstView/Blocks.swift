//
//  Blocks.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//

import Foundation
import SwiftUI


//UIColor(red: 0.827  , green: 0.918  , blue: 0.616  , alpha: 1),
//UIColor(red: 0.949  , green: 0.773  , blue: 0.412  , alpha: 1),
//UIColor(red: 0.953  , green: 0.953  , blue: 0.839  , alpha: 1)

var groupColor : [UIColor] = [ UIColor(red: 0.996  , green: 0.349  , blue: 0.169  , alpha: 1),
                                UIColor(red: 0.267  , green: 0.686  , blue: 0.710  , alpha: 1),
                                UIColor(red: 0.102  , green: 0.467  , blue: 0.639  , alpha: 1),
                                UIColor(red: 1.000  , green: 0.698  , blue: 0.000  , alpha: 1)]
var colorBackground2  =  UIColor(red: 0.678  , green: 0.663  , blue: 0.431  , alpha: 1)
var colorBackground1  =  UIColor(red: 0.243  , green: 0.349  , blue: 0.400  , alpha: 1)
var mayColor          =  UIColor(red: 0.827  , green: 0.918  , blue: 0.616  , alpha: 1)


var width_block = UIScreen.main.bounds.width / 1.1
var height_block = ((UIScreen.main.bounds.width / 1.1 ) / 38 ) * 8
var spacing_block = (UIScreen.main.bounds.width / 1.1 ) / 38
var lineWidth_block : CGFloat = 2.0
var button_index    : CGFloat = 1.0
var indexRadius     : CGFloat = 2.0

struct AuthAll : Codable, Identifiable , Hashable{
    
    var id         : String = UUID().uuidString
    var authNumber : String
    var authPhone  : String
    var isInLine   : Bool
    var title      : String
    var fromPEER   : String
    var toPEER     : String
    var isDownloud : Bool
    var data_event : String
    var date_term  : String
    var minuteMM   : String
    
}


struct BraviFier : Codable, Identifiable {
    
    var          id: String = UUID().uuidString
    var title      : String
    var fromPEER   : String
    var toPEER     : String

}

struct AuthModel : Codable, Identifiable {
    
    var          id: String = UUID().uuidString
    var authNumber : String
    var authPhone  : String
    var title      : String
    var fromPEER   : String
    var toPEER     : String
    var index_H    : String
    
}


struct Model   :  Codable {
   
   var peerID     : Data
   var massige    : Data
   var isSender   : Bool
   var dateNow    : Date
   var dateFutuer : Date
   var peerTopeer : String
   var witness    : Data
}

struct Witness : Codable {
    
    var minuteMinute: String
    var dateEvent   : String
    var dateTerm    : String
    var peerTopeer  : String
    var cryptWitness: Data
}

struct BlockMidle : Shape {
    
    func path(in rect: CGRect) -> Path {
        let deltaX = rect.maxX / 38
        let deltaY = deltaX
        var path = Path()
            path.move(   to: CGPoint(x: rect.minX, y: deltaY ))
            path.addLine(to: CGPoint(x: deltaX   , y: rect.minY))
            path.addLine(to: CGPoint(x: deltaX * 4, y: rect.minY))
            path.addLine(to: CGPoint(x: deltaX * 5, y: deltaY))
            path.addLine(to: CGPoint(x: deltaX * 7, y: deltaY))
            path.addLine(to: CGPoint(x: deltaX * 8, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - deltaX , y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: deltaY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - (deltaY * 2) ))
            path.addLine(to: CGPoint(x: rect.maxX - deltaX, y: rect.maxY - deltaY ))
            path.addLine(to: CGPoint(x: deltaX * 8, y: rect.maxY - deltaY ))
            path.addLine(to: CGPoint(x: deltaX * 7, y: rect.maxY  ))
            path.addLine(to: CGPoint(x: deltaX * 5, y: rect.maxY  ))
            path.addLine(to: CGPoint(x: deltaX * 4, y: rect.maxY - deltaY ))
            path.addLine(to: CGPoint(x: deltaX    , y: rect.maxY - deltaY ))
            path.addLine(to: CGPoint(x: rect.minX    , y: rect.maxY - (deltaY * 2) ))
            path.closeSubpath()
      
     return path
    }
}

struct BlockTop : Shape {
    
    func path(in rect: CGRect) -> Path {
        let deltaX = rect.maxX / 38
        let deltaY = deltaX
        var path = Path()
            path.move(   to: CGPoint(x: rect.minX, y: deltaY ))
            path.addLine(to: CGPoint(x: deltaX   , y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - deltaX , y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: deltaY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - (deltaY * 2) ))
            path.addLine(to: CGPoint(x: rect.maxX - deltaX, y: rect.maxY - deltaY ))
            path.addLine(to: CGPoint(x: deltaX * 8, y: rect.maxY - deltaY ))
            path.addLine(to: CGPoint(x: deltaX * 7, y: rect.maxY  ))
            path.addLine(to: CGPoint(x: deltaX * 5, y: rect.maxY  ))
            path.addLine(to: CGPoint(x: deltaX * 4, y: rect.maxY - deltaY ))
            path.addLine(to: CGPoint(x: deltaX    , y: rect.maxY - deltaY ))
            path.addLine(to: CGPoint(x: rect.minX    , y: rect.maxY - (deltaY * 2) ))
            path.closeSubpath()
      
     return path
    }
}
struct BlockBottom : Shape {
    
    func path(in rect: CGRect) -> Path {
        let deltaX = rect.maxX / 38
        let deltaY = deltaX
        var path = Path()
            path.move(   to: CGPoint(x: rect.minX, y: deltaY ))
            path.addLine(to: CGPoint(x: deltaX   , y: rect.minY))
            path.addLine(to: CGPoint(x: deltaX * 4, y: rect.minY))
            path.addLine(to: CGPoint(x: deltaX * 5, y: deltaY))
            path.addLine(to: CGPoint(x: deltaX * 7, y: deltaY))
            path.addLine(to: CGPoint(x: deltaX * 8, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - deltaX , y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: deltaY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - (deltaY * 2) ))
            path.addLine(to: CGPoint(x: rect.maxX - deltaX, y: rect.maxY - deltaY ))
            path.addLine(to: CGPoint(x: deltaX    , y: rect.maxY - deltaY ))
            path.addLine(to: CGPoint(x: rect.minX    , y: rect.maxY - (deltaY * 2) ))
            path.closeSubpath()
      
     return path
    }
}
struct PrimaryButton: ViewModifier {

    var indexRadius : CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
                    RoundedRectangle(cornerRadius: 5 * indexRadius, style: .continuous)
                        .foregroundColor(.white)
                        .blur(radius: 4.0)
                        .offset(x: -8.0, y: -8.0) })
            .foregroundColor(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 5 * indexRadius, style: .continuous))

    }
}

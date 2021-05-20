//
//  ColorSwitch.swift
//  Aachen2021
//
//  Created by Ivan Dimitrov on 10.05.21.
//


import UIKit
import SwiftUI
import MultipeerConnectivity
import CryptoKit


extension SendView : ColorServiceDelegate {

    func connectedDevicesChanged(manager: ColorService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
//            self.text = "Connections: \(connectedDevices)"
        }
    }
 
    func colorChanged(manager: ColorService, dataModel: Data, peer : MCPeerID) {
        
        OperationQueue.main.addOperation {

            let dataFromModel = try! JSONDecoder().decode(Model.self, from: dataModel)


                if !dataFromModel.peerID.isEmpty {

                    if dataFromModel.isSender {
                        self.signing__ID  = dataFromModel.peerID
                        self.signingID = String(decoding: dataFromModel.peerID, as: UTF8.self)
                          colorService.sendToFistPeer(data: keyAgreenentPublic(), peerID: peer)
//                        colorService.send(colorName: keyAgreenentPublic())
                    }else {
                        self.fromPeer      = dataFromModel.peerTopeer
                        self.peertopeer    = peer.displayName
                        self.agreement__ID = dataFromModel.peerID
                        self.agreementID   =  String(decoding: dataFromModel.peerID, as: UTF8.self)
//                        send data

                          colorService.send(data: senderData())
                        saveToCoreData(peer:  peer) { 
                                                      saveToFireBase()
                        }
                          self.isOkSend = true
                          self.peerString = peer.displayName
//                               saveToFireBase()
                    }
                }

                if !dataFromModel.massige.isEmpty {
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMM dd, yyyy"
                    
                    let minute = DateFormatter()
                        minute.dateFormat = "HH:mm:ss"
//                    self.selectedDateText = formatter.string(from: self.dateNow)
                    
                    let textData = CryptoData_Array(context: moc)
                        textData.name_Title    = peer.displayName
                    
                    if self.agreement__ID.isEmpty {
                                          textData.key_agreement = privateAgreement_Key.rawRepresentation
                    }else{
                                          textData.key_agreement = self.agreement__ID
                    }
                    if self.signing__ID.isEmpty {
                                          textData.key_public    = privateID_Key.publicKey.rawRepresentation
                    }else {
                                          textData.key_public    = self.signing__ID
                    }
                        textData.peer_To_peer = dataFromModel.peerTopeer
                        textData.key_public    = self.signing__ID
                        textData.crypt_Date    = dataFromModel.massige
                        textData.data_event    = formatter.string(from: dataFromModel.dateNow)
                        textData.date_term     = formatter.string(from: dataFromModel.dateFutuer)
                        textData.minuteMM = minute.string(from: dataFromModel.dateNow)
                    
                    if   self.signingID == "" {
                        textData.index_F   = String(2)
                    }else{
                        textData.index_F   = String(1)
                    }
                      
                    do {
                             try self.moc.save()
                    }catch {}
                    
                    self.isOk = true
                    self.peerString = peer.displayName
                    print("\(dataModel)")
       
                }
            
            if !dataFromModel.witness.isEmpty {
                
                let dataFromWitness = try! JSONDecoder().decode(Witness.self, from: dataFromModel.witness)
                let textData = CryptoData_Array(context: moc)
                    textData.name_Title    = peer.displayName
                    textData.index_F       = String(4)
                    textData.minuteMM      = dataFromWitness.minuteMinute
                    textData.data_event    = dataFromWitness.dateEvent
                    textData.date_term     = dataFromWitness.dateTerm
                    textData.crypt_Date    = dataFromWitness.cryptWitness
                    textData.peer_To_peer  = dataFromWitness.peerTopeer
                
                do {
                         try self.moc.save()
                }catch {}
                
                self.isOk = true
                self.peerString = peer.displayName
            }
        }
    }
    func change(color : Data) {
//        self.numberID = String(decoding: color, as: UTF8.self)
    }
}

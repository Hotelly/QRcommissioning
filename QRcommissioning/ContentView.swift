//
//  ContentView.swift
//  commissioning
//
//  Created by k.siddhartha varma on 29/01/24.
//

import SwiftUI
import ManagedAppConfigLib
import CoreImage.CIFilterBuiltins
import CryptoKit
import Compression
import AVKit

struct ContentView: View {
    @EnvironmentObject var networkState: NetworkMonitoring
    @AppConfig("jamfID") var jamfID: String?
    @AppConfig("mdmID") var mdmID: String?
    @AppConfig("serialnumber") var serialnumber: String?
    @AppConfig("macaddress") var macaddress: String?
    @State var localIp: String?
    @State var publicIpAddress: String?
    // device os
    // device serial number
    // device info
    @State private var qrCodeImage: Image?
    @State var player = AVPlayer(url: Bundle.main.url(forResource: "v",
                                                      withExtension: "m4v")!)
    
    private var allVariablesExist: Bool {
        return jamfID != nil && mdmID != nil && serialnumber != nil &&
               macaddress != nil && localIp != nil && publicIpAddress != nil
    }
    
    let columns: [GridItem] = [
        GridItem(.fixed(400)),
        GridItem(.fixed(400)),
        GridItem(.fixed(400))
    ]
    var body: some View {
        ZStack(){
            PlayerView()
            //LoopPlayerView(videoName: "v", videoExtension: "m4v")
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 100) {
                
                //if let jamfID = jamfID, let mdmID = mdmID, let serialNumber = serialnumber,
                //let macAddress = macaddress, let localIp = localIp, let publicIpAddress = publicIpAddress {
                if allVariablesExist {
                    if let qrCodeImage {
                        qrCodeImage
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 500, height: 500)
                            .padding(50)
                    }else {
                        Text("generating QR")
                            .onAppear() {
                                
                                let data = ["jamfID": "\(jamfID ?? "nodata")", "mdmID": "\(mdmID ?? "no mdmID")", "serialnumber": "\(serialnumber ?? "no serialnumber")", "devicename": "\(UIDevice.current.name)", "deviceos": "\(UIDevice.current.systemVersion)", "devicemodel": "\(UIDevice.current.model)", "publicip": "\(publicIpAddress ?? "nodata")", "localip": "\(localIp ?? "nodata")",
                                            "macaddress": "\(macaddress ?? "nodata")"]
                                if let jsonData = try? JSONEncoder().encode(data),
                                   let jsonString = String(data: jsonData, encoding: .utf8) {
                                    //print("\(String(describing: compressString(string: jsonString)))")
                                    //generateQRCode(from: jsonString)
                                    
                                    let encryptInfo = encryptDataV1(jsonData)
                                    
                                    let encryjson = ["data": "\(encryptInfo?.encryptedDataString ?? "")", "Key": "\(encryptInfo?.keyString ?? "")"]
                                    if let encryJsonData = try? JSONEncoder().encode(encryjson),
                                       let encryJsonString = String(data: encryJsonData, encoding: .utf8) {
                                        
                                        generateQRCode(from: encryJsonString)
                                    }
                                    
                                }
                                
                                
                            }
                    }
                    //.background(.black)
                }
                //} else {
                if !allVariablesExist {
                    LazyVGrid(columns: columns, spacing: 30, content: {
                        InfoView(title: "Device Name", hadInfo: true)
                        InfoView(title: "Device OS", hadInfo: true)
                        InfoView(title: "Software Version", hadInfo: true)
                        InfoView(title: "JAMF ID", hadInfo: ((jamfID?.isEmpty) != nil) ? true: false)
                        
                        InfoView(title: "MDM ID", hadInfo: ((mdmID?.isEmpty) != nil) ? true: false)
                        
                        InfoView(title: "Serial Number", hadInfo: ((serialnumber?.isEmpty) != nil) ? true: false)
                        
                        InfoView(title: "Macaddress", hadInfo: ((macaddress?.isEmpty) != nil) ? true: false)
                        
                        InfoView(title: "Public IP", hadInfo: ((publicIpAddress?.isEmpty) != nil) ? true: false)
                            .onAppear(perform: {
                                Task {
                                    await getPublicIpaddreess()
                                }
                            })
//                            .onChange(of: publicIpAddress) {
//                                
//                                let data = ["jamfID": "\(jamfID ?? "nodata")", "mdmID": "\(mdmID ?? "no mdmID")", "serialnumber": "\(serialnumber ?? "no serialnumber")", "devicename": "\(UIDevice.current.name)", "deviceos": "\(UIDevice.current.systemVersion)", "devicemodel": "\(UIDevice.current.model)", "publicip": "\(publicIpAddress ?? "nodata")", "localip": "\(localIp ?? "nodata")",
//                                            "macaddress": "\(macaddress ?? "nodata")"]
//                                if let jsonData = try? JSONEncoder().encode(data),
//                                   let jsonString = String(data: jsonData, encoding: .utf8) {
//                                    //print("\(String(describing: compressString(string: jsonString)))")
//                                    //generateQRCode(from: jsonString)
//                                    
//                                    let encryptInfo = encryptDataV1(jsonData)
//                                    
//                                    let encryjson = ["data": "\(encryptInfo?.encryptedDataString ?? "")", "Key": "\(encryptInfo?.keyString ?? "")"]
//                                    if let encryJsonData = try? JSONEncoder().encode(encryjson),
//                                       let encryJsonString = String(data: encryJsonData, encoding: .utf8) {
//                                        
//                                        generateQRCode(from: encryJsonString)
//                                    }
//                                    
//                                }
//                                
//                                
//                            }
                        InfoView(title: "Local IP", hadInfo: ((localIp?.isEmpty) != nil) ? true: false)
                            .onReceive(networkState.$networkInterface, perform: { _ in
                                getLocalIpAddress()
                            })
                        
                        
                        
                        
                        
                        //                Text("Device Name: \(UIDevice.current.name)")
                        //                Text("Device OS: \(UIDevice.current.systemVersion)")
                        //                Text("Device model: \(UIDevice.current.model)")
                    })
}
                // }
                
                //            if qrCodeImage == nil {
                //                Text("No data found to generate qrCode")
                //            }
                
                
                
                
            }
            //        .onAppear(){
            //            let data = ["jamfID": "\(jamfID ?? "nodata")", "mdmID": "\(mdmID ?? "no mdmID")", "serialnumber": "\(serialnumber ?? "no serialnumber")", "devicename": "\(UIDevice.current.name)", "deviceos": "\(UIDevice.current.systemVersion)", "devicemodel": "\(UIDevice.current.model)", "publicip": "\(publicIpAddress ?? "nodata")", "localip": "\(localIp ?? "nodata")", "macaddress": "\(macaddress ?? "nodata")"]
            //            if let jsonData = try? JSONEncoder().encode(data),
            //               let jsonString = String(data: jsonData, encoding: .utf8) {
            //                generateQRCode(from: jsonString)
            //            }
            //
            //        }
        }
        //.padding()
    }
    
    func generateQRCode(from string: String) {
        let filter = CIFilter.qrCodeGenerator()
        let context = CIContext()
        
        filter.message = Data(string.utf8)
        
        // Add this code to compress data
        print("\(Data(string.utf8).debugDescription)")

        do {
            let compressedData = try NSData(data: Data(string.utf8)).compressed(using: .zlib)
            print("\(compressedData.base64EncodedString())")
        } catch {
            print("\(error)")
        }
        
        let outputImage = filter.outputImage!.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            qrCodeImage = Image(uiImage: UIImage(cgImage: cgImage))
        }
    }
    
    func compressString(string: String) -> String? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        do {
            
            let compressedData = try (string.data(using: .utf8)! as NSData).compressed(using: .zlib)
            // use your compressed data
            return compressedData.base64EncodedString()
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
        
    }
    
    func encryptDataV1(_ data: Data) -> (encryptedDataString: String, keyString: String)? {
        let key = SymmetricKey(size: .bits256)
        let keyData = key.withUnsafeBytes { Data(Array($0)) }
        let keyString = keyData.base64EncodedString()

        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            if let encryptedDataString = sealedBox.combined?.base64EncodedString() {
                let compre = compressString(string: encryptedDataString) ?? ""
                //let decompre = deCompressString(string: compre)
                //return (encryptedDataString, keyString)
                return(compre, keyString)
            }
            return nil
        } catch {
            print("Encryption failed: \(error)")
            return nil
        }
    }
    
    
//    func encryptData(_ data: Data) -> (encryptedData: Data, nonce: AES.GCM.Nonce, key: SymmetricKey)? {
//        let key = SymmetricKey(size: .bits256)
//        do {
//            let nonce = AES.GCM.Nonce()
//            let sealedBox = try AES.GCM.seal(data, using: key, nonce: nonce)
//            return (sealedBox.ciphertext, nonce, key)
//        } catch {
//            print("Encryption failed: \(error)")
//            return nil
//        }
//    }
    
    
    func getPublicIpaddreess() async {
        
        print("fetch Flight List started ..... \(FlightApiURL+"flight?&api_key="+FlightApiKey)")
        
        guard let publicIPRequestUrl = URL(string: FlightApiURL+"flight?&api_key="+FlightApiKey)else {
            print("url error")
            return
        }
        
        do {
            print("fetch request ..")
            let (data, _) = try await URLSession.shared.data(from: publicIPRequestUrl)
            print("value found \(String(data: data, encoding: .utf8)!)")
            if let responceValue = try? JSONDecoder().decode(PublicIpAddressResult.self, from: data) {
                print("value recived")
                //print("info value \(responceValue.terms)")
                //print("count \(responceValue.response)")
                publicIpAddress = responceValue.request.client.ip

            }else {
                print("decoding error")
            }
        } catch {
            print("Data invalid")
        }
    }
    
    func getLocalIpAddress(){
        var address: String?
        var nameof: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

                    let name: String = String(cString: (interface.ifa_name))
                    print("name of device: \(name)")
                    if  name == "en0" || name == "en1" || name == "en2" || name == "en3" || name == "en4" || name == "en5" || name == "en8"{
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        if String(cString: hostname).contains("192"){
                            print("name of device updating: \(name)")
                            address = String(cString: hostname)
                            nameof = name
                        } else if String(cString: hostname).contains("10") {
                            print("name of device updating: \(name)")
                            address = String(cString: hostname)
                            nameof = name
                        } else {
                            print("name of device updating: \(name) address: \(String(cString: hostname))")
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        //self.ipAddress = "name of device: \(nameof ?? "no value found" ) Address: \(address ?? "no value found")"
        self.localIp = address
    }
}

#Preview {
    ContentView()
}


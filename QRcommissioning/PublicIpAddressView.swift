//
//  PublicIpAddressView.swift
//  QRcommissioning
//
//  Created by sid on 06/02/24.
//

import SwiftUI

struct PublicIpAddressView: View {
    @Binding var publicIpAddress: String?
    var body: some View {
        Text("Public IP: \(publicIpAddress ?? "Not found")")
            .onAppear(){
                Task {
                    await getPublicIpaddreess()
                }
            }
    }
    func getPublicIpaddreess() async {
        // create URL https://airlabs.co/api/v9/flight?flight_iata=EK5212&api_key=dcaca57c-2cc1-45f9-b965-f092b0ccd334
//        var cancellables = Set<AnyCancellable>()
        
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
}

struct PublicIpAddressView_Previews: PreviewProvider {
    static var previews: some View {
        PublicIpAddressView(publicIpAddress: .constant("test"))
    }
}

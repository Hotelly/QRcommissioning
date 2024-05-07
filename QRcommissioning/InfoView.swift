//
//  InfoView.swift
//  QRcommissioning
//
//  Created by sid on 05/02/24.
//

import SwiftUI

struct InfoView: View {
    let title: String
    let hadInfo: Bool
    var body: some View {
        HStack(spacing: 5){
            Image(systemName: "checkmark.square")
                .opacity(hadInfo ? 1:0)
            Text(title)
            
            Spacer()
        }
    }
}

#Preview {
    InfoView(title: "JAMF ID", hadInfo: false)
}

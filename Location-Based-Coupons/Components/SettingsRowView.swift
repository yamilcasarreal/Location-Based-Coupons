//
//  RowView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 2/28/24.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    let titleColor: Color
    var body: some View {
        HStack (spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text (title)
                .font(.subheadline)
                .foregroundColor(titleColor)
        }
    }
}

//#Preview {
//    SettingsRowView(imageName: "gear", title: "version", tintColor: Color(.systemGray))
//}

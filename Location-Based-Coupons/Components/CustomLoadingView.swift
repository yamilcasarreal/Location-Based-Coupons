//
//  CustomLoadingView.swift
//  Location-Based-Coupons
//
//  Created by Yamil Casarreal on 4/3/24.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .accentColor(.green)
            .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
            .frame(width: 80, height: 80)
            .background(Color(.systemGray4))
            .cornerRadius(20)
    }
}

#Preview {
    CustomProgressView()
}

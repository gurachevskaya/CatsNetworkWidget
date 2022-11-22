//
//  URLImageView.swift
//  CatsNetworkWidget
//
//  Created by Karina gurachevskaya on 22.11.22.
//

import SwiftUI

struct URLImageView: View {
    let data: Data

    var body: some View {
        if let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            Image(systemName: "photo")
        }
    }
}

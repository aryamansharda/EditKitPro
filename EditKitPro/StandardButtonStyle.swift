//
//  StandardButtonStyle.swift
//  EditKitPro
//
//  Created by Aryaman Sharda on 2/25/23.
//

import SwiftUI

struct StandardButtonStyle: ViewModifier {
    let bodyColor: Color

    func body(content: Content) -> some View {
        content
            .buttonStyle(.plain)
            .frame(width: 250)
            .padding(.all, 16)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 50, style: .continuous).fill(bodyColor.opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .strokeBorder(bodyColor, lineWidth: 1)
            )
    }
}

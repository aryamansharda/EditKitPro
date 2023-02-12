//
//  ContentView.swift
//  EditKitPro
//
//  Created by Aryaman Sharda on 12/14/22.
//

import SwiftUI

struct LandingPageView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                VStack(alignment: .center) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("EditKit Pro")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("v1.0")
                            .font(.title3)
                            .fontWeight(.regular)
                    }

                    Text("Multi-tool for Xcode")
                        .font(.title3)
                        .fontWeight(.regular)
                }
                .foregroundColor(Color.white)

                VStack(spacing: 8) {
                    Button {
                        NSWorkspace.shared.open(URL(string: "https://digitalbunker.dev/editkit-pro/")!)
                    } label: {
                        HStack {
                            Image(systemName: "play")
                            Text("Click to watch tutorial")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                    .frame(height: 50)
                    .frame(width: 250)
                    .contentShape(Rectangle())
                    .background(
                        RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.blue)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 50, style: .continuous)
                            .strokeBorder(Color.blue, lineWidth: 1)
                    )
                    .contentShape(Rectangle())

                    Button {
                        NSWorkspace.shared.open(URL(string: "mailton:aryaman@digitalbunker.dev")!)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "message")
                            VStack {
                                Text("Message developer")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                        }
                        .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                    .frame(height: 50)
                    .frame(width: 250)
                    .contentShape(Rectangle())
                    .background(
                        RoundedRectangle(cornerRadius: 50, style: .continuous).fill(Color.blue)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 50, style: .continuous)
                            .strokeBorder(Color.blue, lineWidth: 1)
                    )
                }
                .padding(.vertical, 16)
            }
        }
    }
}

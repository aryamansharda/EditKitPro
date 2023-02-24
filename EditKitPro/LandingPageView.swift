//
//  ContentView.swift
//  EditKitPro
//
//  Created by Aryaman Sharda on 12/14/22.
//

import SwiftUI

struct LandingPageView: View {

    @State var isPopover = false

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
                    Button(action: { self.isPopover.toggle() }) {
                        HStack {
                            Image(systemName: "gift")
                                .shadow(radius: 2.0)
                            Text("Want To Vote On New Features?")
                                .font(.title3)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .foregroundColor(.white)
                    }.popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                        RoadmapContainerView()
                    }
                    .modifier(StandardButtonStyle(bodyColor: .green))

                    Divider()
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding()

                    Button {
                        NSWorkspace.shared.open(URL(string: "https://www.youtube.com/watch?v=ZM4VHOvPdQU&t=5s&ab_channel=AryamanSharda")!)
                    } label: {
                        HStack {
                            Image(systemName: "play")
                            Text("Watch Tutorial")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                    }
                    .modifier(StandardButtonStyle(bodyColor: .blue))

                    Button {
                        NSWorkspace.shared.open(URL(string: "https://digitalbunker.dev/editkit-pro/")!)
                    } label: {
                        HStack {
                            Image(systemName: "book")
                            Text("Read Documentation")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                    }
                    .modifier(StandardButtonStyle(bodyColor: .blue))


                    Button {
                        NSWorkspace.shared.open(URL(string: "mailto:aryaman@digitalbunker.dev")!)
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "message")
                            VStack {
                                Text("Message Me")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                        }
                        .foregroundColor(.white)
                    }
                    .modifier(StandardButtonStyle(bodyColor: .blue))
                }
                .padding(.vertical, 16)
            }
        }
    }
}

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

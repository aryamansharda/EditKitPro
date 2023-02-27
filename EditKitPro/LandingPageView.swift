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

                titleView

                VStack(spacing: 8) {
                    voteOnFeaturesButton
                    contributeButton

                    Divider()
                        .foregroundColor(.white)
                        .frame(width: 200)
                        .padding()

                    watchTutorialButton
                    readDocumentationButton
                    messageDeveloperButton
                }
                .padding(.vertical, 16)
            }
            .foregroundColor(.white)
        }
    }
}

extension LandingPageView {
    var titleView: some View {
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
    }

    var voteOnFeaturesButton: some View {
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
        }.popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
            RoadmapContainerView()
                .foregroundColor(.black)
        }
        .modifier(StandardButtonStyle(bodyColor: .green))
    }

    var contributeButton: some View {
        Button(action: {
            NSWorkspace.shared.open(URL(string: "https://github.com/aryamansharda/EditKitPro")!)
        }) {
            HStack {
                Image(systemName: "swift")
                    .shadow(radius: 2.0)
                Text("Want To Contribute?")
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .modifier(StandardButtonStyle(bodyColor: .green))
    }

    var watchTutorialButton: some View {
        Button {
            NSWorkspace.shared.open(URL(string: "https://www.youtube.com/watch?v=ZM4VHOvPdQU&t=5s&ab_channel=AryamanSharda")!)
        } label: {
            HStack {
                Image(systemName: "play")
                Text("Watch Tutorial")
                    .font(.title3)
                    .fontWeight(.medium)
            }
        }
        .modifier(StandardButtonStyle(bodyColor: .blue))
    }

    var readDocumentationButton: some View {
        Button {
            NSWorkspace.shared.open(URL(string: "https://digitalbunker.dev/editkit-pro/")!)
        } label: {
            HStack {
                Image(systemName: "book")
                Text("Read Documentation")
                    .font(.title3)
                    .fontWeight(.medium)
            }
        }
        .modifier(StandardButtonStyle(bodyColor: .blue))
    }

    var messageDeveloperButton: some View {
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
        }
        .modifier(StandardButtonStyle(bodyColor: .blue))
    }
}

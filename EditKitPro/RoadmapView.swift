//
//  RoadmapView.swift
//  EditKitPro
//
//  Created by Aryaman Sharda on 2/23/23.
//

import SwiftUI
import Roadmap

struct RoadmapContainerView: View {
    private let configuration = RoadmapConfiguration(
        roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/w1wxyqgoqv")!,
        namespace: "roadmap",
        style: RoadmapTemplate.playful.style
    )

    var body: some View {
        RoadmapView(configuration: configuration)
            .frame(width: 800, height: 600)
    }
}

struct RoadmapView_Previews: PreviewProvider {
    static var previews: some View {
        RoadmapContainerView()
    }
}

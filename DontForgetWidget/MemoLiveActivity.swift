//
//  MemoLiveActivity.swift
//  DontForgetWidget
//
//  Created by Gyuni on 2023/07/09.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct MemoLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MemoAttributes.self) { context in
            ZStack {
                VStack(spacing: 30) {
                    ForEach(0..<3) { index in
                        Rectangle()
                            .fill()
                            .frame(height: 1)
                            .opacity(0.1)
                            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                    }
                }
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 0)
                    Text(context.state.text)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(6)
                        .lineLimit(3)
                        .underline(pattern: .solid, color: Color("PointYellow"))
                        .frame(height: 120)
                        .padding(EdgeInsets(top: 2, leading: 24, bottom: 0, trailing: 24))
                }
            }.background(Color("FloatingBackground"))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    ZStack {
                        VStack(spacing: 25) {
                            ForEach(0..<3) { index in
                                Rectangle()
                                    .fill()
                                    .frame(height: 1)
                                    .opacity(0.1)
                                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 8, trailing: 12))
                            }
                        }
                        Text(context.state.text)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4)
                            .lineLimit(3)
                            .underline(pattern: .solid, color: Color("PointYellow"))
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16))
                            .frame(height: 80)
                    }
                }
            } compactLeading: {
                Text("✏️")
                    .padding(4)
            } compactTrailing: {
            } minimal: {
                Text("✏️")
                    .padding(4)
            }
        }
    }
}

struct DontForgetWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = MemoAttributes(id: 0, createdAt: .now)
    static let contentState = MemoAttributes.ContentState(text: "Hello World!")

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}

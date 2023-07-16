//
//  NoteLiveActivity.swift
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

struct NoteLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NoteAttributes.self) { context in
            ZStack {
                VStack(spacing: 25) {
                    ForEach(0..<4) { index in
                        Rectangle()
                            .fill()
                            .frame(height: 1)
                            .opacity(0.05)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                }
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 0)
                    Text(context.attributes.text)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(6)
                        .lineLimit(3)
                        .underline(pattern: .solid, color: Color("NoteHeaderStart"))
                        .frame(height: 120)
                        .padding(EdgeInsets(top: 2, leading: 24, bottom: 0, trailing: 24))
                }
            }.background(Color("FloatingBackground"))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.attributes.text)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .lineLimit(3)
                        .underline(pattern: .solid, color: Color("NoteHeaderStart"))
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16))
                        .frame(height: 80)
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
    static let attributes = NoteAttributes(text: "Lorem ipsum dolor sit amet")
    static let contentState = NoteAttributes.ContentState(value: 3)

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

//
//  ContentView.swift
//  Feedback
//
//  Created by yanguo sun on 2022/1/12.
//

import SwiftUI

struct BreatheStateView: View {
    @ObservedObject var rhythm:BreatheRhythm
    @State private var iconImage = UIImage(systemName: "photo.circle")!

    var body: some View {
        VStack {
            HStack {
                Text("选择次数：").foregroundColor(.black)
                Picker(selection: $rhythm.countOfBreathMaxString) {
                    ForEach(rhythm.roles, id: \.self) { role in
                        Text(role)
                    }
                } label: {
                    Text("选择正念次数：")
                }
            }
            Text("剩余：\(rhythm.countOfBreathMax - rhythm.countOfBreath)").foregroundColor(.black)
            ZStack{
                RoundedRectangle(cornerRadius: 5 + rhythm.intensity * 70)
                    .frame(width: 50 + rhythm.intensity * 100, height: 50 + rhythm.intensity * 100)
                    .foregroundColor(Color(red: 0.7, green: rhythm.intensity, blue: 0.7))
                Image(uiImage: iconImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .task {
                        iconImage = await rhythm.loadWebImage()
                    }
            }
            .onTapGesture {
                if rhythm.canBegin {
                    rhythm.countOfBreath = 1
                    rhythm.beginIn()
                }
            }
        }.foregroundColor(.grid)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BreatheStateView(rhythm:BreatheRhythm())
    }
}

extension Color {
#if os(iOS)
    static let grid = Color(UIColor.tertiarySystemFill)
#elseif os(macOS)
    static let grid = Color(NSColor.controlBackgroundColor)
#endif
}

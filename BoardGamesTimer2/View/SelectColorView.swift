//
//  SelectColorView.swift
//  BoardGamesTimer2
//
//  Created by Diego López Bugna on 23/04/2026.
//

import SwiftUI

struct SelectColorView: View {
    let colors: [Color]
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack {
            Button("<") {
                let i = colors.firstIndex(of: selectedColor) ?? 0
                if i > 0 {
                    withAnimation(.linear(duration: 0.1)) {
                        selectedColor = colors[i - 1]
                    }
                }
            }
            .fontWeight(.bold)
            .disabled(selectedColor == colors.first)
            RoundedRectangle(cornerRadius: 5)
                .fill(selectedColor)
                .stroke(.black, lineWidth: 2)
                .frame(height: 35)

            Button(">") {
                let i = colors.firstIndex(of: selectedColor) ?? 0
                if i < colors.count - 1 {
                    withAnimation(.linear(duration: 0.1)) {
                        selectedColor = colors[i + 1]
                    }
                }
            }
            .fontWeight(.bold)
            .disabled(selectedColor == colors.last)
        }
    }
}

#Preview {
    let g = Game()
    let colors = g.availablePlayerColors.map(\.bgColor)
    SelectColorView(colors: colors, selectedColor: .constant(colors.first!))
}

//
//  Analytic.swift
//  RZBD
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 16.12.2024.
//

import Foundation
import SwiftUI

struct UserRatingPieChartView: View {
    let users: [User]

    var ratingDistribution: [Double] {
        var distribution = Array(repeating: 0.0, count: 10)
        for user in users {
            let index = min(Int(user.user_rating), 9)
            distribution[index] += 1
        }
        return distribution
    }

    var totalUsers: Double {
        ratingDistribution.reduce(0, +)
    }

    var body: some View {
        VStack {
            Text("User Rating Distribution")
                .font(.headline)

            ZStack {
                PieChartView(data: ratingDistribution, total: totalUsers)
                    .frame(width: 300, height: 300)

                // Добавляем текстовые метки на сектора
                ForEach(0..<ratingDistribution.count, id: \..self) { index in
                    if ratingDistribution[index] > 0 {
                        let percentage = ratingDistribution[index] / totalUsers * 100
                        Text(String(format: "%.1f%%", percentage))
                            .foregroundColor(.white)
                            .font(.caption)
                            .offset(x: 150 * cos(self.angle(for: index)), y: 150 * sin(self.angle(for: index)))
                    }
                }
            }

            // Легенда для каждого диапазона
            VStack(alignment: .leading) {
                ForEach(0..<ratingDistribution.count, id: \..self) { index in
                    if ratingDistribution[index] > 0 {
                        Text("Rating \(index)-\(index + 1): \(Int(ratingDistribution[index])) users")
                            .font(.caption)
                    }
                }
            }
        }
    }

    private func angle(for index: Int) -> CGFloat {
        let cumulativeValue = ratingDistribution.prefix(index).reduce(0, +)
        let currentAngle = cumulativeValue / totalUsers * 360
        let midAngle = currentAngle + (ratingDistribution[index] / totalUsers * 180)
        return CGFloat(midAngle * .pi / 180)
    }
}

struct PieChartView: View {
    let data: [Double]
    let total: Double

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let centerX = width / 2
            let centerY = height / 2
            let radius = min(centerX, centerY)

            Path { path in
                var startAngle: Double = 0

                for value in data {
                    let endAngle = startAngle + (value / total * 360)

                    path.addArc(center: CGPoint(x: centerX, y: centerY),
                                radius: radius,
                                startAngle: .degrees(startAngle),
                                endAngle: .degrees(endAngle),
                                clockwise: false)

                    path.addLine(to: CGPoint(x: centerX, y: centerY))
                    path.closeSubpath()

                    startAngle = endAngle
                }
            }
            .fill(AngularGradient(gradient: Gradient(colors: colors), center: .center))
        }
    }

    private var colors: [Color] {
        [
            .red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .cyan, .indigo
        ]
    }
}


#Preview() {
    @Previewable var viewModel = APIClient().users
    UserRatingPieChartView(users: viewModel)
}

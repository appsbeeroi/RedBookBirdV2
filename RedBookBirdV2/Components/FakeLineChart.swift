import SwiftUI

// MARK: - Weekly Line Chart (Data-driven)

struct FakeLineChart: View {
    /// Counts for days of week starting from Monday to Sunday. Length should be 7.
    let counts: [Int]
    
    init(counts: [Int]) {
        self.counts = counts
    }
    
    private var labels: [String] { ["MON","TUE","WED","THU","FRI","SAT","SUN"] }
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let safeTopPadding: CGFloat = 8
            let safeBottomPadding: CGFloat = 30 // extra space for weekday labels
            let verticalOffset: CGFloat = 6 // lift the curve a bit above labels
            let chartHeight = max(h - safeTopPadding - safeBottomPadding, 1)
            let maxValue = max(counts.max() ?? 1, 1)
            let points = pointsFor(width: w, height: chartHeight, maxValue: maxValue)
            
            // Line path
            Path { path in
                guard let first = points.first else { return }
                path.move(to: CGPoint(x: first.x, y: first.y + safeTopPadding - verticalOffset))
                let smooth = smoothed(points: points)
                for segment in smooth {
                    path.addCurve(to: CGPoint(x: segment.to.x, y: segment.to.y + safeTopPadding - verticalOffset),
                                  control1: CGPoint(x: segment.c1.x, y: segment.c1.y + safeTopPadding - verticalOffset),
                                  control2: CGPoint(x: segment.c2.x, y: segment.c2.y + safeTopPadding - verticalOffset))
                }
            }
            .strokedPath(.init(lineWidth: 4, lineCap: .round, lineJoin: .round))
            .fill(Color.yellow)
            
            // Labels
            HStack {
                ForEach(labels, id: \.self) { label in
                    Text(label)
                        .font(.customFont(font: .regular, size: 12))
                        .foregroundStyle(.customBlack.opacity(0.7))
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    // MARK: - Geometry helpers
    private func pointsFor(width: CGFloat, height: CGFloat, maxValue: Int) -> [CGPoint] {
        guard counts.count == 7 else { return [] }
        let stepX = width / 6.0
        return counts.enumerated().map { index, value in
            let ratio = CGFloat(value) / CGFloat(maxValue)
            let y = height - ratio * height
            let x = CGFloat(index) * stepX
            return CGPoint(x: x, y: y)
        }
    }
    
    private struct BezierSegment { let c1: CGPoint; let c2: CGPoint; let to: CGPoint }
    
    // Catmull-Rom to Bezier conversion for smooth curve
    private func smoothed(points: [CGPoint]) -> [BezierSegment] {
        guard points.count > 1 else { return [] }
        var result: [BezierSegment] = []
        let tension: CGFloat = 0.5
        for i in 0..<(points.count - 1) {
            let p0 = i > 0 ? points[i - 1] : points[i]
            let p1 = points[i]
            let p2 = points[i + 1]
            let p3 = i + 2 < points.count ? points[i + 2] : points[i + 1]
            let d1 = CGPoint(x: (p2.x - p0.x) * tension / 6.0, y: (p2.y - p0.y) * tension / 6.0)
            let c1 = CGPoint(x: p1.x + d1.x, y: p1.y + d1.y)
            let d2 = CGPoint(x: (p3.x - p1.x) * tension / 6.0, y: (p3.y - p1.y) * tension / 6.0)
            let c2 = CGPoint(x: p2.x - d2.x, y: p2.y - d2.y)
            result.append(BezierSegment(c1: c1, c2: c2, to: p2))
        }
        return result
    }
}

// Bounds-safe subscript
private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}



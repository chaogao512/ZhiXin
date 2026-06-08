import SwiftUI
import Charts

struct StudentDetailView: View {
    let studentID: String

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                StudentInfoHeader()
                Chart {
                    BarMark(x: .value("学科", "数学"), y: .value("错题数", 12))
                    BarMark(x: .value("学科", "英语"), y: .value("错题数", 8))
                    BarMark(x: .value("学科", "语文"), y: .value("错题数", 5))
                }
                .frame(height: 200)
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading) {
                    Text("最近错题").font(.headline)
                    ForEach(0..<3) { _ in
                        Text("二次函数顶点式").padding(.vertical, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("学生详情")
    }
}

struct StudentInfoHeader: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text("张三").font(.title2).bold()
                Text("七年级一班").foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

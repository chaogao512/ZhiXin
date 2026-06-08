import SwiftUI
import Charts

struct MistakeAnalyticsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ClassSelectorView()
                    Chart {
                        BarMark(x: .value("学科", "数学"), y: .value("错题数", 156))
                        BarMark(x: .value("学科", "英语"), y: .value("错题数", 98))
                        BarMark(x: .value("学科", "语文"), y: .value("错题数", 67))
                    }
                    .frame(height: 200)
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack(alignment: .leading) {
                        Text("全班共性薄弱点").font(.headline)
                        Label("二次函数图像平移 (23人出错)", systemImage: "person.2")
                        Label("过去完成时 (18人出错)", systemImage: "person.2")
                        Label("文言文虚词 (15人出错)", systemImage: "person.2")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .navigationTitle("全班错题分析")
        }
    }
}

struct ClassSelectorView: View {
    @State private var selectedClass = "七年级一班"

    var body: some View {
        Picker("班级", selection: $selectedClass) {
            Text("七年级一班").tag("七年级一班")
            Text("七年级二班").tag("七年级二班")
        }
        .pickerStyle(.menu)
    }
}

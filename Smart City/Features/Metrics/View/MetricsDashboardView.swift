//
//  MetricsDashboardView.swift
//  Smart City
//
//  Created by Lugardo on 03/07/25.
//
import Charts
import SwiftUI

private struct ChartCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
                .frame(minHeight: 180)
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.2))
        )
    }
}

struct MetricsDashboardView: View {
    @State var viewModel: MetricsDashboardViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ChartCard(title: "⏱ Load Time (ms)") {
                    Chart(viewModel.loadTimes, id: \.id) {
                        LineMark(
                            x: .value("Timestamp", $0.timestamp),
                            y: .value("ms", $0.duration * 1000)
                        )
                        .interpolationMethod(.monotone)
                        .foregroundStyle(by: .value("Source", $0.source.capitalized))
                        PointMark(
                            x: .value("Timestamp", $0.timestamp),
                            y: .value("ms", $0.duration * 1000)
                        )
                    }
                    .chartLegend(position: .automatic)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                }

                ChartCard(title: "🔎 Search Latency (ms)") {
                    Chart(viewModel.searchLatencies, id: \.timestamp) { entry in
                        LineMark(
                            x: .value("Time", entry.timestamp),
                            y: .value("ms", entry.duration * 1000)
                        )
                        .foregroundStyle(.purple)
                        .symbol(.circle)
                    }
                    .chartYAxis { AxisMarks(position: .leading) }
                    .frame(height: 180)
                }

                ChartCard(title: "🔍 Top Search Terms") {
                    Chart(viewModel.topSearchTerms, id: \.0) { entry in
                        BarMark(
                            x: .value("Searches", entry.1),
                            y: .value("Term", entry.0)
                        )
                        .annotation(position: .trailing) {
                            Text("\(entry.1)")
                                .font(.caption)
                        }
                    }
                    .chartXAxis(.hidden)
                }

                ChartCard(title: "🏙 Top Visited Cities") {
                    Chart(viewModel.topVisitedCities, id: \.0.id) { entry in
                        let city = entry.0
                        let visits = entry.1
                        BarMark(
                            x: .value("City", city.name),
                            y: .value("Visits", visits)
                        )
                        .annotation(position: .top) {
                            Text("\(visits)")
                                .font(.caption2)
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                            AxisGridLine().foregroundStyle(.clear)
                            AxisTick().foregroundStyle(.clear)
                            AxisValueLabel()
                        }
                    }
                }

                ChartCard(title: "❤️ Favorites by Country") {
                    Chart(viewModel.favoritesByCountry, id: \.0) { entry in
                        BarMark(
                            x: .value("Shape Type", entry.country),
                            y: .value("Total Count", entry.count)
                        )
                        .foregroundStyle(by: .value("Shape Color", "Green"))
                    }
                    .chartLegend(.visible)
                    .frame(height: 240)
                }
            }
            .padding(20)
        }
        .navigationTitle("Metrics")
        .onAppear {
            viewModel.loadAllMetrics()
        }
    }

    private var infoListMode: some View {
        List {
            Section("🔍 Top Search Terms") {
                ForEach(viewModel.topSearchTerms, id: \.0) {
                    Text($0.0)
                }
            }
            Section("🏙 Top Visited Cities") {
                ForEach(viewModel.topVisitedCities, id: \.0) { city in
                    Text(city.0.name)
                }
            }
            Section("⏱ Load Times") {
                ForEach(viewModel.loadTimes, id: \.timestamp) { entry in
                    HStack {
                        Text(entry.source.capitalized + ":")
                        Spacer()
                        Text(String(format: "%.0f ms", entry.duration * 1000))
                    }
                }
            }
            Section("⭐️ Favorites by Country") {
                ForEach(viewModel.favoritesByCountry, id: \.country) { group in
                    HStack {
                        Text(group.country.flagEmoji + " " + group.country)
                        Spacer()
                        Text("\(group.count)")
                    }
                }
            }
        }
    }
}

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
            charts
        }
        .navigationTitle("Metrics")
        .onAppear {
            viewModel.loadAllMetrics()
        }
        .refreshable {
            viewModel.loadAllMetrics()
        }
    }

    private var charts: some View {
        VStack(alignment: .leading, spacing: 24) {
            if !viewModel.favoritesByCountry.isEmpty {
                favoriteChart
            }
            if !viewModel.loadTimes.isEmpty {
                loadTimeChart
            }
            if !viewModel.searchLatencies.isEmpty {
                latencyChart
            }
            if !viewModel.topSearchTerms.isEmpty {
                searchTerm
            }
            if !viewModel.topVisitedCities.isEmpty {
                topVisitedCity
            }
        }
        .padding(20)
    }

    private var loadTimeChart: some View {
        ChartCard(title: "⏱ Load Time (ms)") {
            Chart(viewModel.loadTimes, id: \.id) {
                LineMark(
                    x: .value("Timestamp", $0.timestamp),
                    y: .value("ms", $0.duration)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(by: .value("Source", $0.source.capitalized))
                PointMark(
                    x: .value("Timestamp", $0.timestamp),
                    y: .value("ms", $0.duration)
                )
            }
            .chartLegend(position: .automatic)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
    }

    private var favoriteChart: some View {
        ChartCard(title: "❤️ Favorites by Country") {
            Chart(viewModel.favoritesByCountry, id: \.country) { entry in
                SectorMark(
                    angle: .value("Count", entry.count),
                    innerRadius: .ratio(0.5),
                    angularInset: 2
                )
                .foregroundStyle(
                    by: .value("Country", entry.country)
                )
                .annotation(position: .overlay) {
                    VStack {
                        Text(entry.country.flagEmoji)
                        Text("\(entry.count)")
                            .font(.caption2)
                    }
                }
            }
            .chartLegend(.visible)
            .frame(height: 240)
        }
    }

    private var latencyChart: some View {
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
    }

    private var searchTerm: some View {
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
    }

    private var topVisitedCity: some View {
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
    }
}

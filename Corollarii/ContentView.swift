import Foundation
import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = CorollariiManager()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Bill Amount")) {
                        Text("$\(manager.cash.totalDisplay)")
                    }
                    Section {
                        Stepper("Tip Percent: \(manager.percentage)", value: $manager.percentage)
                        Toggle("Round Up", isOn: $manager.round)
                    }
                    Section {
                        Text("Tip Amount: \(formatCurrency(manager.round ? manager.roundedTip : manager.calculatedTip))")
                        Text("Total: \(formatCurrency(manager.round ? manager.roundedTotal : manager.calculatedTotal))")
                    }
                }
                VStack {
                    HStack {
                        Button("1") { manager.keypress(key: .one) }
                            .padding()
                        Button("2") { manager.keypress(key: .two) }
                            .padding()
                        Button("3") { manager.keypress(key: .three) }
                            .padding()
                    }
                    HStack {
                        Button("4") { manager.keypress(key: .four) }
                            .padding()
                        Button("5") { manager.keypress(key: .five) }
                            .padding()
                        Button("6") { manager.keypress(key: .six) }
                            .padding()
                    }
                    HStack {
                        Button("7") { manager.keypress(key: .seven) }
                            .padding()
                        Button("8") { manager.keypress(key: .eight) }
                            .padding()
                        Button("9") { manager.keypress(key: .nine) }
                            .padding()
                    }
                    HStack {
                        Button(".") { manager.keypress(key: .decimal) }
                            .padding()
                        Button("0") { manager.keypress(key: .zero) }
                            .padding()
                        Button("⌫") { manager.remove() }
                            .padding()
                    }
                }
            }
            .navigationTitle("Corollarii")
        }
    }

    func formatCurrency(_ value: Decimal) -> String {
        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true

        return formatter.string(from: value as NSDecimalNumber) ?? ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
        ContentView()
            .preferredColorScheme(.dark)
    }
}

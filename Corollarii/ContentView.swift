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
                    ButtonRow(manager: manager, values: [.one, .two, .three])
                    ButtonRow(manager: manager, values: [.four, .five, .six])
                    ButtonRow(manager: manager, values: [.seven, .eight, .nine])
                    ButtonRow(manager: manager, values: [.decimal, .zero, .backspace])
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

struct ButtonRow: View {
    let manager: CorollariiManager
    let values: [CalculatorCharacters]

    var body: some View {
        HStack {
            ForEach(values, id: \.self) { value in
                ButtonView(manager: manager, value: value)
            }
        }
    }
}

struct ButtonView: View {
    let manager: CorollariiManager
    let value: CalculatorCharacters

    var body: some View {
        Button(value.rawValue) { manager.keypress(key: value) }
            .padding()
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

import Foundation
import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = CorollariiManager()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter Bill Amount")) {
                    TextField("Bill Amount", text: $manager.amount)
                        .keyboardType(.decimalPad)
                }
                Section {
                    Stepper("Tip Percent: \(manager.percentage)", value: $manager.percentage)
                    Toggle("Round Up", isOn: $manager.round)
                }
                Section {
                    Text("Tip Amount: \(formatCurrency(manager.calculateTip()))")
                    Text("Total: \(formatCurrency(manager.calculateTotal()))")
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
    }
}

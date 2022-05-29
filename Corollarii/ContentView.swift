import Foundation
import SwiftUI

struct ContentView: View {
    @StateObject var cash = CashMachine()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Bill Amount")) {
                        Text(cash.displayValue)
                    }
                    Section {
                        Stepper("Tip Percent: \(cash.percentage)", value: $cash.percentage, in: 1...100)
                        Toggle("Round Up", isOn: $cash.round)
                    }
                    Section {
                        Text("Tip Amount: \(formatCurrency(cash.round ? cash.roundedTip : cash.calculatedTip))")
                        Text("Total: \(formatCurrency(cash.round ? cash.roundedTotal : cash.calculatedTotal))")
                    }
                }
                VStack {
                    ButtonRow(cash: cash, values: [.number(1), .number(2), .number(3)])
                    ButtonRow(cash: cash, values: [.number(4), .number(5), .number(6)])
                    ButtonRow(cash: cash, values: [.number(7), .number(8), .number(9)])
                    ButtonRow(cash: cash, values: [.decimal, .number(0), .backspace])
                }
                .padding(.bottom, 8)
            }
            .navigationTitle("Corollarii")
        }
    }

    func formatCurrency(_ value: Decimal) -> String {
        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true

        return formatter.string(from: value as NSNumber) ?? "invalid input"
    }
}

struct ButtonRow: View {
    let cash: CashMachine
    let values: [CalculatorCharacter]

    var body: some View {
        HStack {
            ForEach(values, id: \.characterValue) { value in
                ButtonView(cash: cash, value: value)
            }
        }.padding([.leading, .trailing])
    }
}

struct ButtonView: View {
    let cash: CashMachine
    let value: CalculatorCharacter

    var body: some View {
        Button(action: { cash.keypress(key: value) }, label: {
            Color.clear
                .frame(maxHeight: 44)
                .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke())
                .overlay(Text(value.characterValue).font(.headline))
        })
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

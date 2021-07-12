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
                    Text("Tip Amount: $\(manager.calculateTip().description)")
                    Text("Total: $\(manager.calculateTotal().description)")
                }
            }
            .navigationTitle("Corollarii")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

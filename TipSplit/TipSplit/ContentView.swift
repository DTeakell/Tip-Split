//
//  ContentView.swift
//  TipSplit
//
//  Created by Dillon Teakell on 10/6/23.
//

import SwiftUI

struct MainView: View {
    
    @State var checkAmount = 0.00
    @State var numberOfPeople = 1
    let tipPercentages = [15, 20, 25, 30, 50]
    @State var tipPercentage = 20
    
    // To make the keyboard dismiss, unset the focus
    @FocusState private var checkAmountIsFocused: Bool
    
    // To calculate total, a computed property is needed
    var totalPerPerson: Double {                                             
        let peopleCount = Double(numberOfPeople + 1)
        let tipSelection = Double(tipPercentage) / 100
        
        let tippedValue = Double(checkAmount * tipSelection)
        let grandTotal = Double(tippedValue + checkAmount)
        let totalPerPerson = Double(grandTotal / peopleCount)
        
        return totalPerPerson
    }
    
    // Calculate total for the bill, including tips.
    var totalWithTip: Double {
        let tipSelection = Double(tipPercentage) / 100
        let tippedTotal = Double(checkAmount * tipSelection) + checkAmount
        
        return tippedTotal
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                // Check Amount Section
                Section ("Check Amount") {
                    TextField("Amount", value: $checkAmount,
                              format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                    .focused($checkAmountIsFocused)
                    
                }
                
                // Number of People
                Section("Number of People") {
                    Picker("People", selection: $numberOfPeople) {
                        ForEach(1..<100) {
                            Text("^[\($0) People](inflect: true)")
                        }
                    }
                }
                
                // Tip Percentage Section
                Section("Tip Percentage") {
                    Picker("Tip", selection: $tipPercentage){
                        ForEach(tipPercentages, id: \.self) {percentage in
                            Text("\(percentage.formatted(.percent))")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                
                // Bill Grand Total Section
                Section("Bill Total") {
                    Text(totalWithTip.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                        .foregroundStyle(.secondary)
                }
                
                // Total Per Person Section
                Section("Total Per Person") {
                    Text(totalPerPerson.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Tip Split")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    
                    Spacer()
                    
                    Button ("Done") {
                        checkAmountIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}

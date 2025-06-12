//
//  ContentView.swift
//  Tipping Calculator
//
//  Created by Carmen Ruan on 6/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var totalSpent = ""
    @State private var customTipPercent = ""
    @State private var includeTax = false
    
    var total: Double {
        Double(totalSpent) ?? 0
    }
    
    var customTip: Double {
        (Double(customTipPercent) ?? 0) / 100
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("💸 Tipping Calculator 💸")
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                Form {
                    Toggle(isOn: $includeTax) {
                        Text("Include New York Tax (8.875%)")
                    }
                    
                    Section(header: Text("Enter Total Amount Spent: ")) {
                        TextField("Total (e.g. 55.50)", text: $totalSpent).keyboardType(.decimalPad)
                    }
                    
                    Section(header: Text("Input Custom Tip % (Optional): ")) {
                        TextField("Custom Tip (e.g. 30)", text: $customTipPercent).keyboardType(.numberPad)
                    }
                    
                    if total > 0 { /* options for tips to show up only if input is > 0 */
                        Section(header: Text("Tipping Options With Totals: ")) {
                            TipRow(percentage: 15, total: total, includeTax: includeTax)
                            TipRow(percentage: 18, total: total, includeTax: includeTax)
                            TipRow(percentage: 20, total: total, includeTax: includeTax)
                            TipRow(percentage: 22, total: total, includeTax: includeTax)
                            TipRow(percentage: 25, total: total, includeTax: includeTax)
                            
                            if customTip > 0 { /* create new tip only if a custom tip % more than 0 is inputted */
                                TipRow(percentage: Double(customTipPercent) ?? 0, total: total, includeTax: includeTax)
                            }
                        }
                    }
                }.scrollContentBackground(.hidden)
            }.background(Color(.systemGroupedBackground).ignoresSafeArea()).navigationBarHidden(true)
        }
    }
}
    
struct TipRow: View {
    let percentage: Double
    let total: Double
    let includeTax: Bool
    let salesTaxPercent = 8.875
    
    var body: some View {
        let tip = total * percentage / 100
        let tax = total * salesTaxPercent / 100
        let finalAmount = total + tip
        let finalAmountWithTipAndTax = finalAmount + (includeTax ? tax : 0)

        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(Int(percentage))% Tip").font(.headline)
                Spacer()
                Text(String(format: "$%.2f", tip)).font(.headline)
            }
            
            Text(String(format: "Total With Tip: $%.2f", finalAmount)).font(.subheadline).foregroundColor(.gray)
            
            if includeTax {
                Text(String(format: "Total with Tip & NY Tax: $%.2f", finalAmountWithTipAndTax))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

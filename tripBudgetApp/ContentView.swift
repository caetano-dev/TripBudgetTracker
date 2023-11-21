//
//  ContentView.swift
//  tripBudgetApp
//
//  Created by Pedro Caetano on 17/11/23.
//

import SwiftUI

struct Trip {
    var tripName: String
    var destination: String
    var startDate: Date
    var totalBudget: Double
}

struct Expense {
    var title: String
    var amount: Double
    var date: Date
    var time: Date
}


struct BudgetSummary {
    var totalExpenses: Double
    var remainingBudget: Double
}

let sampleExpenses: [Expense] = [
    Expense(title: "Hotel Stay", amount: 800.0, date: Date(timeIntervalSinceNow: TimeInterval.random(in: 0...100000)), time: Date.now),
    Expense(title: "Flight Tickets", amount: 1200.0, date: Date(timeIntervalSinceNow: TimeInterval.random(in: 0...100000)), time: Date.now),
    Expense(title: "Dinner", amount: 100.0, date: Date(timeIntervalSinceNow: TimeInterval.random(in: 0...100000)), time: Date.now),
    Expense(title: "Museum Tickets", amount: 150.0, date: Date(timeIntervalSinceNow: TimeInterval.random(in: 0...100000)), time: Date.now)
]



struct ContentView: View {
    @State var expenses: [Expense] = []
    @State private var isAddingExpense: Bool = false;
    @State var totalExpenses: Double = 0
    
    var body: some View {
        NavigationView {
            
            List {
                Text("Σ: $\(totalExpenses.formatted())")
                    .font(.title)
                    .bold()
                ForEach(expenses, id: \.title) { expense in
                    ExpenseRow(expense: expense)
                }
                .onDelete(perform: deleteExpense)
                
            }
            .navigationTitle("Expenses")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button(action: {
                isAddingExpense = true
            }) {
                Image(systemName: "plus")
            }
            )
            .sheet(isPresented: $isAddingExpense) {
                NewExpenseView(isPresented: $isAddingExpense, addExpense: addExpense)
            }
        }
    }
    
    func updateTotalExpenses() {
        totalExpenses = expenses.reduce(0) { $0 + $1.amount }
    }
    
    func deleteExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
         updateTotalExpenses()
    }
    
    func addExpense(expense: Expense) {
        expenses.append(expense)
        updateTotalExpenses()
    }
}

struct NewExpenseView: View {
    @Binding var isPresented: Bool
    var addExpense: (Expense) -> Void
    
    @State private var expenseTitle = ""
    @State private var totalAmount: Double = 0
    @State private var startDate: Date = Date()
    @State private var startTime: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Expense Title", text: $expenseTitle)
                TextField("Total Amount", value: $totalAmount, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                
                Button("Save") {
                    let newExpense = Expense(title: expenseTitle, amount: totalAmount, date: startDate, time: startTime)
                    addExpense(newExpense)
                    isPresented = false
                }
            }
            .navigationTitle("New Expense")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

struct ExpenseRow: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                    Text(expense.title)
                    .font(.title2)
                    .bold()
                    Text("\(expense.amount.formatted(.currency(code: "USD")))")
                    .bold()
                
                HStack{
                    Text("\(expense.date, formatter: dateFormatter)")
                        .font(.subheadline)
                    Text("-")
                        .font(.subheadline)
                    Text("\(expense.time, formatter: timeFormatter)")
                        .font(.subheadline)
                }
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}


#Preview {
    ContentView()
}

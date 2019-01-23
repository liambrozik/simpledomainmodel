//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var value : Money = Money(amount: 0, currency: "USD");
    if self.currency == "USD" {
        if to == "GBP" {
            value.amount = (self.amount / 2)
        } else if to == "EUR" {
            value.amount = ((self.amount * 3) / 2)
        } else if to == "CAN" {
            value.amount = ((self.amount * 5) / 4)
        }
    } else if self.currency == "GBP" {
        if to == "USD" {
            value.amount = (self.amount * 2)
        } else if to == "EUR" {
            value.amount = (((self.amount * 2) * 3) / 2)
        } else if to == "CAN" {
            value.amount = (((self.amount * 2) * 5) / 4)
        }
    }
    else if self.currency == "EUR" {
        if to == "USD" {
            value.amount = ((self.amount * 2) / 3)
        } else if to == "GBP" {
            value.amount = (((self.amount * 2) / 3) / 2)
        } else if to == "CAN" {
            value.amount = ((((self.amount * 2) / 3) * 5) / 4)
        }
    } else if self.currency == "CAN" {
        if to == "USD" {
            value.amount = ((self.amount * 4) / 5)
        } else if to == "GBP" {
            value.amount = (((self.amount * 4) / 5) / 2)
        } else if to == "EUR" {
            value.amount = ((((self.amount * 4) / 5) * 3) / 2)
        }
    }
    value.currency = to;
    return value;
  }
  
  public func add(_ to: Money) -> Money {
    var value : Money
    if (self.currency != to.currency) {
        let temp1 : Money = self.convert(to.currency)
        value = Money(amount: temp1.amount + to.amount, currency: to.currency)
    } else {
        value = Money(amount: self.amount + to.amount, currency: to.currency)
    }
    return value;
  }
  public func subtract(_ from: Money) -> Money {
    let temp1 : Money = self.convert(from.currency)
    let value : Money = Money(amount: from.amount - temp1.amount, currency: from.currency)
    return value;
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title;
    self.type = type;
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
        case JobType.Hourly(let rate): return Int(rate) * hours
        case JobType.Salary(let rate): return rate
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
        case JobType.Hourly(let rate): self.type = Job.JobType.Hourly(rate + amt)
        case JobType.Salary(let rate): self.type = Job.JobType.Salary(rate + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job != nil ? _job! : nil}
    set(value) {
        if (self.age >= 21) {
            _job = value
        } else {
            _job = nil
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse != nil ? _spouse! : nil }
    set(value) {
        if (self.age >= 21) {
            _spouse = value
        } else {
            _spouse = nil
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    let sp = self.spouse != nil ? "\(self.spouse!)" : "nil"
    let j = self.job != nil ? "\(self.job!)" : "nil"
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(j) spouse:\(sp)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    members.append(spouse1)
    members.append(spouse2)
  }
  
  open func haveChild(_ child: Person) -> Bool {
    members.append(child)
    return true
  }
  
  open func householdIncome() -> Int {
    var inc = 0
    for per in members {
        if per.job != nil {
            let ty = per.job!
            switch ty.type {
                case Job.JobType.Hourly(let rate): inc += Int(2000 * rate)
                case Job.JobType.Salary(let rate): inc += Int(rate)
            }
        }
    }
    return inc
  }
}






//
//  CareKitManager.swift
//  Master-Sample
//
//  Created by Santiago Gutierrez on 11/12/19.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import CareKit
import Contacts

class CareKitManager {
    
    static let shared = CareKitManager()
    
    lazy var storeManager: OCKSynchronizedStoreManager<OCKStore> = {
        let store = OCKStore(name: "SampleAppStore")
        let manager = OCKSynchronizedStoreManager(wrapping: store)
        manager.populateSampleData()
        return manager
    }()
    
}


private extension OCKSynchronizedStoreManager where Store == OCKStore {

    // Adds tasks and contacts into the store
    func populateSampleData() {

        let thisMorning = Calendar.current.startOfDay(for: Date())
        let aFewDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: thisMorning)!
        let beforeBreakfast = Calendar.current.date(byAdding: .hour, value: 8, to: aFewDaysAgo)!
        let afterLunch = Calendar.current.date(byAdding: .hour, value: 14, to: aFewDaysAgo)!

        let schedule = OCKSchedule(composing: [
            OCKScheduleElement(start: beforeBreakfast, end: nil,
                               interval: DateComponents(day: 1)),

            OCKScheduleElement(start: afterLunch, end: nil,
                               interval: DateComponents(day: 2))
        ])

        var doxylamine = OCKTask(identifier: "doxylamine", title: "Take Doxylamine",
                             carePlanID: nil, schedule: schedule)
        doxylamine.instructions = "Take 25mg of doxylamine when you experience nausea."

        let nauseaSchedule = OCKSchedule(composing: [
            OCKScheduleElement(start: beforeBreakfast, end: nil,
                               interval: DateComponents(day: 1),
                               text: "Anytime throughout the day", targetValues: [], isAllDay: true)
            ])

        var nausea = OCKTask(identifier: "nausea", title: "Track your nausea",
                             carePlanID: nil, schedule: nauseaSchedule)
        nausea.impactsAdherence = false
        nausea.instructions = "Tap the button below anytime you experience nausea."

        let kegelSchedule = OCKSchedule(composing: [OCKScheduleElement(start: beforeBreakfast, end: nil, interval: DateComponents(day: 2))])
        var kegels = OCKTask(identifier: "kegels", title: "Kegel Exercises", carePlanID: nil, schedule: kegelSchedule)
        kegels.impactsAdherence = true
        kegels.instructions = "Perform kegel exercies"

        store.addTasks([nausea, doxylamine, kegels])

        var contact1 = OCKContact(identifier: "jane", givenName: "Jane",
                                  familyName: "Daniels", carePlanID: nil)
        contact1.asset = "JaneDaniels"
        contact1.title = "Family Practice Doctor"
        contact1.role = "Dr. Daniels is a family practice doctor with 8 years of experience."
        contact1.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "janedaniels@icloud.com")]
        contact1.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]
        contact1.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]

        contact1.address = {
            let address = OCKPostalAddress()
            address.street = "2598 Reposa Way"
            address.city = "San Francisco"
            address.state = "CA"
            address.postalCode = "94127"
            return address
        }()

        var contact2 = OCKContact(identifier: "matthew", givenName: "Matthew",
                                  familyName: "Reiff", carePlanID: nil)
        contact2.asset = "MatthewReiff"
        contact2.title = "OBGYN"
        contact2.role = "Dr. Reiff is an OBGYN with 13 years of experience."
        contact2.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]
        contact2.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(324) 555-7415")]
        contact2.address = {
            let address = OCKPostalAddress()
            address.street = "396 El Verano Way"
            address.city = "San Francisco"
            address.state = "CA"
            address.postalCode = "94127"
            return address
        }()

        store.addContacts([contact1, contact2])
    }
}

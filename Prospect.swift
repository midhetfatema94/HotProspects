//
//  Prospect.swift
//  HotProspects
//
//  Created by Waveline Media on 1/12/21.
//

import SwiftUI

class Prospect: Codable, Identifiable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var timestamp = Date()
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    static let userDefaultKey = "SavedData"
    
    enum SortBy { case name, recent }
    
    init() {
        
        self.people = []
        
        if let data = UserDefaults.standard.data(forKey: Self.userDefaultKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
            }
        }
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(self.people) {
            UserDefaults.standard.set(encoded, forKey: Self.userDefaultKey)
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add(_ prospect: Prospect) {
        self.people.append(prospect)
        self.save()
    }
    
    func sort(by: SortBy) {
        switch by {
        case .name:
            people.sort(by: { (lhs, rhs) -> Bool in
                return lhs.name < rhs.name
            })
        case .recent:
            people.sort(by: { (lhs, rhs) -> Bool in
                return lhs.timestamp > rhs.timestamp
            })
        }
    }
}

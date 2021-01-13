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
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    static let userDefaultKey = "SavedData"
    
    
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
}

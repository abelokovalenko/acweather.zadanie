//
//  CDStorage.swift
//  ACWeather.Zadanie
//
//  Created by Andrey Belokovalenko on 06/02/2024.
//

import Foundation
import CoreData

class CDStorage: Storage {
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Storage")
        container.loadPersistentStores {
            (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
      return self.storeContainer.viewContext
    }()
    
    var count: Int {
        let fetchRequest = StoredCity.fetchRequest()
        fetchRequest.resultType = .countResultType
        return (try? managedContext.count(for: fetchRequest)) ?? 0
    }
    
    func city(at: Int) -> City? {
        let fetchRequest = StoredCity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \StoredCity.date_displayed,
                                                         ascending: false)]

        if let city = try? managedContext.fetch(fetchRequest)[safe: at] {
            return City(key: city.key!, description: city.country, name: city.name)
        }
        
        return nil
    }
    
    func append(city: City) {
        let fetchRequest = StoredCity.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "%K == %@",
                                             argumentArray: [#keyPath(StoredCity.key), (city.key)]) 
        if let existing = try? managedContext.fetch(fetchRequest).first {
            existing.touch()
        } else {
            let newCity = StoredCity(context: managedContext)
            newCity.key = city.key
            newCity.name = city.name
            newCity.country = city.description
            newCity.touch()
        }
        try? managedContext.save()
    }
    
    func delete(city: City) {
        let fetchRequest = StoredCity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(\StoredCity.key) = \(city.key)")
        if let existing = try? managedContext.fetch(fetchRequest).first {
            managedContext.delete(existing)
            try? managedContext.save()
        }
    }
}

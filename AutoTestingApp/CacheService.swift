//
//  CacheService.swift
//  AutoTestingApp
//
//  Created by Stepan Ostapenko on 08.08.2023.
//

import Foundation
import CoreData

class CacheService {
    private let container = NSPersistentContainer(name: "AutoTestingApp")
    private let context: NSManagedObjectContext
    
    init() {
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        context = container.viewContext
        fillDatabase()
    }
    
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getNewAuto() -> Auto {
        return Auto(context: context)
    }
    
    func getFetchResultsController(request: NSFetchRequest<Auto>) -> NSFetchedResultsController<Auto> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func fillDatabase() {
        var objects: [NSManagedObject]
       
        do {
            objects = try context.fetch(Auto.fetchRequest())
            
            if objects.isEmpty {
                let a = Auto(context: context)
                a.distributor = "Audi"
                a.mark = "A7"
                a.price = 1
                
                let b = Auto(context: context)
                b.distributor = "Mercedes"
                b.mark = "Yo"
                b.price = 2
                
                let c = Auto(context: context)
                c.distributor = "Lada"
                c.mark = "Trash"
                c.price = 3
                
                saveContext()
            }
        } catch {
            print("error")
        }
    }
}

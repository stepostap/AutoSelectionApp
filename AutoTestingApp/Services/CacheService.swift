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
                let a = getNewAuto()
                a.distributor = "Audi"
                a.mark = "A7"
                a.price = 2500000.0
                a.driveType = .front
                a.acceleration = 8.3
                a.power = 204
                a.height = 1422
                a.width = 1908
                a.length = 4969
                
                let b = getNewAuto()
                b.distributor = "Mercedes"
                b.mark = "GL 400"
                b.price = 3000000.0
                b.driveType = .full
                b.acceleration = 6.7
                b.power = 333
                b.height = 1850
                b.width = 1934
                b.length = 5120
                
                let c = getNewAuto()
                c.distributor = "Mercedes"
                c.mark = "CL 600"
                c.price = 1500000.0
                c.driveType = .rear
                c.acceleration = 4.6
                c.power = 517
                c.height = 1419
                c.width = 1871
                c.length = 5065
                
                let d = getNewAuto()
                d.distributor = "Mercedes"
                d.mark = "Viano 3.5"
                d.price = 2000000.0
                d.driveType = .rear
                d.acceleration = 10.4
                d.power = 258
                d.height = 2200
                d.width = 2060
                d.length = 6300
                
                let e = getNewAuto()
                e.distributor = "Audi"
                e.mark = "A3 Sportback"
                e.price = 1620000.0
                e.driveType = .front
                e.acceleration = 8.3
                e.power = 150
                e.height = 1436
                e.width = 1785
                e.length = 4313
                
                let f = getNewAuto()
                f.distributor = "Audi"
                f.mark = "A5"
                f.price = 3200000.0
                f.driveType = .front
                f.acceleration = 7.2
                f.power = 190
                f.height = 1371
                f.width = 1846
                f.length = 4673
                
                let g = getNewAuto()
                g.distributor = "Honda"
                g.mark = "Accord"
                g.price = 1200000.0
                g.driveType = .front
                g.acceleration = 7.8
                g.power = 192
                g.height = 1450
                g.width = 1862
                g.length = 4882
                
                let h = getNewAuto()
                h.distributor = "Honda"
                h.mark = "Jazz"
                h.price = 800000.0
                h.driveType = .front
                h.acceleration = 11.2
                h.power = 102
                h.height = 1550
                h.width = 1694
                h.length = 3995

                let i = getNewAuto()
                i.distributor = "Honda"
                i.mark = "Jazz"
                i.price = 750000.0
                i.driveType = .front
                i.acceleration = 11.6
                i.power = 98
                i.height = 1559
                i.width = 1696
                i.length = 3997
                
                let j = getNewAuto()
                j.distributor = "Honda"
                j.mark = "Jazz"
                j.price = 850000.0
                j.driveType = .front
                j.acceleration = 11.0
                j.power = 115
                j.height = 1550
                j.width = 1694
                j.length = 4001
                
                saveContext()
            }
        } catch {
            print("error")
        }
    }
}

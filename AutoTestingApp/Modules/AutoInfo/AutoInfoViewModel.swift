//
//  AutoInfoViewModel.swift
//  AutoTestingApp
//
//  Created by Stepan Ostapenko on 06.08.2023.
//

import Foundation
import RxCocoa
import RxSwift

class AutoInfoViewModel {
    internal init(cacheService: CacheService, auto: Auto?) {
        self.cacheService = cacheService
        self.auto = auto
        
        if let auto = auto {
            markSubject = BehaviorSubject(value: auto.mark ?? "")
            distributorSubject = BehaviorSubject(value: auto.distributor ?? "")
            powerSubject = BehaviorSubject(value: auto.power.description)
            accelerationSubject = BehaviorSubject(value: auto.acceleration.description)
            driveTypeSubject = BehaviorSubject(value: auto.driveType)
            lenSubject = BehaviorSubject(value: auto.length.description)
            widthSubject = BehaviorSubject(value: auto.width.description)
            heightSubject = BehaviorSubject(value: auto.height.description)
            priceSubject = BehaviorSubject(value: auto.price.description)
        } else {
            markSubject = BehaviorSubject(value: "")
            distributorSubject = BehaviorSubject(value: "")
            powerSubject = BehaviorSubject(value: "")
            accelerationSubject = BehaviorSubject(value: "")
            driveTypeSubject = BehaviorSubject(value: .front)
            lenSubject = BehaviorSubject(value: "")
            widthSubject = BehaviorSubject(value: "")
            heightSubject = BehaviorSubject(value: "")
            priceSubject = BehaviorSubject(value: "")
        }
    }
    
    var auto: Auto?
    private let cacheService: CacheService
    
    var markSubject: BehaviorSubject<String>
    private var validMark: Observable<Bool> {
        markSubject.map({ !$0.isEmpty })
    }
    
    var distributorSubject: BehaviorSubject<String>
    private var validDistributor: Observable<Bool> {
        distributorSubject.map({ !$0.isEmpty })
    }
    
    var priceSubject: BehaviorSubject<String>
    private var validPrice: Observable<Bool> {
        priceSubject.map({ self.validDouble(str: $0) })
    }
    
    var driveTypeSubject: BehaviorSubject<DriveType>
    
    var accelerationSubject: BehaviorSubject<String>
    private var validAcceleration: Observable<Bool> {
        accelerationSubject.map({ self.validDouble(str: $0) })
    }
    
    var heightSubject: BehaviorSubject<String>
    private var validHeight: Observable<Bool> {
        heightSubject.map({ self.validInt(str: $0) })
    }
    
    var widthSubject: BehaviorSubject<String>
    private var validWidth: Observable<Bool> {
        widthSubject.map({ self.validInt(str: $0) })
    }
    
    var lenSubject: BehaviorSubject<String>
    private var validLen: Observable<Bool> {
        lenSubject.map({ self.validInt(str: $0) })
    }
    
    var powerSubject: BehaviorSubject<String>
    private var validPower: Observable<Bool> {
        powerSubject.map({ self.validInt(str: $0) })
    }
    
    var validInfo: Observable<Bool> {
        Observable.combineLatest(validLen, validMark, validPower, validWidth, validHeight, validDistributor, validAcceleration, validPrice).map({$0.0 && $0.1 && $0.2 && $0.3 && $0.4 && $0.5 && $0.6 && $0.7})
    }
    
    func save() {
        if let auto = auto {
            fillAutoInfo(auto: auto)
        } else {
            let newAuto = cacheService.getNewAuto()
            fillAutoInfo(auto: newAuto)
        }
        cacheService.saveContext()
    }
    
    // MARK: - Private methods
    
    private func validInt(str: String) -> Bool {
        let int = Int16(str)
        return int ?? -1 > 0
    }
    
    private func validDouble(str: String) -> Bool {
        let double = Double(str)
        return double ?? -1 > 0
    }

    private func fillAutoInfo(auto: Auto) {
        do {
            auto.driveType = try driveTypeSubject.value()
            auto.acceleration = try Double(accelerationSubject.value())!
            auto.power = try Int16(powerSubject.value())!
            auto.distributor = try distributorSubject.value()
            auto.mark = try markSubject.value()
            auto.length = try Int16(lenSubject.value())!
            auto.width = try Int16(widthSubject.value())!
            auto.height = try Int16(heightSubject.value())!
        } catch {
            fatalError()
        }
    }
}

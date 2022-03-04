import Foundation


enum CylindersScheme: String {
    case V4
    case V6
    case V8
    case V10
    case V12
    case Line4
    case Line6
    case Line8
}


class Engine {
    
    private(set) var power: Double
    private(set) var cylindersScheme: CylindersScheme
    private(set) var fuelConsumption: Double
    
    init(power: Double, cylinderScheme: CylindersScheme, fuelConsumption: Double) {
        self.power = power
        self.cylindersScheme = cylinderScheme
        self.fuelConsumption = fuelConsumption
    }
    
    func upgrade(newPower: Double) {
        self.power = newPower
    }
}


class DieselEngine : Engine {
    
}


enum GEType: String {
    case carburetor
    case injection
    case directInjection
}


class GasolineEngine : Engine {

    var type: GEType
    
    init(power: Double, cylinderScheme: CylindersScheme, fuelConsumption: Double, type: GEType) {
        self.type = type
        super.init(power: power, cylinderScheme: cylinderScheme, fuelConsumption: fuelConsumption)
    }
}


enum DriveUnit: String {
    case rear
    case front
    case four
}


class Car {

    private(set) var engine: Engine
    private(set) var driveUnit: DriveUnit
    private(set) var mileage: Double
    private(set) var fuel: Double
    private(set) var manufactorer: String
    
    private let maxFuel: Double

    init(engine: Engine, driveUnit: DriveUnit, maxFuel: Double, manufactorer: String) {
        self.engine = engine
        self.driveUnit = driveUnit
        self.mileage = 0
        self.fuel = 0
        self.maxFuel = maxFuel
        self.manufactorer = manufactorer
    }
    
    func move(distance: Double) -> Bool {
        if distance <= 0 {
            print("Stop roll up the mileage!!!")
            return false
        }

        if fuel <= 0 {
            print("Refuel me please!!!")
            return false
        }

        fuel -= engine.fuelConsumption / 100 * distance
        mileage += distance
        return true
    }
    
    func refuel(fuelQuantity: Double) {
        if fuel + fuelQuantity > maxFuel {
            fuel = maxFuel
        } else {
            fuel += fuelQuantity
        }
    }
    
    func upgradeEngine(newPower: Double) {
        engine.upgrade(newPower: newPower)
    }

    func changeEngine(newEngine: Engine) {
        engine = newEngine
    }
}


class Sedan: Car {
    func transpotPassengers(passengersCount: Int, distance: Double) {
        if passengersCount > 4 {
            print("Please, stop! Rent a bus to transport \(passengersCount) passengers!")
            return
        }

        if move(distance: distance) {
            print("Let's go my dear passengers!")
        }
    }
}


class Offroad: Car {
    func moveToOffroad(distance: Double) {
        if move(distance: distance * 1.2) {
            print("Vroom vroom, I'm offroad!")
        }
    }
}


class Bus: Car {
    func transportManyPassengers(passengersCount: Int, distance: Double) {
        if move(distance: distance) {
            print("I can transport many people! And \(passengersCount) passengers too!")
        }
    }
}


class Truck: Car {
    func transportCargo(cargoWeight: Double, distance: Double) {
        if move(distance: distance + cargoWeight / 5) {
            print("I'm strong! I'm transport cargo weighing \(cargoWeight) tons!")
        }
    }
}


enum CarType: String {
    case sedan
    case offroad
    case bus
    case truck
}


class Factory {

    var carCounter: Int
    var name: String

    init(name: String) {
        self.carCounter = 0
        self.name = name
    }

    func releaseCar(carType: CarType, engine: Engine, driveUnit: DriveUnit, maxFuel: Double) -> Car {
        carCounter += 1
        switch carType {
        case .sedan:
            return Sedan(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self.name)
        case .offroad:
            return Offroad(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self.name)
        case .bus:
            return Bus(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self.name)
        case .truck:
            return Truck(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self.name)
        }
    }
}


let factory = Factory(name: "Factory1")

let offroadEngine = DieselEngine(power: 320, cylinderScheme: .V6, fuelConsumption: 9.0)
let offroad = factory.releaseCar(carType: .offroad, engine: offroadEngine, driveUnit: .four, maxFuel: 90) as? Offroad

offroad?.refuel(fuelQuantity: 40)
offroad?.moveToOffroad(distance: 10)


let truckEngine = DieselEngine(power: 450, cylinderScheme: .V10, fuelConsumption: 15.0)
let truck = factory.releaseCar(carType: .truck, engine: truckEngine, driveUnit: .four, maxFuel: 200) as? Truck

truck?.refuel(fuelQuantity: 70)
truck?.transportCargo(cargoWeight: 20, distance: 5)


let busEngine = DieselEngine(power: 400, cylinderScheme: .V10, fuelConsumption: 12.0)
let bus = factory.releaseCar(carType: .bus, engine: busEngine, driveUnit: .four, maxFuel: 220) as? Bus

bus?.refuel(fuelQuantity: 40)
bus?.transportManyPassengers(passengersCount: 20, distance: 30)


let sedanEngine = GasolineEngine(power: 160, cylinderScheme: .Line4, fuelConsumption: 8.0, type: .injection)
let sedan = factory.releaseCar(carType: .sedan, engine: truckEngine, driveUnit: .front, maxFuel: 60) as? Sedan

sedan?.refuel(fuelQuantity: 30)
sedan?.transpotPassengers(passengersCount: 4, distance: 10)

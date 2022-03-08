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


enum EngineType: String {
    case diesel
    case gasolineCarburetor
    case gasolineInjection
    case gasolineDirectInjection
}


struct Engine {

    private(set) var power: Double
    private(set) var cylindersScheme: CylindersScheme
    private(set) var type: EngineType
    private(set) var fuelConsumption: Double

    init(power: Double, cylinderScheme: CylindersScheme, fuelConsumption: Double, type: EngineType) {
        self.power = power
        self.cylindersScheme = cylinderScheme
        self.fuelConsumption = fuelConsumption
        self.type = type
    }

    mutating func upgrade(newPower: Double) {
        self.power = newPower
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
    private(set) var manufactorer: Factory
    
    private let maxFuel: Double

    init(engine: Engine, driveUnit: DriveUnit, maxFuel: Double, manufactorer: Factory) {
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

    private var _carCounter: Int
    private var _name: String
    private var _sedanParking: [Sedan]
    private var _offroadParking: [Offroad]
    private var _busParking: [Bus]
    private var _truckParking: [Truck]
    
    var carCounter: Int {
        get {
            return _carCounter
        }
    }
    var name: String {
        get {
            return _name
        }
    }

    init(name: String) {
        _name = name
        _carCounter = 0
        _sedanParking = []
        _offroadParking = []
        _busParking = []
        _truckParking = []
    }

    private func createSedan(engine: Engine, driveUnit: DriveUnit, maxFuel: Double) -> Void {
        _sedanParking.append(
            Sedan(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self)
        )
    }

    private func createOffroad(engine: Engine, driveUnit: DriveUnit, maxFuel: Double) -> Void {
        _offroadParking.append(
            Offroad(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self)
        )
    }

    private func createBus(engine: Engine, driveUnit: DriveUnit, maxFuel: Double) -> Void {
        _busParking.append(
            Bus(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self)
        )
    }

    private func createTruck(engine: Engine, driveUnit: DriveUnit, maxFuel: Double) -> Void {
        _truckParking.append(
            Truck(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self)
        )
    }

    func releaseCars(carType: CarType, engine: Engine, driveUnit: DriveUnit, maxFuel: Double, carsCount: Int) -> Void {
        for _ in 0..<carsCount {
            _carCounter += 1

            switch carType {
            case .sedan:
                createSedan(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel)
            case .offroad:
                createOffroad(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel)
            case .bus:
                createBus(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel)
            case .truck:
                createTruck(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel)
            }
        }
    }

    func getReleasedSedans() -> [Sedan] {
        var result: [Sedan] = []

        for _ in 0..<_sedanParking.count {
            result.append(_sedanParking.removeLast())
        }

        return result
    }
    
    func getReleasedOffroads() -> [Offroad] {
        var result: [Offroad] = []

        for _ in 0..<_offroadParking.count {
            result.append(_offroadParking.removeLast())
        }

        return result
    }

    func getReleasedBuses() -> [Bus] {
        var result: [Bus] = []

        for _ in 0..<_busParking.count {
            result.append(_busParking.removeLast())
        }

        return result
    }

    func getReleasedTrucks() -> [Truck] {
        var result: [Truck] = []

        for _ in 0..<_truckParking.count {
            result.append(_truckParking.removeLast())
        }

        return result
    }
}

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


struct SteeringWheel {

    private(set) var rotationDegree: Float = 0

    let maxRotatingDegree: Float = 480.0

    // Static Dispatch
    func getRotationDegree() -> Float {
        return rotationDegree
    }
    
    mutating func rotateRight(degree: Float) -> Void {
        if degree < 0 {
            rotateLeft(degree: degree)
        }
        
        let newRotating = self.rotationDegree + degree
        self.rotationDegree = newRotating > maxRotatingDegree ? maxRotatingDegree : newRotating
    }
    
    mutating func rotateLeft(degree: Float) -> Void {
        if degree < 0 {
            rotateRight(degree: degree)
        }

        let newRotating = self.rotationDegree - degree
        self.rotationDegree = newRotating < -maxRotatingDegree ? -maxRotatingDegree : newRotating
    }
}


enum DriveUnit: String {
    case rear
    case front
    case four
}


enum Season {
    case summer
    case winter
}


struct Wheel {

    var radius: Int
    var width: Float
}


struct WheelAxle {

    var leftWheel: Wheel
    var rightWheel: Wheel
}


struct Wheelbase {

    private(set) var frontAxleRotatingProcent: Float = 0
    
    var wheelAxles: [WheelAxle]

    let maxRotateProcent: Float = 100.0

    init(axlesCount: Int, wheel: Wheel) {
        self.wheelAxles = []

        for _ in 0..<axlesCount {
            let rightWheel: Wheel = wheel
            let leftWheel: Wheel = wheel
            let newAxle: WheelAxle = WheelAxle(leftWheel: leftWheel, rightWheel: rightWheel)
            wheelAxles.append(newAxle)
        }
    }

    mutating func rotateRight(procent: Float) {
        if procent < 0 {
            rotateLeft(procent: procent)
        }

        let newRotating = self.frontAxleRotatingProcent + procent
        self.frontAxleRotatingProcent = newRotating > frontAxleRotatingProcent ? maxRotateProcent : newRotating
    }

    mutating func rotateLeft(procent: Float) {
        if procent < 0 {
            rotateRight(procent: procent)
        }

        let newRotating = self.frontAxleRotatingProcent - procent
        self.frontAxleRotatingProcent = newRotating < -frontAxleRotatingProcent ? -maxRotateProcent : newRotating
    }

    mutating func changeLeftWheel(wheel: Wheel, axleNum: Int) -> Bool {
        if (wheelAxles.count - 1 < axleNum || wheelAxles.count - 1 > axleNum) {
            return false
        }

        wheelAxles[axleNum].leftWheel = wheel
        return true
    }

    mutating func changeRightWheel(wheel: Wheel, axleNum: Int) -> Bool {
        if (wheelAxles.count - 1 < axleNum || wheelAxles.count - 1 > axleNum) {
            return false
        }

        wheelAxles[axleNum].rightWheel = wheel
        return true
    }
}


protocol Car {
    var engine: Engine { get set }
    var driveUnit: DriveUnit { get set }
    var mileage: Double { get set }
    var fuel: Double { get set }
    var manufactorer: Factory { get set }
    var maxFuel: Double { get set }
    var steeringWheel: SteeringWheel { get set }
    var wheelbase: Wheelbase { get set }

    // Witness Table Dispatch
    mutating func move(distance: Double) -> Bool
    mutating func refuel(fuelQuantity: Double)
    mutating func upgradeEngine(newPower: Double)
    mutating func turnSteeringWheelLeft(degree: Float)
    mutating func changeLeftWheel(wheel: Wheel, axleNum: Int)
    mutating func changeRightWheel(wheel: Wheel, axleNum: Int)
}

extension Car {

    mutating func move(distance: Double) -> Bool {
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

    mutating func refuel(fuelQuantity: Double) {
        if fuel + fuelQuantity > maxFuel {
            fuel = maxFuel
        } else {
            fuel += fuelQuantity
        }
    }
    
    mutating func upgradeEngine(newPower: Double) {
        engine.upgrade(newPower: newPower)
    }

    mutating func changeEngine(newEngine: Engine) {
        engine = newEngine
    }

    mutating func turnSteeringWheelLeft(degree: Float) {
        let frontWheelsTurnProcent = degree / steeringWheel.maxRotatingDegree * 100
    
        steeringWheel.rotateLeft(degree: degree)
        wheelbase.rotateLeft(procent: frontWheelsTurnProcent)
    }
    
    mutating func changeLeftWheel(wheel: Wheel, axleNum: Int) {
        self.wheelbase.changeLeftWheel(wheel: wheel, axleNum: axleNum)
    }

    mutating func changeRightWheel(wheel: Wheel, axleNum: Int) {
        self.wheelbase.changeRightWheel(wheel: wheel, axleNum: axleNum)
    }
}


protocol CityMode {
    var cityModeOn: Bool { get set }
    
    mutating func onCityMode()
    mutating func offCityMode()
}

extension CityMode {
    mutating func onCityMode() {
        cityModeOn = true
    }

    mutating func offCityMode() {
        cityModeOn = false
    }
}


struct Sedan: Car, CityMode {

    var steeringWheel: SteeringWheel
    var engine: Engine
    var driveUnit: DriveUnit
    var mileage: Double
    var fuel: Double
    var manufactorer: Factory
    var maxFuel: Double
    var wheelbase: Wheelbase
    var cityModeOn: Bool
    
    init(engine: Engine, driveUnit: DriveUnit, maxFuel: Double, manufactorer: Factory, wheelType: Wheel) {
        self.engine = engine
        self.driveUnit = driveUnit
        self.mileage = 0
        self.fuel = 0
        self.maxFuel = maxFuel
        self.manufactorer = manufactorer
        self.steeringWheel = SteeringWheel()
        self.wheelbase = Wheelbase(axlesCount: 2, wheel: wheelType)
        self.cityModeOn = false
    }

    mutating func transpotPassengers(passengersCount: Int, distance: Double) {
        if passengersCount > 4 {
            print("Please, stop! Rent a bus to transport \(passengersCount) passengers!")
            return
        }

        if move(distance: distance) {
            print("Let's go my dear passengers!")
        }
    }
}

protocol DownshiftMode {
    var downshiftMode: Bool { get set }
    
    mutating func onDownshiftMode()
    mutating func offDownshiftMode()
}

extension DownshiftMode {
    mutating func onDownshiftMode() {
        downshiftMode = true
    }

    mutating func offDownshiftMode() {
        downshiftMode = false
    }
}


struct Offroad: Car, DownshiftMode {
    var engine: Engine
    var driveUnit: DriveUnit
    var mileage: Double
    var fuel: Double
    var manufactorer: Factory
    var maxFuel: Double
    var steeringWheel: SteeringWheel
    var wheelbase: Wheelbase
    var downshiftMode: Bool

    init(engine: Engine, driveUnit: DriveUnit, maxFuel: Double, manufactorer: Factory, wheelType: Wheel) {
        self.engine = engine
        self.driveUnit = driveUnit
        self.mileage = 0
        self.fuel = 0
        self.maxFuel = maxFuel
        self.manufactorer = manufactorer
        self.steeringWheel = SteeringWheel()
        self.wheelbase = Wheelbase(axlesCount: 2, wheel: wheelType)
        self.downshiftMode = false
    }

    mutating func moveToOffroad(distance: Double) {
        onDownshiftMode()

        if move(distance: distance * 1.2) {
            print("Vroom vroom, I'm offroad!")
        }

        offDownshiftMode()
    }
}


protocol PassangerTransport {
    var passengerSeatsCount: Int { get set }
    var passengersCount: Int { get set }
    
    mutating func addPassengers(count: Int) -> Bool
    mutating func dropOffPassengers(count: Int) -> Bool
}

extension PassangerTransport {
    mutating func addPassengers(count: Int) -> Bool {
        if (passengersCount + count > passengerSeatsCount) {
            print("I can't accommodate more than \(passengerSeatsCount) passangers!")
            return false
        }
        
        passengersCount += count
        return true
    }

    mutating func dropOffPassengers(count: Int) -> Bool {
        if (passengersCount - count < 0) {
            print("I can't drop off more than \(passengersCount) passangers!")
            return false
        }
        
        passengersCount -= count
        return true
    }
}


struct Bus: Car, PassangerTransport {

    var engine: Engine
    var driveUnit: DriveUnit
    var mileage: Double
    var fuel: Double
    var manufactorer: Factory
    var maxFuel: Double
    var steeringWheel: SteeringWheel
    var wheelbase: Wheelbase
    var passengerSeatsCount: Int
    var passengersCount: Int

    init(engine: Engine, driveUnit: DriveUnit, maxFuel: Double, manufactorer: Factory, wheelType: Wheel, wheelAxlesCount: Int, passengerSeatsCount: Int) {
        self.engine = engine
        self.driveUnit = driveUnit
        self.mileage = 0
        self.fuel = 0
        self.maxFuel = maxFuel
        self.manufactorer = manufactorer
        self.steeringWheel = SteeringWheel()
        self.wheelbase = Wheelbase(axlesCount: wheelAxlesCount, wheel: wheelType)
        self.passengersCount = 0
        self.passengerSeatsCount = passengerSeatsCount
    }
    
    mutating func transportManyPassengers(passengersCount: Int, distance: Double) {
        addPassengers(count: passengersCount)

        if move(distance: distance) {
            print("I can transport many people! And \(self.passengersCount) passengers too!")
        }

        dropOffPassengers(count: passengersCount)
    }
}


protocol FreightTransport {
    var cargoCapacity: Float { get set }
    var currentCargoHeight: Float { get set }
    var isCargoСompartmentOpen: Bool { get set }
    
    mutating func loadCargo(cargoHeight: Float) -> Bool
    mutating func unloadCargo(cargoHeight: Float) -> Bool
    mutating func openCargoCompartment()
    mutating func closeCargoСompartment()
}

extension FreightTransport {
    mutating func loadCargo(cargoHeight: Float) -> Bool {
        if (currentCargoHeight + cargoHeight > cargoCapacity) {
            print("I can't load more than \(cargoCapacity) tons of cargo!")
            return false
        }

        currentCargoHeight += cargoHeight
        return true
    }

    mutating func unloadCargo(cargoHeight: Float) -> Bool {
        if (currentCargoHeight - cargoHeight < 0) {
            print("I can't unload more than \(currentCargoHeight) tons of cargo!")
            return false
        }

        currentCargoHeight -= cargoHeight
        return true
    }
    
    mutating func openCargoCompartment() {
        isCargoСompartmentOpen = true
    }

    mutating func closeCargoСompartment() {
        isCargoСompartmentOpen = false
    }
}


struct Truck: Car, FreightTransport {

    var engine: Engine
    var driveUnit: DriveUnit
    var mileage: Double
    var fuel: Double
    var manufactorer: Factory
    var maxFuel: Double
    var steeringWheel: SteeringWheel
    var wheelbase: Wheelbase
    var cargoCapacity: Float
    var currentCargoHeight: Float
    var isCargoСompartmentOpen: Bool

    init(engine: Engine, driveUnit: DriveUnit, maxFuel: Double, manufactorer: Factory, wheelType: Wheel, wheelAxlesCount: Int, cargoCapacity: Float) {
        self.engine = engine
        self.driveUnit = driveUnit
        self.mileage = 0
        self.fuel = 0
        self.maxFuel = maxFuel
        self.manufactorer = manufactorer
        self.steeringWheel = SteeringWheel()
        self.wheelbase = Wheelbase(axlesCount: wheelAxlesCount, wheel: wheelType)
        self.isCargoСompartmentOpen = false
        self.currentCargoHeight = 0
        self.cargoCapacity = cargoCapacity
    }

    mutating func transportCargo(cargoWeight: Double, distance: Double) {
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


protocol CarReleaseDelegate: AnyObject {
    func releaseCars(carType: CarType, engine: Engine, wheelType: Wheel, driveUnit: DriveUnit, maxFuel: Double, carsCount: Int)
    func getReleasedSedans(count: Int) -> [Sedan]
    func getReleasedOffroads(count: Int) -> [Offroad]
    func getReleasedBuses(count: Int) -> [Bus]
    func getReleasedTrucks(count: Int) -> [Truck]
}


class Factory: CarReleaseDelegate {
    private var sedanParking: [Sedan] = []
    private var offroadParking: [Offroad] = []
    private var busParking: [Bus] = []
    private var truckParking: [Truck] = []

    private(set) var carCounter: Int
    private(set) var name: String

    init(name: String) {
        self.name = name
        self.carCounter = 0
    }

    private func createSedan(engine: Engine, driveUnit: DriveUnit, maxFuel: Double) {
        sedanParking.append(
            Sedan(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self, wheelType: Wheel(radius: 16, width: 6.5))
        )
    }

    private func createOffroad(engine: Engine, driveUnit: DriveUnit, maxFuel: Double) {
        offroadParking.append(
            Offroad(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self, wheelType: Wheel(radius: 18, width: 7.5))
        )
    }

    private func createBus(engine: Engine, driveUnit: DriveUnit, maxFuel: Double) {
        busParking.append(
            Bus(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self, wheelType: Wheel(radius: 22, width: 7), wheelAxlesCount: 3, passengerSeatsCount: 30)
        )
    }

    private func createTruck(engine: Engine, driveUnit: DriveUnit, maxFuel: Double) {
        truckParking.append(
            Truck(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self, wheelType: Wheel(radius: 24, width: 8), wheelAxlesCount: 2, cargoCapacity: 20)
        )
    }

    func releaseCars(carType: CarType, engine: Engine, wheelType: Wheel, driveUnit: DriveUnit, maxFuel: Double, carsCount: Int) {
        for _ in 0..<carsCount {
            carCounter += 1

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

    func getReleasedSedans(count: Int) -> [Sedan] {
        var result: [Sedan] = []

        for _ in 0..<count {
            result.append(sedanParking.removeLast())
        }

        return result
    }
    
    func getReleasedOffroads(count: Int) -> [Offroad] {
        var result: [Offroad] = []

        for _ in 0..<count {
            result.append(offroadParking.removeLast())
        }

        return result
    }

    func getReleasedBuses(count: Int) -> [Bus] {
        var result: [Bus] = []

        for _ in 0..<count {
            result.append(busParking.removeLast())
        }

        return result
    }

    func getReleasedTrucks(count: Int) -> [Truck] {
        var result: [Truck] = []

        for _ in 0..<count {
            result.append(truckParking.removeLast())
        }

        return result
    }
}


class Dealer {

    private var sedanParking: [Sedan] = []
    private var offroadParking: [Offroad] = []
    private var busParking: [Bus] = []
    private var truckParking: [Truck] = []

    weak var factoryDelegate: CarReleaseDelegate?
    
    private(set) var name: String
    private(set) var address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }

    // Witness Table Dispatch
    func releaseCars(carType: CarType, engine: Engine, wheelType: Wheel, driveUnit: DriveUnit, maxFuel: Double, carsCount: Int) {
        if let factory = factoryDelegate {
            factory.releaseCars(carType: carType, engine: engine, wheelType: Wheel(radius: 16, width: 6.5), driveUnit: driveUnit, maxFuel: maxFuel, carsCount: carsCount)
            
            switch carType {
            case .sedan:
                sedanParking.append(contentsOf: factory.getReleasedSedans(count: carsCount))
            case .offroad:
                offroadParking.append(contentsOf: factory.getReleasedOffroads(count: carsCount))
            case .bus:
                offroadParking.append(contentsOf: factory.getReleasedOffroads(count: carsCount))
            case .truck:
                truckParking.append(contentsOf: factory.getReleasedTrucks(count: carsCount))
            }
        } else {
            print("Dialer \(name) don't have manufactorer!")
        }
    }

    func shipSedan() -> Sedan? {
        return sedanParking.popLast()
    }

    func shipOffroad() -> Offroad? {
        return offroadParking.popLast()
    }

    func shipBus() -> Bus? {
        return busParking.popLast()
    }

    func shipTruck() -> Truck? {
        return truckParking.popLast()
    }
}


var factory = Factory(name: "Factory1")
factory.releaseCars(carType: .offroad, engine: Engine(power: 250, cylinderScheme: .V6, fuelConsumption: 10, type: .diesel), wheelType: Wheel(radius: 16, width: 6.5), driveUnit: .four, maxFuel: 90, carsCount: 1)

var dealer = Dealer(name: "KIA", address: "Moscow")
dealer.factoryDelegate = factory

dealer.releaseCars(carType: .offroad, engine: Engine(power: 250, cylinderScheme: .V6, fuelConsumption: 10, type: .diesel), wheelType: Wheel(radius: 16, width: 6.5), driveUnit: .four, maxFuel: 90, carsCount: 1)

var dealer2 = Dealer(name: "BMW", address: "SPb")

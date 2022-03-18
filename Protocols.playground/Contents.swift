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


protocol CarStorageDelegate: AnyObject {
    func store(sedans: [Sedan])
    func store(offroads: [Offroad])
    func store(buses: [Bus])
    func store(trucks: [Truck])
}


class Factory {

    private(set) var carCounter: Int
    private(set) var name: String

    weak var storeDelegate: CarStorageDelegate?

    init(name: String) {
        self.name = name
        self.carCounter = 0
    }
    
    private func store(sedans: [Sedan]) {
        storeDelegate?.store(sedans: sedans)
    }

    private func store(offroads: [Offroad]) {
        storeDelegate?.store(offroads: offroads)
    }
    
    private func store(buses: [Bus]) {
        storeDelegate?.store(buses: buses)
    }
    
    private func store(trucks: [Truck]) {
        storeDelegate?.store(trucks: trucks)
    }

    private func createSedans(engine: Engine, driveUnit: DriveUnit, maxFuel: Double, count: Int) {
        var createdSedans: [Sedan] = []

        for _ in 1...count {
            createdSedans.append(
                Sedan(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self, wheelType: Wheel(radius: 16, width: 6.5))
            )
        }

        store(sedans: createdSedans)
    }

    private func createOffroads(engine: Engine, driveUnit: DriveUnit, maxFuel: Double, count: Int) {
        var createdOffroads: [Offroad] = []
        
        for _ in 1...count {
            createdOffroads.append(
                Offroad(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self, wheelType: Wheel(radius: 18, width: 7.5))
            )
        }
        
        store(offroads: createdOffroads)
    }

    private func createBuses(engine: Engine, driveUnit: DriveUnit, maxFuel: Double, count: Int) {
        var createdBuses: [Bus] = []

        for _ in 1...count {
            createdBuses.append(
                Bus(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self, wheelType: Wheel(radius: 22, width: 7), wheelAxlesCount: 3, passengerSeatsCount: 30)
            )
        }
        
        store(buses: createdBuses)
    }

    private func createTrucks(engine: Engine, driveUnit: DriveUnit, maxFuel: Double, count: Int) {
        var createdTrucks: [Truck] = []
        
        for _ in 1...count {
            createdTrucks.append(
                Truck(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, manufactorer: self, wheelType: Wheel(radius: 24, width: 8), wheelAxlesCount: 2, cargoCapacity: 20)
            )
        }
        
        store(trucks: createdTrucks)
    }

    func releaseCars(carType: CarType, engine: Engine, wheelType: Wheel, driveUnit: DriveUnit, maxFuel: Double, carsCount: Int) {
        switch carType {
        case .sedan:
            createSedans(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, count: carsCount)
        case .offroad:
            createOffroads(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, count: carsCount)
        case .bus:
            createBuses(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, count: carsCount)
        case .truck:
            createTrucks(engine: engine, driveUnit: driveUnit, maxFuel: maxFuel, count: carsCount)
        }
    }
}


class Dealer: CarStorageDelegate {

    private var sedanParking: [Sedan] = []
    private var offroadParking: [Offroad] = []
    private var busParking: [Bus] = []
    private var truckParking: [Truck] = []
    
    private(set) var name: String
    private(set) var address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
    
    func store(sedans: [Sedan]) {
        sedanParking.append(contentsOf: sedans)
    }
    
    func store(offroads: [Offroad]) {
        offroadParking.append(contentsOf: offroads)
    }
    
    func store(buses: [Bus]) {
        busParking.append(contentsOf: buses)
    }
    
    func store(trucks: [Truck]) {
        truckParking.append(contentsOf: trucks)
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

var dealer = Dealer(name: "KIA", address: "Moscow")
var factory = Factory(name: "Factory1")
factory.storeDelegate = dealer
factory.releaseCars(carType: .offroad, engine: Engine(power: 250, cylinderScheme: .V6, fuelConsumption: 10, type: .diesel), wheelType: Wheel(radius: 16, width: 6.5), driveUnit: .four, maxFuel: 90, carsCount: 1)

factory.releaseCars(carType: .offroad, engine: Engine(power: 250, cylinderScheme: .V6, fuelConsumption: 10, type: .diesel), wheelType: Wheel(radius: 16, width: 6.5), driveUnit: .four, maxFuel: 90, carsCount: 1)

var dealer2 = Dealer(name: "BMW", address: "SPb")


dealer.shipOffroad()

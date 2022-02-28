import Foundation


// Функция решения квадратичного уравнения
func getQuadEquationRoots(a: Double, b: Double, c: Double) -> Array<Double> {
    var roots: Array<Double> = []
    let d: Double = pow(b, 2) - 4 * a * c

    if (d > 0) {
        let squareRootD = sqrt(d)
    
        let root1: Double = (-b + squareRootD) / (2 * a)
        let root2: Double = (-b - squareRootD) / (2 * a)

        roots.append(root1)
        roots.append(root2)
    } else if (d == 0) {
        let root: Double = (-b) / (2 * a)
        roots.append(root)
    }

    return roots
}


let a: Double = 10
let b: Double = 28
let c: Double = -49

let roots: Array<Double> = getQuadEquationRoots(a: a, b: b, c: c)
let outStr = "Квадратичное равнение с коэфициентами a=\(a), b=\(b), c=\(c)"
if (roots.count <= 0) {
    print(outStr + " не имеет решения")
} else {
    print(outStr + " имеет корни:")
    for root in roots {
        print(root)
    }
}
print()


// Структура для хранения комплексных чисел
struct Complex {
    var real: Double
    var imaginary: Double
}

extension Complex: CustomStringConvertible {
    var description: String {
        let sign = imaginary.sign == .minus ? "-" : "+"
        return "\(real)" + (imaginary != 0 ? " \(sign) i\(abs(imaginary))" : "")
    }
}

// Функция решения квадратичного уравнения
func getThirdDegreeEquationRoots(a: Double, b: Double, c: Double, d: Double) -> Array<Complex> {
    var roots: Array<Complex> = []
    
    for _ in 0...2 {
        roots.append(Complex(real: 0, imaginary: 0))
    }
    
    let r: Double = b - (2 * pow(a, 3) - 9 * a * b + 27 * c) / 54
    let q: Double = (pow(a, 2) - 3 * b) / 9
    let rQuad: Double = r * r
    let qCube: Double = q * q
    let aDivThree = a / 3
    
    if (rQuad < qCube) {
        let t: Double = acos(r / sqrt(qCube)) / 3
        let qSqrt = sqrt(q)

        roots[0].real = -2 * qSqrt * cos(t) - aDivThree
        roots[1].real = -2 * qSqrt * cos(t + (2 * Double.pi / 3)) - aDivThree
        roots[2].real = -2 * qSqrt * cos(t - (2 * Double.pi / 3)) - aDivThree
    } else {
        let rSign: Double = r.sign == .minus ? -1.0 : 1.0
        let A: Double = -rSign * pow((abs(r) + sqrt(rQuad - qCube)), 1.0 / 3.0)
        let B: Double = a != 0 ? q / a : 0

        roots[0].real = (A + B) - a / 3
        
        if (A == B) { roots[1].real = -A - aDivThree }
        else {
            let real: Double = -( A + B) / 2 - aDivThree
            let imaginary: Double = sqrt(3) * ( A - B) / 2

            roots[1].real = real
            roots[2].real = real
            roots[1].imaginary = imaginary
            roots[2].imaginary = -imaginary
        }
        
        return roots
    }
    
    return roots
}


let aThird: Double = 1
let bThird: Double = 3
let cThird: Double = 4
let dThird: Double = 2

let rootsThird: Array<Complex> = getThirdDegreeEquationRoots(a: aThird, b: bThird, c: cThird, d: dThird)
print("Кубическое равнение с коэфициентами a=\(aThird), b=\(bThird), c=\(cThird), d=\(dThird) имеет корни:")
for root in rootsThird {
    if (root.real != 0 || root.imaginary != 0) { print(root) }
}
print()


// Функция получения чисел Фибоначчи
func getFibNumber(n: Int) -> (Int) {
    if (n < 3) {
        return 1
    }

    return getFibNumber(n: n - 1) + getFibNumber(n: n - 2)
}

// Функция формирования массива чисел Фибоначчи
func getFibArray(length: Int) -> Array<Int> {
    var result: Array<Int> = []
    
    for i in 1...length {
        result.append(getFibNumber(n: i))
    }
    
    return result
}

let fibLength: Int = 6
print("Массив из \(fibLength) чисел Фибоначчи:")
print(getFibArray(length: fibLength))
print()

// Фнкция получения простых чисел
func getSimpleNumbers(n: Int) -> Array<Int> {
    var numbers: Array<Int> = []
    
    for i in 0...n {
        numbers.append(i)
    }
    
    numbers[1] = 0
    var i: Int = 2
    while i < numbers.count {
        let p: Int = numbers[i]
        
        if (p != 0) {
            var a: Int = 2*p
            while (a < numbers.count) {
                numbers[a] = 0
                a += p
            }
        }
        
        i += 1
    }
    
    return numbers.filter { $0 != 0 }
}

let maxNumber: Int = 30
print(String(format: "Простые числа от 0 до %d:", arguments: [maxNumber]))
print(getSimpleNumbers(n: maxNumber))

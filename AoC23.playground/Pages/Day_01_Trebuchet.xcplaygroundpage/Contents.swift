import Foundation

guard let fileURL = Bundle.main.url(forResource: "CalibrationDocument", withExtension: "txt") else { fatalError("No file!") }
let fileContents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)

let calibrationValues = fileContents.split(separator: "\n")
print(calibrationValues)

let digits = /[1-9]+/

let extractedValues = calibrationValues.map { value in
    let digitRange = value.ranges(of: digits)
    guard let firstRange = digitRange.first,
          let lastRange = digitRange.last
    else { fatalError("No range!") }

    let firstValue = value[firstRange].prefix(1)
    let lastValue = value[lastRange].suffix(1)

    guard let intValue = Int(firstValue + lastValue) else { fatalError("No Int!") }
    print(intValue)
    return intValue
}

let sum = extractedValues.reduce(0, +)
print(sum)

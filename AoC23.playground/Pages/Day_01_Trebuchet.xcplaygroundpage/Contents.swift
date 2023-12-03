import Foundation

guard let fileURL = Bundle.main.url(forResource: "CalibrationDocument", withExtension: "txt") else { fatalError("No file!") }
let fileContents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)

let calibrationValues = fileContents.split(separator: "\n")
//print(calibrationValues)

let digits = /([1-9]|one|two|three|four|five|six|seven|eight|nine)/

func replace(letterDigit: Substring) -> Substring {
    letterDigit.replacing("one", with: "1")
        .replacing("two", with: "2")
        .replacing("three", with: "3")
        .replacing("four", with: "4")
        .replacing("five", with: "5")
        .replacing("six", with: "6")
        .replacing("seven", with: "7")
        .replacing("eight", with: "8")
        .replacing("nine", with: "9")
}

let extractedValues = calibrationValues.map { value in
    print("value: \(value)")
    let digitRange = value.ranges(of: digits)
    guard let firstRange = digitRange.first,
          let lastRange = digitRange.last
    else { fatalError("No range!") }

    print("first: \(value[firstRange])")
    let firstValue = replace(letterDigit: value[firstRange])

    print("last: \(value[lastRange])")
    let lastValue = replace(letterDigit: value[lastRange])

    guard let intValue = Int(firstValue + lastValue) else { fatalError("No Int!") }
    print("int: \(intValue)")
    print("---")
    return intValue
}

let sum = extractedValues.reduce(0, +)
print("sum: \(sum)")

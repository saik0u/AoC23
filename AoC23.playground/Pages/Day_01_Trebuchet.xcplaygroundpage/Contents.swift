import Foundation

guard let fileURL = Bundle.main.url(forResource: "CalibrationDocument", withExtension: "txt") else { fatalError("No file!") }
let fileContents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)

let calibrationValues = fileContents.split(separator: "\n")
//print(calibrationValues)

let digits = /([1-9]|one|two|three|four|five|six|seven|eight|nine)/
let digitsReversed = /([1-9]|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)/

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

    // First Digit
    let digitRange = value.ranges(of: digits)
    guard let firstRange = digitRange.first else { fatalError("No range!") }
    print("first: \(value[firstRange])")
    let firstValue = replace(letterDigit: value[firstRange])

    // Last Digit
    // This fixes edge cases like 'oneight'
    let valueReversed = Substring(value.reversed())
    guard let reversedRange = valueReversed.ranges(of: digitsReversed).first else { fatalError("No range!")}
    print("last: \(String(valueReversed[reversedRange].reversed()))")
    let lastValue = replace(letterDigit: Substring(valueReversed[reversedRange].reversed()))

    guard let intValue = Int(firstValue + lastValue) else { fatalError("No Int!") }
    print("int: \(intValue)")
    print("---")
    return intValue
}

let sum = extractedValues.reduce(0, +)
print("sum: \(sum)")

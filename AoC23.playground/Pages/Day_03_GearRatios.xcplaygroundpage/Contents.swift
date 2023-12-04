//: [Previous](@previous)
import Foundation

guard let fileURL = Bundle.main.url(forResource: "EngineSchematic", withExtension: "txt") else { fatalError("No file!") }
let fileContents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
let schematic = fileContents.split(separator: "\n")

let digits = /([10-999]+)/
let symbols = /(\*)/

let sum = schematic.map({ value in

    let currentRowDigitRanges = value.ranges(of: digits)
    let currentRowSymbolRanges = value.ranges(of: symbols)

    let currentIndex = schematic.firstIndex(of: value)!

    var partNum = 0

    for gearRange in currentRowSymbolRanges {
        var gearParts: [Int] = []

        for digitRange in currentRowDigitRanges {
            if gearRange.upperBound == digitRange.lowerBound ||
                gearRange.lowerBound == digitRange.upperBound,
               let int = Int(value[digitRange]) {
                gearParts.append(int)
            }
        }

        if currentIndex + 1 < schematic.count {
            let nextRow = schematic[currentIndex + 1]
            let nextRowDigitRanges = nextRow.ranges(of: digits)

            for digitRange in nextRowDigitRanges {
                let expandedGearRange = Range(uncheckedBounds: (
                    lower: nextRow.index(nextRow.startIndex, offsetBy: max(0, gearRange.lowerBound.utf16Offset(in: value) - 1)),
                    upper: nextRow.index(nextRow.startIndex, offsetBy: min(nextRow.count, gearRange.upperBound.utf16Offset(in: value) + 1))
                ))

                if expandedGearRange.overlaps(digitRange),
                   let int = Int(nextRow[digitRange]) {
                    gearParts.append(int)
                }
            }
        }

        if currentIndex - 1 >= 0 {
            let prevRow = schematic[currentIndex - 1]
            let prevRowDigitRanges = prevRow.ranges(of: digits)

            for digitRange in prevRowDigitRanges {
                let expandedDigitRange = Range(uncheckedBounds: (
                    lower: prevRow.index(prevRow.startIndex, offsetBy: max(0, gearRange.lowerBound.utf16Offset(in: value) - 1)),
                    upper: prevRow.index(prevRow.startIndex, offsetBy: min(prevRow.count, gearRange.upperBound.utf16Offset(in: value) + 1))
                ))

                if expandedDigitRange.overlaps(digitRange),
                   let int = Int(prevRow[digitRange]) {
                    gearParts.append(int)
                }
            }
        }

        if gearParts.count == 2,
           let first = gearParts.first,
           let second = gearParts.last {

            let ratio = first * second
            partNum += ratio
        }
    }

    return partNum
})
    .reduce(0, +)

print(sum)

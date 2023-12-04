//: [Previous](@previous)
import Foundation

guard let fileURL = Bundle.main.url(forResource: "EngineSchematic", withExtension: "txt") else { fatalError("No file!") }
let fileContents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
let schematic = fileContents.split(separator: "\n")

let digits = /([10-999]+)/
let symbols = /(@|#|\$|%|&|\*|-|=|\+|\/)/

var currentRow = 0

let sum = schematic.map({ value in

    let currentRowDigitRanges = value.ranges(of: digits)
    let currentRowSymbolRanges = value.ranges(of: symbols)

    let currentIndex = schematic.firstIndex(of: value)!

    var partNum: [Int] = []

    for digitRange in currentRowDigitRanges {

        for symbolRange in currentRowSymbolRanges {
            if digitRange.upperBound == symbolRange.lowerBound ||
                digitRange.lowerBound == symbolRange.upperBound,
               let int = Int(value[digitRange]) {

                partNum.append(int)
                break
            }
        }

        if currentIndex + 1 < schematic.count {
            let nextRow = schematic[currentIndex + 1]
            let nextRowSymbolRanges = nextRow.ranges(of: symbols)

            for symbolRange in nextRowSymbolRanges {
                let expandedDigitRange = Range(uncheckedBounds: (
                    lower: nextRow.index(nextRow.startIndex, offsetBy: max(0, digitRange.lowerBound.utf16Offset(in: value) - 1)),
                    upper: nextRow.index(nextRow.startIndex, offsetBy: min(nextRow.count, digitRange.upperBound.utf16Offset(in: value) + 1))
                ))

                if expandedDigitRange.overlaps(symbolRange),
                   let int = Int(value[digitRange]) {
                    partNum.append(int)
                    break
                }
            }
        }

        if currentIndex - 1 >= 0 {
            let prevRow = schematic[currentIndex - 1]
            let prevRowSymbolRanges = prevRow.ranges(of: symbols)

            for symbolRange in prevRowSymbolRanges {
                let expandedDigitRange = Range(uncheckedBounds: (
                    lower: prevRow.index(prevRow.startIndex, offsetBy: max(0, digitRange.lowerBound.utf16Offset(in: value) - 1)),
                    upper: prevRow.index(prevRow.startIndex, offsetBy: min(prevRow.count, digitRange.upperBound.utf16Offset(in: value) + 1))
                ))

                if expandedDigitRange.overlaps(symbolRange),
                   let int = Int(value[digitRange]) {
                    partNum.append(int)
                    break
                }
            }
        }
    }

    return partNum
})
    .flatMap { $0 }
    .reduce(0, +)

print(sum)

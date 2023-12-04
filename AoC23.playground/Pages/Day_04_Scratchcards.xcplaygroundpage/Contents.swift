//: [Previous](@previous)
import Foundation

guard let fileURL = Bundle.main.url(forResource: "Scratchcards", withExtension: "txt") else { fatalError("No file!") }
let fileContents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
let scratchcards = fileContents.split(separator: "\n")

let sum = scratchcards.map {
    let card = $0.split(separator: ":")
    let allNumbers = card.last?.split(separator: "|")

    guard let winningNumbers = allNumbers?.first?.split(separator: " ").compactMap ({ Int($0) }),
          let myNumbers = allNumbers?.last?.split(separator: " ").compactMap ({ Int($0) })
    else { fatalError("No numbers!") }

    let hits = myNumbers.compactMap { num in
        for win in winningNumbers {
            if num == win {
                return num
            }
        }
        return nil
    }

//    print("hit: \(hits)")

    var points = hits.count

    if hits.count > 1 {
        points = 1

        var i = hits.count - 1

        while i > 0 {
            points *= 2
            i -= 1
        }
    }

//    print("calced points: \(points)")

    return points
}
    .reduce(0, +)

print("sum: \(sum)")

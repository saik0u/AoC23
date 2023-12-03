//: [Previous](@previous)
import Foundation

guard let fileURL = Bundle.main.url(forResource: "Games", withExtension: "txt") else { fatalError("No file!") }
let fileContents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
//print(fileContents)

struct Cubes {
    let red: Int
    let green: Int
    let blue: Int
}

let possibleCubes = Cubes(red: 12, green: 13, blue: 14)

enum Color: String {
    case red
    case green
    case blue
}

let sum = fileContents
    .split(separator: "\n")
    .compactMap({
        let game = $0.split(separator: ":")

        guard let gameIdRaw = game.first?.split(separator: " ").last,
              let gameId = Int(String(gameIdRaw))
        else { fatalError("No gameId!") }

        var isValid = true

        game.last?.split(separator: ";").forEach {
            $0.split(separator: ",").forEach {

                let colors = $0.split(separator: " ")

                guard let countRaw = colors.first,
                      let count = Int(countRaw),
                      let colorRaw = colors.last,
                      let color = Color(rawValue: String(colorRaw))
                else { fatalError("No color!") }

                switch color {
                case .red:
                    if count > possibleCubes.red {
                        isValid = false
                    }
                case .green:
                    if count > possibleCubes.green {
                        isValid = false
                    }
                case .blue:
                    if count > possibleCubes.blue {
                        isValid = false
                    }
                }
            }
        }

        if isValid {
            return gameId
        }
        return nil
    })
    .reduce(0, +)

print("sum: \(sum)")

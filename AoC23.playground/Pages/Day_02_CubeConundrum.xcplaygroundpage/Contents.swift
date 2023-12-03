//: [Previous](@previous)
import Foundation

guard let fileURL = Bundle.main.url(forResource: "Games", withExtension: "txt") else { fatalError("No file!") }
let fileContents = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
//print(fileContents)

struct Cubes {
    var red: Int
    var green: Int
    var blue: Int
}

let possibleCubes = Cubes(red: 12, green: 13, blue: 14)

enum Color: String {
    case red
    case green
    case blue
}

let sum = fileContents
    .split(separator: "\n")
    .map({
        let game = $0.split(separator: ":")
        var topCubes = Cubes(red: 1, green: 1, blue: 1)

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
                    if count > topCubes.red {
                        topCubes.red = count
                    }
                case .green:
                    if count > topCubes.green {
                        topCubes.green = count
                    }
                case .blue:
                    if count > topCubes.blue {
                        topCubes.blue = count
                    }
                }
            }
        }

        return topCubes.red * topCubes.blue * topCubes.green
    })
    .reduce(0, +)

print("sum: \(sum)")

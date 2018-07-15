// Surf.Alarm

import Foundation
extension Double {
    func toSurfRange() -> String {
        let low = Int(floor(self))
        let high = Int(ceil(self))
        return "\(low) - \(high) ft"
    }
}

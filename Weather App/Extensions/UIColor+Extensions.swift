import UIKit

public extension UIColor {
    enum AppColor {
        case primary
        case error
    }

    static func app(_ color: AppColor) -> UIColor {
        switch color {
        case .primary:
            return custom(.black)
        case .error:
            return custom(.red)
        }
    }

    enum Color {
        // 12 12 12 #0c0c0c
        case black

        // 28 28 30 #1c1c1e
        case gray

        // 255 0 0 #ff0000
        case red
        
        // 255 255 255 #ffffff
        case white

        case transparentWhite
    }

    static func custom(_ color: Color) -> UIColor {
        switch color {
        case .black: return #colorLiteral(red: 0.047058823, green: 0.047058823, blue: 0.047058823, alpha: 1) // 12 12 12 #0c0c0c
        case .gray: return #colorLiteral(red: 0.10980392, green: 0.10980392, blue: 0.117647058, alpha: 1) // 28 28 30 #1c1c1e
        case .red: return #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1) // 255 0 0 #ff0000
        case .white: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // 255 255 255 #ffffff
        case .transparentWhite: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
        }
    }
}

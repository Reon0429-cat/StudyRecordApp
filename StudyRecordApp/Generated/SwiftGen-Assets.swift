// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let blackHeartBlack = ImageAsset(name: "Black-Heart-Black")
  internal static let blackHeartWhite = ImageAsset(name: "Black-Heart-White")
  internal static let blackWingBlack = ImageAsset(name: "Black-Wing-Black")
  internal static let blackWingWhite = ImageAsset(name: "Black-Wing-White")
  internal static let blackWingsBlack = ImageAsset(name: "Black-Wings-Black")
  internal static let blackWingsWhite = ImageAsset(name: "Black-Wings-White")
  internal static let blueHeartBlack = ImageAsset(name: "Blue-Heart-Black")
  internal static let blueHeartWhite = ImageAsset(name: "Blue-Heart-White")
  internal static let blueWingBlack = ImageAsset(name: "Blue-Wing-Black")
  internal static let blueWingWhite = ImageAsset(name: "Blue-Wing-White")
  internal static let blueWingsBlack = ImageAsset(name: "Blue-Wings-Black")
  internal static let blueWingsWhite = ImageAsset(name: "Blue-Wings-White")
  internal static let blueGreenHeartBlack = ImageAsset(name: "BlueGreen-Heart-Black")
  internal static let blueGreenHeartWhite = ImageAsset(name: "BlueGreen-Heart-White")
  internal static let blueGreenWingBlack = ImageAsset(name: "BlueGreen-Wing-Black")
  internal static let blueGreenWingWhite = ImageAsset(name: "BlueGreen-Wing-White")
  internal static let blueGreenWingsBlack = ImageAsset(name: "BlueGreen-Wings-Black")
  internal static let blueGreenWingsWhite = ImageAsset(name: "BlueGreen-Wings-White")
  internal static let blueGreenLightBlueHeartBlack = ImageAsset(name: "BlueGreen_LightBlue-Heart-Black")
  internal static let blueGreenLightBlueHeartWhite = ImageAsset(name: "BlueGreen_LightBlue-Heart-White")
  internal static let blueGreenLightBlueWingBlack = ImageAsset(name: "BlueGreen_LightBlue-Wing-Black")
  internal static let blueGreenLightBlueWingWhite = ImageAsset(name: "BlueGreen_LightBlue-Wing-White")
  internal static let blueGreenLightBlueWingsBlack = ImageAsset(name: "BlueGreen_LightBlue-Wings-Black")
  internal static let blueGreenLightBlueWingsWhite = ImageAsset(name: "BlueGreen_LightBlue-Wings-White")
  internal static let bluePurpleHeartBlack = ImageAsset(name: "Blue_Purple-Heart-Black")
  internal static let bluePurpleHeartWhite = ImageAsset(name: "Blue_Purple-Heart-White")
  internal static let bluePurpleWingBlack = ImageAsset(name: "Blue_Purple-Wing-Black")
  internal static let bluePurpleWingWhite = ImageAsset(name: "Blue_Purple-Wing-White")
  internal static let bluePurpleWingsBlack = ImageAsset(name: "Blue_Purple-Wings-Black")
  internal static let bluePurpleWingsWhite = ImageAsset(name: "Blue_Purple-Wings-White")
  internal static let blueYellowHeartBlack = ImageAsset(name: "Blue_Yellow-Heart-Black")
  internal static let blueYellowHeartWhite = ImageAsset(name: "Blue_Yellow-Heart-White")
  internal static let blueYellowWingBlack = ImageAsset(name: "Blue_Yellow-Wing-Black")
  internal static let blueYellowWingWhite = ImageAsset(name: "Blue_Yellow-Wing-White")
  internal static let blueYellowWingsBlack = ImageAsset(name: "Blue_Yellow-Wings-Black")
  internal static let blueYellowWingsWhite = ImageAsset(name: "Blue_Yellow-Wings-White")
  internal static let greenHeartBlack = ImageAsset(name: "Green-Heart-Black")
  internal static let greenHeartWhite = ImageAsset(name: "Green-Heart-White")
  internal static let greenWingBlack = ImageAsset(name: "Green-Wing-Black")
  internal static let greenWingWhite = ImageAsset(name: "Green-Wing-White")
  internal static let greenWingsBlack = ImageAsset(name: "Green-Wings-Black")
  internal static let greenWingsWhite = ImageAsset(name: "Green-Wings-White")
  internal static let greenYellowHeartBlack = ImageAsset(name: "Green_Yellow-Heart-Black")
  internal static let greenYellowHeartWhite = ImageAsset(name: "Green_Yellow-Heart-White")
  internal static let greenYellowWingBlack = ImageAsset(name: "Green_Yellow-Wing-Black")
  internal static let greenYellowWingWhite = ImageAsset(name: "Green_Yellow-Wing-White")
  internal static let greenYellowWingsBlack = ImageAsset(name: "Green_Yellow-Wings-Black")
  internal static let greenYellowWingsWhite = ImageAsset(name: "Green_Yellow-Wings-White")
  internal static let lightBlueHeartBlack = ImageAsset(name: "LightBlue-Heart-Black")
  internal static let lightBlueHeartWhite = ImageAsset(name: "LightBlue-Heart-White")
  internal static let lightBlueWingBlack = ImageAsset(name: "LightBlue-Wing-Black")
  internal static let lightBlueWingWhite = ImageAsset(name: "LightBlue-Wing-White")
  internal static let lightBlueWingsBlack = ImageAsset(name: "LightBlue-Wings-Black")
  internal static let lightBlueWingsWhite = ImageAsset(name: "LightBlue-Wings-White")
  internal static let lightBlueOrangeHeartBlack = ImageAsset(name: "LightBlue_Orange-Heart-Black")
  internal static let lightBlueOrangeHeartWhite = ImageAsset(name: "LightBlue_Orange-Heart-White")
  internal static let lightBlueOrangeWingBlack = ImageAsset(name: "LightBlue_Orange-Wing-Black")
  internal static let lightBlueOrangeWingWhite = ImageAsset(name: "LightBlue_Orange-Wing-White")
  internal static let lightBlueOrangeWingsBlack = ImageAsset(name: "LightBlue_Orange-Wings-Black")
  internal static let lightBlueOrangeWingsWhite = ImageAsset(name: "LightBlue_Orange-Wings-White")
  internal static let lightPinkHeartBlack = ImageAsset(name: "LightPink-Heart-Black")
  internal static let lightPinkHeartWhite = ImageAsset(name: "LightPink-Heart-White")
  internal static let lightPinkWingBlack = ImageAsset(name: "LightPink-Wing-Black")
  internal static let lightPinkWingWhite = ImageAsset(name: "LightPink-Wing-White")
  internal static let lightPinkWingsBlack = ImageAsset(name: "LightPink-Wings-Black")
  internal static let lightPinkWingsWhite = ImageAsset(name: "LightPink-Wings-White")
  internal static let orangeHeartBlack = ImageAsset(name: "Orange-Heart-Black")
  internal static let orangeHeartWhite = ImageAsset(name: "Orange-Heart-White")
  internal static let orangeWingBlack = ImageAsset(name: "Orange-Wing-Black")
  internal static let orangeWingWhite = ImageAsset(name: "Orange-Wing-White")
  internal static let orangeWingsBlack = ImageAsset(name: "Orange-Wings-Black")
  internal static let orangeWingsWhite = ImageAsset(name: "Orange-Wings-White")
  internal static let pinkHeartBlack = ImageAsset(name: "Pink-Heart-Black")
  internal static let pinkHeartWhite = ImageAsset(name: "Pink-Heart-White")
  internal static let pinkWingBlack = ImageAsset(name: "Pink-Wing-Black")
  internal static let pinkWingWhite = ImageAsset(name: "Pink-Wing-White")
  internal static let pinkWingsBlack = ImageAsset(name: "Pink-Wings-Black")
  internal static let pinkWingsWhite = ImageAsset(name: "Pink-Wings-White")
  internal static let pinkGreenHeartBlack = ImageAsset(name: "Pink_Green-Heart-Black")
  internal static let pinkGreenHeartWhite = ImageAsset(name: "Pink_Green-Heart-White")
  internal static let pinkGreenWingBlack = ImageAsset(name: "Pink_Green-Wing-Black")
  internal static let pinkGreenWingWhite = ImageAsset(name: "Pink_Green-Wing-White")
  internal static let pinkGreenWingsBlack = ImageAsset(name: "Pink_Green-Wings-Black")
  internal static let pinkGreenWingsWhite = ImageAsset(name: "Pink_Green-Wings-White")
  internal static let purpleHeartBlack = ImageAsset(name: "Purple-Heart-Black")
  internal static let purpleHeartWhite = ImageAsset(name: "Purple-Heart-White")
  internal static let purpleWingBlack = ImageAsset(name: "Purple-Wing-Black")
  internal static let purpleWingWhite = ImageAsset(name: "Purple-Wing-White")
  internal static let purpleWingsBlack = ImageAsset(name: "Purple-Wings-Black")
  internal static let purpleWingsWhite = ImageAsset(name: "Purple-Wings-White")
  internal static let redHeartBlack = ImageAsset(name: "Red-Heart-Black")
  internal static let redHeartWhite = ImageAsset(name: "Red-Heart-White")
  internal static let redWingBlack = ImageAsset(name: "Red-Wing-Black")
  internal static let redWingWhite = ImageAsset(name: "Red-Wing-White")
  internal static let redWingsBlack = ImageAsset(name: "Red-Wings-Black")
  internal static let redWingsWhite = ImageAsset(name: "Red-Wings-White")
  internal static let redBlueHeartBlack = ImageAsset(name: "Red_Blue-Heart-Black")
  internal static let redBlueHeartWhite = ImageAsset(name: "Red_Blue-Heart-White")
  internal static let redBlueWingBlack = ImageAsset(name: "Red_Blue-Wing-Black")
  internal static let redBlueWingWhite = ImageAsset(name: "Red_Blue-Wing-White")
  internal static let redBlueWingsBlack = ImageAsset(name: "Red_Blue-Wings-Black")
  internal static let redBlueWingsWhite = ImageAsset(name: "Red_Blue-Wings-White")
  internal static let redPinkHeartBlack = ImageAsset(name: "Red_Pink-Heart-Black")
  internal static let redPinkHeartWhite = ImageAsset(name: "Red_Pink-Heart-White")
  internal static let redPinkWingBlack = ImageAsset(name: "Red_Pink-Wing-Black")
  internal static let redPinkWingWhite = ImageAsset(name: "Red_Pink-Wing-White")
  internal static let redPinkWingsBlack = ImageAsset(name: "Red_Pink-Wings-Black")
  internal static let redPinkWingsWhite = ImageAsset(name: "Red_Pink-Wings-White")
  internal static let yellowHeartBlack = ImageAsset(name: "Yellow-Heart-Black")
  internal static let yellowHeartWhite = ImageAsset(name: "Yellow-Heart-White")
  internal static let yellowWingBlack = ImageAsset(name: "Yellow-Wing-Black")
  internal static let yellowWingWhite = ImageAsset(name: "Yellow-Wing-White")
  internal static let yellowWingsBlack = ImageAsset(name: "Yellow-Wings-Black")
  internal static let yellowWingsWhite = ImageAsset(name: "Yellow-Wings-White")
  internal static let heartWings = ImageAsset(name: "heartWings")
  internal static let wing = ImageAsset(name: "wing")
  internal static let wings = ImageAsset(name: "wings")

  // swiftlint:disable trailing_comma
  internal static let allColors: [ColorAsset] = [
    accentColor,
  ]
  internal static let allImages: [ImageAsset] = [
    blackHeartBlack,
    blackHeartWhite,
    blackWingBlack,
    blackWingWhite,
    blackWingsBlack,
    blackWingsWhite,
    blueHeartBlack,
    blueHeartWhite,
    blueWingBlack,
    blueWingWhite,
    blueWingsBlack,
    blueWingsWhite,
    blueGreenHeartBlack,
    blueGreenHeartWhite,
    blueGreenWingBlack,
    blueGreenWingWhite,
    blueGreenWingsBlack,
    blueGreenWingsWhite,
    blueGreenLightBlueHeartBlack,
    blueGreenLightBlueHeartWhite,
    blueGreenLightBlueWingBlack,
    blueGreenLightBlueWingWhite,
    blueGreenLightBlueWingsBlack,
    blueGreenLightBlueWingsWhite,
    bluePurpleHeartBlack,
    bluePurpleHeartWhite,
    bluePurpleWingBlack,
    bluePurpleWingWhite,
    bluePurpleWingsBlack,
    bluePurpleWingsWhite,
    blueYellowHeartBlack,
    blueYellowHeartWhite,
    blueYellowWingBlack,
    blueYellowWingWhite,
    blueYellowWingsBlack,
    blueYellowWingsWhite,
    greenHeartBlack,
    greenHeartWhite,
    greenWingBlack,
    greenWingWhite,
    greenWingsBlack,
    greenWingsWhite,
    greenYellowHeartBlack,
    greenYellowHeartWhite,
    greenYellowWingBlack,
    greenYellowWingWhite,
    greenYellowWingsBlack,
    greenYellowWingsWhite,
    lightBlueHeartBlack,
    lightBlueHeartWhite,
    lightBlueWingBlack,
    lightBlueWingWhite,
    lightBlueWingsBlack,
    lightBlueWingsWhite,
    lightBlueOrangeHeartBlack,
    lightBlueOrangeHeartWhite,
    lightBlueOrangeWingBlack,
    lightBlueOrangeWingWhite,
    lightBlueOrangeWingsBlack,
    lightBlueOrangeWingsWhite,
    lightPinkHeartBlack,
    lightPinkHeartWhite,
    lightPinkWingBlack,
    lightPinkWingWhite,
    lightPinkWingsBlack,
    lightPinkWingsWhite,
    orangeHeartBlack,
    orangeHeartWhite,
    orangeWingBlack,
    orangeWingWhite,
    orangeWingsBlack,
    orangeWingsWhite,
    pinkHeartBlack,
    pinkHeartWhite,
    pinkWingBlack,
    pinkWingWhite,
    pinkWingsBlack,
    pinkWingsWhite,
    pinkGreenHeartBlack,
    pinkGreenHeartWhite,
    pinkGreenWingBlack,
    pinkGreenWingWhite,
    pinkGreenWingsBlack,
    pinkGreenWingsWhite,
    purpleHeartBlack,
    purpleHeartWhite,
    purpleWingBlack,
    purpleWingWhite,
    purpleWingsBlack,
    purpleWingsWhite,
    redHeartBlack,
    redHeartWhite,
    redWingBlack,
    redWingWhite,
    redWingsBlack,
    redWingsWhite,
    redBlueHeartBlack,
    redBlueHeartWhite,
    redBlueWingBlack,
    redBlueWingWhite,
    redBlueWingsBlack,
    redBlueWingsWhite,
    redPinkHeartBlack,
    redPinkHeartWhite,
    redPinkWingBlack,
    redPinkWingWhite,
    redPinkWingsBlack,
    redPinkWingsWhite,
    yellowHeartBlack,
    yellowHeartWhite,
    yellowWingBlack,
    yellowWingWhite,
    yellowWingsBlack,
    yellowWingsWhite,
    heartWings,
    wing,
    wings,
  ]
  // swiftlint:enable trailing_comma
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

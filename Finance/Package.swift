// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Finance",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AddPaymentMethod",
            targets: ["AddPaymentMethod"]),
        .library(
            name: "AddPaymentMethodImpl",
            targets: ["AddPaymentMethodImpl"]),
        .library(
            name: "Topup",
            targets: ["Topup"]),
        .library(
            name: "TopupImpl",
            targets: ["TopupImpl"]),

        .library(
            name: "FinanceHome",
            targets: ["FinanceHome"]),
        .library(
            name: "FinanceEntity",
            targets: ["FinanceEntity"]
        ),
        .library(
            name: "FinanceRepository",
            targets: ["FinanceRepository"]
        ),
    ],
    dependencies: [
        .package(name: "ModernRIBs", url: "https://github.com/DevYeom/ModernRIBs", from: "1.0.1"),
        .package(path: "../Platform"),
    ],
    targets: [
        .target(
            name: "AddPaymentMethod",
            dependencies: [
                "ModernRIBs",
                "FinanceEntity",
                .product(name: "RIBsUtil", package: "Platform"),
            ]
        ),
        .target(
            name: "AddPaymentMethodImpl",
            dependencies: [
                "ModernRIBs",
                "FinanceEntity",
                "FinanceRepository",
                .product(name: "RIBsUtil", package: "Platform"),
                .product(name: "SuperUI", package: "Platform")
            ]
        ),
        .target(
            name: "TopupImpl",
            dependencies: [
                "ModernRIBs",
                "FinanceEntity",
                "FinanceRepository",
                "AddPaymentMethod",
                .product(name: "RIBsUtil", package: "Platform"),
                .product(name: "SuperUI", package: "Platform"),
                .product(name: "DefaultsStore", package: "Platform"),
            ]
        ),
        .target(
            name: "Topup",
            dependencies: [
                "ModernRIBs",
            ]
        ),
        .target(
            name: "FinanceHome",
            dependencies: [
                "ModernRIBs",
                "FinanceEntity",
                "FinanceRepository",
                "AddPaymentMethod",
                "Topup",
                .product(name: "RIBsUtil", package: "Platform"),
                .product(name: "SuperUI", package: "Platform")
            ]
        ),

        .target(
            name: "FinanceEntity",
            dependencies: [
            ]
        ),
        .target(name: "FinanceRepository",
                dependencies: [
                    "FinanceEntity",
                    .product(name: "CombineUtil", package: "Platform"),
                    .product(name: "Network", package: "Platform"),
                ]
        )
    ]
)

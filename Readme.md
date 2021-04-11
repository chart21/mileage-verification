# Mileage Verification - Verify the mileage history of a second-hand car via an Ethereum Blockchain  

Tamperproof application for tracking mileage data on an Ethereum Blockchain. To visualize tracked mileage data's validity, results are presented to the application user in an intuitive way with an Android and iOS client.

Tools used: Flutter, Solidity, Web3, Azure (Ethereum Proof of Authority nodes are hosted on Azure)

## Demo

<p align="center"><img src="media/Mileage-verification-process-flow.gif" width="300"\> </p>




## Software Architecture

Vehicles frequently upload sensor data to the Ethereum Blockchain. The Android or iOS app of the customer retrieves mileage data from the Blockchain via Web3. In our test setup, we hosted an Ethereum Proof-of-Authority chain via two virtual machines on Microsoft Azure.

<p align="center"><img src="media/sw architecture.jpg"\></p>

## Getting Started

app.apk - Android APK file, install on your Android device to get the app running (Ethereum PoA chain is currently offline)
BlockchainCode.sol - Solidity Code. The app interacts with the smart contract deployed on an Ethereum Blockchain.

mileage_verification folder - iOS and Android application source code. If you want to build the app on iOS or want to look in more detail, follow the following steps:

- Install the latest version of Android Studio
- Install flutter (https://flutter.dev/docs/get-started/install)
- to build Android app: Navigate to source folder in terminal, type flutter run
- to build the iOS app: You need a Mac, connected iPhone, xCode installed and connect the app to your apple developer account (instructions: https://flutter.dev/docs/deployment/ios)


## Motivation

When buying a second-hand car, it is essential to inspect how many miles the previous owner drove with it. As driven miles result in wear and a higher chance of damaged components [1], mileage record nowadays has a big (up to 40% [1]) influence on the negotiated price of a second-hand car. Currently, a device called odometer tracks mileage in a car. This sensor measures mileage driven and typically moves a pointer to the mileage value to display the mileage near the speed display. However, this pointer can be turned back quickly in a simple physical process. With this simple method, millions of cars worldwide and about 6.5% [1] of sold cars in total are affected by mileage manipulation by turning back the odometer pointer.

## References 
[1] Chris Greener, “Why mileage matters: the importance of mileage on a used car”, Autobebid, 2016

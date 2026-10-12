# CollabMN

A SwiftUI prototype for connecting local businesses and creators in Mongolia. It includes separate business and influencer views, offer browsing, category search, application forms, and profile screens.

## Run

Open `CollabMN.xcodeproj` in Xcode, choose the `CollabMN` scheme, and run on an iOS simulator. The interface uses Mongolian labels. No API keys are needed.

## What works

- Browse sample offers and search by title, business, or category.
- Create offers tied to the current business account during the current run.
- Show each demo user their own offers, applications, and dashboard totals.
- Submit an application using the current demo user's identity.
- Reject duplicate applications, expired/inactive offers, and applications below the follower requirement.

## Structure and limits

`Models.swift` holds the domain types. `DataStore.swift` owns the sample offers and applications. Business, influencer, and shared views live in separate files.

Login is a demo flow; it does not authenticate a real account. Data is kept in memory and resets when the app restarts. The shared sample marketplace is for demonstrating screens, not production authorization. The Expo marketplace project contains the separate Supabase implementation.

The minimum deployment target is iOS 17. An unsigned device build passes in Xcode. CI checks offer ownership, application visibility, duplicate prevention, eligibility, and account identity across a demo logout/login, then builds the app. Simulator and real-device interactions remain unverified.

```sh
mkdir -p build
swiftc CollabMN/Models.swift CollabMN/DataStore.swift tests/main.swift -o build/model-tests
build/model-tests
xcodebuild -project CollabMN.xcodeproj -scheme CollabMN -sdk iphoneos -destination 'generic/platform=iOS' -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO build
```

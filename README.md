# CollabMN

A SwiftUI prototype for connecting local businesses and creators in Mongolia. It includes separate business and influencer views, offer browsing, category search, application forms, and profile screens.

## Run

Open `CollabMN.xcodeproj` in Xcode, choose the `CollabMN` scheme, and run on an iOS simulator. The interface uses Mongolian labels. No API keys are needed.

## What works

- Browse sample offers and search by title, business, or category.
- Create offers during the current run.
- Submit an application using the current demo user's identity.
- Reject duplicate applications, expired/inactive offers, and applications below the follower requirement.

## Structure and limits

`Models.swift` holds the domain types. `DataStore.swift` owns the sample offers and applications. Business, influencer, and shared views live in separate files.

Login is a demo flow; it does not authenticate a real account. Data is kept in memory and resets when the app restarts. The shared sample marketplace is for demonstrating screens, not production authorization. The Expo marketplace project contains the separate Supabase implementation.

Swift source was checked against the iOS SDK. A full Xcode build and simulator interaction still need verification on a machine with working simulator runtimes.

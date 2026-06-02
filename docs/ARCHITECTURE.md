# YiyosaGel v3 Architecture

## Product Surface

- Android and web app from one Flutter codebase.
- Native app experience, no WebView.
- Guest access requires terms acceptance and username.
- Google access requires terms acceptance and supports custom avatar/profile cosmetics.
- Game modes: daily competitive, tour, private room, custom game, word guessing.
- Social: profile, user search, friend request, direct message, block, report.
- Economy: YG balance, daily rewards, missions, badges, inventory, cosmetics and limit unlocks.
- Notifications: Firebase Cloud Messaging for Android.
- Payments: Google Play Billing for Android, separate web payment provider.

## Data Split

- Firestore: durable documents, wallet ledger, inventory, store, user profiles, reports, admin records.
- Realtime Database: room state, presence, live chat, live scoreboards.
- Cloud Functions: every critical write, including score, wallet, inventory, limits, rewards and reports.

## Security Principles

- Client never writes wallet, inventory, score, leaderboard or store purchases directly.
- Rules default deny. Only explicit reads are opened.
- App Check should be enabled before production.
- Payment fulfillment must verify provider webhook/server receipt before granting YG or subscription.
- Moderation reports should include immutable source metadata and server timestamps.

## Performance Principles

- Feature modules stay small and lazy navigated.
- Live game state uses Realtime Database subscriptions scoped to the active room.
- Leaderboards query top 100 only.
- Images use cached network loading and compressed upload sizes.
- Expensive aggregation runs in Cloud Functions, not on user devices.

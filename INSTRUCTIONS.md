# Foodie Finder — Codex Development Instructions

> THIS DOCUMENT IS THE SOURCE OF TRUTH FOR ALL FUTURE DEVELOPMENT.
>
> ALL DEVELOPMENT MUST FOLLOW THESE INSTRUCTIONS.
> DOD (Definition of Done) REQUIREMENTS ARE NON-NEGOTIABLE.
>
> PRIORITY ORDER:
>
> 1. DO NOT BREAK WORKING FEATURES
> 2. FOLLOW DOD STRICTLY
> 3. MAINTAIN CLEAN ARCHITECTURE
> 4. MAINTAIN ORIGINALITY
> 5. IMPROVE UX/QUALITY INCREMENTALLY

---

# 0. CRITICAL NON-NEGOTIABLE RULES

## NEVER DO THESE
- NEVER overwrite large files blindly.
- NEVER regenerate the whole project.
- NEVER remove working features unless explicitly instructed.
- NEVER replace architecture without migration planning.
- NEVER create duplicate providers/models/widgets/services.
- NEVER use template-generated UI patterns.
- NEVER create generic “AI-looking” layouts.
- NEVER use random JSON dumping in Firestore.
- NEVER misuse `setState()` when Provider should manage state.
- NEVER skip testing after major changes.
- NEVER commit with messages like:
  - `final update`
  - `done`
  - `changes`
  - `fixes`

---

# 1. PROJECT CONTEXT

## Project Name
Foodie Finder

## Project Type
Flutter cross-platform restaurant discovery and dining application.

## Current Architecture
- Flutter
- Provider state management
- Material 3 custom theme
- Mock/in-memory data (partial)
- Multi-screen navigation implemented

## Existing Screens
- LoginScreen
- UserDetailsScreen
- LocationSetupScreen
- HomeScreen
- FavoritesScreen
- ProfileScreen
- BookingScreen
- InsightsScreen

## Existing Providers
- AuthProvider
- DishProvider
- FavoritesProvider

## Existing Features
### Implemented/Partial
- Dish search
- Favorites
- Basic recommendation scoring
- Analytics placeholders
- Booking placeholders
- Responsive food-card style UI

### NOT Implemented Yet
- Firebase integration
- Real authentication
- Firestore persistence
- Maps
- Live location
- Real reservations
- Offline caching
- Dark mode
- Recently viewed
- Advanced analytics
- Real restaurant detail pages

---

# 2. PRIMARY DOD (DEFINITION OF DONE)

THE PROJECT IS ONLY CONSIDERED COMPLETE IF ALL CONDITIONS BELOW ARE SATISFIED.

## REQUIRED FINAL CHECKLIST

### Core
- [ ] Fully functional Flutter app
- [ ] Original custom UI
- [ ] Firebase integrated
- [ ] Provider architecture properly implemented
- [ ] Recommendation engine implemented
- [ ] Analytics visualizations implemented
- [ ] Edge cases handled
- [ ] Tests implemented
- [ ] APK generated
- [ ] GitHub quality maintained
- [ ] Documentation complete

---

# 3. MANDATORY DEVELOPMENT PROCESS

## BEFORE MODIFYING ANYTHING
Codex MUST:

1. Read all related files first.
2. Understand existing architecture.
3. Preserve working functionality.
4. Identify dependencies before editing.
5. Make incremental changes only.

## AFTER EVERY MAJOR CHANGE
Codex MUST provide Git commands.

Example:

```bash
git status
git checkout -b feature/restaurant-details
git add .
git commit -m "feat: implemented restaurant details screen with Firestore integration"
git push origin feature/restaurant-details
4. REQUIRED ARCHITECTURE
REQUIRED STATE MANAGEMENT

Provider ONLY.

Use:

ChangeNotifier
Consumer
Selector
MultiProvider

Avoid unnecessary rebuilds.

REQUIRED CLEAN ARCHITECTURE

Use feature-first architecture.

lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   ├── services/
│   ├── errors/
│   └── network/
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── restaurants/
│   ├── bookings/
│   ├── analytics/
│   ├── profile/
│   ├── favorites/
│   ├── recommendations/
│   └── settings/
│
├── shared/
│   ├── widgets/
│   ├── models/
│   └── providers/
│
├── firebase/
├── routes/
└── main.dart
5. FIREBASE REQUIREMENTS (MANDATORY)
REQUIRED SERVICES
Firebase Auth
Firestore
Firebase Storage
Firebase Analytics
Firebase Cloud Messaging
AUTHENTICATION

Must support:

Email/password
Google Sign-In
Optional guest mode
FIRESTORE REQUIREMENTS

Use structured collections.

Example:

users/
restaurants/
menus/
reviews/
bookings/
favorites/
analytics/
recommendations/

DO NOT dump unstructured JSON.

6. OFFLINE SUPPORT (MANDATORY)
REQUIRED

Hive local caching.

MUST HANDLE
no internet
slow internet
Firestore fetch failure
empty states
REQUIRED UX
offline banners
retry buttons
cached fallback content
7. MAPS & LOCATION REQUIREMENTS
REQUIRED
Google Maps integration
Live GPS location
Nearby restaurant discovery
Distance calculation
Map markers
Open directions in Google Maps
8. UI/UX REQUIREMENTS (HIGH PRIORITY)
APP MUST NOT LOOK TEMPLATE-GENERATED

The app MUST feel custom-built.

REQUIRED
Custom Theme System
primary colors
secondary colors
semantic colors
typography hierarchy
spacing system
elevation system
REQUIRED REUSABLE WIDGETS

Minimum 3 custom reusable widgets.

Examples:

RestaurantCard
AnalyticsTile
RecommendationCarousel
FilterChipBar
BookingSummaryCard
REQUIRED MICRO-INTERACTIONS

Minimum 2:

animated transitions
page animations
loading skeletons
animated favorites
gesture interactions
RESPONSIVENESS

Must work across:

phones
tablets
web layouts
9. ADVANCED FEATURES (MANDATORY)
REQUIRED ADVANCED FEATURES
1. Personalized Recommendation Engine

MUST IMPLEMENT.

Recommendation Signals
user favorites
cuisine preference
ratings
delivery time
popularity
recent activity
spending behavior
time-of-day preference
2. Analytics Dashboard

MUST IMPLEMENT.

REQUIRED VISUALIZATIONS
cuisine preference pie chart
weekly spending trend
favorite category analytics

Each visualization MUST answer:

“What insight does this provide to the user?”

3. Recently Viewed Tracking

MUST IMPLEMENT.

4. Order History Simulation

MUST IMPLEMENT.

10. RESTAURANT FEATURES
REQUIRED
restaurant detail page
menu browsing
search
advanced filters
reviews & ratings
favorites
booking flow
booking history
booking cancellation
recently viewed
trending section
11. DARK MODE
REQUIRED

Implement full dark mode support.

Must include:

theme persistence
adaptive colors
accessibility contrast
12. SEARCH & FILTERING
REQUIRED FILTERS
cuisine
rating
distance
delivery time
veg/non-veg
price range
13. PERFORMANCE RULES
REQUIRED
no UI lag
optimized rebuilds
lazy loading where applicable
efficient Provider usage
optimized image loading
AVOID
rebuilding entire screen unnecessarily
large widget trees without extraction
huge build methods
14. TESTING REQUIREMENTS
REQUIRED MINIMUM
3 widget tests
provider/unit tests
integration tests after Firebase integration
TEST CASES MUST COVER
Happy Paths
login
booking
favorites
recommendations
Edge Cases
empty data
offline mode
invalid forms
auth failure
Firestore errors
15. DOCUMENTATION REQUIREMENTS
README MUST INCLUDE
setup instructions
Firebase setup
feature list
screenshots
architecture explanation
state management explanation
testing instructions
PROJECT REPORT MUST INCLUDE
problem understanding
feature justification
architecture diagrams
Provider explanation
challenges faced
AI usage disclosure
Firebase explanation
recommendation engine explanation
analytics explanation
16. GITHUB QUALITY RULES
REQUIRED
Meaningful Commits ONLY

GOOD:

feat: implemented Firestore restaurant repository
fix: resolved provider rebuild issue in favorites
ui: redesigned analytics dashboard cards

BAD:

final update
changes
done
fix
REQUIRED BRANCH STRATEGY
main
develop
feature/*
bugfix/*
17. REQUIRED DEVELOPMENT PHASES
Phase 1 — Stabilization
audit current app
refactor architecture carefully
preserve working features
Phase 2 — Firebase Integration
auth
firestore
storage
analytics
Phase 3 — Restaurant System
restaurant details
menus
reviews
bookings
Phase 4 — Recommendation Engine
personalized ranking
recommendation scoring
Phase 5 — Analytics Dashboard
charts
insights
trends
Phase 6 — Offline Support
Hive caching
sync strategy
Phase 7 — Maps & Location
GPS
nearby discovery
directions
Phase 8 — Polish
animations
dark mode
performance optimization
Phase 9 — Testing & Deployment
tests
APK generation
documentation
screenshots
18. AI/CODEX OPERATING RULES
BEFORE CODING

Codex MUST:

inspect existing implementation
identify dependencies
preserve architecture consistency
WHEN MODIFYING FILES

Codex MUST:

explain what changes are being made
explain why changes are needed
avoid unnecessary rewrites
WHEN ADDING FEATURES

Codex MUST:

reuse existing widgets/providers when possible
avoid duplicate logic
maintain naming consistency
WHEN REFACTORING

Codex MUST:

migrate safely
avoid breaking imports
preserve public APIs where possible
19. FEATURE CHECKLIST (LIVE TRACKER)
Authentication
 Firebase Auth
 Email/password login
 Google Sign-In
 Guest mode
 Logout flow
Home
 Restaurant feed
 Search
 Filters
 Recommendations
 Trending restaurants
Restaurants
 Restaurant detail screen
 Menu system
 Ratings/reviews
 Favorite system
 Recently viewed
Bookings
 Reservation flow
 Firestore persistence
 Booking history
 Booking cancellation
Analytics
 Cuisine pie chart
 Spending trend
 Favorite categories
 Insight summaries
Maps
 Live location
 Nearby restaurants
 Google Maps markers
 Directions support
Offline
 Hive caching
 Offline banners
 Retry flows
UI/UX
 Dark mode
 Animations
 Responsive layouts
 Reusable widgets
 Custom branding
Testing
 Widget tests
 Provider tests
 Integration tests
Deployment
 Splash screen
 App icon
 Release APK
 README updated
20. FINAL ACCEPTANCE RULE

THE APP IS NOT DONE UNTIL:

all DOD conditions are satisfied,
the app feels polished,
the UI looks original,
Firebase works correctly,
analytics/recommendations work,
tests pass,
and documentation is complete.

QUALITY > SPEED.

DO NOT RUSH IMPLEMENTATION.
param(
    [string]$TemplatePath = "c:\Users\Himanshu\Downloads\Project-Report-MAD-2026.docx",
    [string]$OutputPath = "c:\Users\Himanshu\Downloads\Foodie_Finder_Project_Report_Generated.docx"
)

$ErrorActionPreference = "Stop"

function Add-Paragraph {
    param(
        $Selection,
        [string]$Text,
        [string]$Style = "Normal",
        [string]$FontName = "Calibri",
        [int]$FontSize = 11,
        [switch]$Bold
    )

    $Selection.Style = $Style
    $Selection.Font.Name = $FontName
    $Selection.Font.Size = $FontSize
    $Selection.Font.Bold = [int]$Bold.IsPresent
    $Selection.TypeText($Text)
    $Selection.TypeParagraph()
}

function Add-Block {
    param(
        $Selection,
        [string[]]$Lines,
        [string]$Style = "Normal",
        [string]$FontName = "Calibri",
        [int]$FontSize = 11
    )

    foreach ($line in $Lines) {
        Add-Paragraph -Selection $Selection -Text $line -Style $Style -FontName $FontName -FontSize $FontSize
    }
}

function Add-CodeBlock {
    param(
        $Selection,
        [string]$Text
    )

    $Selection.Style = "Normal"
    $Selection.Font.Name = "Consolas"
    $Selection.Font.Size = 9
    $Selection.Font.Bold = 0
    $Selection.TypeText($Text)
    $Selection.TypeParagraph()
}

function Add-PageBreak {
    param($Selection)
    $wdPageBreak = 7
    $Selection.InsertBreak($wdPageBreak)
}

$repoUrl = "https://github.com/HimanshuChahar31/foodie_finder_app"
$commitOne = "cd36d6b - feat: add geolocation onboarding flow"
$commitTwo = "d2b80f8 - feat: add Google account login flow"

$word = $null
$doc = $null

try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $doc = $word.Documents.Open($TemplatePath)
    $doc.Range().Delete()
    $selection = $word.Selection

    Add-Paragraph $selection "End-Term Project Report" "Title" "Calibri" 20
    Add-Paragraph $selection "Foodie Finder - A Flutter Based Food Discovery, Ordering, and Table Booking Application" "Subtitle" "Calibri" 13
    Add-Paragraph $selection "" "Normal"
    Add-Paragraph $selection "Roll No.: ____________________"
    Add-Paragraph $selection "Semester: ____________________"
    Add-Paragraph $selection "Group: ____________________"
    Add-Paragraph $selection "Department of Computer Science and Engineering"
    Add-Paragraph $selection "The NorthCap University, Gurugram - 122001, India"
    Add-Paragraph $selection "Session 2025-26"
    Add-Paragraph $selection ""
    Add-Paragraph $selection "Prepared Project Title: Foodie Finder"
    Add-Paragraph $selection "Primary Platform: Android (Flutter)"
    Add-Paragraph $selection "Repository: $repoUrl"

    Add-PageBreak $selection

    Add-Paragraph $selection "Table of Contents" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "1. Project Overview",
        "2. Problem Framing & Scope",
        "3. Solution Design & Architecture",
        "4. UI/UX Design",
        "5. Feature Implementation Breakdown",
        "6. Custom Logic / Intelligence Layer",
        "7. Backend & Integration",
        "8. Data Visualization & Insights",
        "9. Testing & Validation",
        "10. Performance & Optimization",
        "11. Output (Screenshots + Flow)",
        "12. AI Usage Disclosure",
        "13. GitHub & Code Quality",
        "14. Conclusion & Future Scope"
    )

    Add-PageBreak $selection

    Add-Paragraph $selection "1. Project Overview" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "Foodie Finder is a Flutter-based mobile application that combines food discovery, user onboarding, cart-based ordering, restaurant seat booking, profile management, and role-aware analytics access in one interface. The application is designed for users who want to browse dishes across dietary categories, place cart orders, reserve seats, and manage their profile through a clean mobile flow.",
        "The project uses a Provider-based state management architecture, Firebase Authentication for account sign-in, Cloud Firestore for cloud persistence, SharedPreferences for local device fallback, and geolocation packages for real-time location setup. The codebase targets Android first but keeps Flutter's cross-platform structure intact for future expansion.",
        "The current implementation demonstrates both product thinking and engineering practice: it supports Google sign-in, email/password authentication, onboarding checkpoints, location capture through GPS or manual entry, order history, booking history, admin-restricted analytics, and graceful fallback when cloud sync is unavailable."
    )
    Add-Paragraph $selection "Core objectives" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "- Provide a smooth first-run onboarding flow.",
        "- Support real-user authentication and session persistence.",
        "- Offer food discovery with search, filtering, and category-aware ranking.",
        "- Enable basic ordering and restaurant seat booking features.",
        "- Keep the app usable even when Firestore is unavailable by using local persistence fallback."
    )
    Add-Paragraph $selection "Technology stack" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "- Flutter / Dart for application development",
        "- Provider for state management",
        "- Firebase Core, Firebase Auth, Cloud Firestore",
        "- Google Sign-In",
        "- Geolocator and Geocoding packages",
        "- SharedPreferences for local state fallback",
        "- fl_chart for insights-oriented visual components"
    )

    Add-Paragraph $selection "2. Problem Framing & Scope" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "The food-ordering experience is often fragmented. Users may discover dishes in one place, manage bookings somewhere else, and track orders or account details in separate flows. Foodie Finder addresses this by combining user identity, food discovery, ordering, and table booking inside a single app experience.",
        "The primary user problems addressed by this project are: difficulty in quickly finding dishes relevant to dietary preference, lack of a simple onboarding mechanism that captures address and location context, absence of a unified ordering and booking interface, and weak continuity when a user returns to the application after logging in once.",
        "The app scope includes the customer-facing journey from login to browsing to ordering and booking. It also includes an admin-only gateway for analytics visibility. The app does not yet implement a production-grade payment gateway, live restaurant backend, real delivery partner integration, or a full customer-support chatbot. These remain future-scope items."
    )
    Add-Paragraph $selection "Functional scope" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "- Authentication via Google and email/password",
        "- New user signup and old user login",
        "- Personal details onboarding",
        "- GPS-based or manual location capture",
        "- Dish listing, search, category filter, and preference-sensitive ranking",
        "- Favorites, cart, order placement, order history",
        "- Seat booking and booking history",
        "- Profile edit, support page, about page",
        "- Admin-gated analytics placeholder"
    )
    Add-Paragraph $selection "Constraints observed during implementation" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "- Firestore was not enabled correctly in the connected Firebase project, so local persistence fallback had to be introduced.",
        "- Real-world GPS reverse geocoding through cloud APIs depends on Android key configuration and device/network availability.",
        "- The current app uses sample dish data rather than a live restaurant catalog API."
    )

    Add-Paragraph $selection "3. Solution Design & Architecture" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "The application follows a layered Flutter architecture centered around ChangeNotifier-based providers. Presentation is separated into screens and widgets, while state and business rules sit in providers. Utility classes handle bootstrap, transitions, theme, and geocoding. Firebase and local storage act as data sources."
    )
    Add-Paragraph $selection "Architecture diagram" "Heading 2" "Calibri" 13
    Add-CodeBlock $selection @"
+--------------------------------------------------------------+
|                      Presentation Layer                      |
| LoginScreen | AuthGateScreen | UserDetails | LocationSetup   |
| HomeScreen | ProfileScreen | BookingScreen | InsightsScreen  |
+------------------------------+-------------------------------+
                               |
                               v
+--------------------------------------------------------------+
|                    State Management Layer                    |
| AuthProvider | DishProvider | FavoritesProvider              |
| CartProvider | BookingProvider                              |
+------------------------------+-------------------------------+
                               |
                               v
+--------------------------------------------------------------+
|                  Utility / Service Layer                     |
| FirebaseBootstrap | GoogleGeocodingService                  |
| RouteTransitions | Theme / Color / Spacing utilities        |
| Android MethodChannel (native_config)                       |
+------------------------------+-------------------------------+
                               |
                               v
+--------------------------------------------------------------+
|                        Data Sources                          |
| Firebase Auth | Cloud Firestore | SharedPreferences          |
| Geolocator | Geocoding | Google Sign-In                     |
+--------------------------------------------------------------+
"@
    Add-Paragraph $selection "Startup flow" "Heading 2" "Calibri" 13
    Add-CodeBlock $selection @"
main()
  -> FirebaseBootstrap.initialize()
  -> runApp(MyApp)
  -> MultiProvider injects app state
  -> AuthGateScreen checks AuthProvider
      -> LoginScreen if not authenticated
      -> UserDetailsScreen if basic details missing
      -> LocationSetupScreen if location missing
      -> HomeScreen if onboarding complete
"@
    Add-Paragraph $selection "Code flow explanation" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "The main entry point initializes Firebase before the widget tree is created. MyApp then registers providers using MultiProvider, which allows the entire app to access shared state. AuthProvider is the most critical provider because it controls login state, session restore, onboarding completion, cloud/local persistence, and role flags.",
        "AuthGateScreen is the route decision engine. It waits until authentication state is resolved, then sends the user to LoginScreen, UserDetailsScreen, LocationSetupScreen, or HomeScreen. This prevents the app from flashing the wrong page while a previous session is being restored.",
        "LoginScreen handles Google sign-in, email login, and signup. On success it explicitly navigates to the next step rather than waiting only on top-level rebuilds. This made the navigation flow more reliable on real devices.",
        "LocationSetupScreen provides two branches: manual address entry and GPS-based capture. The GPS branch requests runtime permission, fetches coordinates, attempts reverse geocoding, and then persists the final location values through AuthProvider."
    )
    Add-Paragraph $selection "Representative architecture snippet" "Heading 2" "Calibri" 13
    Add-CodeBlock $selection @"
return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => DishProvider()),
    ChangeNotifierProxyProvider<AuthProvider, CartProvider>(...)
  ],
  child: MaterialApp(home: const AuthGateScreen()),
);
"@

    Add-Paragraph $selection "4. UI/UX Design" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "The user interface follows a warm food-oriented aesthetic using a cream, amber, and dark-ink palette. The UI relies on reusable style constants from AppColors, AppSpacing, and AppTextStyles to maintain consistency across screens. Rounded cards, clear sectioning, and a focused onboarding flow make the app accessible to first-time users.",
        "The login screen is intentionally simple: users choose Google, email, or signup. Once inside the app, navigation is task-driven rather than menu-heavy. HomeScreen uses a SliverAppBar, search field, category chips, cart quick access, favorites, profile, and booking shortcuts. ProfileScreen centralizes account-level features such as order history, booking history, edit profile, support, about, and logout.",
        "Several UI fixes were also integrated into the project: keyboard-safe forms through SingleChildScrollView, better text wrapping, removal of redundant onboarding fields, and consistent alignment using Expanded/Flexible patterns."
    )
    Add-Paragraph $selection "Key UI screens" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "- Login and signup screens",
        "- Personal details screen",
        "- Manual and GPS-based location setup screens",
        "- Home screen with search, filter chips, and dish feed",
        "- Cart, order history, booking history, edit profile, help and about screens",
        "- Admin-only insights dashboard"
    )

    Add-Paragraph $selection "5. Feature Implementation Breakdown" "Heading 1" "Calibri" 16
    Add-Paragraph $selection "5.1 Authentication and session restore" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "AuthProvider manages Google sign-in, email/password login, signup, phone-based methods already present in the provider, logout, and session restoration. It also stores the provider type and determines whether onboarding is complete.",
        "A startup bootstrap path loads the current Firebase user and then hydrates local cached profile data immediately, reducing delays after app relaunch."
    )
    Add-Paragraph $selection "5.2 User onboarding" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "After authentication, the user is required to complete personal details and location setup. The personal details screen captures name, password update intent, and gender. The location screen captures either a manual multi-part address or real device location with house/building number."
    )
    Add-Paragraph $selection "5.3 Food discovery" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "DishProvider holds a curated in-memory dataset of food items across Veg, Non-Veg, and Vegan categories. It supports keyword search, category filter chips, recommendation ordering, and lightweight analytics data generation."
    )
    Add-Paragraph $selection "5.4 Favorites, cart, and orders" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "FavoritesProvider manages local favorite states. CartProvider manages item quantity, delivery fee calculation, handling fee, order placement, and order history retrieval from Firestore. Orders are stored as nested documents under the signed-in user."
    )
    Add-Paragraph $selection "5.5 Table booking" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "BookingProvider captures booking records containing user name, contact, hotel name, cuisine, seats, amount, booking time, and scheduled slot. These are persisted in Firestore under the current user's booking collection."
    )
    Add-Paragraph $selection "5.6 Profile and role-based access" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "ProfileScreen exposes history, edit profile, support, about, and logout operations. InsightsScreen checks the user's role and restricts analytics access to admins only."
    )

    Add-Paragraph $selection "6. Custom Logic / Intelligence Layer" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "Although this version does not yet integrate a generative AI chatbot, it includes several custom logic layers that add intelligent behavior.",
        "First, DishProvider ranks dishes using a scoring function that combines restaurant rating, category-preference match, and delivery time. This ensures that the visible food list is not random but preference-aware.",
        "Second, AuthProvider resolves email-or-name login. If the user types a name rather than an email, the provider attempts to map that name back to the stored email in Firestore.",
        "Third, a fault-tolerant persistence strategy was implemented. When Firestore is unavailable or denied, the provider saves data locally through SharedPreferences, disables further Firestore retries, and keeps the app usable on the same device.",
        "Fourth, onboarding continuity is computed from derived state such as hasBasicDetails and hasLocationDetails, allowing the app to resume exactly from the missing step."
    )
    Add-Paragraph $selection "Dish ranking snippet" "Heading 2" "Calibri" 13
    Add-CodeBlock $selection @"
double _scoreForDish(Dish dish, String preferenceCategory) {
  final ratingScore = (dish.rating / 5.0) * 0.5;
  final preferenceScore = _preferenceMatch(dish.category, preferenceCategory) * 0.35;
  final distanceScore = (1 - (dish.deliveryTime / 35).clamp(0.0, 1.0)) * 0.15;
  return ratingScore + preferenceScore + distanceScore;
}
"@

    Add-Paragraph $selection "7. Backend & Integration" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "The backend integration is centered on Firebase. FirebaseBootstrap initializes the service layer. Firebase Authentication is responsible for user identity, Google sign-in, and email/password login. Firestore stores user profiles, orders, and booking data in user-specific collections.",
        "Google account login is configured through the google_sign_in package. A native Android MethodChannel is used to expose values such as default_web_client_id and the Google API key from generated Android resources to Dart.",
        "Geolocator provides live device coordinates, the geocoding package provides platform-based reverse geocoding, and GoogleGeocodingService optionally queries Google geocoding to improve address quality.",
        "Because the connected Firebase project produced permission-denied responses for Firestore, the project includes a SharedPreferences fallback for profile persistence and a network-disabling safeguard for Firestore after the first hard denial."
    )
    Add-Paragraph $selection "Backend data model summary" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "- users/{uid}: profile metadata such as name, email, gender, location, role, coordinates",
        "- users/{uid}/orders: placed cart orders",
        "- users/{uid}/bookings: restaurant booking records"
    )
    Add-Paragraph $selection "Integration snippet" "Heading 2" "Calibri" 13
    Add-CodeBlock $selection @"
await firestore.collection('users').doc(uid).set({
  'email': _email,
  'name': _name,
  'location': _location,
  'latitude': _latitude,
  'longitude': _longitude,
}, SetOptions(merge: true));
"@

    Add-Paragraph $selection "8. Data Visualization & Insights" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "The project includes early-stage analytical support through DishProvider and the admin-gated InsightsScreen. DishProvider computes category distribution, most ordered dishes, and a weekly spending trend, with fl_chart imported to support visual charting.",
        "At present, the InsightsScreen itself is a scaffolded admin dashboard with placeholder totals for orders, revenue, and active users. The underlying provider already exposes enough structure to evolve this into a richer dashboard once a live dataset is connected."
    )
    Add-Paragraph $selection "Analytics-ready data exposed in code" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "- categoryDistribution -> percentage spread of Veg, Non-Veg, Vegan dishes",
        "- mostOrderedDishes -> ranked dish ordering counts",
        "- spendingTrendSpots -> fl_chart points for weekly spend trend"
    )

    Add-Paragraph $selection "9. Testing & Validation" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "The project was validated using static analysis, widget testing, build verification, and repeated manual flow fixes. The current repository contains a widget test that checks the expected startup login choices. Multiple Android APK builds were produced successfully in both debug and release modes during development.",
        "Major validation focus areas included: login screen stability, onboarding step continuity, personal details submission, location setup, session restoration after relaunch, and graceful fallback when cloud storage was denied."
    )
    Add-Paragraph $selection "Validation methods used" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "- dart analyze for static code checks",
        "- flutter test for widget-level validation",
        "- flutter build apk --debug and flutter build apk --release for packaging checks",
        "- manual scenario testing of login, onboarding, and persistence flows"
    )

    Add-Paragraph $selection "10. Performance & Optimization" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "The codebase uses lightweight Provider state management, which keeps rebuild scope narrow and avoids unnecessary complexity. HomeScreen uses slivers and builder-driven lists for efficient scrolling. Search and category filtering in DishProvider operate on in-memory lists for low-latency UI updates.",
        "A major optimization area addressed during development was resilience under failing backend conditions. Rather than blocking the entire app on Firestore availability, AuthProvider now writes local profile state first, syncs in the background when possible, and disables Firestore network retries after repeated permission-denied failures. This optimization improves real-user responsiveness significantly.",
        "UI performance was also improved by resolving overflow issues, using SingleChildScrollView only where keyboard safety demanded it, and trimming icon fonts during release build generation."
    )

    Add-Paragraph $selection "11. Output (Screenshots + Flow)" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "The report template expects screenshots. Because screenshots are environment-dependent, the following placeholders indicate the exact captures that should be attached from the final APK during demonstration or viva."
    )
    Add-Block $selection @(
        "[Screenshot 1] Login screen with Google / Email / Signup choices",
        "[Screenshot 2] Google account chooser",
        "[Screenshot 3] Personal details onboarding screen",
        "[Screenshot 4] Location setup screen with Manual and GPS options",
        "[Screenshot 5] GPS location detection result",
        "[Screenshot 6] Home screen with search, chips, and dish listing",
        "[Screenshot 7] Cart and order placement",
        "[Screenshot 8] Booking screen / booking history",
        "[Screenshot 9] Profile screen",
        "[Screenshot 10] Admin insights access screen"
    )
    Add-Paragraph $selection "User flow summary" "Heading 2" "Calibri" 13
    Add-CodeBlock $selection @"
App Launch
  -> Session Check
      -> Login / Signup
      -> Personal Details
      -> Location Setup
      -> Home Dashboard
          -> Search / Filter Dishes
          -> Add to Favorites
          -> Add to Cart
          -> Place Order
          -> Book Seats
          -> Manage Profile and History
"@

    Add-Paragraph $selection "12. AI Usage Disclosure" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "AI assistance was used during the engineering and documentation lifecycle of this project. The assistance covered debugging support, code restructuring suggestions, navigation stability fixes, report drafting help, and explanation of architecture and flow. Final code integration, feature prioritization, testing decisions, and repository commits were still performed within the project workspace and verified through build/test commands.",
        "No autonomous cloud AI feature has yet been embedded inside the running app. The current application is not using an LLM at runtime for user support, refund queries, or natural-language chat. If such a feature is added later, it would belong in a future enhancement section and require a clear safety and prompt-control design."
    )

    Add-Paragraph $selection "13. GitHub & Code Quality" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "The project repository is maintained on GitHub at $repoUrl. The development history includes meaningful feature commits, including one commit for geolocation onboarding and a second commit for Google account login flow. This separation improves traceability and makes code review easier.",
        "Code quality practices visible in the project include modular separation of screens/providers/widgets, shared visual constants, provider-based dependency injection, background sync fallbacks, and widget/build verification before APK generation."
    )
    Add-Paragraph $selection "Relevant commits" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        $commitOne,
        $commitTwo
    )
    Add-Paragraph $selection "Quality observations" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "- Clear entry point and provider setup",
        "- Distinct screen and provider responsibilities",
        "- Explicit onboarding state gates",
        "- Local persistence fallback for degraded backend states",
        "- Release APK generation completed successfully"
    )

    Add-Paragraph $selection "14. Conclusion & Future Scope" "Heading 1" "Calibri" 16
    Add-Block $selection @(
        "Foodie Finder successfully demonstrates a modern Flutter application with end-to-end user onboarding, authentication, dish discovery, cart ordering, seat booking, profile management, and role-aware UI access. The project is strong as an academic mobile app because it connects interface design, state management, backend integration, device capability usage, and practical debugging under constrained backend conditions.",
        "The most notable engineering strength of the project is not just the feature list, but the way the app was adapted to remain functional even when the cloud database configuration was incomplete. This led to a more fault-tolerant implementation through local caching and backend fallback logic."
    )
    Add-Paragraph $selection "Future scope" "Heading 2" "Calibri" 13
    Add-Block $selection @(
        "- Enable and secure Firestore fully for cross-device profile continuity",
        "- Replace sample dish data with a live restaurant/content API",
        "- Expand analytics with real charts and admin insights",
        "- Add chatbot-based support for FAQs such as refunds and booking help",
        "- Integrate payment gateway and order status tracking",
        "- Add cloud-synced offline queue and conflict resolution",
        "- Prepare production signing and Play Store deployment"
    )

    $wdFormatXMLDocument = 12
    $doc.SaveAs([ref]$OutputPath, [ref]$wdFormatXMLDocument)
    Write-Output "REPORT_CREATED: $OutputPath"
}
finally {
    if ($doc -ne $null) {
        $doc.Close()
    }
    if ($word -ne $null) {
        $word.Quit()
    }
}

param(
    [string]$ReportPath = "c:\Users\Himanshu\OneDrive\Desktop\Foodie_Finder_Project_Report.docx"
)

$ErrorActionPreference = "Stop"

$umlText = @"
@startuml
skinparam packageStyle rectangle
skinparam componentStyle rectangle

package "Presentation Layer" {
  [LoginScreen]
  [AuthGateScreen]
  [UserDetailsScreen]
  [LocationSetupScreen]
  [HomeScreen]
  [ProfileScreen]
  [BookingScreen]
  [InsightsScreen]
}

package "State Management Layer" {
  [AuthProvider]
  [DishProvider]
  [FavoritesProvider]
  [CartProvider]
  [BookingProvider]
}

package "Utility / Service Layer" {
  [FirebaseBootstrap]
  [GoogleGeocodingService]
  [RouteTransitions]
  [AppTheme / Styles]
  [Android MethodChannel]
}

package "Data Sources" {
  [Firebase Auth]
  [Cloud Firestore]
  [SharedPreferences]
  [Google Sign-In]
  [Geolocator]
  [Geocoding]
}

[AuthGateScreen] --> [AuthProvider]
[LoginScreen] --> [AuthProvider]
[UserDetailsScreen] --> [AuthProvider]
[LocationSetupScreen] --> [AuthProvider]
[LocationSetupScreen] --> [GoogleGeocodingService]
[HomeScreen] --> [DishProvider]
[HomeScreen] --> [CartProvider]
[HomeScreen] --> [FavoritesProvider]
[ProfileScreen] --> [AuthProvider]
[BookingScreen] --> [BookingProvider]
[InsightsScreen] --> [AuthProvider]

[AuthProvider] --> [FirebaseBootstrap]
[AuthProvider] --> [Firebase Auth]
[AuthProvider] --> [Cloud Firestore]
[AuthProvider] --> [SharedPreferences]
[AuthProvider] --> [Google Sign-In]
[AuthProvider] --> [Android MethodChannel]

[GoogleGeocodingService] --> [Android MethodChannel]
[GoogleGeocodingService] --> [Geolocator]
[GoogleGeocodingService] --> [Geocoding]

[CartProvider] --> [Cloud Firestore]
[BookingProvider] --> [Cloud Firestore]
@enduml
"@

$word = $null
$doc = $null

try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $doc = $word.Documents.Open($ReportPath)

    $content = $doc.Content
    $find = $content.Find
    $find.ClearFormatting()
    $find.Text = "Architecture diagram"
    if (-not $find.Execute()) {
        throw "Could not find 'Architecture diagram' heading in report."
    }

    $startRange = $word.Selection.Range
    $startPos = $startRange.End

    $find2 = $doc.Range($startPos, $doc.Content.End).Find
    $find2.ClearFormatting()
    $find2.Text = "Startup flow"
    if (-not $find2.Execute()) {
        throw "Could not find 'Startup flow' heading in report."
    }

    $endRange = $word.Selection.Range
    $replaceRange = $doc.Range($startPos, $endRange.Start)
    $replaceRange.Text = "`r`nThe following UML component/package diagram describes the system architecture used in Foodie Finder:`r`n`r`n$umlText`r`n`r`n"

    $doc.Save()
    Write-Output "UPDATED: $ReportPath"
}
finally {
    if ($doc -ne $null) { $doc.Close() }
    if ($word -ne $null) { $word.Quit() }
}

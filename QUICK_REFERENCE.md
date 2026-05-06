# Flutter UI Fixes - Quick Reference Guide

## Problem → Solution Mapping

### 1️⃣ OVERFLOW ISSUES (Cards/Containers)

**Problem**: Cards showing "BOTTOM OVERFLOWED BY XX PIXELS"

**Solution**:
```dart
// ✅ CORRECT: Use SingleChildScrollView + Column with mainAxisSize
Card(
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min, // KEY: Prevents forced expansion
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [...]
      ),
    ),
  ),
)

// ❌ WRONG: Fixed structure without scroll
Card(
  child: Column(
    children: [...] // Will overflow if content exceeds space
  ),
)
```

---

### 2️⃣ KEYBOARD HANDLING

**Problem**: UI breaks/overflows when keyboard opens

**Solution**:
```dart
// ✅ CORRECT: Wrap entire scrollable content
body: SafeArea(
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Form(
      key: _formKey,
      child: Column(...) // Can scroll when keyboard open
    ),
  ),
)

// ❌ WRONG: Fixed layout without scroll
body: SafeArea(
  child: Padding(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(...) // Will overflow with keyboard
  ),
)
```

---

### 3️⃣ TEXT OVERFLOW

**Problem**: "Tell us about yourself" text overflowing

**Solution**:
```dart
// ✅ CORRECT: Always use maxLines + overflow on long text
Text(
  'Tell us about yourself',
  style: AppTextStyles.h2,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)

// ❌ WRONG: No wrapping/ellipsis
Text(
  'Tell us about yourself',
  style: AppTextStyles.h2,
)
```

---

### 4️⃣ RESPONSIVE ROW/COLUMN

**Problem**: UI elements not properly aligned, overlapping

**Solution for Row**:
```dart
// ✅ CORRECT: Use Expanded for flexible content
Row(
  children: [
    Expanded(
      child: Text('This text can expand'),
    ),
    SizedBox(width: AppSpacing.sm),
    Icon(...) // Fixed size
  ],
)

// ❌ WRONG: Multiple widgets fighting for space
Row(
  children: [
    Text('Text without Expanded'),
    Text('Another text'), // Will overflow
    Icon(...)
  ],
)
```

---

### 5️⃣ ROLE-BASED UI (Admin-Only Features)

**Problem**: "See insights" button visible for all users

**Setup**:
```dart
// Step 1: AuthProvider - Add role property
class AuthProvider extends ChangeNotifier {
  String _userRole = 'user'; // 'user' or 'admin'
  
  bool get isAdmin => _userRole == 'admin';
  
  void setUserRole(String role) {
    if (_userRole != role) {
      _userRole = role;
      notifyListeners();
    }
  }
}

// Step 2: HomeScreen - Conditional rendering
final authProvider = context.watch<AuthProvider>();

if (authProvider.isAdmin)
  IconButton(
    onPressed: () => _navigateTo(context, const InsightsScreen()),
    icon: const Icon(Icons.insights),
  ),
```

---

### 6️⃣ CARD LAYOUT BEST PRACTICES

**Problem**: Cards have alignment and spacing issues

**Solution**:
```dart
// ✅ CORRECT: Proper card structure
Card(
  margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
  ),
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Content with proper text wrapping
          Text(
            'Title',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          // Buttons spanning full width
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(...)
          ),
        ],
      ),
    ),
  ),
)
```

---

### 7️⃣ SCROLLABLE SCREENS

**Problem**: Some screens not scrollable, content cuts off

**Pattern for Full-Page Scroll**:
```dart
// ✅ CORRECT: Top-level SingleChildScrollView
body: SafeArea(
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Section 1'),
        SizedBox(height: AppSpacing.lg),
        Text('Section 2'),
        // All content scrolls together
      ],
    ),
  ),
)

// ✅ ALSO CORRECT: SingleChildScrollView + Expanded at bottom
body: SafeArea(
  child: Column(
    children: [
      // Fixed header
      Padding(child: Row(...)),
      
      // Scrollable content
      Expanded(
        child: SingleChildScrollView(
          child: Column(...),
        ),
      ),
    ],
  ),
)
```

---

### 8️⃣ REMOVED FIELDS

**Problem**: Taste Preference field cluttering the form

**Solution**:
```dart
// ✅ REMOVED: These lines completely
// final List<String> _preferences = ['Veg', 'Non-Veg', 'Vegan'];
// String _selectedPreference = 'Veg';
// 
// And in _saveDetails():
// context.read<AuthProvider>().updatePreferenceCategory(_selectedPreference);
//
// And in build():
// Text('Your preferred taste', ...)
// Wrap(children: [..._preferences.map(...)])

// Keep only:
final _nameController = TextEditingController();
final _addressController = TextEditingController();
```

---

## Layout Patterns Reference

### Pattern: Full-Screen List
```dart
// ✅ For screens with items that fill screen
body: SafeArea(
  child: ListView.separated(
    itemCount: items.length,
    separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
    itemBuilder: (context, index) {
      return ItemWidget(items[index]);
    },
  ),
)
```

### Pattern: Header + Scrollable Content
```dart
// ✅ For screens with fixed header and scrollable content
body: SafeArea(
  child: Column(
    children: [
      // Fixed header
      Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(...),
      ),
      
      // Scrollable content
      Expanded(
        child: SingleChildScrollView(
          child: Column(...),
        ),
      ),
    ],
  ),
)
```

### Pattern: List Inside List (Horizontal + Vertical)
```dart
// ✅ For carousel inside scrollable content
SingleChildScrollView(
  child: Column(
    children: [
      SizedBox(
        height: 220,
        child: ListView.builder(...), // Horizontal list
      ),
      ListView.separated( // Vertical list
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (...),
      ),
    ],
  ),
)
```

### Pattern: Form with Keyboard
```dart
// ✅ For forms that need to scroll with keyboard
body: SafeArea(
  child: SingleChildScrollView(
    padding: EdgeInsets.all(AppSpacing.lg),
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(...),
          SizedBox(height: AppSpacing.md),
          TextFormField(...),
          SizedBox(height: AppSpacing.lg),
          ElevatedButton(...),
        ],
      ),
    ),
  ),
)
```

---

## Common Mistakes to Avoid

| ❌ WRONG | ✅ CORRECT | WHY |
|---------|-----------|-----|
| `Column(children: [Text('Long...'), ...])` | `Column(children: [Text('Long...', maxLines: 2, overflow: TextOverflow.ellipsis)])` | Text must wrap or ellipsis |
| `Row(children: [Text(...), Icon(...)])` | `Row(children: [Expanded(child: Text(...)), Icon(...)])` | Expanded takes available space |
| `ListView` directly in `Column` | `Expanded(child: ListView(...))` or `ListView(shrinkWrap: true)` | ListView needs bounded height |
| No `SingleChildScrollView` when keyboard | `SingleChildScrollView(child: Form(...))` | Keyboard needs scroll support |
| Fixed height cards | `SingleChildScrollView(child: Column(mainAxisSize: MinMax))` | Dynamic content needs scroll |
| `TextButton(onPressed: null, ...)` | `TextButton(onPressed: condition ? () => {} : null, ...)` | Disable by setting to null |
| Always show admin button | `if (authProvider.isAdmin) IconButton(...)` | Role-based visibility needed |

---

## Testing Checklist

- [ ] No overflow errors in debug console
- [ ] All screens scrollable on small screens
- [ ] Keyboard opens/closes without breaking layout
- [ ] Long text properly wrapped with ellipsis
- [ ] Buttons properly aligned and full-width where needed
- [ ] Responsive on portrait and landscape modes
- [ ] Admin sees insights button, user doesn't
- [ ] Cards render correctly with varying content lengths
- [ ] No jank during transitions
- [ ] Navigation works smoothly

---

## Key Flutter Concepts

### Expanded vs Flexible
```dart
// Expanded: Takes all available space
Row(children: [
  Expanded(child: Text('Takes all space')),
  Icon(...) // Fixed size
])

// Flexible: Takes available space based on fit
Row(children: [
  Flexible(
    flex: 2,
    fit: FlexFit.tight, // Force full space
    child: Text(...),
  ),
  Icon(...)
])
```

### MainAxisSize
```dart
// Main axis = vertical in Column, horizontal in Row

Column(
  mainAxisSize: MainAxisSize.max, // Default: expands to fill
  children: [...]
)

Column(
  mainAxisSize: MainAxisSize.min, // Shrinks to content
  children: [...]
)
```

### ScrollPhysics
```dart
// For nested lists, disable scroll on inner list
ListView(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(), // Disable scroll
  children: [...]
)
```

---

**Remember**: Responsive UI = No fixed heights/widths + Proper Expanded usage + SingleChildScrollView for scrollable areas! 🎯


# 📊 MediMind - Visual Architecture

## 🏗️ Application Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      📱 MEDIMIND APP                         │
│                  Offline Medication Reminder                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     🎨 UI LAYER (Screens)                    │
├─────────────────────────────────────────────────────────────┤
│  📅 Calendar    │  💊 Med List  │  ➕ Add/Edit              │
│  ⚙️ Settings    │  ℹ️ About     │                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              🔄 STATE MANAGEMENT (Providers)                 │
├─────────────────────────────────────────────────────────────┤
│  MedicationProvider │ ThemeProvider │ LanguageProvider       │
│  - CRUD operations  │ - Light/Dark  │ - PT-BR/EN            │
│  - State updates    │ - Persistence │ - Persistence         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 ⚙️ SERVICE LAYER (Business Logic)           │
├─────────────────────────────────────────────────────────────┤
│  DatabaseService          │  NotificationService             │
│  - Hive operations        │  - Schedule notifications       │
│  - CRUD methods           │  - Background scheduling        │
│  - Backup/Restore         │  - Action handling              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   💾 DATA LAYER (Storage)                    │
├─────────────────────────────────────────────────────────────┤
│  Hive Database       │  SharedPreferences                    │
│  - medications box   │  - theme preference                   │
│  - logs box          │  - language preference                │
│                      │  - notification settings              │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 User Flow Diagram

```
START
  │
  ▼
┌─────────────────┐
│  📱 App Launch  │
│  - Init Hive    │
│  - Init Notif   │
│  - Load State   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐      ┌──────────────────┐
│  📅 Calendar    │◄─────┤  Hamburger Menu  │
│  Main Screen    │      └──────────────────┘
└────────┬────────┘              │
         │                        │
    ┌────┴────┐                  │
    │         │                   │
    ▼         ▼                   ▼
[Tap Date] [Tap +]        [My Medications]
    │         │                   │
    ▼         ▼                   ▼
┌─────────┐ ┌──────────┐  ┌──────────────┐
│View Meds│ │Add/Edit  │  │Medication    │
│for Date │ │Medication│  │List Screen   │
└────┬────┘ └────┬─────┘  └──────┬───────┘
     │           │                │
     ▼           ▼                ▼
[Take/Skip]  [Save]          [Edit/Delete]
     │           │                │
     └───────────┴────────────────┘
                 │
                 ▼
         [Update State]
                 │
                 ▼
    [Schedule Notifications]
                 │
                 ▼
         [Update Calendar]
                 │
                 ▼
         [Save to Hive]
```

## 🔔 Notification Flow

```
USER CREATES MEDICATION
         │
         ▼
┌────────────────────┐
│ Calculate Schedule │
│ Based on Interval  │
└─────────┬──────────┘
          │
          ▼
┌────────────────────┐
│ Create Log Entries │
│ (MedicationLog)    │
└─────────┬──────────┘
          │
          ▼
┌────────────────────────┐
│ Schedule Notifications │
│ with Android Scheduler │
└─────────┬──────────────┘
          │
          ▼
    [Wait for Time]
          │
          ▼
┌───────────────────┐
│ NOTIFICATION FIRES│
│ - Show alert      │
│ - Play sound      │
│ - Vibrate         │
│ - Show actions    │
└─────────┬─────────┘
          │
     ┌────┴────┐
     │         │
     ▼         ▼
[✓ Taken] [✗ Skip]
     │         │
     └────┬────┘
          │
          ▼
┌──────────────────┐
│ Update Log Status│
│ in Hive Database │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Update Calendar  │
│ Dot Color        │
└──────────────────┘
```

## 📊 Data Model Relationships

```
┌──────────────────────────────────────────┐
│           MEDICATION                      │
├──────────────────────────────────────────┤
│ - id: String                              │
│ - name: String                            │
│ - dosageValue: double                     │
│ - dosageUnit: String                      │
│ - firstDoseTime: String                   │
│ - notificationsEnabled: bool              │
│ - intervalType: String                    │
│ - timesPerDay: int?                       │
│ - intervalDays: int?                      │
│ - startDate: DateTime?                    │
│ - weekdays: List<int>?                    │
│ - dayOfMonth: int?                        │
│ - customIntervalHours: int?               │
│ - notes: String?                          │
│ - createdAt: DateTime                     │
└────────┬─────────────────────────────────┘
         │
         │ 1 : N (One to Many)
         │
         ▼
┌──────────────────────────────────────────┐
│        MEDICATION_LOG                     │
├──────────────────────────────────────────┤
│ - id: String                              │
│ - medicationId: String (FK)               │
│ - scheduledTime: DateTime                 │
│ - takenTime: DateTime?                    │
│ - status: String (scheduled/taken/skipped)│
└──────────────────────────────────────────┘
```

## 🎨 Screen Hierarchy

```
┌─────────────────────────────────────────────┐
│              MyApp (main.dart)               │
│  - MultiProvider setup                       │
│  - MaterialApp config                        │
│  - Theme & Locale                            │
└────────────────┬────────────────────────────┘
                 │
                 ▼
        ┌────────────────┐
        │ CalendarScreen │ (Home)
        └────────┬───────┘
                 │
        ┌────────┴─────────┐
        │                  │
        ▼                  ▼
┌───────────────┐   ┌──────────────┐
│ Drawer Menu   │   │ FAB (+)      │
└───┬───────────┘   └──────┬───────┘
    │                      │
    │                      ▼
    │            ┌──────────────────┐
    │            │AddMedicationScreen│
    │            └──────────────────┘
    │
    ├──► MedicationListScreen
    │
    ├──► SettingsScreen
    │
    └──► AboutScreen
```

## 🔐 Permission Flow (Android)

```
APP FIRST LAUNCH
       │
       ▼
┌────────────────┐
│ Request        │
│ NOTIFICATION   │ ───► [User Grants/Denies]
│ Permission     │
└───────┬────────┘
        │
        ▼
┌────────────────┐
│ Request        │
│ EXACT ALARM    │ ───► [User Grants/Denies]
│ Permission     │      (Android 12+)
└───────┬────────┘
        │
        ▼
┌────────────────┐
│ Request        │
│ STORAGE        │ ───► [User Grants/Denies]
│ Permission     │      (For Backup)
└───────┬────────┘
        │
        ▼
┌────────────────┐
│ Suggest        │
│ DISABLE BATTERY│ ───► [Manual Setting]
│ OPTIMIZATION   │
└────────────────┘
```

## 💾 Database Structure (Hive)

```
📦 Hive Database (Local Storage)
│
├── 📁 medications (Box<Medication>)
│   ├── med-uuid-1 → Medication object
│   ├── med-uuid-2 → Medication object
│   └── med-uuid-3 → Medication object
│
└── 📁 medication_logs (Box<MedicationLog>)
    ├── log-uuid-1 → MedicationLog (for med-uuid-1)
    ├── log-uuid-2 → MedicationLog (for med-uuid-1)
    ├── log-uuid-3 → MedicationLog (for med-uuid-2)
    └── log-uuid-4 → MedicationLog (for med-uuid-3)
```

## 🌐 Localization Structure

```
📁 lib/l10n/
│
├── 📄 intl_en.arb (English translations)
│   ├── "appName": "MediMind"
│   ├── "myCalendar": "My Calendar"
│   ├── "addMedication": "Add Medication"
│   └── ... (100+ strings)
│
└── 📄 intl_pt.arb (Portuguese translations)
    ├── "appName": "MediMind"
    ├── "myCalendar": "Meu Calendário"
    ├── "addMedication": "Adicionar Medicamento"
    └── ... (100+ strings)
            │
            ▼
    [flutter gen-l10n]
            │
            ▼
📁 .dart_tool/flutter_gen/gen_l10n/
└── 📄 app_localizations.dart (Generated)
```

## 🎯 Feature Dependency Tree

```
                    📱 MediMind App
                           │
         ┌─────────────────┼─────────────────┐
         │                 │                 │
         ▼                 ▼                 ▼
   📅 Calendar      💊 Medications    ⚙️ Settings
         │                 │                 │
    ┌────┴────┐       ┌────┴────┐      ┌────┴────┐
    ▼         ▼       ▼         ▼      ▼         ▼
[View]  [Status]  [Add]    [Edit]  [Theme] [Language]
    │         │       │         │      │         │
    └─────┬───┴───────┴─────┬───┴──────┴─────────┘
          │                 │
          ▼                 ▼
    💾 Database      🔔 Notifications
          │                 │
          └────────┬────────┘
                   │
                   ▼
           📊 Medication Logs
                   │
                   ▼
          📈 Adherence Stats
```

## 🚀 Deployment Pipeline

```
┌──────────────┐
│ Source Code  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ flutter pub  │
│    get       │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ build_runner │
│  generate    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ gen-l10n     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ flutter      │
│   build      │
└──────┬───────┘
       │
   ┌───┴────┐
   │        │
   ▼        ▼
[APK]   [AAB]
   │        │
   ▼        ▼
[Test]  [Deploy]
```

## 📈 State Flow (Provider Pattern)

```
USER ACTION (UI Event)
       │
       ▼
┌─────────────────┐
│   Provider      │
│   Method Call   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Service       │
│   Operation     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Database      │
│   Update        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ notifyListeners │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   UI Rebuild    │
│   (Automatic)   │
└─────────────────┘
```

---

## 🎨 Color Scheme

```
Light Theme                Dark Theme
┌──────────────┐          ┌──────────────┐
│ Primary      │          │ Primary      │
│ #4CAF50      │ ◄──────► │ #81C784      │
│ (Green)      │          │ (Light Green)│
└──────────────┘          └──────────────┘

Status Colors (Both Themes)
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Taken        │  │ Skipped      │  │ Scheduled    │
│ #4CAF50      │  │ #F44336      │  │ #2196F3      │
│ (Green)      │  │ (Red)        │  │ (Blue)       │
└──────────────┘  └──────────────┘  └──────────────┘
```

---

**Legend:**
- 📱 = Mobile/App
- 📅 = Calendar
- 💊 = Medication
- ⚙️ = Settings
- 🔔 = Notification
- 💾 = Database
- 🎨 = UI/Design
- 🔄 = State Management
- 📊 = Data/Model
- 🌐 = Localization
- 🚀 = Deployment

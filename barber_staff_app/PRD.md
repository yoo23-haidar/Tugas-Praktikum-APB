# Product Requirements Document (PRD): Staff Application for Barbershop SaaS

## 1. Project Overview
**Product Name:** Barbershop Staff App
**Platform:** Mobile (Android & iOS)
**Tech Stack:** Flutter
**Description:** A SaaS-based barbershop management system designed specifically for barbershop staff. The app facilitates daily operational activities including staff profile management, attendance tracking, transparent salary & commission monitoring, and service documentation.

## 2. User Persona
**Persona:** Barbershop Staff Member / Barber
**Attributes:**
- Wants a fast, distraction-free interface to perform administrative tasks quickly.
- Relies on the app to track their earnings accurately and log in/out reliably every day.
- May experience varying network conditions depending on the barbershop's WiFi or signal strength.
- Needs to seamlessly capture photos of their work to showcase their portfolio to customers.

## 3. Functional Requirements

### 3.1. Profile Management (Data Staff)
- **View Profile:** Staff members can view their personal information, role inside the barbershop, and current status.
- **Update Profile:** Staff members can edit their profile data (e.g., phone number, email, profile picture, bio).

### 3.2. Attendance (Kehadiran)
- **Check-In:** Staff can record their start time when arriving at the barbershop.
- **Check-Out:** Staff can record their end time when finishing their shift.
- **Attendance History:** Staff can view a historical log of their past work days, including check-in/out times, dates, and total shift durations.

### 3.3. Salary Recap (Rekap Salary)
- **Basic Salary:** Staff can view their base salary calculated based on attendance records/hours worked.
- **Commissions:** Staff can view accumulated commissions earned per service/haircut performed.
- **Total Earnings:** A consolidated, real-time view showing the total sum of basic salary, commissions, and any other bonuses for a specified pay period.

### 3.4. Haircut Documentation (Dokumentasi Hasil Potongan)
- **Capture Photo:** Staff can use the device camera directly within the app to take photos of completed haircuts.
- **Upload Photo:** Staff can upload the captured images to the system, linking them to specific service tickets or customers.
- **Customer Gallery Integration:** Photos uploaded through this module are automatically pushed and displayed dynamically on the customer's gallery in the separate customer-facing application.

## 4. Workflow: Detailed Login-to-Checkout

1. **Authentication:** 
   - Staff opens the app and enters credentials (Email/Phone and Password). Token is saved securely.
2. **Dashboard/Home View:** 
   - Post-login, the staff is greeted by a high-contrast, terminal-like dashboard highlighting immediate actionable items: "Pending Check-In", "Today's Quick Earnings", and "Current Queue".
3. **Daily Check-In:**
   - Tap the prominent "Check-In" action button. 
   - The app securely logs the timestamp (and optionally location) and immediately caches it locally if offline.
4. **Service Execution & Documentation:**
   - Following a haircut, staff selects the corresponding service ticket.
   - Taps "Add Documentation" to invoke the camera, snaps a photo of the haircut, and confirms the upload.
   - The photo is queued for upload or uploaded immediately based on connectivity.
5. **Review Earnings:**
   - Staff tabs over to the "Salary Recap" section to review real-time updates on commissions earned for the freshly completed haircut and base pay.
6. **Daily Check-Out:**
   - At the completion of the workday, staff taps "Check-Out".
   - The app logs the end time, computes the day's working hours, and syncs the completed attendance record to the server.

## 5. Non-Functional Requirements

### 5.1. UI/UX: High-Contrast Dark Minimalist / Terminal-like
- **Design Aesthetics:** Use deep blacks (e.g., `#000000` or `#0A0A0A`), high-contrast neon/accent colors (e.g., Matrix Green `#00FF41` or Cyan `#00FFFF`) for primary actions.
- **Typography:** Monospaced fonts (like *Fira Code*, *Roboto Mono*, or *JetBrains Mono*) for numerical data, statuses, and logs to achieve a terminal aesthetic.
- **Layout:** Clean, distraction-free, grid-based layouts avoiding unnecessary graphics to emulate a direct, command-line efficiency feel.

### 5.2. Offline-First Architecture
- **Data Caching:** Local persistent storage must be utilized to cache attendance actions.
- **Background Sync:** If network requests fail due to connectivity, attendance logs (check-ins/check-outs) and photo payloads must be saved locally and pushed to the background queue to sync automatically once internet connectivity is restored.

### 5.3. Security & API Communication
- **Networking:** All network requests will run over HTTPS.
- **Authentication Handling:** Token-based architecture (e.g., JWT). Tokens must be encrypted and stored using secure storage mechanisms. Request interceptors will handle token injection and automatic token refreshing.
- **Data Minimization:** Expose only staff-specific data necessary for the dashboard; restrict access from broader administrative endpoints.

## 6. Tech Stack

- **App Framework:** Flutter (building primarily for mobile).
- **Architecture Strategy:** Clean Feature-First Architecture. 
  - *Structure:* Grouped by features (e.g., `features/auth`, `features/attendance`, `features/salary`, `features/documentation`), inside each having `data`, `domain`, and `presentation` layers.
- **Networking:** `dio` for robust HTTP requests, utilizing intercepts for authorization, logging, and global error handling.
- **State Management:** *Flutter Riverpod* or *BLoC* (recommended for complex feature-first modularization).
- **Local Storage/Offline Cache:** `hive` or `isar` for fast offline caching of attendance; `flutter_secure_storage` for credentials.
- **Hardware Integrations:** `camera` and `image_picker` for integrated photography flows.

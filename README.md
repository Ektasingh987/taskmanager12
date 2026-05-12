# 📝 Premium Task Manager

A high-performance, real-time Task Management application built with **Flutter**, **Cloud Firestore**, and **Provider**. This app features a premium glassmorphism UI, real-time database synchronization, and motivational quotes integration.

---

## 🚀 Key Features

*   **Real-time Synchronization**: Powered by Cloud Firestore for instant updates across devices.
*   **Authentication**: Secure User Login and Sign-up using Firebase Auth.
*   **Task Management**: Complete CRUD functionality (Create, Read, Update, Delete).
*   **Motivational Quotes**: Dynamic quotes fetched from the Quotable API to keep you inspired.
*   **Premium UI**: Sleek design with glassmorphism elements, custom themes, and smooth transitions.
*   **Clean Architecture**: Modular code structure for scalability and maintainability.

---

## 🛠️ Tech Stack & Libraries

### Core
*   **Flutter**: Framework for high-performance cross-platform development.
*   **Dart**: Programming language used for logic and UI.

### Backend (Firebase)
*   **`firebase_core`**: To initialize Firebase services.
*   **`firebase_auth`**: For user identity and secure authentication.
*   **`cloud_firestore`**: As the primary NoSQL document database for real-time task storage.

### State Management
*   **`provider`**: Used for efficient dependency injection and reactive state management.

### Networking & Utilities
*   **`http`**: For communicating with the Quotable API.
*   **`intl`**: For date and time formatting.
*   **`google_fonts`**: For premium typography.

---

## 📂 Project Structure

```text
lib/
├── models/          # Data structures (TaskModel)
├── providers/       # State management logic (Auth, Task, Quote)
├── screens/         # UI Screens (Login, Home, Task Form)
├── services/        # Backend communication (Firebase, API)
├── utils/           # Themes and constants
└── widgets/         # Reusable UI components (TaskCard, QuoteWidget)
```

---

## ⚙️ Setup & Installation

### Prerequisites
*   Flutter SDK installed.
*   A Firebase project created in the [Firebase Console](https://console.firebase.google.com/).
*   Windows Developer Mode enabled (for building on Windows).

### Steps
1.  **Clone the project**:
    ```bash
    git clone <repository-url>
    ```
2.  **Add Firebase Configuration**:
    *   Download `google-services.json` from your Firebase project.
    *   Place it in `android/app/`.
3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Firestore Indexing**:
    *   This app requires a **Composite Index** in Firestore. 
    *   Fields: `userId` (Ascending) and `date` (Descending).
    *   You can create this in the Firestore "Indexes" tab.
5.  **Run the App**:
    ```bash
    flutter run
    ```

---

## 🛡️ Security Rules (Firestore)

To keep your data safe, ensure your Firestore rules are set as follows:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == request.resource.data.userId;
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

---

**GitHub Repository**: [https://github.com/Ektasingh987/taskmanager12.git](https://github.com/Ektasingh987/taskmanager12.git)

---
*Last Updated: May 12, 2026*

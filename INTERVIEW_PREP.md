# 🎓 Project Interview Preparation Guide

This document contains potential interview questions and professional answers based on the **Premium Task Manager** project. Use this to prepare for technical rounds or project walkthroughs.

---

## 🏗️ Architecture & State Management

### Q1: Why did you choose Provider for state management instead of Bloc or Riverpod?
**Answer:**
I chose **Provider** because of its balance between simplicity and power. For a Task Manager app, Provider offers:
1.  **Low Boilerplate**: It's easy to set up and read compared to Bloc's event-state streams.
2.  **Efficiency**: It uses Flutter's `InheritedWidget` under the hood, ensuring only the widgets that depend on a specific piece of state are rebuilt.
3.  **Scalability**: By using `MultiProvider`, the architecture remains modular, allowing separate providers for `Auth`, `Tasks`, and `Quotes`.

### Q2: How does the application handle real-time updates?
**Answer:**
The app leverages **Firestore Streams**. In the `TaskProvider`, I use a `StreamSubscription` to listen to the `tasks` collection. Whenever a document is added, updated, or deleted in Firestore, the stream emits a new snapshot. We then map this snapshot to our `TaskModel` list and call `notifyListeners()`, which triggers a UI rebuild instantly across all connected devices.

---

## ☁️ Firebase & Firestore

### Q3: Why did you need a "Composite Index" in Firestore?
**Answer:**
Firestore requires a composite index when performing a query that involves **multiple fields** where at least one is filtered and another is sorted. 
In this project, we query tasks by `userId` (filtering) and sort them by `date` (sorting). A single-field index isn't enough for this specific combination, so we manually created an index for `userId` (Ascending) + `date` (Descending).

### Q4: Explain the Security Rules you implemented for this project.
**Answer:**
Security is handled at the database level using **Firestore Security Rules**. 
*   **Authentication**: We ensure `request.auth != null`, so only logged-in users can access data.
*   **Ownership**: We use `request.auth.uid == resource.data.userId` for updates/deletes and `request.auth.uid == request.resource.data.userId` for creations. This ensures that User A cannot read or modify User B's tasks, even if they know the Document ID.

---

## 🎨 UI/UX & Design

### Q5: How did you implement the "Premium" look and Glassmorphism?
**Answer:**
The premium aesthetic was achieved through:
1.  **BackdropFilter**: Using the `ImageFilter.blur` to create the frosted glass effect.
2.  **Opacity & Gradients**: Using semi-transparent containers with subtle white borders to simulate glass edges.
3.  **Typography**: Using `GoogleFonts` (like 'Outfit' or 'Inter') to give it a modern, clean feel.
4.  **Micro-animations**: Using `Flutter Spinkit` for loading states and smooth transitions between screens.

---

## 🌐 Networking & API

### Q6: How do you handle API failures (e.g., the Quotable API is down)?
**Answer:**
I implemented a robust error-handling layer in the `QuoteProvider`. 
1.  **Try-Catch Blocks**: All HTTP requests are wrapped in try-catch to handle timeouts or lack of internet.
2.  **Graceful Degradation**: If the API fails, the app doesn't crash; instead, it shows a "local fallback quote" or a user-friendly error message in the UI while allowing the rest of the app (task management) to function normally.
3.  **Loading States**: We use a `status` enum or boolean to show a loader while the data is fetching, preventing the user from seeing empty or broken widgets.

---

## 🚀 Performance & Best Practices

### Q7: How did you ensure the app remains performant as the number of tasks grows?
**Answer:**
1.  **Lazy Loading**: We use `ListView.builder` which only renders the items currently visible on the screen.
2.  **Optimized Rebuilds**: Using `Consumer` and `Selector` from Provider to ensure that only the smallest possible part of the UI rebuilds when data changes.
3.  **Indexing**: As mentioned before, proper Firestore indexing ensures that queries remain fast (O(log n)) regardless of the size of the database.

---
*Generated for: Ektasingh987/taskmanager12*

# SoftleticsPro IMS Flutter - Firebase Edition

A comprehensive Internal Management System (IMS) built with Flutter and **Firebase** as the primary backend. This application provides role-based access control for Admins, Project Managers, Employees, and Clients to manage projects, tasks, and team collaboration efficiently.

## 🔥 Firebase Architecture Overview

This project has been **completely migrated from REST API to Firebase** for a serverless, real-time backend solution:

```
lib/
├── core/
│   ├── firebase/            # Firebase service layer
│   │   └── firebase_service.dart
│   ├── constants/           # App constants and Firebase collections
│   ├── error/              # Error handling
│   └── injection/          # Dependency injection with Firebase
├── data/                    # Data layer
│   ├── models/             # Data models (compatible with Firestore)
│   └── repositories/       # Repository implementations using Firebase
├── domain/                  # Domain layer (Business logic)
│   ├── repositories/       # Repository interfaces
│   └── usecases/          # Business use cases
└── presentation/           # Presentation layer
    ├── app/               # Main app setup
    ├── bloc/              # State management (BLoC)
    ├── screens/           # UI screens
    └── widgets/           # Reusable UI components
```

## 🔧 Firebase Tech Stack

### **Firebase Services Used:**
- **🔐 Firebase Authentication**: User login, registration, password reset
- **📊 Cloud Firestore**: Real-time NoSQL database
- **📁 Firebase Storage**: File and image storage
- **🔔 Firebase Messaging**: Push notifications
- **📈 Firebase Analytics**: User behavior tracking (optional)

### **Flutter Stack:**
- **Framework**: Flutter 3.9.0+
- **State Management**: flutter_bloc 8.1.3
- **Dependency Injection**: get_it 7.6.4 + injectable 2.3.2
- **Local Storage**: shared_preferences 2.2.2 + hive 2.2.3
- **UI**: flutter_screenutil + Material Design 3

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.0 or higher
- Firebase project setup
- Android Studio / VS Code with Flutter extensions

### Firebase Setup

1. **Create Firebase Project**
   ```bash
   # Go to https://console.firebase.google.com/
   # Create a new project: "softleticspro-ims"
   ```

2. **Enable Firebase Services**
   - Authentication (Email/Password)
   - Cloud Firestore
   - Storage
   - Cloud Messaging

3. **Configure Firebase for Flutter**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```

4. **Update Firebase Configuration**
   - Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase project configuration

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd SoftleticsPro_ims_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📊 Firebase Database Structure

### Firestore Collections

```javascript
// Users Collection
users/{userId} {
  id: string,
  firstName: string,
  lastName: string,
  email: string,
  role: 'admin' | 'project_manager' | 'employee' | 'client',
  phone?: string,
  department?: string,
  position?: string,
  status: 'active' | 'inactive',
  createdAt: timestamp,
  updatedAt: timestamp,
  lastLoginAt?: timestamp
}

// Projects Collection
projects/{projectId} {
  id: string,
  name: string,
  description: string,
  status: 'planning' | 'in_progress' | 'on_hold' | 'completed' | 'cancelled',
  managerId: string,
  teamMemberIds: string[],
  startDate: timestamp,
  endDate?: timestamp,
  budget?: number,
  progress: number,
  createdAt: timestamp,
  updatedAt: timestamp
}

// Tasks Collection
tasks/{taskId} {
  id: string,
  title: string,
  description: string,
  projectId: string,
  assignedTo: string,
  status: 'pending' | 'in_progress' | 'completed' | 'cancelled',
  priority: 'low' | 'medium' | 'high' | 'urgent',
  startDate?: timestamp,
  dueDate?: timestamp,
  completedAt?: timestamp,
  attachments?: string[],
  comments?: object[],
  createdAt: timestamp,
  updatedAt: timestamp
}

// Notifications Collection
notifications/{notificationId} {
  id: string,
  userId: string,
  title: string,
  message: string,
  type: 'task' | 'project' | 'system',
  isRead: boolean,
  data?: object,
  createdAt: timestamp
}
```

### Firebase Storage Structure

```
storage/
├── profile_images/
│   └── {userId}/
│       └── profile.jpg
├── project_files/
│   └── {projectId}/
│       ├── documents/
│       └── images/
├── task_attachments/
│   └── {taskId}/
│       ├── files/
│       └── images/
└── documents/
    └── shared/
```

## 🏛️ Architecture Details

### Firebase Service Layer

The `FirebaseService` class provides centralized access to all Firebase operations:

```dart
@lazySingleton
class FirebaseService {
  // Authentication
  Future<UserCredential> signInWithEmailAndPassword({...});
  Future<UserCredential> createUserWithEmailAndPassword({...});
  Future<void> signOut();
  
  // Firestore Operations
  Future<void> createUserProfile(UserResponse user);
  Future<UserResponse?> getUserProfile(String userId);
  Future<List<ProjectResponse>> getProjectsForUser({...});
  
  // Real-time Listeners
  Stream<List<ProjectResponse>> watchProjectsForUser({...});
  Stream<List<TaskResponse>> watchTasksForProject(String projectId);
  
  // File Storage
  Future<String> uploadFile({...});
  Future<void> deleteFile(String downloadUrl);
}
```

### Key Benefits of Firebase Migration

✅ **Real-time Updates**: Automatic UI updates when data changes  
✅ **Offline Support**: Firestore provides built-in offline capabilities  
✅ **Scalability**: Firebase scales automatically with usage  
✅ **Security**: Built-in security rules and authentication  
✅ **Cost-Effective**: Pay only for what you use  
✅ **No Backend Maintenance**: Fully managed by Google  

### Security Rules

Configure Firestore security rules to protect your data:

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Project access based on team membership
    match /projects/{projectId} {
      allow read: if request.auth != null && 
        (request.auth.uid in resource.data.teamMemberIds || 
         request.auth.uid == resource.data.managerId);
      allow write: if request.auth != null && 
        request.auth.uid == resource.data.managerId;
    }
    
    // Task access based on project membership
    match /tasks/{taskId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.assignedTo ||
         request.auth.uid in get(/databases/$(database)/documents/projects/$(resource.data.projectId)).data.teamMemberIds);
    }
  }
}
```

## 🔄 Migration from REST API

### What Changed:

1. **Authentication**: Firebase Auth instead of JWT tokens
2. **Database**: Firestore instead of REST endpoints
3. **File Storage**: Firebase Storage instead of file upload API
4. **Real-time**: Native Firestore listeners instead of polling
5. **Offline**: Built-in offline support

### Removed Dependencies:
- ❌ `dio` - HTTP client
- ❌ `retrofit` - API client generator
- ❌ Custom API client and interceptors

### Added Dependencies:
- ✅ `firebase_auth` - Authentication
- ✅ `cloud_firestore` - Database
- ✅ `firebase_storage` - File storage
- ✅ `firebase_messaging` - Push notifications

## 📱 Features

### User Roles & Permissions

#### 🔴 Admin
- **Firebase Rules**: Full read/write access to all collections
- **Features**: User management, system configuration, analytics

#### 🔵 Project Manager
- **Firebase Rules**: Read/write access to assigned projects and team data
- **Features**: Project creation, task assignment, team management

#### 🟢 Employee
- **Firebase Rules**: Read access to assigned projects, write access to own tasks
- **Features**: Task updates, time tracking, team communication

#### 🟡 Client
- **Firebase Rules**: Read-only access to assigned project status
- **Features**: Project visibility, status updates, feedback

### Core Modules

#### 🔐 Authentication Module
- **Firebase Auth Integration**: Email/password authentication
- **Automatic Token Management**: Firebase handles token refresh
- **Password Reset**: Built-in Firebase password reset
- **Real-time Auth State**: Listen to auth state changes

#### 📊 Dashboard Module
- **Real-time Data**: Live updates from Firestore
- **Role-based Views**: Dynamic UI based on user role
- **Offline Support**: Cached data when offline

#### 📁 Project Management Module
- **Real-time Collaboration**: Live project updates
- **File Attachments**: Firebase Storage integration
- **Team Management**: Real-time team member updates

#### ✅ Task Management Module
- **Live Task Updates**: Real-time task status changes
- **File Attachments**: Direct Firebase Storage uploads
- **Comments & Activity**: Real-time activity feeds

## 🚀 Deployment

### Firebase Hosting (Web)
```bash
# Build for web
flutter build web

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

### Mobile App Deployment
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🔧 Development Commands

```bash
# Install dependencies
flutter pub get

# Generate code (models, DI)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run with Firebase emulators (development)
firebase emulators:start

# Run app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

## 📝 Environment Configuration

Create different Firebase projects for different environments:

- **Development**: `softleticspro-ims-dev`
- **Staging**: `softleticspro-ims-staging`
- **Production**: `softleticspro-ims-prod`

## 🎯 Next Steps

1. **Firebase Setup**: Configure your Firebase project
2. **Security Rules**: Implement proper Firestore security rules
3. **Testing**: Add unit and integration tests
4. **Performance**: Optimize Firestore queries and implement pagination
5. **Analytics**: Add Firebase Analytics for user behavior tracking
6. **Crashlytics**: Implement Firebase Crashlytics for error tracking

---

**Version**: 2.0.0 (Firebase Edition)  
**Maintained by**: SoftleticsPro Development Team  
**Backend**: Firebase (Serverless)  
**Database**: Cloud Firestore  
**Authentication**: Firebase Auth

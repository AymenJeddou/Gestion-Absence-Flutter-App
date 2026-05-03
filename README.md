# 📱 Gestion d'Absence - Flutter App

## 📌 Project Overview

This project is a **Student Attendance Management System** built using **Flutter (frontend)** and **PHP/MySQL (backend)**.

It allows administrators, teachers, and students to manage and track attendance efficiently.

---

## 🚀 Features

### 👨‍💼 Admin

* Manage students (add, view, delete)
* Manage teachers (add, view, delete)
* Manage classes
* Manage sessions (séances)

### 👨‍🏫 Teacher

* View assigned sessions
* Track student attendance

### 🎓 Student

* Login to account
* View attendance status

---

## 🛠️ Technologies Used

### Frontend

* Flutter
* Dart
* HTTP package

### Backend

* PHP (API)
* MySQL (Database)
* XAMPP (Local server)

---

## 📂 Project Structure

```
lib/
 ├── config/          # API configuration
 ├── screens/
 │    ├── admin/      # Admin screens
 │    ├── enseignant/ # Teacher screens
 │    ├── etudiant/   # Student screens
 ├── services/        # API services
 └── main.dart        # Entry point
```

---

## ⚙️ Setup Instructions

### 1. Clone the repository

```bash
git clone <your-repo-url>
```

---

### 2. Install dependencies

```bash
flutter pub get
```

---

### 3. Configure Backend

* Place backend folder in:

```
C:\xampp\htdocs\gest_absence_api
```

* Start:

  * Apache ✅
  * MySQL ✅

* Open:

```
http://localhost/phpmyadmin
```

* Import or create database:

```
gest_absence
```

---

### 4. Configure API URL

Open:

```
lib/config/api_config.dart
```

Set:

```dart
const String baseUrl = "http://localhost/gest_absence_api";
```

---

### 5. Run the app

```bash
flutter run
```

---

## 🔑 Default Login Credentials

### Admin

* Email: [admin@school.tn](mailto:admin@school.tn)
* Password: admin123

### Teacher

* Email: [sami@school.tn](mailto:sami@school.tn)
* Password: prof123

### Student

* Email: [amine@school.tn](mailto:amine@school.tn)
* Password: etu123

---

## 🧪 Testing

* Ensure XAMPP is running
* Verify API endpoints in browser:

```
http://localhost/gest_absence_api/admin/etudiants.php
```

---

## ⚠️ Notes

* This project is for educational purposes
* Security improvements (like password hashing) are not implemented
* CORS is enabled for development

---

## 👨‍💻 Authors

* Aymen Jeddou
* Abderrahim Neji

---

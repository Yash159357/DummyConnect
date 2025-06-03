# 🚀 DummyConnect

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/BLoC-4285F4?style=for-the-badge&logo=flutter&logoColor=white" alt="BLoC">
  <img src="https://img.shields.io/badge/API-DummyJSON-FF6B6B?style=for-the-badge" alt="DummyJSON">
</div>

<div align="center">
  <h3>A modern Flutter app showcasing clean architecture with BLoC pattern</h3>
  <p>Fetches and displays user data, posts, and todos from the DummyJSON API</p>
</div>

---

> **📋 Internship Assessment Project – Flutter Developer Role**  
> **🗓️ Deadline:** 4th June 2025

## ✨ Features

<table>
  <tr>
    <td>🔍</td>
    <td><strong>User List with Infinite Scroll & Real-time Search</strong></td>
  </tr>
  <tr>
    <td>📄</td>
    <td><strong>User Details with Posts & Todos</strong></td>
  </tr>
  <tr>
    <td>📝</td>
    <td><strong>Create Post Locally</strong></td>
  </tr>
  <tr>
    <td>🔁</td>
    <td><strong>Pull-to-Refresh Support</strong> <em>(Bonus)</em></td>
  </tr>
  <tr>
    <td>🌗</td>
    <td><strong>Light/Dark Theme Toggle</strong> <em>(Bonus)</em></td>
  </tr>
  <tr>
    <td>💡</td>
    <td><strong>Clean Architecture with flutter_bloc</strong></td>
  </tr>
</table>

## 🏗️ Architecture Overview

This project follows the **BLoC (Business Logic Component)** pattern for predictable state management and clean architecture principles.

```
lib/
├── 📁 models/          # Data models (User, Post, Todo)
├── 📁 services/        # API calls (UserService, PostService, TodoService)
├── 📁 cubits/          # State management using Cubits
├── 📁 screens/         # UI screens & widgets
├── 📁 constants/       # API endpoints & configuration
├── 📁 utils/           # Helper functions (debounce, etc.)
└── 📄 main.dart        # App entry point with MultiBlocProvider
```

## 📡 API Integration

Powered by the [**DummyJSON API**](https://dummyjson.com/docs) 🌐

| Endpoint | Purpose | Features |
|----------|---------|----------|
| `/users` | List users | ✅ Pagination & Search |
| `/posts/user/{userId}` | User's posts | ✅ Dynamic loading |
| `/todos/user/{userId}` | User's todos | ✅ Interactive display |

> **📝 Note:** Pagination handled via `limit` and `skip` query parameters  
> **🔍 Search:** Client-side filtering by user name for optimal performance

## 🎨 Screenshots

<div align="center">
  
  | User List Screen | User Details | Create Post |
  |------------------|--------------|-------------|
  | <img src="https://github.com/Yash159357/DummyConnect/blob/main/assets/UserList.png" alt="User List Screen" width="250"/> | <img src="https://github.com/Yash159357/DummyConnect/blob/main/assets/UserDetail.png" alt="User Details Screen" width="250"/> | <img src="https://github.com/Yash159357/DummyConnect/blob/main/assets/CreatePost.png" alt="Create Post Screen" width="250"/> |
</div>

## 🧠 State Management

Built with [`flutter_bloc`](https://bloclibrary.dev) for robust state management:

<table>
  <thead>
    <tr>
      <th>🎯 Cubit Name</th>
      <th>📋 Responsibility</th>
      <th>🔄 States</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>UserListCubit</code></td>
      <td>Fetch users, search, pagination</td>
      <td rowspan="4">
        • Loading<br>
        • Success<br>
        • Error
      </td>
    </tr>
    <tr>
      <td><code>UserDetailCubit</code></td>
      <td>Fetch user's posts and todos</td>
    </tr>
    <tr>
      <td><code>PostCubit</code></td>
      <td>Add local posts</td>
    </tr>
    <tr>
      <td><code>TodosCubit</code></td>
      <td>Local todo state management</td>
    </tr>
  </tbody>
</table>

## 🛠️ Setup Instructions

### Prerequisites
- Flutter 3.x 📱
- Dart 3.x ⚡
- Internet connection 🌐

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/dummyconnect.git
   cd dummyconnect
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

4. **Format code** *(Optional)*
   ```bash
   flutter format .
   ```

## ⚠️ Known Limitations

| Limitation | Details |
|------------|---------|
| 📝 **Local Posts** | Posts are created locally and not persisted on server |
| ✅ **Todo States** | Todo toggle states are managed locally only |
| 💾 **No Offline Cache** | Planned for future improvement |

## 🎉 Bonus Features

- 🔄 **Pull-to-refresh** on user list
- 🌓 **Light/Dark theme** toggle
- 🧩 **Modular widgets** (UserTile, PostTile, etc.)
- 📱 **Responsive design** for various screen sizes

## 🏆 Tech Stack

<div align="center">
  <img src="https://img.shields.io/badge/Framework-Flutter-02569B?style=flat-square&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Language-Dart-0175C2?style=flat-square&logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/State%20Management-BLoC-4285F4?style=flat-square" alt="BLoC">
  <img src="https://img.shields.io/badge/Architecture-Clean-00C853?style=flat-square" alt="Clean Architecture">
  <img src="https://img.shields.io/badge/API-REST-FF5722?style=flat-square" alt="REST API">
</div>

## 📄 License

This project is open for **review and educational use only**.

## 🙏 Acknowledgements

- 🎯 [**DummyJSON**](https://dummyjson.com/) for providing an excellent free API
- 🧩 [**BLoC Library**](https://bloclibrary.dev/) for powerful state management tools
- 💙 **Flutter Community** for continuous support and resources

---

<div align="center">
  <h3>👨‍💻 Author</h3>
  <p><strong>Yash</strong><br>
  CSE Student – USICT, New Delhi<br>
  <a href="https://github.com/your-username">🔗 GitHub: @your-username</a></p>
</div>

<div align="center">
  <p><em>Built with ❤️ using Flutter & BLoC</em></p>
</div>

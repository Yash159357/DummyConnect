// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Services
import 'package:dummy_connect/service/user_service.dart';
import 'package:dummy_connect/service/todo_service.dart';

// Cubits
import 'package:dummy_connect/controllers/cubits/todos/todo_cubit.dart';
import 'package:dummy_connect/controllers/cubits/todo_statistics/todo_statistics_cubit.dart';
import 'package:dummy_connect/controllers/cubits/todo_management/todo_management_cubit.dart';
import 'package:dummy_connect/controllers/cubits/todo_form/todo_form_cubit.dart';
import 'package:dummy_connect/controllers/cubits/post_create/post_create_cubit.dart';

// Blocs
import 'package:dummy_connect/controllers/blocs/user_detail_bloc/user_detail_bloc.dart';
import 'package:dummy_connect/controllers/blocs/user_list_bloc/user_list_bloc.dart';

// Views
import 'package:dummy_connect/views/splash_screen.dart';

// Theme(onyl dark mode working for now)
import 'package:dummy_connect/views/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  _configureSystemUI();
  _setPreferredOrientations();
  
  runApp(const DummyConnectApp());
}

/// Configure system UI overlay style
void _configureSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Hide the system navigation bar completely
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top], // Only show status bar
  );
}

// Set preferred device orientations(app is non responsive)
void _setPreferredOrientations() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class DummyConnectApp extends StatelessWidget {
  const DummyConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: _buildRepositoryProviders(),
      child: MultiBlocProvider(
        providers: _buildBlocProviders(),
        child: MaterialApp(
          title: 'DummyConnect',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const SplashScreen(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
                ),
              ),
              // Wrap with AnnotatedRegion to ensure system UI changes apply
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarIconBrightness: Brightness.light,
                ),
                child: child!,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build all BLoC providers for the app
  List<BlocProvider> _buildBlocProviders() {
    return [
      ..._buildUserProviders(),
      ..._buildPostProviders(),      
      ..._buildTodoProviders(),
    ];
  }

  /// Build repository providers
  List<RepositoryProvider> _buildRepositoryProviders() {
    return [
      RepositoryProvider<UserService>(
        create: (_) => UserService(),
      ),
      RepositoryProvider<TodoService>(
        create: (_) => TodoService(),
      ),
    ];
  }

  /// Build user-related BLoC providers
  List<BlocProvider> _buildUserProviders() {
    return [
      BlocProvider<UserListBloc>(
        create: (context) => UserListBloc(
          userRepository: context.read<UserService>(),
        ),
      ),
      BlocProvider<UserDetailBloc>(
        create: (context) => UserDetailBloc(
          userRepository: context.read<UserService>(),
        ),
      ),
    ];
  }

  /// Build post-related BLoC providers
  List<BlocProvider> _buildPostProviders() {
    return [
      BlocProvider<PostCubit>(
        create: (_) => PostCubit(),
      ),
    ];
  }

  /// Build todo-related BLoC providers
  List<BlocProvider> _buildTodoProviders() {
    return [
      BlocProvider<TodosCubit>(
        create: (context) => TodosCubit(
          context.read<TodoService>(),
        ),
      ),      
      BlocProvider<TodoStatisticsCubit>(
        create: (context) => TodoStatisticsCubit(
          context.read<TodosCubit>(),
        ),
      ),      
      BlocProvider<TodoManagementCubit>(
        create: (context) => TodoManagementCubit(
          context.read<TodoService>(),
          context.read<TodosCubit>(),
        ),
      ),      
      BlocProvider<TodoFormCubit>(
        create: (_) => TodoFormCubit(),
      ),
    ];
  }
}
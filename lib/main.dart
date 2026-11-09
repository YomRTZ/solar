import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_app/app/routing/app_router.dart';
import 'package:flutter_app/core/bloc/app_bloc_observer.dart';
import 'package:flutter_app/core/theme/app_theme.dart';
import 'package:flutter_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_app/features/products/data/repositories/in_memory_product_repository.dart';
import 'package:flutter_app/features/products/domain/repositories/product_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Register the global BLoC observer for debug logging
  Bloc.observer = const AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
          create: (_) => InMemoryProductRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [BlocProvider<AuthCubit>(create: (_) => AuthCubit())],
        child: MaterialApp.router(
          title: 'SolarTradeXHub',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}

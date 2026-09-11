import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/features/product_page/presentation/blocs/product_page_bloc.dart';

import 'core/routes/routes.dart' show Routes;
import 'core/services/service_locator.dart';
import 'features/inventory_session/presentation/blocs/inventory_session_bloc.dart';
import 'features/store_selection/presentation/blocs/store_selection_bloc.dart';

void main() {
  ServiceLocator().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<StoreSelectionBloc>()),
        BlocProvider(create: (_) => getIt<InventorySessionBloc>()),
        BlocProvider(create: (_) => getIt<ProductPageBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        routerConfig: Routes.goRouter,
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
      ),
    );
  }
}


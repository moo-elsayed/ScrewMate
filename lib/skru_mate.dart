import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';

class SkruMate extends StatelessWidget {
  const SkruMate({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        title: 'SkruMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        initialRoute: Routes.homeView,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}

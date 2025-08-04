import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/routing/app_router.dart';
import 'package:skru_mate/screw_mate.dart';
import 'package:skru_mate/simple_bloc_onserver.dart';
import 'core/helpers/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  Bloc.observer = SimpleBlocObserver();
  setupServiceLocator();
  runApp(ScrewMate(appRouter: AppRouter()));
}

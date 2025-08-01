import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skru_mate/core/routing/app_router.dart';
import 'package:skru_mate/screw_mate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(ScrewMate(appRouter: AppRouter()));
}

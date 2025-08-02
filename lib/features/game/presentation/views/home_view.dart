import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../widgets/drawer_body.dart';
import '../widgets/home_view_body.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250.w),
          child: const Drawer(child: DrawerBody()),
        ),
      ),
      appBar: const CustomAppBar(),
      body: const SafeArea(child: HomeViewBody()),
    );
  }
}

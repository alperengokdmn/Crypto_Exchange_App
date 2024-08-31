import 'package:cryptocurrency/feature/home/home_view.dart';
import 'package:cryptocurrency/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import '../../Currency/company_view.dart';
import '../../Currency/currency_view.dart';
import '../bloc/bottom_nav_cubit.dart';
import '../gold_view.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// Top Level Pages
  final List<Widget> topLevelPages =  [
    HomeView(),
    CurrencyView(),
    AltinWidget(),
    CompanyView()

  ];

  /// on Page Changed
  void onPageChanged(int page) {
    BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 2, 2),
      body: _mainWrapperBody(),
      bottomNavigationBar: _mainWrapperBottomNavBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  // Bottom Navigation Bar - MainWrapper Widget
  BottomAppBar _mainWrapperBottomNavBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bottomAppBarItem(
            context,
            defaultIcon: IconlyLight.chart,
            page: 0,
            label: "Kripto",
            filledIcon: IconlyBold.chart,
          ),
          _bottomAppBarItem(
            context,
            defaultIcon: Icons.attach_money_sharp,
            page: 1,
            label: "Doviz",
            filledIcon:  Icons.attach_money_sharp,
          ),
          _bottomAppBarItem(
            context,
            defaultIcon: IconlyLight.activity,
            page: 2,
            label: "Altın",
            filledIcon: IconlyBold.activity,
          ),
          _bottomAppBarItem(
            context,
            defaultIcon: IconlyLight.category,
            page: 3,
            label: "Kampanya",
            filledIcon: IconlyBold.category,
          ),
        ],
      ),
    );
  }





  // Body - MainWrapper Widget
  PageView _mainWrapperBody() {
    return PageView(
      onPageChanged: (int page) => onPageChanged(page),
      controller: pageController,
      children: topLevelPages,
    );
  }

  // Bottom Navigation Bar Single item - MainWrapper Widget
  Widget _bottomAppBarItem(
    BuildContext context, {
    required defaultIcon,
    required page,
    required label,
    required filledIcon,
  }) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<BottomNavCubit>(context).changeSelectedIndex(page);

        pageController.animateToPage(page,
            duration: const Duration(milliseconds: 10),
            curve: Curves.fastLinearToSlowEaseIn);
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 1,
            ),
            Icon(
              context.watch<BottomNavCubit>().state == page
                  ? filledIcon
                  : defaultIcon,
              color: context.watch<BottomNavCubit>().state == page
                  ? Colors.amber
                  : Colors.grey,
              size: 25,
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              label,
              style: GoogleFonts.aBeeZee(
                color: context.watch<BottomNavCubit>().state == page
                    ? Colors.amber
                    : Colors.grey,
                fontSize: 13,
                fontWeight: context.watch<BottomNavCubit>().state == page
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

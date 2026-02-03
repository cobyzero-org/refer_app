import 'package:flutter/material.dart';
import 'package:refer_app/core/constants/app_constants.dart';
import 'package:refer_app/features/home/widgets/auth_card.dart';
import 'package:refer_app/features/home/widgets/banner_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 20,
        leadingWidth: 18,
        title: Text(
          '¡Buenas tardes!',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.3,
          ),
        ),
        /* actions: [
          InkWell(
            onTap: () {},
            child: SvgPicture.asset('assets/icon/notification_bell_icon.svg'),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {},
            child: SvgPicture.asset('assets/icon/three_dots_icon.svg'),
          ),
          const SizedBox(width: 20),
        ],*/
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingHorizontal,
            vertical: AppConstants.paddingVertical,
          ),
          child: Column(
            children: [
              /* const PointDetail(),*/
              const BannerCard(),
              const SizedBox(height: AppConstants.paddingVertical),
              const AuthCard(),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingVertical,
                ),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return const BannerCard();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: AppConstants.paddingVertical);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:refer_app/core/constants/app_constants.dart';
import 'package:refer_app/core/constants/app_fake_data.dart';
import 'package:refer_app/features/menu/ui/widgets/app_bar_menu.dart';
import 'package:refer_app/features/menu/ui/widgets/chip_container.dart';
import 'package:refer_app/features/menu/ui/widgets/product_card.dart';
import 'package:refer_app/features/menu/ui/widgets/search_menu.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: AppFakeData.categories.length,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingHorizontal,
                ),
                child: AppBarMenu(),
              ),
              const SizedBox(height: AppConstants.paddingVertical),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingHorizontal,
                ),
                child: SearchMenu(),
              ),
              const SizedBox(height: 10),
              TabBar(
                dividerHeight: 0,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: AppFakeData.categories
                    .map((e) => Tab(text: e.name))
                    .toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: AppFakeData.categories
                      .map(
                        (e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.paddingHorizontal,
                                  vertical: 15,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: AppFakeData.subCategories.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return ChipContainer(
                                      text: 'Todo',
                                      isSelected: true,
                                    );
                                  }
                                  final subCategory =
                                      AppFakeData.subCategories[index - 1];
                                  return ChipContainer(
                                    text: subCategory.name,
                                    isSelected: false,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(width: 10);
                                },
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppConstants.paddingHorizontal,
                                      ),
                                      child: Text(
                                        e.name,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            AppConstants.paddingHorizontal,
                                        vertical: 10,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 0.8,
                                            crossAxisSpacing: 10,
                                          ),
                                      itemCount: AppFakeData.products.length,
                                      itemBuilder: (context, index) {
                                        final product =
                                            AppFakeData.products[index];
                                        return ProductCard(product: product);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

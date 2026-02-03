import 'package:flutter/material.dart';
import 'package:refer_app/core/utils/widgets/app_button.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.asset(
                  'assets/images/campaign.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12.0, top: 12.0),
                child: Text(
                  'Empieza el verano lleno de Pistacho',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12.0, top: 6.0),
                child: Text(
                  'Disfruta cada momento con un sabor especial:\nPistacho Latte, Frío o Frappucino.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            AppButton(
              onPressed: () {},
              title: 'Pidelo ahora',
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}

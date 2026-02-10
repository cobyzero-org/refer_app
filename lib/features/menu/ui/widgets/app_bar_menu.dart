import 'package:flutter/material.dart';

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comienza tu pedido ahora',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Elige tu opcíon de entrega',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(Icons.shopping_cart_outlined, color: theme.colorScheme.primary),
      ],
    );
  }
}

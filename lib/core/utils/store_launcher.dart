import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../widgets/app_snackbar.dart';
import 'app_version.dart';

/// Abre la ficha de la app en la tienda (Play / App Store).
/// Si no hay URL disponible o falla, muestra aviso con el snackbar global.
/// Retorna true si se pudo lanzar.
Future<bool> openAppStore(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  try {
    final packageName = (await PackageInfo.fromPlatform()).packageName;
    final uri = AppUpdateConfig.storeUri(packageName: packageName);
    if (uri == null) {
      if (context.mounted) {
        AppSnackBar.error(context, l10n.couldNotOpenStore);
      }
      return false;
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      AppSnackBar.error(context, l10n.couldNotOpenStore);
    }
    return launched;
  } catch (_) {
    if (context.mounted) {
      AppSnackBar.error(context, l10n.couldNotOpenStore);
    }
    return false;
  }
}

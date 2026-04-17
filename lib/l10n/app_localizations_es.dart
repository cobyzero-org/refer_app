// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomeBack => 'Bienvenido de nuevo.';

  @override
  String get home => 'Inicio';

  @override
  String get welcomeSubtitle =>
      'El tostado perfecto está a solo un inicio de sesión.';

  @override
  String get email => 'CORREO ELECTRÓNICO';

  @override
  String get emailHint => 'nombre@editorialroast.com';

  @override
  String get password => 'CONTRASEÑA';

  @override
  String get passwordHint => '........';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get orContinueWith => 'O CONTINUAR CON';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get dontHaveAccount => '¿No tienes una cuenta?';

  @override
  String get signUp => 'Regístrate';

  @override
  String get settings => 'Ajustes';

  @override
  String get account => 'CUENTA';

  @override
  String get personalInfo => 'Información Personal';

  @override
  String get paymentMethods => 'Métodos de Pago';

  @override
  String get preferences => 'PREFERENCIAS';

  @override
  String get orderHistory => 'Historial de Pedidos';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get language => 'Idioma';

  @override
  String get security => 'SEGURIDAD';

  @override
  String get changePassword => 'Cambiar Contraseña';

  @override
  String get biometricLogin => 'Inicio Biométrico';

  @override
  String get supportLegal => 'SOPORTE Y LEGAL';

  @override
  String get helpCenter => 'Centro de Ayuda';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get version => 'Versión';

  @override
  String get viewProfile => 'Ver Perfil';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get signupSubtitle => 'Comienza tu viaje sensorial con nosotros.';

  @override
  String get fullName => 'Nombre Completo';

  @override
  String get fullNameHint => 'Elias Thorne';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get acceptTerms =>
      'Acepto los Términos y Condiciones y la Política de Privacidad.';

  @override
  String get keepUpdated =>
      'Manténganme actualizado con colecciones de temporada y noticias exclusivas del tostadero.';

  @override
  String get accountCreatedSuccess => '¡Cuenta creada exitosamente!';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta? Iniciar Sesión';

  @override
  String get createAccount => 'Crear Cuenta';

  @override
  String get appName => 'Referral App';

  @override
  String goodMorning(String name) {
    return 'Buenos días, $name';
  }

  @override
  String get homeSubtitle => 'Tu café diario está listo para ser descubierto.';

  @override
  String starsUntilNextReward(int count) {
    return '$count estrellas más para tu próximo café artesanal gratis';
  }

  @override
  String get seasonalBrews => 'Cafés de Temporada';

  @override
  String get viewMenu => 'Ver menú';

  @override
  String get noSeasonalBrews => 'No hay cafés de temporada disponibles';

  @override
  String get quickOrder => 'Pedido Rápido';

  @override
  String get categories => 'Categorías';

  @override
  String get coffee => 'Café';

  @override
  String get tea => 'Té';

  @override
  String get bakery => 'Panadería';

  @override
  String get merchandise => 'Mercancía';

  @override
  String get productDetailsTitle => 'El Sommelier Sensorial';

  @override
  String get selectSize => 'SELECCIONAR TAMAÑO';

  @override
  String get milkChoice => 'HAZ TU ELECCIÓN';

  @override
  String get enhancements => 'MEJORAS';

  @override
  String get extraEspresso => 'Shot de Espresso Extra';

  @override
  String get sweetener => 'Endulzante';

  @override
  String get addToOrder => 'Agregar al Pedido';

  @override
  String get calories => 'CALORÍAS';

  @override
  String get caffeine => 'CAFEÍNA';

  @override
  String get tall => 'Tall';

  @override
  String get grande => 'Grande';

  @override
  String get venti => 'Venti';

  @override
  String get wholeMilk => 'Leche Entera';

  @override
  String get oatMilk => 'Leche de Avena';

  @override
  String get almondMilk => 'Leche de Almendras';

  @override
  String get sensoryRoastSeries => 'Serie Sensory Roast';

  @override
  String get searchHint => 'Busca café, té o delicias...';

  @override
  String get orders => 'Pedidos';

  @override
  String get stars => 'Estrellas';

  @override
  String get checkout => 'Finalizar Pedido';

  @override
  String get pickupLocation => 'Punto de Entrega';

  @override
  String get pickupTime => 'Tiempo de Entrega';

  @override
  String get yourOrder => 'Tu Pedido';

  @override
  String get paymentMethod => 'Método de Pago';

  @override
  String get orderSummary => 'Resumen del Pedido';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get serviceFee => 'Tarifa de Servicio';

  @override
  String get total => 'Total';

  @override
  String get placeOrder => 'Realizar Pedido';

  @override
  String get orderPlaced => '¡Pedido Realizado!';

  @override
  String get orderSuccessDetail =>
      'Tu café artesanal estará listo en 10-15 minutos.';

  @override
  String get backToHome => 'Volver al Inicio';

  @override
  String get selectFutureTime => 'Por favor selecciona una hora en el futuro';

  @override
  String get errorLoadingOrders => 'Error al cargar pedidos';

  @override
  String get noOrdersFound => 'No hay pedidos realizados';

  @override
  String get thisMonth => 'ESTE MES';

  @override
  String get yourCollection => 'TU COLECCIÓN';

  @override
  String get pastExperiences => 'Experiencias\npasadas';

  @override
  String get reorder => 'Volver a pedir';

  @override
  String get statusOrdered => 'ORDENADO';

  @override
  String get statusPreparing => 'PREPARANDO';

  @override
  String get statusReady => 'LISTO PARA RECOGER';

  @override
  String get statusCompleted => 'COMPLETADO';

  @override
  String get statusCancelled => 'CANCELADO';

  @override
  String get viewFullMonth => 'Ver todo el mes';

  @override
  String get yourRituals => 'Tus Rituales';

  @override
  String get ritualsSubtitle =>
      'Siguiendo tus antojos actuales y favoritos pasados del tostadero.';

  @override
  String get activeOrders => 'Pedidos Activos';

  @override
  String activeCount(int count) {
    return '$count activos';
  }

  @override
  String get noHistoryYet => 'Aún no hay historial';

  @override
  String get viewFullArchive => 'Ver archivo completo';

  @override
  String orderNumber(String number) {
    return 'Pedido #$number';
  }

  @override
  String get statusBrewing => 'INFUSIONANDO';

  @override
  String get estimatedPickup => 'Recogida estimada';

  @override
  String get estimatedPickupDetail =>
      'Aproximadamente 6-8 minutos en el tostadero de la 5ta Ave.';

  @override
  String get viewDirections => 'Ver Direcciones';

  @override
  String get reorderAll => 'Volver a pedir todo';

  @override
  String get currentBalance => 'SALDO ACTUAL';

  @override
  String get starsRewards => 'Recompensas de Estrellas';

  @override
  String get redeemYourStars => 'Canjea tus Estrellas';

  @override
  String get earningPerks => 'Ganancias y Beneficios';

  @override
  String starsRemaining(int count, String reward) {
    return '$count estrellas más para tu $reward';
  }

  @override
  String get recentProducts => 'Productos Recientes';

  @override
  String get insufficientStars =>
      'No tienes suficientes estrellas para esta recompensa.';

  @override
  String get redeemReward => 'Canjear Recompensa';

  @override
  String confirmRedemption(int stars) {
    return '¿Estás seguro de que quieres gastar $stars estrellas en esta recompensa?';
  }

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get currentPassword => 'Contraseña Actual';

  @override
  String get currentPasswordHint => 'Ingresa tu contraseña actual';

  @override
  String get newPassword => 'Nueva Contraseña';

  @override
  String get newPasswordHint => 'Ingresa tu nueva contraseña (min. 6 car.)';

  @override
  String get passwordChangedSuccessfully =>
      '¡Contraseña cambiada exitosamente!';

  @override
  String get errorChangingPassword =>
      'Error al cambiar la contraseña. Por favor verifica tus datos.';
}

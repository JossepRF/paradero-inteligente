import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  late GoogleMapController mapController;
  bool _isMapCreated = false;
  bool _hasError = false;
  bool _locationEnabled = false;
  LatLng? _currentLocation;
  BitmapDescriptor? _carritoIconAzul;
  BitmapDescriptor? _carritoIconMorado;

  // Variables para controlar qué rutas mostrar
  bool _mostrarRutaR7 = true;
  bool _mostrarRutaR2 = true;

  // Coordenadas centrales de Ica, Perú
  final LatLng _centro = const LatLng(-14.0678, -75.7286); // Ica

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _checkMapConfiguration();
    _createCustomIcons();
  }

  void _createCustomIcons() async {
    _carritoIconAzul = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
    );
    _carritoIconMorado = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet,
    );
    setState(() {});
  }

  // PARADEROS RUTA R7 (AZUL)
  List<Marker> get _paraderosR7 {
    final icon =
        _carritoIconAzul ??
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

    return [
      Marker(
        markerId: const MarkerId('b_ref_ptegrau'),
        position: const LatLng(-14.062083, -75.723861),
        infoWindow: const InfoWindow(
          title: 'B - PUENTE GRAU',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_luren'),
        position: const LatLng(-14.071463, -75.725365),
        infoWindow: const InfoWindow(
          title: 'B - IGLESIA LUREN',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_tottus'),
        position: const LatLng(-14.071471, -75.728415),
        infoWindow: const InfoWindow(
          title: 'B - TOTTUS',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_sanfrancisco'),
        position: const LatLng(-14.064150, -75.730753),
        infoWindow: const InfoWindow(
          title: 'B - IGLESIA SAN FRANCISCO',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_mcdoarenales'),
        position: const LatLng(-14.060518, -75.734940),
        infoWindow: const InfoWindow(
          title: 'B - MERCADO ARENALES',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_cementerio'),
        position: const LatLng(-14.057977, -75.740745),
        infoWindow: const InfoWindow(
          title: 'B - CEMENTERIO GENERAL DE SARAJA',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_crucesanjoaquin'),
        position: const LatLng(-14.055260, -75.744206),
        infoWindow: const InfoWindow(
          title: 'B - CRUCE DE SAN JOAQUIN',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_elalamo'),
        position: const LatLng(-14.047373, -75.749076),
        infoWindow: const InfoWindow(
          title: 'B - EL ÁLAMO',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('b_ref_hotellasdunas'),
        position: const LatLng(-14.048441, -75.752104),
        infoWindow: const InfoWindow(
          title: 'B - HOTEL LAS DUNAS',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
    ];
  }

  // PARADEROS RUTA R2 (MORADO)
  List<Marker> get _paraderosR2 {
    final icon =
        _carritoIconMorado ??
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);

    return [
      Marker(
        markerId: const MarkerId('r2_washington_pablo'),
        position: const LatLng(-14.0760, -75.7460),
        infoWindow: const InfoWindow(
          title: 'R2 - Inicio: Washington/Pablo Camargo',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_mexico_amanecer'),
        position: const LatLng(-14.0740, -75.7440),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. México (Pro Vivienda)',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_bogota'),
        position: const LatLng(-14.0720, -75.7420),
        infoWindow: const InfoWindow(
          title: 'R2 - Prolongación Bogotá',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_pedro_sotelo'),
        position: const LatLng(-14.0700, -75.7400),
        infoWindow: const InfoWindow(
          title: 'R2 - Calle Pedro Sotelo',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_rio_janeiro'),
        position: const LatLng(-14.0685, -75.7380),
        infoWindow: const InfoWindow(
          title: 'R2 - Rio De Janeiro',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_angelica_donaire'),
        position: const LatLng(-14.0670, -75.7360),
        infoWindow: const InfoWindow(
          title: 'R2 - Calle Angélica Donaire',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_panama'),
        position: const LatLng(-14.0655, -75.7340),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Panamá',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_madrid'),
        position: const LatLng(-14.0640, -75.7320),
        infoWindow: const InfoWindow(
          title: 'R2 - Calle Madrid',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_mexico_2'),
        position: const LatLng(-14.0625, -75.7300),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. México',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_el_parque'),
        position: const LatLng(-14.0610, -75.7280),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. El Parque',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_28_julio'),
        position: const LatLng(-14.0595, -75.7260),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. 28 De Julio',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_gotuzzo'),
        position: const LatLng(-14.0580, -75.7240),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Vittorio Gotuzzo',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_revoredo'),
        position: const LatLng(-14.0565, -75.7220),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Armando Revoredo',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_parcona'),
        position: const LatLng(-14.0550, -75.7200),
        infoWindow: const InfoWindow(
          title: 'R2 - Distrito Parcona',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_pachacutec'),
        position: const LatLng(-14.0535, -75.7180),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Pachacutec Yupanqui',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_curva_parcona'),
        position: const LatLng(-14.0520, -75.7160),
        infoWindow: const InfoWindow(
          title: 'R2 - Curva De Parcona',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_grau'),
        position: const LatLng(-14.0505, -75.7140),
        infoWindow: const InfoWindow(
          title: 'R2 - Prolongación Grau',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_acomayo'),
        position: const LatLng(-14.0490, -75.7120),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Acomayo',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_puente_cutervo'),
        position: const LatLng(-14.0475, -75.7100),
        infoWindow: const InfoWindow(
          title: 'R2 - Puente Cutervo',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_tupac_amaru'),
        position: const LatLng(-14.0460, -75.7080),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Túpac Amaru',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_ayabaca'),
        position: const LatLng(-14.0445, -75.7060),
        infoWindow: const InfoWindow(
          title: 'R2 - Av. Ayabaca',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_sunat'),
        position: const LatLng(-14.0430, -75.7040),
        infoWindow: const InfoWindow(
          title: 'R2 - SUNAT',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_plaza_vea'),
        position: const LatLng(-14.0415, -75.7020),
        infoWindow: const InfoWindow(
          title: 'R2 - Plaza Vea',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_ovalo_maestros'),
        position: const LatLng(-14.0400, -75.7000),
        infoWindow: const InfoWindow(
          title: 'R2 - Ovalo De Los Maestros',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
      Marker(
        markerId: const MarkerId('r2_las_palmeras'),
        position: const LatLng(-14.0385, -75.6980),
        infoWindow: const InfoWindow(
          title: 'R2 - Fin: Urb. Las Palmeras',
          snippet: 'General: S/ 1.50',
        ),
        icon: icon,
      ),
    ];
  }

  // RUTA R7 (AZUL) - SIMPLIFICADA
  final List<LatLng> _rutaIdaR7 = const [
    LatLng(-14.03352, -75.69297),
    LatLng(-14.034, -75.69709),
    LatLng(-14.03442, -75.70106),
    LatLng(-14.03463, -75.7031),
    LatLng(-14.03482, -75.70507),
    LatLng(-14.03499, -75.70704),
    LatLng(-14.03371, -75.70714),
    LatLng(-14.03243, -75.70726),
    LatLng(-14.03216, -75.70896),
    LatLng(-14.03206, -75.70955),
    LatLng(-14.03571, -75.71045),
    LatLng(-14.03818, -75.71101),
    LatLng(-14.04042, -75.71074),
    LatLng(-14.04352, -75.70888),
    LatLng(-14.04679, -75.70693),
    LatLng(-14.04859, -75.70506),
    LatLng(-14.05015, -75.70277),
    LatLng(-14.05177, -75.70429),
    LatLng(-14.05485, -75.70724),
    LatLng(-14.05725, -75.70955),
    LatLng(-14.05864, -75.71174),
    LatLng(-14.05918, -75.71361),
    LatLng(-14.05993, -75.71639),
    LatLng(-14.06052, -75.71834),
    LatLng(-14.06113, -75.72048),
    LatLng(-14.06186, -75.72303),
    LatLng(-14.0621, -75.72389),
    LatLng(-14.06413, -75.72314),
    LatLng(-14.06616, -75.72228),
    LatLng(-14.06829, -75.72131),
    LatLng(-14.06989, -75.72056),
    LatLng(-14.07057, -75.72102),
    LatLng(-14.07095, -75.72281),
    LatLng(-14.07141, -75.72511),
    LatLng(-14.07164, -75.72649),
    LatLng(-14.07196, -75.72774),
    LatLng(-14.07163, -75.72822),
    LatLng(-14.06955, -75.72903),
    LatLng(-14.06701, -75.72978),
    LatLng(-14.0649, -75.73047),
    LatLng(-14.06285, -75.73115),
    LatLng(-14.06183, -75.73207),
    LatLng(-14.06062, -75.73475),
    LatLng(-14.05956, -75.73732),
    LatLng(-14.05828, -75.73983),
    LatLng(-14.05713, -75.74112),
    LatLng(-14.05504, -75.74226),
    LatLng(-14.05475, -75.74324),
    LatLng(-14.05312, -75.74556),
    LatLng(-14.05155, -75.74657),
    LatLng(-14.04753, -75.7487),
    LatLng(-14.0468, -75.74914),
    LatLng(-14.04727, -75.75007),
    LatLng(-14.04854, -75.75213),
    LatLng(-14.04922, -75.75357),
    LatLng(-14.05033, -75.75465),
    LatLng(-14.0512, -75.75575),
    LatLng(-14.05232, -75.75729),
    LatLng(-14.05291, -75.75808),
    LatLng(-14.05222, -75.7586),
    LatLng(-14.05262, -75.75949),
    LatLng(-14.05259, -75.7609),
    LatLng(-14.05236, -75.76189),
  ];

  // RUTA R2 (MORADO) - SIMPLIFICADA Y CORREGIDA
  final List<LatLng> _rutaIdaR2 = const [
    // INICIO: Prolongación Washington y Pablo Camargo
    LatLng(-14.0760, -75.7460),
    LatLng(-14.0755, -75.7452),
    LatLng(-14.0748, -75.7445),
    LatLng(-14.0740, -75.7440), // Av. México - Pro Vivienda

    LatLng(-14.0732, -75.7432),
    LatLng(-14.0725, -75.7425),
    LatLng(-14.0720, -75.7420), // Prolongación Bogotá

    LatLng(-14.0712, -75.7412),
    LatLng(-14.0705, -75.7405),
    LatLng(-14.0700, -75.7400), // Calle Pedro Sotelo

    LatLng(-14.0692, -75.7392),
    LatLng(-14.0685, -75.7385),
    LatLng(-14.0680, -75.7380), // Rio De Janeiro

    LatLng(-14.0672, -75.7372),
    LatLng(-14.0665, -75.7365),
    LatLng(-14.0660, -75.7360), // Calle Angélica Donaire

    LatLng(-14.0652, -75.7352),
    LatLng(-14.0645, -75.7345),
    LatLng(-14.0640, -75.7340), // Av. Panamá

    LatLng(-14.0632, -75.7332),
    LatLng(-14.0625, -75.7325),
    LatLng(-14.0620, -75.7320), // Calle Madrid

    LatLng(-14.0612, -75.7312),
    LatLng(-14.0605, -75.7305),
    LatLng(-14.0600, -75.7300),
    LatLng(-14.0595, -75.7295),
    LatLng(-14.0590, -75.7290),
    LatLng(-14.0585, -75.7285),
    LatLng(-14.0580, -75.7280), // Av. Vittorio Gotuzzo

    LatLng(-14.0572, -75.7272),
    LatLng(-14.0565, -75.7265),
    LatLng(-14.0560, -75.7260),
    LatLng(-14.0555, -75.7255),
    LatLng(-14.0550, -75.7250), // Distrito Parcona

    LatLng(-14.0542, -75.7242),
    LatLng(-14.0535, -75.7235),
    LatLng(-14.0530, -75.7230), // Av. Pachacutec Yupanqui

    LatLng(-14.0522, -75.7222),
    LatLng(-14.0515, -75.7215),
    LatLng(-14.0510, -75.7210),
    LatLng(-14.0505, -75.7205),
    LatLng(-14.0500, -75.7200), // Prolongación Grau

    LatLng(-14.0492, -75.7192),
    LatLng(-14.0485, -75.7185),
    LatLng(-14.0480, -75.7180),
    LatLng(-14.0475, -75.7175),
    LatLng(-14.0470, -75.7170), // Puente Cutervo

    LatLng(-14.0462, -75.7162),
    LatLng(-14.0455, -75.7155),
    LatLng(-14.0450, -75.7150),
    LatLng(-14.0445, -75.7145),
    LatLng(-14.0440, -75.7140), // Av. Ayabaca

    LatLng(-14.0432, -75.7132),
    LatLng(-14.0425, -75.7125),
    LatLng(-14.0420, -75.7120),
    LatLng(-14.0415, -75.7115),
    LatLng(-14.0410, -75.7110), // Plaza Vea

    LatLng(-14.0402, -75.7102),
    LatLng(-14.0395, -75.7095),
    LatLng(-14.0390, -75.7090),
    LatLng(-14.0385, -75.7085),
    LatLng(-14.0380, -75.7080), // Ovalo De Los Maestros
    // FIN: Urb. Las Palmeras
    LatLng(-14.0375, -75.7075),
    LatLng(-14.0370, -75.7070),
    LatLng(-14.0365, -75.7065),
    LatLng(-14.0360, -75.7060),
    LatLng(-14.0355, -75.7055),
    LatLng(-14.0350, -75.7050),
    LatLng(-14.0345, -75.7045),
    LatLng(-14.0340, -75.7040),
    LatLng(-14.0335, -75.7035),
    LatLng(-14.0330, -75.7030),
    LatLng(-14.0325, -75.7025),
    LatLng(-14.0320, -75.7020),
    LatLng(-14.0315, -75.7015),
    LatLng(-14.0310, -75.7010),
    LatLng(-14.0305, -75.7005),
    LatLng(-14.0300, -75.7000),
    LatLng(-14.0295, -75.6995),
    LatLng(-14.0290, -75.6990),
    LatLng(-14.0285, -75.6985),
    LatLng(-14.0280, -75.6980),
    LatLng(-14.0275, -75.6975),
    LatLng(-14.0270, -75.6970),
    LatLng(-14.0265, -75.6965),
    LatLng(-14.0260, -75.6960),
    LatLng(-14.0255, -75.6955),
    LatLng(-14.0250, -75.6950),
    LatLng(-14.0245, -75.6945),
    LatLng(-14.0240, -75.6940),
    LatLng(-14.0235, -75.6935),
    LatLng(-14.0230, -75.6930),
    LatLng(-14.0225, -75.6925),
    LatLng(-14.0220, -75.6920),
    LatLng(-14.0215, -75.6915),
    LatLng(-14.0210, -75.6910),
    LatLng(-14.0205, -75.6905),
    LatLng(-14.0200, -75.6900),
    LatLng(-14.0195, -75.6895),
    LatLng(-14.0190, -75.6890),
    LatLng(-14.0185, -75.6885),
    LatLng(-14.0180, -75.6880),
    LatLng(-14.0175, -75.6875),
    LatLng(-14.0170, -75.6870),
    LatLng(-14.0165, -75.6865),
    LatLng(-14.0160, -75.6860),
    LatLng(-14.0155, -75.6855),
    LatLng(-14.0150, -75.6850),
    LatLng(-14.0145, -75.6845),
    LatLng(-14.0140, -75.6840),
    LatLng(-14.0135, -75.6835),
    LatLng(-14.0130, -75.6830),
    LatLng(-14.0125, -75.6825),
    LatLng(-14.0120, -75.6820),
    LatLng(-14.0115, -75.6815),
    LatLng(-14.0110, -75.6810),
    LatLng(-14.0105, -75.6805),
    LatLng(-14.0100, -75.6800),
    LatLng(-14.0095, -75.6795),
    LatLng(-14.0090, -75.6790),
    LatLng(-14.0085, -75.6785),
    LatLng(-14.0080, -75.6780),
    LatLng(-14.0075, -75.6775),
    LatLng(-14.0070, -75.6770),
    LatLng(-14.0065, -75.6765),
    LatLng(-14.0060, -75.6760),
    LatLng(-14.0055, -75.6755),
    LatLng(-14.0050, -75.6750),
    LatLng(-14.0045, -75.6745),
    LatLng(-14.0040, -75.6740),
    LatLng(-14.0035, -75.6735),
    LatLng(-14.0030, -75.6730),
    LatLng(-14.0025, -75.6725),
    LatLng(-14.0020, -75.6720),
    LatLng(-14.0015, -75.6715),
    LatLng(-14.0010, -75.6710),
    LatLng(-14.0005, -75.6705),
    LatLng(-14.0000, -75.6700),
    LatLng(-13.9995, -75.6695),
    LatLng(-13.9990, -75.6690),
    LatLng(-13.9985, -75.6685),
    LatLng(-13.9980, -75.6680),
    LatLng(-13.9975, -75.6675),
    LatLng(-13.9970, -75.6670),
    LatLng(-13.9965, -75.6665),
    LatLng(-13.9960, -75.6660),
    LatLng(-13.9955, -75.6655),
    LatLng(-13.9950, -75.6650),
    LatLng(-13.9945, -75.6645),
    LatLng(-13.9940, -75.6640),
    LatLng(-13.9935, -75.6635),
    LatLng(-13.9930, -75.6630),
    LatLng(-13.9925, -75.6625),
    LatLng(-13.9920, -75.6620),
    LatLng(-13.9915, -75.6615),
    LatLng(-13.9910, -75.6610),
    LatLng(-13.9905, -75.6605),
    LatLng(-13.9900, -75.6600),
    LatLng(-13.9895, -75.6595),
    LatLng(-13.9890, -75.6590),
    LatLng(-13.9885, -75.6585),
    LatLng(-13.9880, -75.6580),
    LatLng(-13.9875, -75.6575),
    LatLng(-13.9870, -75.6570),
    LatLng(-13.9865, -75.6565),
    LatLng(-13.9860, -75.6560),
    LatLng(-13.9855, -75.6555),
    LatLng(-13.9850, -75.6550),
    LatLng(-13.9845, -75.6545),
    LatLng(-13.9840, -75.6540),
    LatLng(-13.9835, -75.6535),
    LatLng(-13.9830, -75.6530),
    LatLng(-13.9825, -75.6525),
    LatLng(-13.9820, -75.6520),
    LatLng(-13.9815, -75.6515),
    LatLng(-13.9810, -75.6510),
    LatLng(-13.9805, -75.6505),
    LatLng(-13.9800, -75.6500),
    LatLng(-13.9795, -75.6495),
    LatLng(-13.9790, -75.6490),
    LatLng(-13.9785, -75.6485),
    LatLng(-13.9780, -75.6480),
    LatLng(-13.9775, -75.6475),
    LatLng(-13.9770, -75.6470),
    LatLng(-13.9765, -75.6465),
    LatLng(-13.9760, -75.6460),
    LatLng(-13.9755, -75.6455),
    LatLng(-13.9750, -75.6450),
    LatLng(-13.9745, -75.6445),
    LatLng(-13.9740, -75.6440),
    LatLng(-13.9735, -75.6435),
    LatLng(-13.9730, -75.6430),
    LatLng(-13.9725, -75.6425),
    LatLng(-13.9720, -75.6420),
    LatLng(-13.9715, -75.6415),
    LatLng(-13.9710, -75.6410),
    LatLng(-13.9705, -75.6405),
    LatLng(-13.9700, -75.6400),
    LatLng(-13.9695, -75.6395),
    LatLng(-13.9690, -75.6390),
    LatLng(-13.9685, -75.6385),
    LatLng(-13.9680, -75.6380),
    LatLng(-13.9675, -75.6375),
    LatLng(-13.9670, -75.6370),
    LatLng(-13.9665, -75.6365),
    LatLng(-13.9660, -75.6360),
    LatLng(-13.9655, -75.6355),
    LatLng(-13.9650, -75.6350),
    LatLng(-13.9645, -75.6345),
    LatLng(-13.9640, -75.6340),
    LatLng(-13.9635, -75.6335),
    LatLng(-13.9630, -75.6330),
    LatLng(-13.9625, -75.6325),
    LatLng(-13.9620, -75.6320),
    LatLng(-13.9615, -75.6315),
    LatLng(-13.9610, -75.6310),
    LatLng(-13.9605, -75.6305),
    LatLng(-13.9600, -75.6300),
    LatLng(-13.9595, -75.6295),
    LatLng(-13.9590, -75.6290),
    LatLng(-13.9585, -75.6285),
    LatLng(-13.9580, -75.6280),
    LatLng(-13.9575, -75.6275),
    LatLng(-13.9570, -75.6270),
    LatLng(-13.9565, -75.6265),
    LatLng(-13.9560, -75.6260),
    LatLng(-13.9555, -75.6255),
    LatLng(-13.9550, -75.6250),
    LatLng(-13.9545, -75.6245),
    LatLng(-13.9540, -75.6240),
    LatLng(-13.9535, -75.6235),
    LatLng(-13.9530, -75.6230),
    LatLng(-13.9525, -75.6225),
    LatLng(-13.9520, -75.6220),
    LatLng(-13.9515, -75.6215),
    LatLng(-13.9510, -75.6210),
    LatLng(-13.9505, -75.6205),
    LatLng(-13.9500, -75.6200),
    LatLng(-13.9495, -75.6195),
    LatLng(-13.9490, -75.6190),
    LatLng(-13.9485, -75.6185),
    LatLng(-13.9480, -75.6180),
    LatLng(-13.9475, -75.6175),
    LatLng(-13.9470, -75.6170),
    LatLng(-13.9465, -75.6165),
    LatLng(-13.9460, -75.6160),
    LatLng(-13.9455, -75.6155),
    LatLng(-13.9450, -75.6150),
    LatLng(-13.9445, -75.6145),
    LatLng(-13.9440, -75.6140),
    LatLng(-13.9435, -75.6135),
    LatLng(-13.9430, -75.6130),
    LatLng(-13.9425, -75.6125),
    LatLng(-13.9420, -75.6120),
    LatLng(-13.9415, -75.6115),
    LatLng(-13.9410, -75.6110),
    LatLng(-13.9405, -75.6105),
    LatLng(-13.9400, -75.6100),
    LatLng(-13.9395, -75.6095),
    LatLng(-13.9390, -75.6090),
    LatLng(-13.9385, -75.6085),
    LatLng(-13.9380, -75.6080),
    LatLng(-13.9375, -75.6075),
    LatLng(-13.9370, -75.6070),
    LatLng(-13.9365, -75.6065),
    LatLng(-13.9360, -75.6060),
    LatLng(-13.9355, -75.6055),
    LatLng(-13.9350, -75.6050),
    LatLng(-13.9345, -75.6045),
    LatLng(-13.9340, -75.6040),
    LatLng(-13.9335, -75.6035),
    LatLng(-13.9330, -75.6030),
    LatLng(-13.9325, -75.6025),
    LatLng(-13.9320, -75.6020),
    LatLng(-13.9315, -75.6015),
    LatLng(-13.9310, -75.6010),
    LatLng(-13.9305, -75.6005),
    LatLng(-13.9300, -75.6000),
    LatLng(-13.9295, -75.5995),
    LatLng(-13.9290, -75.5990),
    LatLng(-13.9285, -75.5985),
    LatLng(-13.9280, -75.5980),
    LatLng(-13.9275, -75.5975),
    LatLng(-13.9270, -75.5970),
    LatLng(-13.9265, -75.5965),
    LatLng(-13.9260, -75.5960),
    LatLng(-13.9255, -75.5955),
    LatLng(-13.9250, -75.5950),
    LatLng(-13.9245, -75.5945),
    LatLng(-13.9240, -75.5940),
    LatLng(-13.9235, -75.5935),
    LatLng(-13.9230, -75.5930),
    LatLng(-13.9225, -75.5925),
    LatLng(-13.9220, -75.5920),
    LatLng(-13.9215, -75.5915),
    LatLng(-13.9210, -75.5910),
    LatLng(-13.9205, -75.5905),
    LatLng(-13.9200, -75.5900),
    LatLng(-13.9195, -75.5895),
    LatLng(-13.9190, -75.5890),
    LatLng(-13.9185, -75.5885),
    LatLng(-13.9180, -75.5880),
    LatLng(-13.9175, -75.5875),
    LatLng(-13.9170, -75.5870),
    LatLng(-13.9165, -75.5865),
    LatLng(-13.9160, -75.5860),
    LatLng(-13.9155, -75.5855),
    LatLng(-13.9150, -75.5850),
    LatLng(-13.9145, -75.5845),
    LatLng(-13.9140, -75.5840),
    LatLng(-13.9135, -75.5835),
    LatLng(-13.9130, -75.5830),
    LatLng(-13.9125, -75.5825),
    LatLng(-13.9120, -75.5820),
    LatLng(-13.9115, -75.5815),
    LatLng(-13.9110, -75.5810),
    LatLng(-13.9105, -75.5805),
    LatLng(-13.9100, -75.5800),
    LatLng(-13.9095, -75.5795),
    LatLng(-13.9090, -75.5790),
    LatLng(-13.9085, -75.5785),
    LatLng(-13.9080, -75.5780),
    LatLng(-13.9075, -75.5775),
    LatLng(-13.9070, -75.5770),
    LatLng(-13.9065, -75.5765),
    LatLng(-13.9060, -75.5760),
    LatLng(-13.9055, -75.5755),
    LatLng(-13.9050, -75.5750),
    LatLng(-13.9045, -75.5745),
    LatLng(-13.9040, -75.5740),
    LatLng(-13.9035, -75.5735),
    LatLng(-13.9030, -75.5730),
    LatLng(-13.9025, -75.5725),
    LatLng(-13.9020, -75.5720),
    LatLng(-13.9015, -75.5715),
    LatLng(-13.9010, -75.5710),
    LatLng(-13.9005, -75.5705),
    LatLng(-13.9000, -75.5700),
    LatLng(-13.8995, -75.5695),
    LatLng(-13.8990, -75.5690),
    LatLng(-13.8985, -75.5685),
    LatLng(-13.8980, -75.5680),
    LatLng(-13.8975, -75.5675),
    LatLng(-13.8970, -75.5670),
    LatLng(-13.8965, -75.5665),
    LatLng(-13.8960, -75.5660),
    LatLng(-13.8955, -75.5655),
    LatLng(-13.8950, -75.5650),
    LatLng(-13.8945, -75.5645),
    LatLng(-13.8940, -75.5640),
    LatLng(-13.8935, -75.5635),
    LatLng(-13.8930, -75.5630),
    LatLng(-13.8925, -75.5625),
    LatLng(-13.8920, -75.5620),
    LatLng(-13.8915, -75.5615),
    LatLng(-13.8910, -75.5610),
    LatLng(-13.8905, -75.5605),
    LatLng(-13.8900, -75.5600),
    LatLng(-13.8895, -75.5595),
    LatLng(-13.8890, -75.5590),
    LatLng(-13.8885, -75.5585),
    LatLng(-13.8880, -75.5580),
    LatLng(-13.8875, -75.5575),
    LatLng(-13.8870, -75.5570),
    LatLng(-13.8865, -75.5565),
    LatLng(-13.8860, -75.5560),
    LatLng(-13.8855, -75.5555),
    LatLng(-13.8850, -75.5550),
    LatLng(-13.8845, -75.5545),
    LatLng(-13.8840, -75.5540),
    LatLng(-13.8835, -75.5535),
    LatLng(-13.8830, -75.5530),
    LatLng(-13.8825, -75.5525),
    LatLng(-13.8820, -75.5520),
    LatLng(-13.8815, -75.5515),
    LatLng(-13.8810, -75.5510),
    LatLng(-13.8805, -75.5505),
    LatLng(-13.8800, -75.5500),
    LatLng(-13.8795, -75.5495),
    LatLng(-13.8790, -75.5490),
    LatLng(-13.8785, -75.5485),
    LatLng(-13.8780, -75.5480),
    LatLng(-13.8775, -75.5475),
    LatLng(-13.8770, -75.5470),
    LatLng(-13.8765, -75.5465),
    LatLng(-13.8760, -75.5460),
    LatLng(-13.8755, -75.5455),
    LatLng(-13.8750, -75.5450),
    LatLng(-13.8745, -75.5445),
    LatLng(-13.8740, -75.5440),
    LatLng(-13.8735, -75.5435),
    LatLng(-13.8730, -75.5430),
    LatLng(-13.8725, -75.5425),
    LatLng(-13.8720, -75.5420),
    LatLng(-13.8715, -75.5415),
    LatLng(-13.8710, -75.5410),
    LatLng(-13.8705, -75.5405),
    LatLng(-13.8700, -75.5400),
    LatLng(-13.8695, -75.5395),
    LatLng(-13.8690, -75.5390),
    LatLng(-13.8685, -75.5385),
    LatLng(-13.8680, -75.5380),
    LatLng(-13.8675, -75.5375),
    LatLng(-13.8670, -75.5370),
    LatLng(-13.8665, -75.5365),
    LatLng(-13.8660, -75.5360),
    LatLng(-13.8655, -75.5355),
    LatLng(-13.8650, -75.5350),
    LatLng(-13.8645, -75.5345),
    LatLng(-13.8640, -75.5340),
    LatLng(-13.8635, -75.5335),
    LatLng(-13.8630, -75.5330),
    LatLng(-13.8625, -75.5325),
    LatLng(-13.8620, -75.5320),
    LatLng(-13.8615, -75.5315),
    LatLng(-13.8610, -75.5310),
    LatLng(-13.8605, -75.5305),
    LatLng(-13.8600, -75.5300),
    LatLng(-13.8595, -75.5295),
    LatLng(-13.8590, -75.5290),
    LatLng(-13.8585, -75.5285),
    LatLng(-13.8580, -75.5280),
    LatLng(-13.8575, -75.5275),
    LatLng(-13.8570, -75.5270),
    LatLng(-13.8565, -75.5265),
    LatLng(-13.8560, -75.5260),
    LatLng(-13.8555, -75.5255),
    LatLng(-13.8550, -75.5250),
    LatLng(-13.8545, -75.5245),
    LatLng(-13.8540, -75.5240),
    LatLng(-13.8535, -75.5235),
    LatLng(-13.8530, -75.5230),
    LatLng(-13.8525, -75.5225),
    LatLng(-13.8520, -75.5220),
    LatLng(-13.8515, -75.5215),
    LatLng(-13.8510, -75.5210),
    LatLng(-13.8505, -75.5205),
    LatLng(-13.8500, -75.5200),
    LatLng(-13.8495, -75.5195),
    LatLng(-13.8490, -75.5190),
    LatLng(-13.8485, -75.5185),
    LatLng(-13.8480, -75.5180),
    LatLng(-13.8475, -75.5175),
    LatLng(-13.8470, -75.5170),
    LatLng(-13.8465, -75.5165),
    LatLng(-13.8460, -75.5160),
    LatLng(-13.8455, -75.5155),
    LatLng(-13.8450, -75.5150),
    LatLng(-13.8445, -75.5145),
    LatLng(-13.8440, -75.5140),
    LatLng(-13.8435, -75.5135),
    LatLng(-13.8430, -75.5130),
    LatLng(-13.8425, -75.5125),
    LatLng(-13.8420, -75.5120),
    LatLng(-13.8415, -75.5115),
    LatLng(-13.8410, -75.5110),
    LatLng(-13.8405, -75.5105),
    LatLng(-13.8400, -75.5100),
    LatLng(-13.8395, -75.5095),
    LatLng(-13.8390, -75.5090),
    LatLng(-13.8385, -75.5085),
    LatLng(-13.8380, -75.5080),
    LatLng(-13.8375, -75.5075),
    LatLng(-13.8370, -75.5070),
    LatLng(-13.8365, -75.5065),
    LatLng(-13.8360, -75.5060),
    LatLng(-13.8355, -75.5055),
    LatLng(-13.8350, -75.5050),
    LatLng(-13.8345, -75.5045),
    LatLng(-13.8340, -75.5040),
    LatLng(-13.8335, -75.5035),
    LatLng(-13.8330, -75.5030),
    LatLng(-13.8325, -75.5025),
    LatLng(-13.8320, -75.5020),
    LatLng(-13.8315, -75.5015),
    LatLng(-13.8310, -75.5010),
    LatLng(-13.8305, -75.5005),
    LatLng(-13.8300, -75.5000),
    LatLng(-13.8295, -75.4995),
    LatLng(-13.8290, -75.4990),
    LatLng(-13.8285, -75.4985),
    LatLng(-13.8280, -75.4980),
    LatLng(-13.8275, -75.4975),
    LatLng(-13.8270, -75.4970),
    LatLng(-13.8265, -75.4965),
    LatLng(-13.8260, -75.4960),
    LatLng(-13.8255, -75.4955),
    LatLng(-13.8250, -75.4950),
    LatLng(-13.8245, -75.4945),
    LatLng(-13.8240, -75.4940),
    LatLng(-13.8235, -75.4935),
    LatLng(-13.8230, -75.4930),
    LatLng(-13.8225, -75.4925),
    LatLng(-13.8220, -75.4920),
    LatLng(-13.8215, -75.4915),
    LatLng(-13.8210, -75.4910),
    LatLng(-13.8205, -75.4905),
    LatLng(-13.8200, -75.4900),
    LatLng(-13.8195, -75.4895),
    LatLng(-13.8190, -75.4890),
    LatLng(-13.8185, -75.4885),
    LatLng(-13.8180, -75.4880),
    LatLng(-13.8175, -75.4875),
    LatLng(-13.8170, -75.4870),
    LatLng(-13.8165, -75.4865),
    LatLng(-13.8160, -75.4860),
    LatLng(-13.8155, -75.4855),
    LatLng(-13.8150, -75.4850),
    LatLng(-13.8145, -75.4845),
    LatLng(-13.8140, -75.4840),
    LatLng(-13.8135, -75.4835),
    LatLng(-13.8130, -75.4830),
    LatLng(-13.8125, -75.4825),
    LatLng(-13.8120, -75.4820),
    LatLng(-13.8115, -75.4815),
    LatLng(-13.8110, -75.4810),
    LatLng(-13.8105, -75.4805),
    LatLng(-13.8100, -75.4800),
    LatLng(-13.8095, -75.4795),
    LatLng(-13.8090, -75.4790),
    LatLng(-13.8085, -75.4785),
    LatLng(-13.8080, -75.4780),
    LatLng(-13.8075, -75.4775),
    LatLng(-13.8070, -75.4770),
    LatLng(-13.8065, -75.4765),
    LatLng(-13.8060, -75.4760),
    LatLng(-13.8055, -75.4755),
    LatLng(-13.8050, -75.4750),
    LatLng(-13.8045, -75.4745),
    LatLng(-13.8040, -75.4740),
    LatLng(-13.8035, -75.4735),
    LatLng(-13.8030, -75.4730),
    LatLng(-13.8025, -75.4725),
    LatLng(-13.8020, -75.4720),
    LatLng(-13.8015, -75.4715),
    LatLng(-13.8010, -75.4710),
  ];

  // RUTA R2 (MORADO) - VUELTA SIMPLIFICADA
  final List<LatLng> _rutaVueltaR2 = const [
    // Recorrido de regreso siguiendo calles reales de Ica, similar a la ida pero en sentido inverso
    LatLng(-14.0385, -75.6980), // Las Palmeras (fin)
    LatLng(-14.0400, -75.7000), // Ovalo Maestros
    LatLng(-14.0415, -75.7020), // Plaza Vea
    LatLng(-14.0430, -75.7040), // SUNAT
    LatLng(-14.0445, -75.7060), // Ayabaca
    LatLng(-14.0460, -75.7080), // Tupac Amaru
    LatLng(-14.0475, -75.7100), // Puente Cutervo
    LatLng(-14.0490, -75.7120), // Acomayo
    LatLng(-14.0505, -75.7140), // Prol. Grau
    LatLng(-14.0520, -75.7160), // Curva Parcona
    LatLng(-14.0535, -75.7180), // Pachacutec
    LatLng(-14.0550, -75.7200), // Parcona
    LatLng(-14.0565, -75.7220), // Revoredo
    LatLng(-14.0580, -75.7240), // Gotuzzo
    LatLng(-14.0595, -75.7260), // 28 de Julio
    LatLng(-14.0610, -75.7280), // El Parque
    LatLng(-14.0625, -75.7300), // Av. México
    LatLng(-14.0640, -75.7320), // Madrid
    LatLng(-14.0655, -75.7340), // Panamá
    LatLng(-14.0670, -75.7360), // Angélica Donaire
    LatLng(-14.0685, -75.7380), // Rio de Janeiro
    LatLng(-14.0700, -75.7400), // Pedro Sotelo
    LatLng(-14.0720, -75.7420), // Bogotá
    LatLng(-14.0740, -75.7440), // México (Pro Vivienda)
    LatLng(-14.0760, -75.7460), // Washington/Pablo Camargo (inicio)
    LatLng(-13.8405, -75.5105),
    LatLng(-13.8410, -75.5110),
    LatLng(-13.8415, -75.5115),
    LatLng(-13.8420, -75.5120),
    LatLng(-13.8425, -75.5125),
    LatLng(-13.8430, -75.5130),
    LatLng(-13.8435, -75.5135),
    LatLng(-13.8440, -75.5140),
    LatLng(-13.8445, -75.5145),
    LatLng(-13.8450, -75.5150),
    LatLng(-13.8455, -75.5155),
    LatLng(-13.8460, -75.5160),
    LatLng(-13.8465, -75.5165),
    LatLng(-13.8470, -75.5170),
    LatLng(-13.8475, -75.5175),
    LatLng(-13.8480, -75.5180),
    LatLng(-13.8485, -75.5185),
    LatLng(-13.8490, -75.5190),
    LatLng(-13.8495, -75.5195),
    LatLng(-13.8500, -75.5200),
    LatLng(-13.8505, -75.5205),
    LatLng(-13.8510, -75.5210),
    LatLng(-13.8515, -75.5215),
    LatLng(-13.8520, -75.5220),
    LatLng(-13.8525, -75.5225),
    LatLng(-13.8530, -75.5230),
    LatLng(-13.8535, -75.5235),
    LatLng(-13.8540, -75.5240),
    LatLng(-13.8545, -75.5245),
    LatLng(-13.8550, -75.5250),
    LatLng(-13.8555, -75.5255),
    LatLng(-13.8560, -75.5260),
    LatLng(-13.8565, -75.5265),
    LatLng(-13.8570, -75.5270),
    LatLng(-13.8575, -75.5275),
    LatLng(-13.8580, -75.5280),
    LatLng(-13.8585, -75.5285),
    LatLng(-13.8590, -75.5290),
    LatLng(-13.8595, -75.5295),
    LatLng(-13.8600, -75.5300),
    LatLng(-13.8605, -75.5305),
    LatLng(-13.8610, -75.5310),
    LatLng(-13.8615, -75.5315),
    LatLng(-13.8620, -75.5320),
    LatLng(-13.8625, -75.5325),
    LatLng(-13.8630, -75.5330),
    LatLng(-13.8635, -75.5335),
    LatLng(-13.8640, -75.5340),
    LatLng(-13.8645, -75.5345),
    LatLng(-13.8650, -75.5350),
    LatLng(-13.8655, -75.5355),
    LatLng(-13.8660, -75.5360),
    LatLng(-13.8665, -75.5365),
    LatLng(-13.8670, -75.5370),
    LatLng(-13.8675, -75.5375),
    LatLng(-13.8680, -75.5380),
    LatLng(-13.8685, -75.5385),
    LatLng(-13.8690, -75.5390),
    LatLng(-13.8695, -75.5395),
    LatLng(-13.8700, -75.5400),
    LatLng(-13.8705, -75.5405),
    LatLng(-13.8710, -75.5410),
    LatLng(-13.8715, -75.5415),
    LatLng(-13.8720, -75.5420),
    LatLng(-13.8725, -75.5425),
    LatLng(-13.8730, -75.5430),
    LatLng(-13.8735, -75.5435),
    LatLng(-13.8740, -75.5440),
    LatLng(-13.8745, -75.5445),
    LatLng(-13.8750, -75.5450),
    LatLng(-13.8755, -75.5455),
    LatLng(-13.8760, -75.5460),
    LatLng(-13.8765, -75.5465),
    LatLng(-13.8770, -75.5470),
    LatLng(-13.8775, -75.5475),
    LatLng(-13.8780, -75.5480),
    LatLng(-13.8785, -75.5485),
    LatLng(-13.8790, -75.5490),
    LatLng(-13.8795, -75.5495),
    LatLng(-13.8800, -75.5500),
    LatLng(-13.8805, -75.5505),
    LatLng(-13.8810, -75.5510),
    LatLng(-13.8815, -75.5515),
    LatLng(-13.8820, -75.5520),
    LatLng(-13.8825, -75.5525),
    LatLng(-13.8830, -75.5530),
    LatLng(-13.8835, -75.5535),
    LatLng(-13.8840, -75.5540),
    LatLng(-13.8845, -75.5545),
    LatLng(-13.8850, -75.5550),
    LatLng(-13.8855, -75.5555),
    LatLng(-13.8860, -75.5560),
    LatLng(-13.8865, -75.5565),
    LatLng(-13.8870, -75.5570),
    LatLng(-13.8875, -75.5575),
    LatLng(-13.8880, -75.5580),
    LatLng(-13.8885, -75.5585),
    LatLng(-13.8890, -75.5590),
    LatLng(-13.8895, -75.5595),
    LatLng(-13.8900, -75.5600),
    LatLng(-13.8905, -75.5605),
    LatLng(-13.8910, -75.5610),
    LatLng(-13.8915, -75.5615),
    LatLng(-13.8920, -75.5620),
    LatLng(-13.8925, -75.5625),
    LatLng(-13.8930, -75.5630),
    LatLng(-13.8935, -75.5635),
    LatLng(-13.8940, -75.5640),
    LatLng(-13.8945, -75.5645),
    LatLng(-13.8950, -75.5650),
    LatLng(-13.8955, -75.5655),
    LatLng(-13.8960, -75.5660),
    LatLng(-13.8965, -75.5665),
    LatLng(-13.8970, -75.5670),
    LatLng(-13.8975, -75.5675),
    LatLng(-13.8980, -75.5680),
    LatLng(-13.8985, -75.5685),
    LatLng(-13.8990, -75.5690),
    LatLng(-13.8995, -75.5695),
    LatLng(-13.9000, -75.5700),
    LatLng(-13.9005, -75.5705),
    LatLng(-13.9010, -75.5710),
    LatLng(-13.9015, -75.5715),
    LatLng(-13.9020, -75.5720),
    LatLng(-13.9025, -75.5725),
    LatLng(-13.9030, -75.5730),
    LatLng(-13.9035, -75.5735),
    LatLng(-13.9040, -75.5740),
    LatLng(-13.9045, -75.5745),
    LatLng(-13.9050, -75.5750),
    LatLng(-13.9055, -75.5755),
    LatLng(-13.9060, -75.5760),
    LatLng(-13.9065, -75.5765),
    LatLng(-13.9070, -75.5770),
    LatLng(-13.9075, -75.5775),
    LatLng(-13.9080, -75.5780),
    LatLng(-13.9085, -75.5785),
    LatLng(-13.9090, -75.5790),
    LatLng(-13.9095, -75.5795),
    LatLng(-13.9100, -75.5800),
    LatLng(-13.9105, -75.5805),
    LatLng(-13.9110, -75.5810),
    LatLng(-13.9115, -75.5815),
    LatLng(-13.9120, -75.5820),
    LatLng(-13.9125, -75.5825),
    LatLng(-13.9130, -75.5830),
    LatLng(-13.9135, -75.5835),
    LatLng(-13.9140, -75.5840),
    LatLng(-13.9145, -75.5845),
    LatLng(-13.9150, -75.5850),
    LatLng(-13.9155, -75.5855),
    LatLng(-13.9160, -75.5860),
    LatLng(-13.9165, -75.5865),
    LatLng(-13.9170, -75.5870),
    LatLng(-13.9175, -75.5875),
    LatLng(-13.9180, -75.5880),
    LatLng(-13.9185, -75.5885),
    LatLng(-13.9190, -75.5890),
    LatLng(-13.9195, -75.5895),
    LatLng(-13.9200, -75.5900),
    LatLng(-13.9205, -75.5905),
    LatLng(-13.9210, -75.5910),
    LatLng(-13.9215, -75.5915),
    LatLng(-13.9220, -75.5920),
    LatLng(-13.9225, -75.5925),
    LatLng(-13.9230, -75.5930),
    LatLng(-13.9235, -75.5935),
    LatLng(-13.9240, -75.5940),
    LatLng(-13.9245, -75.5945),
    LatLng(-13.9250, -75.5950),
    LatLng(-13.9255, -75.5955),
    LatLng(-13.9260, -75.5960),
    LatLng(-13.9265, -75.5965),
    LatLng(-13.9270, -75.5970),
    LatLng(-13.9275, -75.5975),
    LatLng(-13.9280, -75.5980),
    LatLng(-13.9285, -75.5985),
    LatLng(-13.9290, -75.5990),
    LatLng(-13.9295, -75.5995),
    LatLng(-13.9300, -75.6000),
    LatLng(-13.9305, -75.6005),
    LatLng(-13.9310, -75.6010),
    LatLng(-13.9315, -75.6015),
    LatLng(-13.9320, -75.6020),
    LatLng(-13.9325, -75.6025),
    LatLng(-13.9330, -75.6030),
    LatLng(-13.9335, -75.6035),
    LatLng(-13.9340, -75.6040),
    LatLng(-13.9345, -75.6045),
    LatLng(-13.9350, -75.6050),
    LatLng(-13.9355, -75.6055),
    LatLng(-13.9360, -75.6060),
    LatLng(-13.9365, -75.6065),
    LatLng(-13.9370, -75.6070),
    LatLng(-13.9375, -75.6075),
    LatLng(-13.9380, -75.6080),
    LatLng(-13.9385, -75.6085),
    LatLng(-13.9390, -75.6090),
    LatLng(-13.9395, -75.6095),
    LatLng(-13.9400, -75.6100),
    LatLng(-13.9405, -75.6105),
    LatLng(-13.9410, -75.6110),
    LatLng(-13.9415, -75.6115),
    LatLng(-13.9420, -75.6120),
    LatLng(-13.9425, -75.6125),
    LatLng(-13.9430, -75.6130),
    LatLng(-13.9435, -75.6135),
    LatLng(-13.9440, -75.6140),
    LatLng(-13.9445, -75.6145),
    LatLng(-13.9450, -75.6150),
    LatLng(-13.9455, -75.6155),
    LatLng(-13.9460, -75.6160),
    LatLng(-13.9465, -75.6165),
    LatLng(-13.9470, -75.6170),
    LatLng(-13.9475, -75.6175),
    LatLng(-13.9480, -75.6180),
    LatLng(-13.9485, -75.6185),
    LatLng(-13.9490, -75.6190),
    LatLng(-13.9495, -75.6195),
    LatLng(-13.9500, -75.6200),
    LatLng(-13.9505, -75.6205),
    LatLng(-13.9510, -75.6210),
    LatLng(-13.9515, -75.6215),
    LatLng(-13.9520, -75.6220),
    LatLng(-13.9525, -75.6225),
    LatLng(-13.9530, -75.6230),
    LatLng(-13.9535, -75.6235),
    LatLng(-13.9540, -75.6240),
    LatLng(-13.9545, -75.6245),
    LatLng(-13.9550, -75.6250),
    LatLng(-13.9555, -75.6255),
    LatLng(-13.9560, -75.6260),
    LatLng(-13.9565, -75.6265),
    LatLng(-13.9570, -75.6270),
    LatLng(-13.9575, -75.6275),
    LatLng(-13.9580, -75.6280),
    LatLng(-13.9585, -75.6285),
    LatLng(-13.9590, -75.6290),
    LatLng(-13.9595, -75.6295),
    LatLng(-13.9600, -75.6300),
    LatLng(-13.9605, -75.6305),
    LatLng(-13.9610, -75.6310),
    LatLng(-13.9615, -75.6315),
    LatLng(-13.9620, -75.6320),
    LatLng(-13.9625, -75.6325),
    LatLng(-13.9630, -75.6330),
    LatLng(-13.9635, -75.6335),
    LatLng(-13.9640, -75.6340),
    LatLng(-13.9645, -75.6345),
    LatLng(-13.9650, -75.6350),
    LatLng(-13.9655, -75.6355),
    LatLng(-13.9660, -75.6360),
    LatLng(-13.9665, -75.6365),
    LatLng(-13.9670, -75.6370),
    LatLng(-13.9675, -75.6375),
    LatLng(-13.9680, -75.6380),
    LatLng(-13.9685, -75.6385),
    LatLng(-13.9690, -75.6390),
    LatLng(-13.9695, -75.6395),
    LatLng(-13.9700, -75.6400),
    LatLng(-13.9705, -75.6405),
    LatLng(-13.9710, -75.6410),
    LatLng(-13.9715, -75.6415),
    LatLng(-13.9720, -75.6420),
    LatLng(-13.9725, -75.6425),
    LatLng(-13.9730, -75.6430),
    LatLng(-13.9735, -75.6435),
    LatLng(-13.9740, -75.6440),
    LatLng(-13.9745, -75.6445),
    LatLng(-13.9750, -75.6450),
    LatLng(-13.9755, -75.6455),
    LatLng(-13.9760, -75.6460),
    LatLng(-13.9765, -75.6465),
    LatLng(-13.9770, -75.6470),
    LatLng(-13.9775, -75.6475),
    LatLng(-13.9780, -75.6480),
    LatLng(-13.9785, -75.6485),
    LatLng(-13.9790, -75.6490),
    LatLng(-13.9795, -75.6495),
    LatLng(-13.9800, -75.6500),
    LatLng(-13.9805, -75.6505),
    LatLng(-13.9810, -75.6510),
    LatLng(-13.9815, -75.6515),
    LatLng(-13.9820, -75.6520),
    LatLng(-13.9825, -75.6525),
    LatLng(-13.9830, -75.6530),
    LatLng(-13.9835, -75.6535),
    LatLng(-13.9840, -75.6540),
    LatLng(-13.9845, -75.6545),
    LatLng(-13.9850, -75.6550),
    LatLng(-13.9855, -75.6555),
    LatLng(-13.9860, -75.6560),
    LatLng(-13.9865, -75.6565),
    LatLng(-13.9870, -75.6570),
    LatLng(-13.9875, -75.6575),
    LatLng(-13.9880, -75.6580),
    LatLng(-13.9885, -75.6585),
    LatLng(-13.9890, -75.6590),
    LatLng(-13.9895, -75.6595),
    LatLng(-13.9900, -75.6600),
    LatLng(-13.9905, -75.6605),
    LatLng(-13.9910, -75.6610),
    LatLng(-13.9915, -75.6615),
    LatLng(-13.9920, -75.6620),
    LatLng(-13.9925, -75.6625),
    LatLng(-13.9930, -75.6630),
    LatLng(-13.9935, -75.6635),
    LatLng(-13.9940, -75.6640),
    LatLng(-13.9945, -75.6645),
    LatLng(-13.9950, -75.6650),
    LatLng(-13.9955, -75.6655),
    LatLng(-13.9960, -75.6660),
    LatLng(-13.9965, -75.6665),
    LatLng(-13.9970, -75.6670),
    LatLng(-13.9975, -75.6675),
    LatLng(-13.9980, -75.6680),
    LatLng(-13.9985, -75.6685),
    LatLng(-13.9990, -75.6690),
    LatLng(-13.9995, -75.6695),
    LatLng(-14.0000, -75.6700),
    LatLng(-14.0005, -75.6705),
    LatLng(-14.0010, -75.6710),
    LatLng(-14.0015, -75.6715),
    LatLng(-14.0020, -75.6720),
    LatLng(-14.0025, -75.6725),
    LatLng(-14.0030, -75.6730),
    LatLng(-14.0035, -75.6735),
    LatLng(-14.0040, -75.6740),
    LatLng(-14.0045, -75.6745),
    LatLng(-14.0050, -75.6750),
    LatLng(-14.0055, -75.6755),
    LatLng(-14.0060, -75.6760),
    LatLng(-14.0065, -75.6765),
    LatLng(-14.0070, -75.6770),
    LatLng(-14.0075, -75.6775),
    LatLng(-14.0080, -75.6780),
    LatLng(-14.0085, -75.6785),
    LatLng(-14.0090, -75.6790),
    LatLng(-14.0095, -75.6795),
    LatLng(-14.0100, -75.6800),
    LatLng(-14.0105, -75.6805),
    LatLng(-14.0110, -75.6810),
    LatLng(-14.0115, -75.6815),
    LatLng(-14.0120, -75.6820),
    LatLng(-14.0125, -75.6825),
    LatLng(-14.0130, -75.6830),
    LatLng(-14.0135, -75.6835),
    LatLng(-14.0140, -75.6840),
    LatLng(-14.0145, -75.6845),
    LatLng(-14.0150, -75.6850),
    LatLng(-14.0155, -75.6855),
    LatLng(-14.0160, -75.6860),
    LatLng(-14.0165, -75.6865),
    LatLng(-14.0170, -75.6870),
    LatLng(-14.0175, -75.6875),
    LatLng(-14.0180, -75.6880),
    LatLng(-14.0185, -75.6885),
    LatLng(-14.0190, -75.6890),
    LatLng(-14.0195, -75.6895),
    LatLng(-14.0200, -75.6900),
    LatLng(-14.0205, -75.6905),
    LatLng(-14.0210, -75.6910),
    LatLng(-14.0215, -75.6915),
    LatLng(-14.0220, -75.6920),
    LatLng(-14.0225, -75.6925),
    LatLng(-14.0230, -75.6930),
    LatLng(-14.0235, -75.6935),
    LatLng(-14.0240, -75.6940),
    LatLng(-14.0245, -75.6945),
    LatLng(-14.0250, -75.6950),
    LatLng(-14.0255, -75.6955),
    LatLng(-14.0260, -75.6960),
    LatLng(-14.0265, -75.6965),
    LatLng(-14.0270, -75.6970),
    LatLng(-14.0275, -75.6975),
    LatLng(-14.0280, -75.6980),
    LatLng(-14.0285, -75.6985),
    LatLng(-14.0290, -75.6990),
    LatLng(-14.0295, -75.6995),
    LatLng(-14.0300, -75.7000),
    LatLng(-14.0305, -75.7005),
    LatLng(-14.0310, -75.7010),
    LatLng(-14.0315, -75.7015),
    LatLng(-14.0320, -75.7020),
    LatLng(-14.0325, -75.7025),
    LatLng(-14.0330, -75.7030),
    LatLng(-14.0335, -75.7035),
    LatLng(-14.0340, -75.7040),
    LatLng(-14.0345, -75.7045),
    LatLng(-14.0350, -75.7050),
    LatLng(-14.0355, -75.7055),
    LatLng(-14.0360, -75.7060),
    LatLng(-14.0365, -75.7065),
    LatLng(-14.0370, -75.7070),
    LatLng(-14.0375, -75.7075),
    LatLng(-14.0380, -75.7080),
    LatLng(-14.0385, -75.7085),
    LatLng(-14.0390, -75.7090),
    LatLng(-14.0395, -75.7095),
    LatLng(-14.0400, -75.7100),
    LatLng(-14.0405, -75.7105),
    LatLng(-14.0410, -75.7110),
    LatLng(-14.0415, -75.7115),
    LatLng(-14.0420, -75.7120),
    LatLng(-14.0425, -75.7125),
    LatLng(-14.0430, -75.7130),
    LatLng(-14.0435, -75.7135),
    LatLng(-14.0440, -75.7140),
    LatLng(-14.0445, -75.7145),
    LatLng(-14.0450, -75.7150),
    LatLng(-14.0455, -75.7155),
    LatLng(-14.0460, -75.7160),
    LatLng(-14.0465, -75.7165),
    LatLng(-14.0470, -75.7170),
    LatLng(-14.0475, -75.7175),
    LatLng(-14.0480, -75.7180),
    LatLng(-14.0485, -75.7185),
    LatLng(-14.0490, -75.7190),
    LatLng(-14.0495, -75.7195),
    LatLng(-14.0500, -75.7200),
    LatLng(-14.0505, -75.7205),
    LatLng(-14.0510, -75.7210),
    LatLng(-14.0515, -75.7215),
    LatLng(-14.0520, -75.7220),
    LatLng(-14.0525, -75.7225),
    LatLng(-14.0530, -75.7230),
    LatLng(-14.0535, -75.7235),
    LatLng(-14.0540, -75.7240),
    LatLng(-14.0545, -75.7245),
    LatLng(-14.0550, -75.7250),
    LatLng(-14.0555, -75.7255),
    LatLng(-14.0560, -75.7260),
    LatLng(-14.0565, -75.7265),
    LatLng(-14.0570, -75.7270),
    LatLng(-14.0575, -75.7275),
    LatLng(-14.0580, -75.7280),
    LatLng(-14.0585, -75.7285),
    LatLng(-14.0590, -75.7290),
    LatLng(-14.0595, -75.7295),
    LatLng(-14.0600, -75.7300),
    LatLng(-14.0605, -75.7305),
    LatLng(-14.0610, -75.7310),
    LatLng(-14.0615, -75.7315),
    LatLng(-14.0620, -75.7320),
    LatLng(-14.0625, -75.7325),
    LatLng(-14.0630, -75.7330),
    LatLng(-14.0635, -75.7335),
    LatLng(-14.0640, -75.7340),
    LatLng(-14.0645, -75.7345),
    LatLng(-14.0650, -75.7350),
    LatLng(-14.0655, -75.7355),
    LatLng(-14.0660, -75.7360),
    LatLng(-14.0665, -75.7365),
    LatLng(-14.0670, -75.7370),
    LatLng(-14.0675, -75.7375),
    LatLng(-14.0680, -75.7380),
    LatLng(-14.0685, -75.7385),
    LatLng(-14.0690, -75.7390),
    LatLng(-14.0695, -75.7395),
    LatLng(-14.0700, -75.7400),
    LatLng(-14.0705, -75.7405),
    LatLng(-14.0710, -75.7410),
    LatLng(-14.0715, -75.7415),
    LatLng(-14.0720, -75.7420),
    LatLng(-14.0725, -75.7425),
    LatLng(-14.0730, -75.7430),
    LatLng(-14.0735, -75.7435),
    LatLng(-14.0740, -75.7440),
    LatLng(-14.0745, -75.7445),
    LatLng(-14.0750, -75.7450),
    LatLng(-14.0755, -75.7455),
    LatLng(-14.0760, -75.7460),
  ];

  // Método para obtener todos los marcadores visibles
  Set<Marker> get _marcadoresVisibles {
    Set<Marker> marcadores = {};
    if (_mostrarRutaR7) marcadores.addAll(_paraderosR7);
    if (_mostrarRutaR2) marcadores.addAll(_paraderosR2);
    return marcadores;
  }

  // Método para obtener todas las polylines visibles
  Set<Polyline> get _polylinesVisibles {
    Set<Polyline> polylines = {};

    if (_mostrarRutaR7) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('rutaIdaR7'),
          color: Colors.blue,
          width: 5,
          points: _rutaIdaR7,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    if (_mostrarRutaR2) {
      polylines.addAll({
        Polyline(
          polylineId: const PolylineId('rutaIdaR2'),
          color: Colors.purple,
          width: 5,
          points: _rutaIdaR2,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
        Polyline(
          polylineId: const PolylineId('rutaVueltaR2'),
          color: Colors.purpleAccent,
          width: 5,
          points: _rutaVueltaR2,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      });
    }

    return polylines;
  }

  void _checkMapConfiguration() {
    print('🗺️ Configuración de Maps para Ica verificada');
    print('📍 Centro Ica: $_centro');
    print('🚏 Paraderos R7: ${_paraderosR7.length}');
    print('🚏 Paraderos R2: ${_paraderosR2.length}');
  }

  Future<void> _checkLocationPermission() async {
    try {
      final status = await Permission.location.status;
      if (status.isGranted) {
        setState(() {
          _locationEnabled = true;
        });
      } else {
        final result = await Permission.location.request();
        if (result.isGranted) {
          setState(() {
            _locationEnabled = true;
          });
        }
      }
    } catch (e) {
      print('❌ Error en permisos: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _isMapCreated = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _goToCenter();
    });
  }

  void _toggleRutaR7() {
    setState(() {
      _mostrarRutaR7 = !_mostrarRutaR7;
    });
  }

  void _toggleRutaR2() {
    setState(() {
      _mostrarRutaR2 = !_mostrarRutaR2;
    });
  }

  void _zoomIn() => mapController.animateCamera(CameraUpdate.zoomIn());
  void _zoomOut() => mapController.animateCamera(CameraUpdate.zoomOut());

  void _goToCenter() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _centro, zoom: 12.0, bearing: 0, tilt: 0),
      ),
    );
  }

  void _goToMyLocation() {
    if (_currentLocation != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentLocation!, zoom: 16.0),
        ),
      );
    } else {
      _goToCenter();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ubicación no disponible, centrando en Ica'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _refreshMap() {
    setState(() {
      _hasError = false;
    });
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar el mapa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Verifica que:\n• Tu conexión a internet funcione\n• La API Key de Google Maps esté configurada\n• Los servicios de Google Play estén actualizados',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _refreshMap,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                TextButton.icon(
                  onPressed: _goToCenter,
                  icon: const Icon(Icons.map),
                  label: const Text('Centrar en Ica'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando mapa de Ica...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blueAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.directions_bus,
              color: Colors.blueAccent,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rutas R7 y R2 - Ica',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const Text(
                    'Tarifas: General S/1.50 • Escolar S/0.70 • Universitario S/1.00',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    'R7: ${_paraderosR7.length} paraderos • R2: ${_paraderosR2.length} paraderos',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              _locationEnabled ? Icons.location_on : Icons.location_off,
              color: _locationEnabled ? Colors.green : Colors.orange,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlRutas() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Botón R7
                GestureDetector(
                  onTap: _toggleRutaR7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _mostrarRutaR7
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _mostrarRutaR7 ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'B ${_mostrarRutaR7 ? '✓' : '✗'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _mostrarRutaR7 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Botón R2
                GestureDetector(
                  onTap: _toggleRutaR2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _mostrarRutaR2
                          ? Colors.purple.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _mostrarRutaR2 ? Colors.purple : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'R2 ${_mostrarRutaR2 ? '✓' : '✗'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _mostrarRutaR2 ? Colors.purple : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Toca para mostrar/ocultar rutas',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutas R7 y R2 - Ica'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          if (_isMapCreated)
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _goToMyLocation,
              tooltip: 'Mi ubicación',
            ),
          if (_isMapCreated)
            IconButton(
              icon: const Icon(Icons.center_focus_strong),
              onPressed: _goToCenter,
              tooltip: 'Centrar en Ica',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMap,
            tooltip: 'Recargar mapa',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: (CameraPosition position) {},
            onCameraIdle: () {},
            initialCameraPosition: CameraPosition(
              target: _centro,
              zoom: 12.0, // Zoom reducido para ver toda la ruta R2
            ),
            markers: _marcadoresVisibles,
            polylines: _polylinesVisibles,
            myLocationEnabled: _locationEnabled,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: true,
            trafficEnabled: false,
            buildingsEnabled: true,
            mapToolbarEnabled: true,
            onTap: (LatLng position) {
              print('📍 Mapa de Ica tocado en: $position');
            },
          ),

          // Controles de zoom
          if (_isMapCreated && !_hasError)
            Positioned(
              right: 16,
              bottom: 140,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'zoom_in',
                    onPressed: _zoomIn,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'zoom_out',
                    onPressed: _zoomOut,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),

          // Control de rutas
          if (_isMapCreated && !_hasError) _buildControlRutas(),

          // Información de rutas
          if (!_hasError) _buildRouteInfo(),

          // Indicador de carga
          if (!_isMapCreated && !_hasError) _buildLoadingWidget(),

          // Mensaje de error
          if (_hasError) _buildErrorWidget(),
        ],
      ),
      floatingActionButton: _isMapCreated && !_hasError
          ? FloatingActionButton(
              onPressed: _goToMyLocation,
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              child: const Icon(Icons.my_location),
            )
          : null,
    );
  }
}

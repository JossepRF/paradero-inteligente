import 'package:flutter/material.dart';
import 'pages/mapa_page.dart';

void main() {
  runApp(const ParaderoInteligenteApp());
}

class ParaderoInteligenteApp extends StatelessWidget {
  const ParaderoInteligenteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paradero Inteligente',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF007AFF), Color(0xFF0051A8), Color(0xFF003D82)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header con menú
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    const Text(
                      'Paradero Inteligente',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48), // Para balancear el espacio
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo animado
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.elasticOut,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                            ),
                            child: const Icon(Icons.directions_bus_rounded,
                                color: Colors.white, size: 100),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Título principal
                        const Column(
                          children: [
                            Text(
                              'PARADERO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              'INTELIGENTE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Subtítulo
                        const Text(
                          'Tu guía urbana en tiempo real',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Botón principal
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF007AFF),
                              elevation: 8,
                              shadowColor: Colors.black.withOpacity(0.3),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MapaPage()),
                              );
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.map, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Ver Mapa de Rutas',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Botón secundario
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            _showTarifasDialog(context);
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.attach_money, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Ver Tarifas',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Información rápida
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: const Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InfoItem(icon: Icons.directions_bus, text: '2 Rutas'),
                                  InfoItem(icon: Icons.schedule, text: '24/7'),
                                  InfoItem(icon: Icons.location_on, text: 'En Tiempo Real'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTarifasDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.attach_money, color: Colors.green),
            SizedBox(width: 10),
            Text('Tarifas de Pasaje'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTarifaItem('General', 'S/ 1.50'),
              _buildTarifaItem('Escolar', 'S/ 0.70'),
              _buildTarifaItem('Universitario', 'S/ 1.00'),
              _buildTarifaItem('Adulto Mayor', 'S/ 0.70'),
              const SizedBox(height: 10),
              const Text(
                'Válidas para todas las rutas',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTarifaItem(String tipo, String precio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tipo,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            precio,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header del drawer
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF007AFF), Color(0xFF0051A8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 40),
                const SizedBox(height: 10),
                const Text(
                  'Paradero Inteligente',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Tu transporte urbano',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Opciones del menú
          _buildDrawerItem(
            context,
            icon: Icons.map,
            title: 'Mapa de Rutas',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MapaPage()));
            },
          ),

          _buildDrawerItem(
            context,
            icon: Icons.attach_money,
            title: 'Tarifas y Precios',
            onTap: () {
              Navigator.pop(context);
              _showTarifasCompletas(context);
            },
          ),

          _buildDrawerItem(
            context,
            icon: Icons.directions_bus,
            title: 'Información de Rutas',
            onTap: () {
              Navigator.pop(context);
              _showInfoRutas(context);
            },
          ),

          _buildDrawerItem(
            context,
            icon: Icons.info,
            title: 'Acerca de la App',
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),

          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Configuración',
            onTap: () {
              Navigator.pop(context);
              _showSettingsDialog(context);
            },
          ),

          const Divider(),

          _buildDrawerItem(
            context,
            icon: Icons.exit_to_app,
            title: 'Salir',
            onTap: () {
              Navigator.pop(context);
              // Aquí puedes agregar lógica para salir de la app
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF007AFF)),
      title: Text(title),
      onTap: onTap,
    );
  }

  void _showTarifasCompletas(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.attach_money, color: Colors.green),
            SizedBox(width: 10),
            Text('Tarifas Completas'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tarifas de Pasaje',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 15),
              _buildTarifaCard('General', 'S/ 1.50', Colors.blue),
              _buildTarifaCard('Escolar', 'S/ 0.70', Colors.green),
              _buildTarifaCard('Universitario', 'S/ 1.00', Colors.orange),
              _buildTarifaCard('Adulto Mayor', 'S/ 0.70', Colors.purple),
              const SizedBox(height: 15),
              const Text(
                'Horarios de servicio: 5:00 AM - 11:00 PM',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTarifaCard(String tipo, String precio, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.attach_money, color: color),
        ),
        title: Text(tipo),
        trailing: Text(
          precio,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showInfoRutas(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.directions_bus, color: Colors.blue),
            SizedBox(width: 10),
            Text('Información de Rutas'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRutaInfo('Ruta B', 'Puente Grau - Hotel Las Dunas', Colors.blue),
              _buildRutaInfo('Ruta R2', 'Washington - Las Palmeras', Colors.purple),
              const SizedBox(height: 10),
              const Text(
                'Todas las rutas operan de 5:00 AM a 11:00 PM',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildRutaInfo(String ruta, String descripcion, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: color.withOpacity(0.05),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Text(
            ruta.substring(0, 1),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(ruta, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        subtitle: Text(descripcion),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acerca de'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Paradero Inteligente v1.0'),
            SizedBox(height: 10),
            Text('Aplicación desarrollada para facilitar el transporte urbano en Ica.'),
            SizedBox(height: 10),
            Text('© 2024 Todos los derechos reservados.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Opciones de configuración estarán disponibles en futuras actualizaciones.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
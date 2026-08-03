import 'package:flutter/material.dart';

void main() {
  runApp(const AeroHelperApp());
}

class AeroHelperApp extends StatelessWidget {
  const AeroHelperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aero Pomoćnik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigationScreen(),
      },
    );
  }
}

// --- SCREEN 4: Mreža (Društvo) ---
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _postController = TextEditingController();
  final List<String> _posts = [
    'Završio sam novi model jedrilice danas! Težište je savršeno na 32%.',
    'Može li neko da preporuči dobar ESC za 2212 motor?',
    'Zdravo svima! Novi sam u hobiju, upravo pravim svoj prvi Flite Test avion.'
  ];

  void _addPost() {
    final text = _postController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _posts.insert(0, text);
        _postController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mreža Modelara')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _postController,
                        decoration: const InputDecoration(
                          labelText: 'Podelite savet, pitanje ili projekat...',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addPost(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton(
                      onPressed: _addPost,
                      elevation: 0,
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Korisnik',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(_posts[index]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const OhmsLawScreen(),
    const CGCalculatorScreen(),
    const InventoryScreen(),
    const CommunityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Responsive check for wide screens
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.electrical_services_outlined),
                      selectedIcon: Icon(Icons.electrical_services),
                      label: Text('Omov zakon'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.flight_outlined),
                      selectedIcon: Icon(Icons.flight),
                      label: Text('Težište (CG)'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.list_alt_outlined),
                      selectedIcon: Icon(Icons.list_alt),
                      label: Text('Moji delovi'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people),
                      label: Text('Mreža'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _screens[_currentIndex]),
              ],
            )
          : _screens[_currentIndex],
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.electrical_services_outlined),
                  selectedIcon: Icon(Icons.electrical_services),
                  label: 'Omov zakon',
                ),
                NavigationDestination(
                  icon: Icon(Icons.flight_outlined),
                  selectedIcon: Icon(Icons.flight),
                  label: 'Težište',
                ),
                NavigationDestination(
                  icon: Icon(Icons.list_alt_outlined),
                  selectedIcon: Icon(Icons.list_alt),
                  label: 'Delovi',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Mreža',
                ),
              ],
            ),
    );
  }
}

// --- SCREEN 1: Omov Zakon ---
class OhmsLawScreen extends StatefulWidget {
  const OhmsLawScreen({super.key});

  @override
  State<OhmsLawScreen> createState() => _OhmsLawScreenState();
}

class _OhmsLawScreenState extends State<OhmsLawScreen> {
  final TextEditingController _voltageController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();
  String _result = '';

  void _calculate() {
    final voltage = double.tryParse(_voltageController.text);
    final resistance = double.tryParse(_resistanceController.text);

    if (voltage == null || resistance == null) {
      setState(() {
        _result = 'Molimo unesite validne brojeve.';
      });
      return;
    }

    if (resistance == 0) {
      setState(() {
        _result = 'Otpor ne može biti nula.';
      });
      return;
    }

    final current = voltage / resistance;
    setState(() {
      _result = 'Struja (I): ${current.toStringAsFixed(2)} Ampera (A)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Omov Zakon (I = U / R)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Izračunajte struju u kolu na osnovu napona i otpora.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _voltageController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Napon (Volti - V)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.bolt),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _resistanceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Otpor (Omi - Ω)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.speed),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Izračunaj Struju'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 32),
                if (_result.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _result,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- SCREEN 2: Kalkulator Težišta ---
class CGCalculatorScreen extends StatefulWidget {
  const CGCalculatorScreen({super.key});

  @override
  State<CGCalculatorScreen> createState() => _CGCalculatorScreenState();
}

class _CGCalculatorScreenState extends State<CGCalculatorScreen> {
  final TextEditingController _chordController = TextEditingController();
  String _result = '';

  void _calculate() {
    final chord = double.tryParse(_chordController.text);

    if (chord == null || chord <= 0) {
      setState(() {
        _result = 'Molimo unesite ispravnu širinu krila.';
      });
      return;
    }

    final cgPosition = chord * 0.30;
    setState(() {
      _result = 'Težište (CG) na 30% se nalazi na:\n\n${cgPosition.toStringAsFixed(2)} cm\n\nmereno od napadne ivice (prednjeg dela) krila.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Težište Aviona (CG)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Izračunajte gde se nalazi težište (Center of Gravity) za vaš RC model aviona (standardno oko 30% širine krila).',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _chordController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Širina krila - tetiva (cm)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.straighten),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Izračunaj Težište'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 32),
                if (_result.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _result,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onTertiaryContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- SCREEN 3: Spisak delova ---
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _itemController = TextEditingController();
  final List<String> _parts = ['Motor 2212 1000KV', 'ESC 30A', 'Baterija 3S 2200mAh', 'Servo 9g (x4)'];

  void _addItem() {
    final text = _itemController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _parts.insert(0, text);
        _itemController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _parts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moji Delovi')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _itemController,
                        decoration: const InputDecoration(
                          labelText: 'Novi deo (npr. Servo, Baterija...)',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addItem(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton(
                      onPressed: _addItem,
                      elevation: 0,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _parts.isEmpty
                    ? const Center(child: Text('Vaš spisak je prazan. Dodajte novi deo!'))
                    : ListView.builder(
                        itemCount: _parts.length,
                        itemBuilder: (context, index) {
                          final item = _parts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.category),
                              ),
                              title: Text(item),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () => _removeItem(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

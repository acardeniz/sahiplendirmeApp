import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:testapp/l10n/app_localizations.dart';
import 'pages/search_page.dart';
import 'pages/favorites_page.dart';
import 'pages/profile_page.dart';
import 'pages/add_pet_page.dart';
import 'pet_data.dart';
import 'constants.dart';

const Locale turkishLocale = Locale('tr');
const Locale englishLocale = Locale('en');

void main() {
  runApp(const MyAppWrapper());
}

class MyAppWrapper extends StatefulWidget {
  const MyAppWrapper({super.key});

  @override
  State<MyAppWrapper> createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = turkishLocale;

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyApp(
      themeMode: _themeMode,
      toggleTheme: _toggleTheme,
      locale: _locale,
      changeLanguage: _changeLanguage,
    );
  }
}

class MyApp extends StatelessWidget {
  final ThemeMode themeMode;
  final Function(bool) toggleTheme;
  final Locale locale;
  final Function(Locale) changeLanguage;

  const MyApp({
    super.key,
    required this.themeMode,
    required this.toggleTheme,
    required this.locale,
    required this.changeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [turkishLocale, englishLocale],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: lightBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.black54,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(surface: Colors.white, secondary: secondaryColor),
      ),

      darkTheme: ThemeData(
        primaryColor: darkPrimaryColor,
        scaffoldBackgroundColor: darkBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkSecondaryColor,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.white60,
          backgroundColor: darkSecondaryColor,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
            ).copyWith(
              surface: const Color(0xFF1E1E1E),
              secondary: darkSecondaryColor,
            ),
      ),

      home: MyHomePage(
        toggleTheme: toggleTheme,
        currentThemeMode: themeMode,
        currentLocale: locale,
        changeLanguage: changeLanguage,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final ThemeMode currentThemeMode;
  final Locale currentLocale;
  final Function(Locale) changeLanguage;

  const MyHomePage({
    super.key,
    required this.toggleTheme,
    required this.currentThemeMode,
    required this.currentLocale,
    required this.changeLanguage,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final GlobalKey<HomeScreenContentState> _homeKey = GlobalKey();
  final Set<String> _favoritePets = {};

  late SharedPreferences _prefs;
  final List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromStorage();
  }

  void _loadDataFromStorage() async {
    _prefs = await SharedPreferences.getInstance();

    setState(() {
      final savedFavorites = _prefs.getStringList('favoritePets');
      if (savedFavorites != null) {
        _favoritePets.addAll(savedFavorites);
      }

      final savedHistory = _prefs.getStringList('searchHistory');
      if (savedHistory != null) {
        _searchHistory.addAll(savedHistory);
      }
    });
  }

  void _saveFavorites() {
    _prefs.setStringList('favoritePets', _favoritePets.toList());
  }

  void _addSearchQuery(String query) {
    if (query.isEmpty) return;

    if (_searchHistory.contains(query)) {
      _searchHistory.remove(query);
    }
    _searchHistory.insert(0, query);

    if (_searchHistory.length > 5) {
      _searchHistory.removeLast();
    }

    _prefs.setStringList('searchHistory', _searchHistory);
  }

  void _addPetToList(PetAdoptionData newPet) {
    setState(() {
      allPetsData.insert(0, newPet);
      _homeKey.currentState?.setState(() {});
    });
  }

  void _toggleFavorite(String petName) {
    setState(() {
      if (_favoritePets.contains(petName)) {
        _favoritePets.remove(petName);
      } else {
        _favoritePets.add(petName);
      }
      _saveFavorites();
      _homeKey.currentState?.setState(() {});
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<Widget> pages = [
      HomeScreenContent(
        key: _homeKey,
        favoritePets: _favoritePets,
        toggleFavorite: _toggleFavorite,
      ),
      SearchPage(searchHistory: _searchHistory, addQuery: _addSearchQuery),
      FavoritesPage(
        favoritePets: _favoritePets,
        toggleFavorite: _toggleFavorite,
      ),
      ProfilePage(
        toggleTheme: widget.toggleTheme,
        currentThemeMode: widget.currentThemeMode,
        currentLocale: widget.currentLocale,
        changeLanguage: widget.changeLanguage,
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: l10n.homePage),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: l10n.search),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: l10n.favorites,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPetPage(onPetAdded: _addPetToList),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.pets, color: Colors.white, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  final Set<String>? favoritePets;
  final Function(String)? toggleFavorite;

  const HomeScreenContent({
    super.key,
    required this.favoritePets,
    required this.toggleFavorite,
  });

  @override
  State<HomeScreenContent> createState() => HomeScreenContentState();
}

class HomeScreenContentState extends State<HomeScreenContent> {
  String? _selectedType;

  List<PetAdoptionData> get _filteredPets {
    if (_selectedType == null ||
        _selectedType == 'Hepsi' ||
        _selectedType == 'All') {
      return allPetsData;
    }
    return allPetsData.where((pet) => pet.type == _selectedType).toList();
  }

  Widget _buildFilterButton(
    BuildContext context,
    IconData icon,
    String label,
    String filterType,
  ) {
    final isSelected =
        _selectedType == filterType ||
        ((filterType == 'Hepsi' || filterType == 'All') &&
            _selectedType == null);

    final color = Theme.of(context).primaryColor;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = (filterType == 'Hepsi' || filterType == 'All')
              ? null
              : filterType;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label ${AppLocalizations.of(context)!.adsShowing}'),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: isSelected ? color : color.withOpacity(0.1),
            child: Icon(icon, color: isSelected ? Colors.white : color),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium!.color!.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get _carouselItems {
    if (allPetsData.isEmpty) {
      return [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            'https://via.placeholder.com/400x200?text=Ilan+Yok',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ];
    }

    return allPetsData.map((pet) {
      void showPetContact() {
        showDialog(
          context: context,
          builder: (context) => ContactInfoDialog(pet: pet),
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: showPetContact,
          child: Image.network(
            pet.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.network(
                'https://via.placeholder.com/400x200?text=Resim+Yuklenemedi',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          CarouselSlider(
            items: _carouselItems,
            options: CarouselOptions(
              height: 200,
              viewportFraction: 0.8,
              autoPlay: true,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
            ),
          ),
          const SizedBox(height: 30),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.adoptionCategories,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                Divider(height: 20, color: Theme.of(context).dividerColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFilterButton(context, Icons.pets, l10n.dog, l10n.dog),
                    _buildFilterButton(
                      context,
                      Icons.mood_sharp,
                      l10n.cat,
                      l10n.cat,
                    ),
                    _buildFilterButton(
                      context,
                      Icons.flutter_dash,
                      l10n.bird,
                      l10n.bird,
                    ),
                    _buildFilterButton(
                      context,
                      Icons.view_list,
                      l10n.all,
                      l10n.all,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _selectedType == null
                  ? l10n.popularAds
                  : '$_selectedType ${l10n.ads}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                if (_filteredPets.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text(
                        l10n.noAdsInCategory,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ..._filteredPets
                      .map(
                        (pet) => PetAdoptionCard(
                          pet: pet,
                          favoritePets: widget.favoritePets,
                          toggleFavorite: widget.toggleFavorite,
                        ),
                      )
                      .toList(),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

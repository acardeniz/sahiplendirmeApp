import 'package:flutter/material.dart';
import '../pet_data.dart';
import '../constants.dart';

class FavoritesPage extends StatelessWidget {
  final Set<String> favoritePets;

  final Function(String)? toggleFavorite;

  const FavoritesPage({
    super.key,
    required this.favoritePets,
    this.toggleFavorite,
  });

  List<PetAdoptionData> get _favoritePetsList {
    return allPetsData.where((pet) => favoritePets.contains(pet.name)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pets = _favoritePetsList;

    return Scaffold(
      body: favoritePets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: lightGreyColor),
                  const SizedBox(height: 10),
                  Text(
                    'Henüz Favori İlanınız Yok.',
                    style: TextStyle(fontSize: 20, color: lightGreyColor),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Beğendiğiniz hayvanları burada göreceksiniz.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];

                return PetAdoptionCard(
                  pet: pet,
                  favoritePets: favoritePets,
                  toggleFavorite: toggleFavorite,
                );
              },
            ),
    );
  }
}

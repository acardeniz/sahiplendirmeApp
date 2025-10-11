import 'package:flutter/material.dart';
import '../pet_data.dart';
import '../constants.dart';

class SearchPage extends StatefulWidget {
  final List<String> searchHistory;
  final Function(String) addQuery;

  const SearchPage({
    super.key,
    required this.searchHistory,
    required this.addQuery,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<PetAdoptionData> _filteredResults = allPetsData;

  String get _query => _searchController.text.toLowerCase();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterPets);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalizeTurkish(String text) {
    text = text.toLowerCase();
    text = text.replaceAll('ç', 'c');
    text = text.replaceAll('ğ', 'g');
    text = text.replaceAll('ı', 'i');
    text = text.replaceAll('ö', 'o');
    text = text.replaceAll('ş', 's');
    text = text.replaceAll('ü', 'u');
    return text;
  }

  void _filterPets() {
    final query = _searchController.text;
    final normalizedQuery = _normalizeTurkish(query);

    setState(() {
      if (normalizedQuery.isEmpty) {
        _filteredResults = allPetsData;
      } else {
        _filteredResults = allPetsData.where((pet) {
          final normalizedPetName = _normalizeTurkish(pet.name);
          final normalizedPetType = _normalizeTurkish(pet.type);
          final normalizedPetBreed = _normalizeTurkish(pet.breed);

          return normalizedPetName.contains(normalizedQuery) ||
              normalizedPetType.contains(normalizedQuery) ||
              normalizedPetBreed.contains(normalizedQuery);
        }).toList();
      }
    });

    if (query.isNotEmpty && _filteredResults.isNotEmpty) {
      widget.addQuery(query);
    }
  }

  void _onHistoryTap(String query) {
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    _filterPets();
  }

  @override
  Widget build(BuildContext context) {
    final showHistory = _query.isEmpty && widget.searchHistory.isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tür, ırk veya ada göre ara (ör: kedi)...',
              prefixIcon: const Icon(Icons.search, color: primaryColor),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),

        if (showHistory)
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 8.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8.0,
                children: widget.searchHistory.map((query) {
                  return ActionChip(
                    label: Text(query),
                    onPressed: () => _onHistoryTap(query),
                    backgroundColor: lightGreyColor.withOpacity(0.3),
                  );
                }).toList(),
              ),
            ),
          ),

        Expanded(
          child: _filteredResults.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      'Aradığınız kriterlere uygun ilan bulunamadı.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _filteredResults.length,
                  itemBuilder: (context, index) {
                    final pet = _filteredResults[index];
                    return PetAdoptionCard(pet: pet);
                  },
                ),
        ),
      ],
    );
  }
}

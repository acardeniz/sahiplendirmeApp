// lib/pet_data.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'constants.dart';

String createWhatsAppLink(String phoneNumber) {
  if (phoneNumber.startsWith('+90')) {
    phoneNumber = phoneNumber.substring(1);
  } else if (phoneNumber.startsWith('0')) {
    phoneNumber = '90${phoneNumber.substring(1)}';
  }
  return 'https://wa.me/$phoneNumber';
}

class PetAdoptionData {
  final String imageUrl;
  final String name;
  final String location;
  final String breed;
  final String age;
  final String type;
  final Map<String, String> contactInfo;

  const PetAdoptionData({
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.breed,
    required this.age,
    required this.type,
    required this.contactInfo,
  });
}

List<PetAdoptionData> allPetsData = [
  PetAdoptionData(
    imageUrl:
        'https://cdn.pixabay.com/photo/2019/07/30/05/53/dog-4372036_960_720.jpg',
    name: 'Max',
    location: 'İstanbul / Kadıköy',
    breed: 'Golden Retriever',
    age: '1.5 Yaş',
    type: 'Köpek',
    contactInfo: {'Telefon': '05551234567', 'Instagram': '@maxin_sahibi'},
  ),
  PetAdoptionData(
    imageUrl:
        'https://cdn.pixabay.com/photo/2017/11/09/21/41/cat-2934720_1280.jpg',
    name: 'Lila',
    location: 'Ankara / Çankaya',
    breed: 'Tekir',
    age: '6 Aylık',
    type: 'Kedi',
    contactInfo: {'Telefon': '05329876543', 'Messenger': 'Lila_Ankara'},
  ),
  PetAdoptionData(
    imageUrl:
        'https://cdn.pixabay.com/photo/2022/02/18/11/50/rabbit-7020508_960_720.jpg',
    name: 'Pamuk',
    location: 'İzmir / Bornova',
    breed: 'Hollanda Lop',
    age: '2 Yaş',
    type: 'Diğer',
    contactInfo: {'Telefon': '05051112233'},
  ),
  PetAdoptionData(
    imageUrl:
        'https://cdn.pixabay.com/photo/2017/08/07/12/41/paige-2603450_960_720.jpg',
    name: 'Reis',
    location: 'Bursa / Nilüfer',
    breed: 'Sultan Papağanı',
    age: '1 Yaş',
    type: 'Kuş',
    contactInfo: {'Instagram': '@kuscu_reis'},
  ),
  PetAdoptionData(
    imageUrl:
        'https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_1280.jpg',
    name: 'Duman',
    location: 'İstanbul / Kizilay',
    breed: 'Siyam',
    age: '3 Yaş',
    type: 'Kedi',
    contactInfo: {'Telefon': '05445556677'},
  ),
];

class ContactInfoDialog extends StatelessWidget {
  final PetAdoptionData pet;

  const ContactInfoDialog({super.key, required this.pet});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Telefon':
        return Icons.phone;
      case 'WhatsApp':
        return Icons.send;
      case 'Instagram':
        return Icons.camera_alt;
      case 'Messenger':
        return Icons.message;
      default:
        return Icons.contact_mail;
    }
  }

  void _copyAndNotify(BuildContext context, String value, String type) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type bilgisi panoya kopyalandı: $value'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _launchContact(BuildContext context, String type, String value) async {
    String url = '';

    if (type == 'Telefon') {
      _copyAndNotify(context, value, type);
      url = 'tel:$value';
    } else if (type == 'WhatsApp') {
      _copyAndNotify(context, value, type);
      url = createWhatsAppLink(value);
    } else if (type == 'Instagram') {
      url = 'https://instagram.com/${value.replaceAll('@', '')}';
    } else if (type == 'Messenger') {
      url = 'https://m.me/${value}';
    } else if (type == 'Diğer') {
      _copyAndNotify(context, value, type);
      return;
    }

    if (url.isNotEmpty && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else if (type != 'Telefon' && type != 'Diğer') {
      debugPrint('Açılamayan URL: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = pet.contactInfo['Telefon'];
    final displayContacts = Map<String, String>.from(pet.contactInfo);

    if (phone != null && !displayContacts.containsKey('WhatsApp')) {
      displayContacts['WhatsApp'] = phone;
    }

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        '${pet.name} (${pet.breed}) İletişim',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: displayContacts.entries.map((entry) {
            final type = entry.key;
            final value = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                leading: Icon(_getIconForType(type), color: primaryColor),
                title: Text(value),
                subtitle: Text(type),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _launchContact(context, type, value),
                tileColor: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Kapat', style: TextStyle(color: primaryColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class PetAdoptionCard extends StatelessWidget {
  final PetAdoptionData pet;
  final Set<String>? favoritePets;
  final Function(String)? toggleFavorite;

  const PetAdoptionCard({
    super.key,
    required this.pet,
    this.favoritePets,
    this.toggleFavorite,
  });

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black12,
              child: ContactInfoDialog(pet: pet),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = favoritePets?.contains(pet.name) ?? false;

    return InkWell(
      onTap: () => _showContactDialog(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.network(
                pet.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              pet.breed,
                              style: const TextStyle(
                                fontSize: 14,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey.shade400,
                          size: 30,
                        ),
                        onPressed: () {
                          if (toggleFavorite != null) {
                            toggleFavorite!(pet.name);
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: lightGreyColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pet.location,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.cake, size: 16, color: lightGreyColor),
                      const SizedBox(width: 4),
                      Text(
                        pet.age,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

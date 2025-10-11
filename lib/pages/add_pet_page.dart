import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import '../pet_data.dart';

class AddPetPage extends StatefulWidget {
  final Function(PetAdoptionData) onPetAdded;

  const AddPetPage({super.key, required this.onPetAdded});

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _imageUrlController = TextEditingController();

  File? _pickedImage;
  String? _selectedType;
  final List<String> petTypes = ['Köpek', 'Kedi', 'Kuş', 'Diğer'];

  List<ContactField> _contactFields = [];
  final List<String> contactOptions = [
    'Telefon',
    'Instagram',
    'Messenger',
    'Diğer',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _imageUrlController.dispose();
    for (var field in _contactFields) {
      field.controller.dispose();
    }
    super.dispose();
  }

  void _addContactField() {
    setState(() {
      _contactFields.add(
        ContactField(
          type: contactOptions.first,
          controller: TextEditingController(),
          key: UniqueKey(),
        ),
      );
    });
  }

  void _removeContactField(Key key) {
    setState(() {
      _contactFields.removeWhere((field) => field.key == key);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _imageUrlController.clear();
      });
    }
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      if (_selectedType == null &&
          _pickedImage == null &&
          _imageUrlController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen hayvan türünü seçin ve bir resim ekleyin!'),
          ),
        );
        return;
      }

      final String finalImageUrl;
      if (_pickedImage != null) {
        finalImageUrl = _pickedImage!.path;
      } else if (_imageUrlController.text.isNotEmpty) {
        finalImageUrl = _imageUrlController.text;
      } else {
        finalImageUrl = 'https://via.placeholder.com/150?text=Yeni+Hayvan';
      }

      final Map<String, String> contactInfo = {};
      for (var field in _contactFields) {
        if (field.controller.text.isNotEmpty) {
          contactInfo[field.type] = field.controller.text;
        }
      }

      final newPet = PetAdoptionData(
        name: _nameController.text,
        location: _locationController.text,
        breed: _breedController.text,
        age: _ageController.text,
        imageUrl: finalImageUrl,
        type: _selectedType ?? 'Diğer',
        contactInfo: contactInfo,
      );

      widget.onPetAdded(newPet);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Hayvan Ekle'),
        backgroundColor: secondaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Hayvan Türü*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: _selectedType,
                items: petTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Lütfen tür seçiniz' : null,
              ),
              const SizedBox(height: 15),

              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: lightGreyColor),
                ),
                child: _pickedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _pickedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : Center(
                        child: Text(
                          _imageUrlController.text.isNotEmpty
                              ? "URL Resmi Kullanılacak"
                              : "Resim Seçilmedi / URL Girilmedi",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galeriden Seç'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Kamera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Veya Resim URL\'sini Buraya Yapıştırın',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onTap: () {
                  setState(() => _pickedImage = null);
                },
              ),
              const SizedBox(height: 15),

              _buildTextField('Adı', _nameController),
              _buildTextField('Irkı (Cinsi)', _breedController),
              _buildTextField('Yaşı', _ageController),
              _buildTextField('Konumu', _locationController),

              const SizedBox(height: 30),

              const Text(
                'İletişim Bilgileri (Birden Fazla Eklenebilir)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ..._contactFields.map((field) => _buildContactField(field)),

              OutlinedButton.icon(
                onPressed: _addContactField,
                icon: const Icon(Icons.add_circle, color: primaryColor),
                label: const Text('İletişim Alanı Ekle'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: primaryColor),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'İlanı Yayınla',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: '$label${isRequired ? '*' : ''}',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return '$label alanı zorunludur.';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildContactField(ContactField field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              value: field.type,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
              ),
              items: contactOptions.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    field.type = newValue;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: field.controller,
              decoration: InputDecoration(
                labelText: field.type == 'Telefon'
                    ? 'Numara (05xx...)'
                    : 'Kullanıcı Adı/Link',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Değer gerekli';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () => _removeContactField(field.key!),
          ),
        ],
      ),
    );
  }
}

class ContactField {
  Key? key;
  String type;
  TextEditingController controller;

  ContactField({this.key, required this.type, required this.controller});
}

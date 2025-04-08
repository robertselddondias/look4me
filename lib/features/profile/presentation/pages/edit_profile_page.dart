import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look4me/core/theme/app_colors.dart';
import 'package:look4me/core/theme/text_styles.dart';
import 'package:look4me/core/widgets/app_button.dart';
import 'package:look4me/features/profile/domain/bloc/profile_bloc.dart';
import 'package:look4me/features/profile/domain/bloc/profile_event.dart';
import 'package:look4me/features/profile/domain/bloc/profile_state.dart';
import 'package:look4me/modules/auth/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  File? _imageFile;
  String? _currentPhotoUrl;
  bool _isLoading = false;
  bool _hasChangedPhoto = false;
  UserModel? _currentUser;

  // Preferências de moda
  final List<String> _selectedCategories = [];
  final List<String> _availableCategories = [
    'Casual', 'Trabalho', 'Festa', 'Esporte', 'Praia',
    'Inverno', 'Verão', 'Outono', 'Primavera', 'Formal'
  ];

  String? _selectedFashionStyle;
  final List<String> _availableFashionStyles = [
    'Casual Chique', 'Minimalista', 'Boho', 'Vintage',
    'Clássico', 'Romântico', 'Esportivo', 'Streetwear'
  ];

  // Marcas favoritas
  final TextEditingController _brandsController = TextEditingController();
  List<String> _favoriteBrands = [];

  @override
  void initState() {
    super.initState();
    // Vamos carregar o perfil depois que o widget for completamente montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _brandsController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profileBloc = context.read<ProfileBloc>();
      profileBloc.add(LoadUserProfileEvent());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar dados: $e'),
          backgroundColor: AppColors.error,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateFormWithUserData(UserModel user) {
    setState(() {
      _currentUser = user;

      // Dados básicos
      _nameController.text = user.fullName;
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _currentPhotoUrl = user.photoUrl;

      if (user.bio != null && user.bio!.isNotEmpty) {
        _bioController.text = user.bio!;
      }

      if (user.location != null) {
        _locationController.text = user.location!;
      }

      // Preferências
      _selectedCategories.clear();
      if (user.categories.isNotEmpty) {
        _selectedCategories.addAll(user.categories);
      }

      _selectedFashionStyle = user.fashionStyle;

      _favoriteBrands = List<String>.from(user.interests);
      _brandsController.text = _favoriteBrands.join(', ');

      _isLoading = false;
    });
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String? photoUrl = _currentPhotoUrl;

        // Se a foto foi alterada, fazer upload
        if (_imageFile != null && _hasChangedPhoto) {
          photoUrl = await _uploadProfileImage();
        }

        // Separar as marcas da string
        final brands = _brandsController.text
            .split(',')
            .map((brand) => brand.trim())
            .where((brand) => brand.isNotEmpty)
            .toList();

        // Dados atualizados do usuário
        final updatedUser = _currentUser!.copyWith(
          fullName: _nameController.text,
          username: _usernameController.text,
          bio: _bioController.text,
          photoUrl: photoUrl,
          location: _locationController.text,
          categories: _selectedCategories,
          fashionStyle: _selectedFashionStyle,
          interests: brands,
        );

        context.read<ProfileBloc>().add(UpdateProfileEvent(updatedUser));

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar perfil: $e'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> _uploadProfileImage() async {
    if (_imageFile == null) return null;

    try {
      final userId = _currentUser!.id;
      final fileName = 'profile_$userId.jpg';

      // Referência para o arquivo no Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName);

      // Upload da imagem
      final uploadTask = ref.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() {});

      // Obter URL da imagem
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Erro ao fazer upload: $e');
      return null;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _hasChangedPhoto = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar imagem: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Foto de perfil',
            style: TextStyles.heading3,
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                Icons.camera_alt,
                color: AppColors.primary,
              ),
            ),
            title: const Text('Tirar foto'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                Icons.photo_library,
                color: AppColors.primary,
              ),
            ),
            title: const Text('Escolher da galeria'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          if (_currentPhotoUrl != null || _hasChangedPhoto)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.1),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              title: const Text(
                'Remover foto atual',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentPhotoUrl = null;
                  _imageFile = null;
                  _hasChangedPhoto = true;
                });
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showCategoriesDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              'Categorias favoritas',
              style: TextStyles.heading3,
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Selecione suas categorias favoritas:',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableCategories.map((category) {
                          final isSelected = _selectedCategories.contains(category);
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                if (isSelected) {
                                  _selectedCategories.remove(category);
                                } else {
                                  _selectedCategories.add(category);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.primaryLight.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                category,
                                style: TextStyles.bodySmall.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Salvar',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showStylesDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              'Seu estilo pessoal',
              style: TextStyles.heading3,
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Escolha o estilo que mais combina com você:',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _availableFashionStyles.map((style) {
                          final isSelected = _selectedFashionStyle == style;
                          return RadioListTile<String>(
                            title: Text(style),
                            value: style,
                            groupValue: _selectedFashionStyle,
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              setDialogState(() {
                                _selectedFashionStyle = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Salvar',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use BlocListener para reagir às mudanças de estado sem reconstruir o widget
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          _updateFormWithUserData(state.user);
        } else if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        } else if (state is ProfileLoading) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar perfil'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _isLoading ? null : _handleSave,
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfilePictureSection(),
            const SizedBox(height: 32),
            _buildInfoSection('Informações básicas'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nome de usuário',
                prefixIcon: Icon(Icons.alternate_email),
                helperText: 'Seu nome de usuário único no Look4Me',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um nome de usuário';
                }
                if (value.contains(' ')) {
                  return 'O nome de usuário não pode conter espaços';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              maxLength: 150,
              decoration: const InputDecoration(
                labelText: 'Bio',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.info_outline),
                helperText: 'Conte um pouco sobre você e seus interesses de moda',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Localização',
                prefixIcon: Icon(Icons.location_on_outlined),
                helperText: 'Cidade/Estado onde você mora',
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoSection('Informações de contato'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.email_outlined),
                helperText: 'E-mail usado para login (não pode ser alterado)',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefone (opcional)',
                prefixIcon: Icon(Icons.phone_outlined),
                helperText: 'Seu número não será visível para outros usuários',
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoSection('Preferências'),
            const SizedBox(height: 16),
            _buildPreferencesTile(
              title: 'Categorias favoritas',
              subtitle: _selectedCategories.isEmpty
                  ? 'Selecione suas categorias de moda favoritas'
                  : _selectedCategories.join(', '),
              icon: Icons.category_outlined,
              onTap: _showCategoriesDialog,
            ),
            _buildPreferencesTile(
              title: 'Marcas favoritas',
              subtitle: _favoriteBrands.isEmpty
                  ? 'Adicione suas marcas favoritas'
                  : _favoriteBrands.join(', '),
              icon: Icons.shopping_bag_outlined,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Marcas favoritas',
                      style: TextStyles.heading3,
                    ),
                    content: TextField(
                      controller: _brandsController,
                      decoration: const InputDecoration(
                        hintText: 'Zara, H&M, Dior, Nike...',
                        helperText: 'Separe as marcas por vírgulas',
                      ),
                      maxLines: 3,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final brands = _brandsController.text
                              .split(',')
                              .map((brand) => brand.trim())
                              .where((brand) => brand.isNotEmpty)
                              .toList();

                          setState(() {
                            _favoriteBrands = brands;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Salvar',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            _buildPreferencesTile(
              title: 'Estilo pessoal',
              subtitle: _selectedFashionStyle ?? 'Selecione seu estilo de moda',
              icon: Icons.style_outlined,
              onTap: _showStylesDialog,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Salvar alterações',
              isGradient: true,
              isLoading: _isLoading,
              onPressed: _handleSave,
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancelar',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!) as ImageProvider
                    : _currentPhotoUrl != null
                    ? NetworkImage(_currentPhotoUrl!)
                    : null,
                child: _imageFile == null && _currentPhotoUrl == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _showImageSourceDialog,
            icon: const Icon(Icons.photo_library, size: 18),
            label: const Text('Alterar foto de perfil'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.heading3.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 4),
        const Divider(),
      ],
    );
  }

  Widget _buildPreferencesTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
        ),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}

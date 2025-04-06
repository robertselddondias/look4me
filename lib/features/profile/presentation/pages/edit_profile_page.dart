// lib/features/profile/presentation/pages/edit_profile_page.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/app_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Maria Silva');
  final _usernameController = TextEditingController(text: 'maria_style');
  final _bioController = TextEditingController(
    text: 'Apaixonada por moda e combinações de roupas. Sempre em busca do look perfeito para cada ocasião.',
  );
  final _emailController = TextEditingController(text: 'maria@example.com');
  final _phoneController = TextEditingController(text: '(11) 98765-4321');

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simular atualização do perfil
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          : SingleChildScrollView(
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
              const SizedBox(height: 24),
              _buildInfoSection('Informações de contato'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor, insira um e-mail válido';
                  }
                  return null;
                },
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
                subtitle: 'Casual, Trabalho, Festa',
                icon: Icons.category_outlined,
                onTap: () {
                  // Navegar para seleção de categorias favoritas
                },
              ),
              _buildPreferencesTile(
                title: 'Marcas favoritas',
                subtitle: 'Zara, H&M, Forever 21',
                icon: Icons.shopping_bag_outlined,
                onTap: () {
                  // Navegar para seleção de marcas favoritas
                },
              ),
              _buildPreferencesTile(
                title: 'Estilo pessoal',
                subtitle: 'Moderno, Casual chique, Minimalista',
                icon: Icons.style_outlined,
                onTap: () {
                  // Navegar para seleção de estilo pessoal
                },
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
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    _showImageSourceDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              _showImageSourceDialog();
            },
            icon: const Icon(Icons.photo_library, size: 16),
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
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
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
              // Lógica para abrir a câmera
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
              // Lógica para abrir a galeria
            },
          ),
          if (_nameController.text.isNotEmpty)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.1),
                child: Icon(
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
                // Lógica para remover a foto atual
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

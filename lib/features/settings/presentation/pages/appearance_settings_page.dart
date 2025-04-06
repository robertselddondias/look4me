import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  ThemeMode _currentThemeMode = ThemeMode.light;
  Color _selectedAccentColor = AppColors.primary;

  final List<Color> _accentColors = [
    AppColors.primary,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.pink,
  ];

  final List<Map<String, dynamic>> _fontSizes = [
    {'name': 'Pequeno', 'scale': 0.8},
    {'name': 'Normal', 'scale': 1.0},
    {'name': 'Grande', 'scale': 1.2},
    {'name': 'Muito Grande', 'scale': 1.4},
  ];

  double _currentFontScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aparência'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Tema'),
          _buildThemeModeSection(),
          _buildSectionHeader('Cor de Destaque'),
          _buildAccentColorGrid(),
          _buildSectionHeader('Tamanho da Fonte'),
          _buildFontSizeSection(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyles.heading3.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _buildThemeModeSection() {
    return Column(
      children: [
        RadioListTile<ThemeMode>(
          title: Text(
            'Claro',
            style: TextStyles.bodyLarge,
          ),
          subtitle: Text(
            'Interface brilhante para ambientes bem iluminados',
            style: TextStyles.bodySmall,
          ),
          value: ThemeMode.light,
          groupValue: _currentThemeMode,
          activeColor: AppColors.primary,
          onChanged: (ThemeMode? value) {
            setState(() {
              _currentThemeMode = value!;
            });
          },
        ),
        RadioListTile<ThemeMode>(
          title: Text(
            'Escuro',
            style: TextStyles.bodyLarge,
          ),
          subtitle: Text(
            'Interface escura para reduzir o brilho',
            style: TextStyles.bodySmall,
          ),
          value: ThemeMode.dark,
          groupValue: _currentThemeMode,
          activeColor: AppColors.primary,
          onChanged: (ThemeMode? value) {
            setState(() {
              _currentThemeMode = value!;
            });
          },
        ),
        RadioListTile<ThemeMode>(
          title: Text(
            'Sistema',
            style: TextStyles.bodyLarge,
          ),
          subtitle: Text(
            'Usar configurações do sistema',
            style: TextStyles.bodySmall,
          ),
          value: ThemeMode.system,
          groupValue: _currentThemeMode,
          activeColor: AppColors.primary,
          onChanged: (ThemeMode? value) {
            setState(() {
              _currentThemeMode = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAccentColorGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: _accentColors.map((color) {
          final isSelected = color == _selectedAccentColor;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedAccentColor = color;
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                  color: Colors.white,
                  width: 4,
                )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isSelected
                  ? const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              )
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFontSizeSection() {
    return Column(
      children: _fontSizes.map((fontSize) {
        final isSelected = fontSize['scale'] == _currentFontScale;
        return RadioListTile(
          title: Text(
            fontSize['name'],
            style: TextStyles.bodyLarge,
          ),
          subtitle: Text(
            'Tamanho de fonte ${fontSize['name'].toLowerCase()}',
            style: TextStyles.bodySmall,
          ),
          value: fontSize['scale'],
          groupValue: _currentFontScale,
          activeColor: AppColors.primary,
          onChanged: (value) {
            setState(() {
              _currentFontScale = value;
            });
          },
        );
      }).toList(),
    );
  }
}

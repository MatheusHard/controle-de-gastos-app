import 'package:flutter/material.dart';
import '../../../core/theme/styles/app_text_styles.dart';
import 'custom_color_picker.dart';

class ListTileThemeGradients extends StatelessWidget {
  final List<MapEntry<String, Gradient>> gradients;
  final int selectedIndex;
  final ValueChanged<int> onGradientSelected;
  final Color? customColor;
  final ValueChanged<Color> onColorSelected;

  const ListTileThemeGradients({
    super.key,
    required this.gradients,
    required this.selectedIndex,
    required this.onGradientSelected,
    required this.customColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      child: ExpansionTile(
        title: Text(
          'Cores disponíveis',
          style: AppTextStyles.textoSentimentoNegritoWhite(27, context),
        ),
        children: [
          SizedBox(
            height: 300,
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: gradients.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                mainAxisExtent: 110,
              ),
              itemBuilder: (context, index) {
                final gradient = gradients[index];
                final isSelected = selectedIndex == index;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    onGradientSelected(index);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 34,
                        child: Center(
                          child: Text(
                            gradient.key,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient.value,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(color: Colors.green, width: 3)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          CustomColorPicker(
            selectedColor: customColor,
            onColorSelected: onColorSelected,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/styles/app_text_styles.dart';

class ListTileThemeGradients extends StatelessWidget {
  final List<Gradient> gradients;
  final int selectedIndex;
  final ValueChanged<int> onGradientSelected;

  const ListTileThemeGradients({
    super.key,
    required this.gradients,
    required this.selectedIndex,
    required this.onGradientSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: ExpansionTile(
        title: Text(
          'Cores disponíveis',
          style: AppTextStyles.textoSentimentoNegritoWhite(
            27,
            context,
          ),
        ),
        children: [
          SizedBox(
            height: 300,
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: gradients.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final gradient = gradients[index];
                final isSelected = selectedIndex == index;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    onGradientSelected(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: Colors.green,
                              width: 3,
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


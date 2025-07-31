import 'package:final_project/core/widgets/custom_appbar.dart';
import 'package:final_project/core/widgets/custom_card.dart';
import 'package:final_project/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favourites_cubit.dart';
import '../cubit/favourites_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        titleText: 'My Favorites',
        leftIcon: Icons.arrow_back_ios_new,
        onLeftIconPressed: () => Navigator.of(context).pop(),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.favoriteProducts.isEmpty) {
            return const Center(
              child: CustomText(
                text: 'You haven\'t added any favorites yet!',
                fontSize: 18,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: state.favoriteProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final product = state.favoriteProducts[index];
                return CustomCard(
                  model: product,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

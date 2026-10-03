import 'package:domain/domain.dart';
import 'package:favorites/favorites.dart';
import 'package:flutter/widgets.dart';

/// Fills every feature's `FavoriteButtonBuilder` slot with the favorites
/// feature's button. The one place where two features meet.
Widget favoriteButtonSlot(BuildContext context, Movie movie, double size) =>
    FavoriteButton(movie: movie, size: size);

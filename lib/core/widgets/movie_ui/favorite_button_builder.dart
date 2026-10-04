import 'package:cine_vault/domain/domain.dart';
import 'package:flutter/widgets.dart';

/// Builds the favorite toggle for a movie at the given icon size.
///
/// Features take one of these instead of depending on the favorites feature;
/// the navigation layer fills it with the real button.
typedef FavoriteButtonBuilder = Widget Function(BuildContext context, Movie movie, double size);

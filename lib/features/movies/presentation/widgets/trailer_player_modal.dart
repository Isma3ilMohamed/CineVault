import 'dart:async';

import 'package:cine_vault/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Studios often disable embedding and some iframe errors never reach the stream,
/// so a 6s no-playback timeout also triggers the open-in-YouTube fallback.
class TrailerPlayerModal extends StatefulWidget {
  const TrailerPlayerModal({required this.videoKey, required this.title, super.key});
  final String videoKey;
  final String title;

  @override
  State<TrailerPlayerModal> createState() => _TrailerPlayerModalState();
}

class _TrailerPlayerModalState extends State<TrailerPlayerModal> {
  late final YoutubePlayerController _controller;
  StreamSubscription<YoutubePlayerValue>? _sub;
  Timer? _startTimeout;
  bool _embedFailed = false;
  bool _hasStartedPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoKey,
      autoPlay: true,
      params: const YoutubePlayerParams(showFullscreenButton: true, strictRelatedVideos: true),
    );

    _sub = _controller.stream.listen(_onPlayerState);

    _startTimeout = Timer(const Duration(seconds: 6), () {
      if (!_hasStartedPlaying) _setEmbedFailed();
    });
  }

  void _onPlayerState(YoutubePlayerValue value) {
    if (value.playerState == PlayerState.playing && !_hasStartedPlaying) {
      _hasStartedPlaying = true;
      _startTimeout?.cancel();
    }
    if (value.error != YoutubeError.none) {
      _setEmbedFailed();
    }
  }

  void _setEmbedFailed() {
    if (!mounted || _embedFailed) return;
    setState(() => _embedFailed = true);
  }

  @override
  void dispose() {
    _startTimeout?.cancel();
    unawaited(_sub?.cancel());
    unawaited(_controller.close());
    super.dispose();
  }

  Future<void> _openInYouTube() async {
    final uri = Uri.parse('https://www.youtube.com/watch?v=${widget.videoKey}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
                  tooltip: l10n.openInYouTube,
                  onPressed: _openInYouTube,
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: _embedFailed
                    ? _EmbedFailedFallback(onOpen: _openInYouTube)
                    : AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubePlayer(controller: _controller),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmbedFailedFallback extends StatelessWidget {
  const _EmbedFailedFallback({required this.onOpen});
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_disabled_rounded, size: 72, color: Colors.white38),
          const SizedBox(height: 16),
          Text(
            l10n.trailerEmbedUnavailable,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onOpen,
            icon: const Icon(Icons.open_in_new_rounded),
            label: Text(l10n.openInYouTube),
          ),
        ],
      ),
    );
  }
}

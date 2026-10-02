import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../l10n/generated/app_localizations.dart';

/// ببساطة كدا: modal fullscreen بيعرض YouTube trailer
///
/// تحديات الـ YouTube embedding:
///   - studios كتير بيعطلوا "Allow embedding" على الـ trailers بتاعتهم
///   - الـ iframe API بيرمي error codes: 101 / 150 / 152
///   - بعض الـ errors مش بتوصل على الـ stream
///
/// الحل:
///   1. `origin` param → بيفيد في بعض الـ embedding errors
///   2. listener للـ error stream → لو error ظاهر، نـ swap للـ fallback
///   3. timeout 6s → لو الـ player ما دخلش `playing` state، نـ swap برضو
///   4. زر external دائم في الـ header — المستخدم يقدر يخرج لـ YouTube في أي وقت
class TrailerPlayerModal extends StatefulWidget {
  final String videoKey;
  final String title;

  const TrailerPlayerModal({
    super.key,
    required this.videoKey,
    required this.title,
  });

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
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        // origin بيفيد في بعض الـ embedding cases
        origin: 'https://www.youtube.com',
      ),
    );

    _sub = _controller.stream.listen(_onPlayerState);

    // Safety net: لو الـ player ما بدأش يشغل خلال 6 ثواني، نعتبره failed
    _startTimeout = Timer(const Duration(seconds: 6), () {
      if (!_hasStartedPlaying) _setEmbedFailed();
    });
  }

  void _onPlayerState(YoutubePlayerValue value) {
    // بمجرد ما playback يبدأ، بنلغي الـ timeout
    if (value.playerState == PlayerState.playing && !_hasStartedPlaying) {
      _hasStartedPlaying = true;
      _startTimeout?.cancel();
    }
    // Explicit error من الـ iframe
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
    _sub?.cancel();
    _controller.close();
    super.dispose();
  }

  Future<void> _openInYouTube() async {
    final uri = Uri.parse(
      'https://www.youtube.com/watch?v=${widget.videoKey}',
    );
    // externalApplication بيفتح YouTube app لو متثبت، YouTube web لو لأ
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
                  icon: const Icon(
                    Icons.open_in_new_rounded,
                    color: Colors.white,
                  ),
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

/// UI بديل لما YouTube يمنع embedding
class _EmbedFailedFallback extends StatelessWidget {
  final VoidCallback onOpen;

  const _EmbedFailedFallback({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.play_disabled_rounded,
            size: 72,
            color: Colors.white38,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.trailerEmbedUnavailable,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
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

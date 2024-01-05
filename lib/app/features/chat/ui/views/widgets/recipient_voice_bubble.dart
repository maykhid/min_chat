import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/app/features/chat/ui/views/widgets/message_button.dart';
import 'package:min_chat/core/utils/datetime_x.dart';
import 'package:min_chat/core/utils/sized_context.dart';

class RecipientVoiceBubble extends StatefulWidget {
  const RecipientVoiceBubble({
    required this.message,
    super.key,
  });

  final Message message;

  @override
  State<RecipientVoiceBubble> createState() => _RecipientVoiceBubbleState();
}

class _RecipientVoiceBubbleState extends State<RecipientVoiceBubble> {
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  late Message message;

  void _playPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _audioPlayer.play(UrlSource(message.url!));
      setState(() {
        _isPlaying = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    message = widget.message;

    // Add a listener to track changes in player state
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        // Audio has completed, reset the playback position to start
        _audioPlayer.seek(Duration.zero);
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      }
    });

    // Listen for changes in audio duration
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });

    // Listen for changes in audio position
    _audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    // _audioPlayer.onPlayerComplete.listen((_) {
    //   if (mounted) {
    //     // setState(() {
    //       // _duration = Duration.zero;
    //     // });
    //   }
    // });
  }

  @override
  void didChangeDependencies() {
    message = widget.message;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  BoxDecoration get _recipientVoiceBoxDecoration => const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(8),
          bottomEnd: Radius.circular(8),
          bottomStart: Radius.circular(8),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 200,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
        decoration: _recipientVoiceBoxDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // if (message.status == sentStatusFlag ||
                //     message.url != null) ...[
                  CustomCircularIconButton(
                    icon: _isPlaying ? Icons.pause : Icons.play_arrow,
                    onPressed: _playPause,
                  ),
                  SizedBox(
                    width: context.width * 0.3,
                    child: ProgressBar(
                      progress: _position,
                      barHeight: 2,
                      buffered: const Duration(milliseconds: 2000),
                      total: _duration,
                      progressBarColor: Colors.black,
                      baseBarColor: Colors.white.withOpacity(0.24),
                      bufferedBarColor: Colors.white.withOpacity(0.24),
                      thumbColor: Colors.black,
                      thumbRadius: 4,
                      timeLabelType: TimeLabelType.totalTime,
                      timeLabelLocation: TimeLabelLocation.none,
                      timeLabelTextStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      onSeek: _audioPlayer.seek,
                    ),
                  ),
                // ],

                // else ...[
                //   const CupertinoActivityIndicator(
                //     color: Colors.grey,
                //   ),
                //   SizedBox(
                //     width: context.width * 0.3,
                //     child: const LinearProgressIndicator(
                //       minHeight: 2,
                //       color: Colors.grey,
                //     ),
                //   ),
                // ],
              ],
            ),
            const Gap(4),
            Text(
              message.timestamp!.formatToTime,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

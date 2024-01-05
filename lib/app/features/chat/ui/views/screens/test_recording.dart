import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_chat/app/features/chat/ui/cubits/voice_note_cubit/voice_note_cubit.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: RecordingScreen(),
//     );
//   }
// }

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool _isRecording = false;
  bool _isPlaying = false;
  // String? path;

  // @override
  // void initState() {
  //   _recorder = context.read<VoiceNoteCubit>();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   // _recorder.disposeResources();
  //   _recorder.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VoiceNoteCubit(),
      child: BlocBuilder<VoiceNoteCubit, VoiceNoteState>(
        builder: (context, state) {
          return BlocListener<VoiceNoteCubit, VoiceNoteState>(
            listener: (context, state) {
              if (state is RecordingState) {
                _isRecording = true;
              } else if (state is PlaybackState) {
                _isPlaying = true;
                // path = state.;
              } else if (state is PlaybackStoppedState ||
                  state is PlaybackCompleteState) {
                _isPlaying = false;
              } else if (state is StoppedState) {
                // path = state.path;
                _isRecording = false;
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Sound Recorder'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (_isRecording)
                      const Text('Recording...')
                    else
                      ElevatedButton(
                        onPressed: () =>
                            startRecording(context.read<VoiceNoteCubit>()),
                        child: const Text('Start Recording'),
                      ),
                    const SizedBox(height: 16),
                    if (_isRecording)
                      ElevatedButton(
                        onPressed: () =>
                            stopRecording(context.read<VoiceNoteCubit>()),
                        child: const Text('Stop Recording'),
                      )
                    else
                      _isPlaying
                          ? ElevatedButton(
                              onPressed: () =>
                                  stopPlayback(context.read<VoiceNoteCubit>()),
                              child: const Text('Stop Playback'),
                            )
                          : ElevatedButton(
                              onPressed: () =>
                                  startPlayback(context.read<VoiceNoteCubit>()),
                              child: const Text('Start Playback'),
                            ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void startRecording(VoiceNoteCubit recorder) {
  recorder.startRecording();
  // setState(() {
  //   _isRecording = true;
  // });
}

void stopRecording(VoiceNoteCubit recorder) {
  recorder.stopRecording();
  // setState(() {
  //   _isRecording = false;
  // });
}

void startPlayback(VoiceNoteCubit recorder) {
  // print(recorder.state.path);

  recorder.playback();

  // setState(() {
  //   _isPlaying = true;
  // });
}

void stopPlayback(VoiceNoteCubit recorder) {
  recorder.stopPlayback();
  // setState(() {
  //   _isPlaying = false;
  // });
}

void pausePlayback(VoiceNoteCubit recorder) {
  recorder.pausePlayback();
  // setState(() {
  //   _isPlaying = false;
  // });
}

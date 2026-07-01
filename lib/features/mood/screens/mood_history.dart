import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zen/features/mood/services/mood_serv.dart';
import 'package:zen/core/components/topbar.dart';
import 'package:zen/core/theme/theme.dart';
import 'package:zen/core/theme/appclrs_serv.dart';
import 'package:zen/core/consts/moodlist.dart';
import 'package:zen/core/components/loading_anims.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MoodHistoryPage extends ConsumerWidget {
  const MoodHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodLogsAsync = ref.watch(moodLogsProvider);
    final colors = ref.watch(appColorsProvider);

    return Scaffold(
      body: moodLogsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return Padding(
              padding: pagePaddingWithScore,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopBar(),
                  Text(
                    "Mood Logs",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          reversedMoodList["Empty"]!,
                          height: 150,
                          width: 150,
                          frameRate: FrameRate(30),
                          renderCache: RenderCache.raster,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No mood logs found yet.\nTrack your first mood!",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 100),
            itemCount: logs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(26, 0, 26, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TopBar(),
                      Text(
                        "Mood Logs",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                );
              } else {
                final log = logs[index - 1];
                final dateStr = DateFormat('MMMM d, y').format(log.updatedOn);
                final timeStr = DateFormat('h:mm a').format(log.updatedOn);
                final lottieAsset = reversedMoodList[log.mood] ?? reversedMoodList["Neutral"]!;

                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.pillClr,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    children: [
                      Lottie.asset(
                        lottieAsset,
                        height: 70,
                        width: 70,
                        frameRate: FrameRate(30),
                        renderCache: RenderCache.raster,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.mood,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$dateStr at $timeStr",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        },
        loading: () => Center(
          child: showRunningIndicator(context, "Fetching mood history..."),
        ),
        error: (error, stackTrace) => Padding(
          padding: pagePaddingWithScore,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              Text(
                "Error loading logs",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const PlayVerseApp());

class PlayVerseApp extends StatefulWidget {
  const PlayVerseApp({super.key});
  @override
  State<PlayVerseApp> createState() => _PlayVerseAppState();
}

class _PlayVerseAppState extends State<PlayVerseApp> {
  int points = 0;

  void addPoints(int value) => setState(() => points += value);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayVerse',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6558E8)),
        scaffoldBackgroundColor: const Color(0xFFF6F5FF),
      ),
      home: HomeScreen(points: points, onReward: addPoints),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final int points;
  final ValueChanged<int> onReward;
  const HomeScreen({super.key, required this.points, required this.onReward});

  @override
  Widget build(BuildContext context) {
    final games = [
      _GameInfo('Quick Quiz', 'Answer questions and earn points', Icons.quiz_rounded, const Color(0xFFE7E2FF), const QuizGame()),
      _GameInfo('Tic-Tac-Toe', 'Play a classic mini game', Icons.grid_3x3_rounded, const Color(0xFFDDF5F0), const TicTacToeGame()),
      _GameInfo('Memory Match', 'Find matching pairs', Icons.extension_rounded, const Color(0xFFFFEACF), const MemoryGame()),
      _GameInfo('Tap Challenge', 'Test your tapping speed', Icons.touch_app_rounded, const Color(0xFFFFDFE8), const TapGame()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PlayVerse', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Chip(
                avatar: const Icon(Icons.stars_rounded, color: Color(0xFF8A6500)),
                label: Text('$points pts', style: const TextStyle(fontWeight: FontWeight.bold)),
                backgroundColor: const Color(0xFFFFE8A3),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6558E8), Color(0xFF9B69E8)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('WELCOME TO PLAYVERSE', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                SizedBox(height: 10),
                Text('Play more.\\nHave more fun.', style: TextStyle(color: Colors.white, fontSize: 29, height: 1.1, fontWeight: FontWeight.w900)),
                SizedBox(height: 8),
                Text('Choose a game and collect points.', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Choose a game', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              Text('${games.length} games', style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 12),
          ...games.map((game) => Card(
            elevation: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              leading: CircleAvatar(radius: 25, backgroundColor: game.color, child: Icon(game.icon, color: const Color(0xFF39305F))),
              title: Text(game.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(game.subtitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GameShell(
                title: game.title,
                child: game.page,
                onReward: onReward,
              ))),
            ),
          )),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: const Color(0xFFFFF4D6),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.card_giftcard_rounded, color: Color(0xFF8A6500), size: 30),
                  SizedBox(width: 12),
                  Expanded(child: Text('Rewards are coming soon. Points in this demo are for fun and have no cash value.', style: TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameInfo {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final Widget page;
  _GameInfo(this.title, this.subtitle, this.icon, this.color, this.page);
}

class GameShell extends StatelessWidget {
  final String title;
  final Widget child;
  final ValueChanged<int> onReward;
  const GameShell({super.key, required this.title, required this.child, required this.onReward});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Padding(padding: const EdgeInsets.all(18), child: child),
  );
}

class QuizGame extends StatefulWidget {
  const QuizGame({super.key});
  @override
  State<QuizGame> createState() => _QuizGameState();
}
class _QuizGameState extends State<QuizGame> {
  int index = 0, score = 0;
  bool finished = false;
  final questions = const [
    ['Which planet is known as the Red Planet?', ['Earth', 'Mars', 'Venus'], 1],
    ['How many days are there in a leap year?', ['365', '366', '364'], 1],
    ['Which animal is known for its black and white stripes?', ['Tiger', 'Zebra', 'Panda'], 1],
  ];
  void answer(int choice) {
    if (choice == questions[index][2]) score++;
    setState(() {
      if (index == questions.length - 1) {
        finished = true;
      } else {
        index++;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if (finished) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.emoji_events_rounded, size: 64, color: Colors.amber),
      const Text('Quiz complete!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      Text('Your score: $score / ${questions.length}'),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: () => setState(() { index = 0; score = 0; finished = false; }), child: const Text('Play again')),
    ]));
    final q = questions[index];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('Question ${index + 1} of ${questions.length}', style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
      const SizedBox(height: 18),
      Text(q[0] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      ...(q[1] as List<String>).asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: OutlinedButton(onPressed: () => answer(e.key), child: Padding(padding: const EdgeInsets.all(12), child: Text(e.value))),
      )),
    ]);
  }
}

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});
  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}
class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> cells = List.filled(9, '');
  String turn = 'X';
  String? winner;
  bool get draw => winner == null && cells.every((e) => e.isNotEmpty);
  final lines = const [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]];
  void play(int i) {
    if (cells[i].isNotEmpty || winner != null) return;
    setState(() {
      cells[i] = turn;
      for (final line in lines) {
        if (cells[line[0]].isNotEmpty && cells[line[0]] == cells[line[1]] && cells[line[1]] == cells[line[2]]) winner = turn;
      }
      turn = turn == 'X' ? 'O' : 'X';
    });
  }
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(winner != null ? '$winner wins!' : draw ? 'It is a draw!' : 'Turn: $turn', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const SizedBox(height: 18),
    AspectRatio(aspectRatio: 1, child: GridView.builder(
      itemCount: 9, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemBuilder: (_, i) => InkWell(
        onTap: () => play(i),
        child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Center(child: Text(cells[i], style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Color(0xFF6558E8))))),
      ),
    )),
    const SizedBox(height: 18),
    ElevatedButton(onPressed: () => setState(() { cells = List.filled(9, ''); turn = 'X'; winner = null; }), child: const Text('Restart')),
  ]);
}

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});
  @override
  State<MemoryGame> createState() => _MemoryGameState();
}
class _MemoryGameState extends State<MemoryGame> {
  final symbols = ['🍎','🚀','🐼','⚽','🌈','🎸'];
  late List<String> cards;
  final opened = <int>[];
  final matched = <int>{};
  bool locked = false;
  @override
  void initState() { super.initState(); reset(); }
  void reset() {
    cards = [...symbols, ...symbols]..shuffle(Random());
    opened.clear(); matched.clear(); locked = false;
    setState(() {});
  }
  Future<void> flip(int i) async {
    if (locked || matched.contains(i) || opened.contains(i)) return;
    setState(() => opened.add(i));
    if (opened.length == 2) {
      locked = true;
      await Future.delayed(const Duration(milliseconds: 650));
      if (cards[opened[0]] == cards[opened[1]]) matched.addAll(opened);
      setState(() => opened.clear());
      locked = false;
    }
  }
  @override
  Widget build(BuildContext context) => Column(children: [
    Text('Matches: ${matched.length ~/ 2} / 6', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 14),
    Expanded(child: GridView.builder(
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemBuilder: (_, i) => InkWell(
        onTap: () => flip(i),
        child: Container(decoration: BoxDecoration(color: matched.contains(i) ? const Color(0xFFDDF5F0) : const Color(0xFFE7E2FF), borderRadius: BorderRadius.circular(16)),
          child: Center(child: Text(opened.contains(i) || matched.contains(i) ? cards[i] : '?', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)))),
      ),
    )),
    ElevatedButton(onPressed: reset, child: const Text('New game')),
  ]);
}

class TapGame extends StatefulWidget {
  const TapGame({super.key});
  @override
  State<TapGame> createState() => _TapGameState();
}
class _TapGameState extends State<TapGame> {
  int taps = 0;
  int seconds = 10;
  bool running = false;
  Timer? timer;
  void start() {
    timer?.cancel();
    setState(() { taps = 0; seconds = 10; running = true; });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds <= 1) {
        t.cancel();
        setState(() { seconds = 0; running = false; });
      } else {
        setState(() => seconds--);
      }
    });
  }
  @override
  void dispose() { timer?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text('Time left: $seconds s', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12),
    Text('$taps taps', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Color(0xFF6558E8))),
    const SizedBox(height: 18),
    FilledButton(onPressed: running ? () => setState(() => taps++) : null, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18), child: Text('TAP!', style: TextStyle(fontSize: 22)))),
    const SizedBox(height: 14),
    if (!running) ElevatedButton(onPressed: start, child: Text(seconds == 0 ? 'Try again' : 'Start 10-second challenge')),
  ]));
}

import 'dart:async';

import 'package:flappy_bird/barriers.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdY;

  static double barrierXone = 1;
  double barrierXtowe = barrierXone + 1.7;

  bool isBarrierOneSurpassed = false;
  bool isBarrierTwoSurpassed = false;

  int score = 0;

  GameState gameState = GameState.beforeStart;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdY;
    });
  }

  void startGame() {
    setState(() {
      gameState = GameState.start;
    });
    // [Timer.periodic]：特定の時間毎に処理を繰り返す
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 3 * time;
      setState(() {
        // 鳥を下に落とす
        birdY = initialHeight - height;

        // 障害物を移動させる
        // 障害物が画面外に出たら右側に移動させる
        if (barrierXone < -1.8) {
          barrierXone += 3.4;
          isBarrierOneSurpassed = false;
        } else {
          barrierXone -= 0.03;
        }
        if (barrierXtowe < -1.8) {
          barrierXtowe += 3.4;
          isBarrierTwoSurpassed = false;
        } else {
          barrierXtowe -= 0.03;
        }

        // 鳥が障害物を越えたらスコアを追加する
        if (barrierXone < 0 && !isBarrierOneSurpassed) {
          score += 1;
          isBarrierOneSurpassed = true;
        }
        if (barrierXtowe < 0 && !isBarrierTwoSurpassed) {
          score += 1;
          isBarrierTwoSurpassed = true;
        }
      });

      // 鳥が地面に落ちたらゲーム終了
      if (birdY > 1) {
        timer.cancel();
        setState(() {
          gameState = GameState.end;
        });
      }

      // TODO:障害物に当たった時の処理
    });
  }

  void replay() {
    setState(() {
      birdY = 0;
      time = 0;
      barrierXone = 1;
      barrierXtowe = barrierXone + 1.7;
      score = 0;

      isBarrierOneSurpassed = false;
      isBarrierOneSurpassed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (gameState) {
          case GameState.start:
            jump();
            break;
          case GameState.beforeStart:
            startGame();
            break;
          case GameState.end:
            replay();
            startGame();
            break;
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  _bird(birdY),
                  _barrier(200.0, false, barrierXone),
                  _barrier(150.0, true, barrierXone),
                  _barrier(130.0, false, barrierXtowe),
                  _barrier(250.0, true, barrierXtowe),
                  _explanatoryText(gameState),
                ],
              ),
            ),
            Container(height: 15, color: Colors.green[400]),
            Expanded(child: _scoreBoard(score.toString())),
          ],
        ),
      ),
    );
  }

  // 鳥 + プレイ画面
  Widget _bird(double birdY) {
    return AnimatedContainer(
      alignment: Alignment(0, birdY),
      duration: const Duration(microseconds: 0),
      color: Colors.blue[100],
      child: const MyBird(),
    );
  }

  // 障害物
  Widget _barrier(double size, bool isUpperSide, double xCoordinate) {
    return AnimatedContainer(
      alignment: Alignment(xCoordinate, isUpperSide ? -1.1 : 1.1),
      duration: const Duration(microseconds: 0),
      child: MyBarrier(size: size),
    );
  }

  // ゲーム開始前の説明文
  Widget _explanatoryText(GameState gameState) {
    return Visibility(
      visible: gameState == GameState.beforeStart || gameState == GameState.end,
      child: Container(
        alignment: const Alignment(0, -0.3),
        child: const Text(
          'T A P  T O  P L A Y',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  // スコアの表示
  Widget _scoreBoard(String score) {
    return Container(
      color: Colors.brown,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SCORE',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              score,
              style: const TextStyle(color: Colors.white, fontSize: 35),
            ),
          ],
        ),
      ),
    );
  }
}

enum GameState {
  beforeStart,
  start,
  end,
}

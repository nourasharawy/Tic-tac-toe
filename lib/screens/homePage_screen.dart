import 'package:flutter/material.dart';
import 'package:tictietoc/classes/game_logic.dart';

import '../sharedComponents.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = "";
  Game game = Game();
  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child:MediaQuery.of(context).orientation==Orientation.portrait? Column(
        children: [
          ...firstBlock(),
          buildExpanded(),
          ...lastBlock(),

        ],
      ): Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...firstBlock(),
                    ...lastBlock(),
                  ],
                ),
              ),
              buildExpanded(),
            ],
          )),
    );
  }
  List <Widget>firstBlock(){
    return[
      defaultPadding(
        padding: 16.0,
        widget: SwitchListTile.adaptive(
          title: defaultText(
              text: "Turn on/off 2 Players",
              color: Colors.white,
              fSize: 25),
          value: isSwitch,
          onChanged: (bool newValue) {
            setState(() {
              isSwitch = newValue;
            });
          },
        ),
      ),
      defaultPadding(
          padding: 10.0,
          widget: defaultText(
              text: "it's $activePlayer turn".toUpperCase(), fSize: 40))
    ];
  }
  Expanded buildExpanded() {
    return Expanded(
            child: GridView.count(
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1,
          crossAxisCount: 3,
          children: List.generate(
              9,
              (index) => InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: gameOver ? null : () => _onTap(index),
                    child: Container(
                      decoration: defaultDecoration(),
                      child: Center(
                        child: Player.playerX.contains(index)
                            ? defaultText(
                                text: 'X', color: Colors.blue, fSize: 40)
                            : Player.playerO.contains(index)
                                ? defaultText(
                                    text: 'O', color: Colors.pink, fSize: 40)
                                : Container(),
                      ),
                    ),
                  )),
        ));
  }
  List <Widget>lastBlock(){
    return [
      defaultPadding(
        padding: 100.0,
        widget: defaultText(text: result),
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            gameOver = false;
            turn = 0;
            result = " ";
          });
        },
        icon: const Icon(Icons.replay),
        label: Text("repeate the game"),
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(Theme.of(context).splashColor),
        ),
      )
    ];
}


  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateLogic();
    }

    if (!isSwitch && !gameOver && turn != 9) {
      await game.autoPlay(activePlayer);
      updateLogic();
    }
  }

  void updateLogic() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn++;

      String winnerPalyer = game.checkWinner();
      if (winnerPalyer != '') {
        gameOver = true;
        result = '$winnerPalyer is the winner';
      } else if (!gameOver && turn == 9) result = 'It\'s a Draw';
    });
  }
}

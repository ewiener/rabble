# rabble

This is a Ruby implementation of Scrabble(tm). It implements an algorithm for finding the best word,
and can run through a game with one or more computer-operated players taking turns,
each using the same algorihtm and dictionary.

Currently, it uses an exhaustive, greedy algorithm, always choosing the word with the highest point value given
the current rack and board.

In the future, it can be extended to apply heuristics to evaluate words in a smarter way, e.g. by considering
the letters that have already been played and simulating possible future hands. For example, currently the
algorithm will always play an S to pluralize a word in order to maximize the score, even if saving it for the
next round would likely increase the next round's score by much more than it increases the current round's score.
As another example, the current algorithm will happily play all U's as quickly as needed to maximize the score
rather than holding onto one in case a Q comes up soon.

## Playing a game

```
ruby -Ilib bin/rabble --help

Usage: rabble [options]
    -w, --word-file                  Path to dictionary, one word per line [dict/en/standard.txt]
    -n, --num-players=PLAYERS        Number of players [1]
    -p, --show-plays=yes|no          Show each play [NO]
    -b, --show-board=yes|no          Show the board after each play [NO]
    -h, --help                       Print this help
```

For example, to play a game with 2 plays, printing each play and board:

```
ruby -Ilib bin/rabble -n 2 -p yes -b yes
```

## Dictionaries

[See here for details on the dictionary used.](dict)

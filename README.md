# tabletop_lua

## scripting for dev

1 player:

    make run-src -- p1 hosts

2 players:

    make run-src -- p1 hosts & make run-src -- p2 &

3 players:

    make run-src -- p1 hosts & make run-src -- p2 & make run-src -- p3 &

4 players:

    make run-src -- p1 hosts & make run-src -- p2 & make run-src -- p3 & make run-src -- p4 &

test

    make run-src -- -t

## testing TODO

assert
http://olivinelabs.com/busted/
https://github.com/norman/telescope
https://github.com/silentbicycle/lunatest https://htmlpreview.github.io/?https://raw.githubusercontent.com/silentbicycle/lunatest/master/files/lunatest.html
https://github.com/stackmachine/lovetest

## TODO

- be careful about globals
  roster, board
- visibility areas
  - check networking works?
  - review zone assignment, could be optimized
  - zones can count cards or money
- start game can be hosted by anyone (export the board.populate function once everyone's here)
- card isTurned default to true
- visually represent remaining clients around board
- create 8x8 grid for checkers and chess
- create hex grid for abalone (maybe push sideways as well)
- create two sided pieces for reversi
- jogo da glória / snakes and ladders
- example judge to enforce/aid in adhering to rules of a game...
  - war?
  - go fish?
  - sueca?
  - blackjack
  - poker texas hold'em?
  - video poker

## Concept ideas:

the board is divided into cardinal-directions per player
(in a 2p game, one sits in N and other is S, etc.)

there are a set of areas that have tags: only i can see, all can see etc.
objects get attributed to each player and sit in their private space (ex their hand)
the player can move their objects and depending where they land, their visibility will be respected according to the area.

enforcing these rules can happen as server logic (events sent by user a get transformed to all listeners)
OR
there can be a silent judge that deals cards, corrects actions etc (this has the downside of players being able to see a state which shouldn't happen, ex player just dropped a card and it's incorrectly visible to all for x time?)

eventually objects have a visibility state from where they are and while the drag happens they remain with it until landing?

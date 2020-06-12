# tabletop_lua

## scripting for dev

1 player:

    make run-src -- p1

2 players:

    make run-src -- p1 & make run-src -- p2 p2@a.com 2 &

3 players:

    make run-src -- p1 & make run-src -- p2 p2@a.com 2 & make run-src -- p3 p3@a.com 4 &

4 players:

    make run-src -- p1 & make run-src -- p2 p2@a.com 2 & make run-src -- p3 p3@a.com 4 & make run-src -- p4 p4@a.com 5 &

## tests

these tests do some assertions and also save images to user dir

    make test

for now using [lunatest](https://github.com/silentbicycle/lunatest) which is very simple.
[docs](https://htmlpreview.github.io/?https://raw.githubusercontent.com)

moving to either:

- [luaunit](https://github.com/bluebird75/luaunit) [docs](https://luaunit.readthedocs.io/en/latest/)
- [lunit](https://github.com/mrothNET/lunit) [docs](https://mroth.net/lunit/documentation-0.4.txt)

## TODO

- confirm checkers layout is ok
- do chess layout
- make pieces on game board span into position

- visibility areas
  - zones can count cards or money
- lobby
  - support choosing color
  - allow choosing server settings (host, port, channel)
- be careful about globals: roster, userData, avatars, board

- create hex grid for abalone (maybe push sideways as well)

- jogo da glória / snakes and ladders - https://www.youtube.com/watch?v=xe9pMUuVwtk
- game setup for
  - sueca?
  - poker texas hold'em?
  - pictionary - https://randomwordgenerator.com/pictionary.php https://hobbylark.com/party-games/pictionary-words
  - checkers
  - chess?
- game judge for
  - snakes and ladders
  - go fish
- game bot for
  - go fish

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

## What is this?

Tabletop is a sandbox for you to play board and cards games with your friends.

You both share a virtual table and can manipulate cards, pieces, counters, dice etc.
Several games are supported and more underway.

Tabletop does not enforce the rules. It can set up the game layout for you and it's you
that do the actions by dragging and dropping items and performing contextual actions on selected items (ex: turn or rotate a card, roll a die, etc.). New items can be spawned as well.

There's a console for communicating to everyone and trigger commands.

## Currently supported games

- card games
  - go fish
  - sueca
- board games
  - checkers
  - chess

## The lobby

One starts at the lobby first to configure the avatar and other options.
Pick your username - that's how you will be named. The email address is used exclusively to generate an avatar (via gravatar) you don't even need to own it.
Choose a color as well and press continue to actually enter the room.

## Supported commands

The console can be made visible and dismissed with the TAB key. Valid commands start with slash and are:

`/help` - basic instructions

`/roster` - lists other users online

`/games` - lists supported games

`/start <game name>` - starts the game, if supported. if the number of players isn't met, command is ignored

Text not started by slash is not considered a command and is sent to other players to allow basic communication.

### starting a game

The players should meet online at the game room and when the required number of players is met, run `/start <game name>`.

Ex:

`/start go-fish` (2-4 players)  
`/start sueca` (4 players)  
`/start checkers` (2 players)  
`/start chess` (2 players)

If more people get in after the game starts they'll be able to spectate but won't be able to play.

## Interacting

### dragging and manipulating items

All items besides zones and boards can be manipulated - those are fixed in the table.

Dragging and dropping is the most common action. A single click/tap will display a contextual menu exposing actions you can perform on an item such as deleting it or specific ones (roll a die, turn a card, etc.)

### zones

The players will be positioned so that you occupy the bottom part of the table and any colored zones and items near you are for you to interact. Ex: in card games you will be given the amount of cards for you to start with, facing the table. As you drop them in your zone, they will be facing up for you but other players will still be seeing their backs.
You can reorder items inside your hand.
If you drag a card out of your hand,
as it leaves it will be faced up unless it lands on another zone such as another person's hand or the deck in the middle.

### boards

Boards have cells to aid positioning their pieces. Other than that they're dumb - several items can occupy the same cell.

### spawning new items

If you click/tap on the table a menu will be presented allowing you to instance a new item in that position. Most items require several parameters to be instantiated.

### other remarks

You're free to not start one of the supported games and layout something else, as long as you can make do with the features in the engine. We would love to know what you can accomplish so share your screen and give feedback on additional games/items. Will try to meet those based to popularity and simplicity of development.

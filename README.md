# LC3-Nim-Stone-Game-In-Assembly
My LC3 code for the two player stone game referred to as Nim written in Assembly Language.

The game board looks as follows:

ROW A: ooo

ROW B: ooooo

ROW C: oooooooo
<br><br>
The rules for the game are the following:
- Row A has 3 stones, Row B has 5 stones, and Row C has 8 stones
- The players take turns removing a certain amount of stones from the row of their choosing
- The player (whose turn it is) can remove any amount of stones from a singular row as long as there are that many stones available to remove
- The player who removes the very last stone is the loser and the other player is the winner 
<br><br>
- For example, when the it is Player 1's turn, they are prompted to make their move
- The format expected is "A3" meaning remove 3 stones from row A
- 3 stones will be removed from Row A in this case and then Player B will be prompted for their move
- If Player 1 removes the last stone (the board is now empty,) then Player 2 is declared the winner

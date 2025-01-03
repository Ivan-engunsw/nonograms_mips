# nonograms_mips
nonograms.c is an implementation of a program to play nonograms (also known as Picross).

A nonogram puzzle takes place on a 2D grid, where the player must mark a set of cells, according to number clues placed on the edge of the puzzle.

Each row and column contains a sequence of numbers which correspond to the correct lengths of consecutive runs of marked cells in that row/column. For example, the numbers 2 3 1 mean that row/column has a run of 2 marked cells, then 3 marked cells, then 1 marked cells, with gaps of at least one cell between them.

The m commands allows the player to mark, unmark or cross out (indicate that the cell should definitely be unmarked) a cell based on the row (lowercase letter) and column (uppercase letter).

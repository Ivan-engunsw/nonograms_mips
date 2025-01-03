########################################################################
# A program to play the nonograms game.
# This program was written by IVAN LUN HUI CHEN (z5557064)
# on 26/09/2024
#
########################################################################

#![tabsize(8)]

# ##########################################################
# ####################### Constants ########################
# ##########################################################

# C constants

TRUE = 1
FALSE = 0

MAX_WIDTH = 12
MAX_HEIGHT = 10

UNMARKED = 1
MARKED = 2
CROSSED_OUT = 3

# Other useful constants (feel free to add more if you want)

SIZEOF_CHAR = 1
SIZEOF_INT = 4

CLUE_SET_VERTICAL_CLUES_OFFSET = 0
CLUE_SET_HORIZONTAL_CLUES_OFFSET = CLUE_SET_VERTICAL_CLUES_OFFSET + SIZEOF_INT * MAX_WIDTH * MAX_HEIGHT
SIZEOF_CLUE_SET = CLUE_SET_HORIZONTAL_CLUES_OFFSET + SIZEOF_INT * MAX_HEIGHT * MAX_WIDTH

	.data
# ##########################################################
# #################### Global variables ####################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THESE         !!!
# !!! DEFINITIONS OR ANY OTHER PART OF THE DATA SEGMENT  !!!

width:					# int width;
	.word	0

height:					# int height;
	.word	0

selected:				# char selected[MAX_HEIGHT][MAX_WIDTH];
	.byte	0:MAX_HEIGHT*MAX_WIDTH

solution:				# char solution[MAX_HEIGHT][MAX_WIDTH];
	.byte	0:MAX_HEIGHT*MAX_WIDTH

	.align	2
selection_clues:			# struct clue_set selection_clues;
	.byte	0:SIZEOF_CLUE_SET

solution_clues:				# struct clue_set solution_clues;
	.byte	0:SIZEOF_CLUE_SET

displayed_clues:			# struct clue_set *displayed_clues;
	.word	0

# ##########################################################
# ######################### Strings ########################
# ##########################################################

# !!! DO NOT ADD, REMOVE, OR MODIFY ANY OF THE      !!!
# !!! STRINGS OR ANY OTHER PART OF THE DATA SEGMENT !!!

str__main__height:
	.asciiz	"height"
str__main__width:
	.asciiz	"width"
str__main__congrats:
	.asciiz	"Congrats, you won!\n"

str__prompt_for_dimension__enter_the:
	.asciiz	"Enter the "
str__prompt_for_dimension__colon:
	.asciiz	": "
str__prompt_for_dimension__too_small:
	.asciiz	"error: too small, the minimum "
str__prompt_for_dimension__is:
	.asciiz	" is "
str__prompt_for_dimension__too_big:
	.asciiz	"error: too big, the maximum "

str__read_solution__enter_solution:
	.asciiz	"Enter solution: "

str__read_solution__loaded:
	.asciiz	"Loaded "
str__read_solution__solution_coordinates:
	.asciiz	" solution coordinates\n"

str__make_move__enter_first_coord:
	.asciiz	"Enter first coord: "
str__make_move__enter_second_coord:
	.asciiz	"Enter second coord: "
str__make_move__bad_input:
	.asciiz	"Bad input, try again!\n"
str__make_move__enter_choice:
	.asciiz	"Enter choice (# to select, x to cross out, . to deselect): "

str__print_game__printing_selection:
	.asciiz	"[printing counts for current selection rather than solution clues]\n"

str__dump_game_state__width:
	.asciiz	"width = "
str__dump_game_state__height:
	.asciiz	", height = "
str__dump_game_state__selected:
	.asciiz	"selected:\n"
str__dump_game_state__solution:
	.asciiz	"solution:\n"
str__dump_game_state__clues_vertical:
	.asciiz	"displayed_clues vertical:\n"
str__dump_game_state__clues_horizontal:
	.asciiz	"displayed_clues horizontal:\n"

str__get_command__prompt:
	.asciiz	" >> "
str__get_command__bad_command:
	.asciiz	"Bad command\n"

# !!! Reminder to not not add to or modify any of the above !!!
# !!! strings or any other part of the data segment.        !!!
# !!! If you add more strings you will likely break the     !!!
# !!! autotests and automarking.                            !!!


############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################

################################################################################
#
# Implement the following functions, and check these boxes as you finish
# implementing each function.
#
#  SUBSET 1
#  - [ ] main
#  - [ ] prompt_for_dimension
#  - [ ] initialise_game
#  - [ ] game_loop
#  SUBSET 2
#  - [ ] decode_coordinate
#  - [ ] read_solution
#  - [ ] lookup_clue
#  - [ ] compute_all_clues
#  SUBSET 3
#  - [ ] make_move
#  - [ ] print_game
#  - [ ] compute_clue
#  - [ ] is_game_over
#  PROVIDED
#  - [X] get_command
#  - [X] dump_game_state


################################################################################
# .TEXT <print_welcome>
# This is the main function where we setup the game with the inputs given and starts the game.
        .text
main:
	# Subset:   1
	#
	# Frame:    [$ra]   <-- FILL THESE OUT!
	# Uses:     [$a0, $a1, $a2, $a3, $v0]
	# Clobbers: [$a0, $a1, $a2, $a3, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - 
	#
	# Structure:        <-- FILL THIS OUT!
	#   main
	#   -> [prologue]
	#     -> body
	#	-> prompt_for_dimension
	#	-> prompt_for_dimension
	#	-> initialise_game
	#	-> read_solution
	#	-> game_loop
	#   -> [epilogue]

main__prologue:
	begin						# move frame pointer
	push	$ra					# save $ra onto stack

main__body:
	la	$a0, str__main__height			# "height"
	li	$a1, 3					# 3 as min argument for prompt_for_dimension
	li	$a2, MAX_HEIGHT				# MAX_HEIGHT
	la	$a3, height				# &height
	jal	prompt_for_dimension			# prompt_for_dimension("height", 3, MAX_HEIGHT, &height);

	la	$a0, str__main__width			# "width"
	li	$a1, 3					# 3 as min argument for prompt_for_dimension
	li	$a2, MAX_WIDTH				# MAX_WIDTH
	la	$a3, width				# &width
	jal	prompt_for_dimension			# prompt_for_dimension("width", 3, MAX_WIDTH, &width);

	jal	initialise_game				# initialise_game();
	jal	read_solution				# read_solution();
	li	$v0, 11					# syscall 11 : print_character
	la	$a0, '\n'	
	syscall						# putchar('\n');

	jal	game_loop				# game_loop();

	li	$v0, 4					# syscall 4 : print_string
	la	$a0, str__main__congrats
	syscall						# printf("Congrats, you won!\n");

main__epilogue:
	pop	$ra					# recover $ra from stack
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# Asks the user to put in the game width/height and then writes the value to *pointer as height/width
        .text
prompt_for_dimension:
	# Subset:   1
	#
	# Frame:    []   <-- FILL THESE OUT!
	# Uses:     [$t0, $t1, $t2, $a0, $a1, $a2, $a3, $v0]
	# Clobbers: [$t0, $t1, $t2, $a0, $a1, $a2, $a3, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $t0: input
	#   - $t1: temporary register to store name argument
	#   - $t2: temporary register to store value of TRUE
	#
	# Structure:        <-- FILL THIS OUT!
	#   prompt_for_dimension
	#   -> [prologue]
	#     -> body
	#	-> prompt_for_dimension_input_while_loop_init
	#	-> prompt_for_dimension_input_while_loop_cond
	#	-> prompt_for_dimension_input_while_loop_body
	#	  -> prompt_for_dimension_input_smaller_than_min
	#	  -> prompt_for_dimension_input_bigger_than_max
	#	-> prompt_for_dimension_input_while_loop_step
	#	-> prompt_for_dimension_input_while_loop_end
	#   -> [epilogue]

prompt_for_dimension__prologue:
	begin						# move frame pointer

prompt_for_dimension__body:
	move	$t1, $a0				# char *t1 = name

prompt_for_dimension_input_while_loop_init:
	li	$t2, TRUE		

prompt_for_dimension_input_while_loop_cond:		# while (TRUE) {
	bne	$t2, TRUE, prompt_for_dimension_input_while_loop_end

prompt_for_dimension_input_while_loop_body:
	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__prompt_for_dimension__enter_the
	syscall						# printf("Enter the ");

	li	$v0, 4					# syscall 4: print_string
	move	$a0, $t1
	syscall						# printf("%s", name);

	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__prompt_for_dimension__colon
	syscall						# printf(": ");

	li	$v0, 5					# syscall 5: read_int
	syscall						#
	move	$t0, $v0				# scanf("%d", &input);

prompt_for_dimension_input_smaller_than_min:		# if (input < min) {
	bge	$t0, $a1, prompt_for_dimension_input_bigger_than_max
	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__prompt_for_dimension__too_small
	syscall						# printf("error: too small, the minimum ");

	li	$v0, 4					# syscall 4: print_string
	move	$a0, $t1				
	syscall						# printf("%s, name);

	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__prompt_for_dimension__is
	syscall						# printf(" is ");

	li	$v0, 1					# syscall 1: print_int
	move	$a0, $a1				
	syscall						# printf("%d", min);

	li	$v0, 11					# syscall 11: print_character
	la	$a0, '\n'			
	syscall						# printf("%c", '\n');

	b	prompt_for_dimension_input_while_loop_body
							# }

prompt_for_dimension_input_bigger_than_max:		# else if (input > max) {
	ble	$t0, $a2, prompt_for_dimension_input_while_loop_end
	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__prompt_for_dimension__too_big
	syscall						# printf("error: too big, the maximum ");

	li	$v0, 4					# syscall 4: print_string
	move	$a0, $t1				
	syscall						# printf("%s, name);

	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__prompt_for_dimension__is
	syscall						# printf(" is ");

	li	$v0, 1					# syscall 1: print_int
	move	$a0, $a2				
	syscall						# printf("%d", max);

	li	$v0, 11					# syscall 11: print_character
	la	$a0, '\n'			
	syscall						# printf("%c", '\n');

	b	prompt_for_dimension_input_while_loop_body
							# }

prompt_for_dimension_input_while_loop_step:
prompt_for_dimension_input_while_loop_end:		# }
	sw	$t0, ($a3)				# *pointer = input;

prompt_for_dimension__epilogue:
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# Initialise the game with both selected and solution tiles to be UNMARKED.
        .text
initialise_game:
	# Subset:   1
	#
	# Frame:    []   <-- FILL THESE OUT!
	# Uses:     [$t0, $t1, $t2, $t3, $t4, $t5, $v0]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $t5, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $t0: row
	#   - $t1: col
	#   - $t2: height
	#   - $t3: width
	#   - $t4: temporary register to store the position we want in the 2D array of selected/solution
	#   - $t5: UNMARKED
	#
	# Structure:        <-- FILL THIS OUT!
	#   initialise_game
	#   -> [prologue]
	#     -> body
	#	-> initialise_game_height_for_loop_init
	#	-> initialise_game_height_for_loop_cond
	#	-> initialise_game_height_for_loop_body
	#	  -> initialise_game_width_for_loop_init
	#	  -> initialise_game_width_for_loop_cond
	#	  -> initialise_game_width_for_loop_body
	#	  -> initialise_game_width_for_loop_step
	#	  -> initialise_game_width_for_loop_end
	#	-> initialise_game_height_for_loop_step
	#	-> initialise_game_height_for_loop_end
	#   -> [epilogue]

initialise_game__prologue:
	begin						# move frame pointer

initialise_game__body:
initialise_game_height_for_loop_init:
	li	$t0, 0					# int row = 0;
	lw	$t2, height

initialise_game_height_for_loop_cond:			# while (row < height) {
	bge	$t0, $t2, initialise_game_height_for_loop_end

initialise_game_height_for_loop_body:
initialise_game_width_for_loop_init:
	li	$t1, 0					# int col = 0;
	lw	$t3, width

initialise_game_width_for_loop_cond:			# while (col < width) {
	bge	$t1, $t3, initialise_game_width_for_loop_end

initialise_game_width_for_loop_body:
	li	$t4, MAX_WIDTH
	mul	$t4, $t4, $t0				# (row * MAX_WIDTH)
	add	$t4, $t4, $t1				# offset = (row * MAX_WIDTH) + col
	li	$t5, UNMARKED
	sb	$t5, selected($t4)			# selected[row][col] = UNMARKED;
	sb	$t5, solution($t4)			# solution[row][col] = UNMARKED;

initialise_game_width_for_loop_step:
	addi	$t1, 1					# col++;
	b	initialise_game_width_for_loop_cond

initialise_game_width_for_loop_end:			# }
initialise_game_height_for_loop_step:
	addi	$t0, 1					# row++;
	b	initialise_game_height_for_loop_cond

initialise_game_height_for_loop_end:			# }
initialise_game__epilogue:
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# The game continuously runs until the game is over. It repeatedly prints the game with the selected tiles,
# receives a command and recomputes all the clues.
        .text
game_loop:
	# Subset:   1
	#
	# Frame:    [$ra]   <-- FILL THESE OUT!
	# Uses:     [$a0, $a1, $v0]
	# Clobbers: [$a0, $a1, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - 
	#
	# Structure:        <-- FILL THIS OUT!
	#   game_loop
	#   -> [prologue]
	#     -> body
	#	-> game_loop_game_not_over_while_loop_init
	#	-> game_loop_game_not_over_while_loop_cond
	#	  -> is_game_over
	#	-> game_loop_game_not_over_while_loop_body
	#	  -> print_game
	#	  -> get_command
	#	  -> compute_all_clues
	#	-> game_loop_game_not_over_while_loop_step
	#	-> game_loop_game_not_over_while_loop_end
	#   -> [epilogue]

game_loop__prologue:
	begin						# move frame pointer
	push	$ra					# save $ra onto stack

game_loop__body:
game_loop_game_not_over_while_loop_init:
game_loop_game_not_over_while_loop_cond:		# while (!is_game_over()) {
	jal	is_game_over				# is_game_over()
	bne	$v0, FALSE, game_loop_game_not_over_while_loop_end

game_loop_game_not_over_while_loop_body:
	la	$a0, selected
	jal	print_game				# print_game(selected);

	jal	get_command				# get_command()

	la	$a0, selected				# selected
	la	$a1, selection_clues			# &selection_clues
	jal	compute_all_clues			# compute_all_clues(selected, &selection_clues);

game_loop_game_not_over_while_loop_step:
	b	game_loop_game_not_over_while_loop_cond

game_loop_game_not_over_while_loop_end:			# }
	la	$a0, selected
	jal	print_game				# print_game(selected);

game_loop__epilogue:
	pop	$ra					# recovers $ra from stack
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# This function converts letter inputs into numbers and returns previous if the input is out of range
        .text
decode_coordinate:
	# Subset:   2
	#
	# Frame:    []   <-- FILL THESE OUT!
	# Uses:     [$a0, $a1, $a2, $a3, $v0, $t0, $t1]
	# Clobbers: [$a0, $a1, $a2, $a3, $v0, $t0, $t1]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $t0: base + maximum
	#   - $t1: input - base
	#
	# Structure:        <-- FILL THIS OUT!
	#   decode_coordinate
	#   -> [prologue]
	#     -> body
	#	-> decode_coordinate_input_bigger_or_equal_base
	#	-> decode_coordinate_input_smaller_than_base_plus_max
	#	-> decode_coordinate_input_out_of_range
	#   -> [epilogue]

decode_coordinate__prologue:
	begin						# move frame pointer

decode_coordinate__body:
decode_coordinate_input_bigger_or_equal_base:		# if (input >= base ) {
	blt	$a0, $a1, decode_coordinate_input_out_of_range

decode_coordinate_input_smaller_than_base_plus_max:
	add	$t0, $a1, $a2				# base + maximum
							# if (input < base + maximum) {
	bge	$a0, $t0, decode_coordinate_input_out_of_range
	sub	$t1, $a0, $a1				# return input - base;
	move	$v0, $t1
	b	decode_coordinate__epilogue		# }

decode_coordinate_input_out_of_range:			# else {
	move	$v0, $a3				# return previous; }

decode_coordinate__epilogue:
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# reads the coordinates of the solution and calls the compute_all_clues to generate the clues
        .text
read_solution:
	# Subset:   2
	#
	# Frame:    [$ra, $s0, $s1]   <-- FILL THESE OUT!
	# Uses:     [$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $a0, $a1, $s0, $s1, $v0]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $a0, $a1, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $t0: total
	#   - $t1: TRUE / MARKED
	#   - $t2: row
	#   - $t3: col
	#   - $t4: height
	#   - $t5: width
	#   - $t6: row % height / the position in solution that we want to mark
	#   - $t7: col % width
	#   - $a0: solution
	#   - $a1: &solution_clues
	#   - $s0: &solution_clues
	#   - $s1: total
	#
	# Structure:        <-- FILL THIS OUT!
	#   read_solution
	#   -> [prologue]
	#     -> body
	#	-> read_solution_mark_solution_while_loop_init
	#	-> read_solution_mark_solution_while_loop_cond
	#	-> read_solution_mark_solution_while_loop_body
	#	-> read_solution_mark_solution_while_loop_step
	#	-> read_solution_mark_solution_while_loop_end
	#	-> compute_all_clues
	#   -> [epilogue]

read_solution__prologue:
	begin						# move frame pointer
	push	$ra					# save $ra onto stack
	push	$s0					# save $s0 onto stack
	push	$s1					# save $s1 onto stack

read_solution__body:
	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__read_solution__enter_solution
	syscall						# printf("Enter solution: ");

	li	$t0, 0					# int total = 0;

read_solution_mark_solution_while_loop_init:
read_solution_mark_solution_while_loop_cond:		# while (TRUE) {
	li	$t1, TRUE
	bne	$t1, TRUE, read_solution_mark_solution_while_loop_end

read_solution_mark_solution_while_loop_body:	
	li	$v0, 5					# syscall 5: read_int
	syscall
	move	$t2, $v0				# scanf("%d", &row);

	li	$v0, 5					# syscall 5: read_int
	syscall
	move	$t3, $v0				# scanf("%d", &col);

	blt	$t2, 0, read_solution_mark_solution_while_loop_end
	blt	$t3, 0, read_solution_mark_solution_while_loop_end
							# if (row < 0 || col < 0) {
							# 	break;
							# }

	lw	$t4, height				# height
	lw	$t5, width				# width
	rem	$t6, $t2, $t4				# row % height
	rem	$t7, $t3, $t5				# col % width

	mul	$t6, $t6, MAX_WIDTH			# (row % height) * MAX_WIDTH
	add	$t6, $t6, $t7				# (col % width) * MAX_WIDTH + (col % width)
	li	$t1, MARKED				# MARKED
	sb	$t1, solution($t6)			# solution[row % height][col % width] = MARKED;
	addi	$t0, 1					# total++;

read_solution_mark_solution_while_loop_step:
	b	read_solution_mark_solution_while_loop_cond
							# }

read_solution_mark_solution_while_loop_end:
	la	$a0, solution				# solution
	la	$a1, solution_clues			# &solution_clues
	move	$s0, $a1				# &solution_clues
	move	$s1, $t0				# total 
	jal	compute_all_clues			# compute_all_clues(solution, &solution_clues);

	sw	$s0, displayed_clues			# displayed_clues = &solution_clues;

	li	$v0, 4					# syscall 4: read_string
	la	$a0, str__read_solution__loaded
	syscall						# printf("Loaded ");

	li	$v0, 1					# syscall 1: read_int
	move	$a0, $s1
	syscall						# printf("%d", total);

	li	$v0, 4					# syscall 4: read_string
	la	$a0, str__read_solution__solution_coordinates
	syscall						# printf(" solution coordinates\n");

read_solution__epilogue:
	pop	$s1					# restore $s1 from stack
	pop	$s0					# restore $s0 from stack
	pop	$ra					# restore $ra from stack
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# Adds spacing between horizontal clues after calculating the index of one of the clues
        .text
lookup_clue:
	# Subset:   2
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [$t0, $t1, $t2, $t3, $a0, $a1, $a2]
	# Clobbers: [$t0, $t1, $t2, $t3, $a0, $a1, $a2]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $t0: horizontal + 1
	#   - $t1: index
	#   - $t2: clues[index]
	#   - $t3: offset % 2
	#
	# Structure:        <-- FILL THIS OUT!
	#   lookup_clue
	#   -> [prologue]
	#     -> body
	#	-> lookup_clue_horizontal_and_offset_check
	#	-> lookup_clue_clues_check
	#	-> lookup_clue_return_zero_character_with_clues_at_index
	#	-> lookup_clue_return_space
	#   -> [epilogue]

lookup_clue__prologue:
	begin						# move frame pointer

lookup_clue__body:
	add	$t0, $a2, 1				# horizontal + 1
	div	$t1, $a1, $t0				# int index = offset / (horizontal + 1);

lookup_clue_horizontal_and_offset_check:		# if (horizontal && offset % 2 == 1) {
	beq	$a2, 0, lookup_clue_clues_check

	rem	$t3, $a1, 2				# offset % 2
	bne	$t3, 1, lookup_clue_clues_check
	b	lookup_clue_return_space

lookup_clue_clues_check:
	mul	$t1, $t1, 4
	add	$t4, $a0, $t1
	lw	$t2, ($t4)				# clues[index]
	beqz	$t2, lookup_clue_return_space		# if (clues[index] == 0) {

lookup_clue_return_zero_character_with_clues_at_index:
	li	$v0, '0'
	add	$v0, $v0, $t2				# return '0' + clues[index];
	b	lookup_clue__epilogue

lookup_clue_return_space:
	li	$v0, ' '				# return ' ' };

lookup_clue__epilogue:
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# computes all the vertical and horizontal clues for each row and column
        .text
compute_all_clues:
	# Subset:   2
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3, $s4, $s5]   <-- FILL THESE OUT!
	# Uses:     [$a0, $a1, $a2, $a3, $t0, $t1, $t2, $s0, $s1, $s2, $s3, $s4, $s5]
	# Clobbers: [$a0, $a1, $a2, $a3, $t0, $t1, $t2]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: col
	#   - $s1: row
	#   - $s2: width
	#   - $s3: height
	#   - $s4: grid[MAX_HEIGHT][MAX_WIDTH]
	#   - $s5: clues
	#   - $t0: vertical / horizontal offset
	#   - $t1: temporary register to calculate offset for clues
	#   - $t2: temporary register to calculte size of vertical_clues/horizontal_clues
	#
	# Structure:        <-- FILL THIS OUT!
	#   compute_all_clues
	#   -> [prologue]
	#     -> body
	#	-> compute_all_clues_width_for_loop_init
	#	-> compute_all_clues_width_for_loop_cond
	#	-> compute_all_clues_width_for_loop_body
	#	   -> compute_clue
	#	-> compute_all_clues_width_for_loop_step
	#	-> compute_all_clues_width_for_loop_end
	#	-> compute_all_clues_height_for_loop_init
	#	-> compute_all_clues_height_for_loop_cond
	#	-> compute_all_clues_height_for_loop_body
	#	   -> compute_clue
	#	-> compute_all_clues_height_for_loop_step
	#	-> compute_all_clues_height_for_loop_end
	#   -> [epilogue]

compute_all_clues__prologue:
	begin						# move frame pointer
	push	$ra					# stores $ra onto stack
	push	$s0					# stores $s0 onto stack
	push	$s1					# stores $s1 onto stack
	push	$s2					# stores $s2 onto stack
	push	$s3					# stores $s3 onto stack
	push	$s4					# stores $s4 onto stack
	push	$s5					# stores $s5 onto stack

compute_all_clues__body:
	move	$s4, $a0				# grid[MAX_HEIGHT][MAX_WIDTH]
	move	$s5, $a1				# clues

compute_all_clues_width_for_loop_init:
	li	$s0, 0					# int col = 0;
	lw	$s2, width

compute_all_clues_width_for_loop_cond:			# while (col < width) {
	bge	$s0, $s2, compute_all_clues_width_for_loop_end

compute_all_clues_width_for_loop_body:
	move	$a0, $s0				# col
	la	$a1, TRUE
	move	$a2, $s4				# grid

	move	$t0, $s5				# clues
	add	$t0, $t0, CLUE_SET_VERTICAL_CLUES_OFFSET
	move	$t1, $s0				# col
	li	$t2, SIZEOF_INT				# SIZEOF_INT
	mul	$t2, $t2, MAX_HEIGHT			# SIZEOF_INT * MAX_HEIGHT
	mul	$t1, $t1, $t2				# col * (SIZEOF_INT * MAX_HEIGHT)
	add	$t0, $t0, $t1
	move	$a3, $t0				# clues->vertical_clues[col]

	jal	compute_clue				# compute_clue(col, TRUE, grid, clues->vertical_clues[col]);

compute_all_clues_width_for_loop_step:
	addi	$s0, 1					# col++;
	b	compute_all_clues_width_for_loop_cond

compute_all_clues_width_for_loop_end:			# }

compute_all_clues_height_for_loop_init:
	li	$s1, 0					# int row = 0;
	lw	$s3, height

compute_all_clues_height_for_loop_cond:			# while (row < height) {
	bge	$s1, $s3, compute_all_clues_height_for_loop_end

compute_all_clues_height_for_loop_body:
	move	$a0, $s1				# row
	la	$a1, FALSE
	move	$a2, $s4				# grid

	move	$t0, $s5				# clues
	add	$t0, $t0, CLUE_SET_HORIZONTAL_CLUES_OFFSET
	move	$t1, $s1				# row
	li	$t2, SIZEOF_INT				# SIZEOF_INT
	mul	$t2, $t2, MAX_WIDTH			# SIZEOF_INT * MAX_WIDTH
	mul	$t1, $t1, $t2				# row * (SIZEOF_INT * MAX_WIDTH)
	add	$t0, $t0, $t1
	move	$a3, $t0				# clues->horizontal_clues[row]
	jal	compute_clue				# compute_clue(row, FALSE, grid, clues->horizontal_clues[row]);
	
compute_all_clues_height_for_loop_step:
	addi	$s1, 1					# row++;
	b	compute_all_clues_height_for_loop_cond

compute_all_clues_height_for_loop_end:			# }
compute_all_clues__epilogue:
	pop	$s5					# restores $s5 from stack
	pop	$s4					# restores $s4 from stack
	pop	$s3					# restores $s3 from stack
	pop	$s2					# restores $s2 from stack
	pop	$s1					# restores $s1 from stack
	pop	$s0					# restores $s0 from stack
	pop	$ra					# restore $ra from stack
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# Asks the user for the coordinates and the move the user wants to execute
        .text
make_move:
	# Subset:   3
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3]   <-- FILL THESE OUT!
	# Uses:     [$s0, $s1, $s2, $s3, $a0, $a1, $a2, $a3, $t0, $t1, $t2, $t3, $v0]
	# Clobbers: [$a0, $a1, $a2, $a3, $t0, $t1, $t2, $t3, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: first_letter
	#   - $s1: second_letter
	#   - $s2: row
	#   - $s3: col
	#   - $t0: new_cell_value
	#   - $t1: choice
	#   - $t2: MARKED/CROSSED_OUT/UNMARKED
	#   - $t3: offset for selected[row][col]
	#   - $a0: selected[row][col]
	#
	# Structure:        <-- FILL THIS OUT!
	#   make_move
	#   -> [prologue]
	#     -> body
	#	-> decode_coordinate
	#	-> decode_coordinate
	#	-> decode_coordinate
	#	-> decode_coordinate
	#	-> make_move_read_bad_input
	#	   -> make_move
	#	-> make_move_valid_read
	#	-> make_move_choice_do_while_loop_body
	#	   -> make_move_choice_do_while_loop_marked_choice
	#	   -> make_move_choice_do_while_loop_crossed_out_choice
	#	   -> make_move_choice_do_while_loop_unmarked_choice
	#	-> make_move_choice_do_while_loop_cond
	#	-> make_move_choice_do_while_loop_step
	#	-> make_move_choice_do_while_loop_end
	#   -> [epilogue]

make_move__prologue:
	begin						# move frame pointer
	push	$ra					# store $ra onto stack
	push	$s0					# store $s0 onto stack
	push	$s1					# store $s1 onto stack
	push	$s2					# store $s2 onto stack
	push	$s3					# store $s3 onto stack

make_move__body:
	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__make_move__enter_first_coord
	syscall						# printf("Enter first coord: ");

	li	$v0, 12					# syscall 12: read_character
	syscall						# scanf(" %c", &first_letter);
	move	$s0, $v0

	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__make_move__enter_second_coord
	syscall						# printf("Enter second coord: ");

	li	$v0, 12					# syscall 12: read_character
	syscall						# scanf(" %c", &second_letter);
	move	$s1, $v0

	li	$s2, -1					# int row = -1;
	li	$s3, -1					# int col = -1;

	move	$a0, $s0				# first_letter
	la	$a1, 'A'
	lw	$a2, width
	move	$a3, $s3				# col
	jal	decode_coordinate			# decode_coordinate(first_letter, 'A', width, col);

	move	$s3, $v0				# col = decode_coordinate(first_letter, 'A', width, col);

	move	$a0, $s1				# second_letter
	la	$a1, 'A'
	lw	$a2, width
	move	$a3, $s3				# col
	jal	decode_coordinate			# decode_coordinate(second_letter, 'A', width, col);

	move	$s3, $v0				# col = decode_coordinate(second_letter, 'A', width, col);

	move	$a0, $s0				# first_letter
	la	$a1, 'a'
	lw	$a2, height
	move	$a3, $s2				# row
	jal	decode_coordinate			# decode_coordinate(first_letter, 'a', height, row);

	move	$s2, $v0				# row = decode_coordinate(first_letter, 'a', height, row);

	move	$a0, $s1				# second_letter
	la	$a1, 'a'
	lw	$a2, height
	move	$a3, $s2				# row
	jal	decode_coordinate			# decode_coordinate(second_letter, 'a', height, row);

	move	$s2, $v0				# row = decode_coordinate(second_letter, 'a', height, row);

	beq	$s2, -1, make_move_read_bad_input	# if (row == -1 || col == -1) {
	beq	$s3, -1, make_move_read_bad_input
	b	make_move_valid_read

make_move_read_bad_input:
	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__make_move__bad_input
	syscall						# printf("Bad input, try again!\n");

	jal	make_move				# make_move();
	b	make_move__epilogue			# return;

make_move_valid_read:
	li	$t0, 0					# char new_cell_value = 0;

make_move_choice_do_while_loop_body:
	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__make_move__enter_choice
	syscall						# printf("Enter choice (# to select, 
							# x to cross out, . to deselect): ");

	li	$v0, 12					# syscall 12: read_character
	syscall
	move	$t1, $v0				# scanf(" %c", &choice);

	beq	$t1, '#', make_move_choice_do_while_loop_marked_choice
	beq	$t1, 'x', make_move_choice_do_while_loop_crossed_out_choice
	beq	$t1, '.', make_move_choice_do_while_loop_unmarked_choice

							# if (choice == '#') {
							# } else if (choice == 'x') {
							# } else if (choice == '.') {
							# else {
	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__make_move__bad_input
	syscall						# printf("Bad input, try again!\n");
	b	make_move_choice_do_while_loop_cond	# }

make_move_choice_do_while_loop_marked_choice:
	li	$t2, MARKED
	move	$t0, $t2				# new_cell_value = MARKED;
	b	make_move_choice_do_while_loop_cond

make_move_choice_do_while_loop_crossed_out_choice:	
	li	$t2, CROSSED_OUT
	move	$t0, $t2				# new_cell_value = CROSSED_OUT;
	b	make_move_choice_do_while_loop_cond

make_move_choice_do_while_loop_unmarked_choice:	
	li	$t2, UNMARKED
	move	$t0, $t2				# new_cell_value = UNMARKED;

make_move_choice_do_while_loop_cond:
	bnez	$t0, make_move_choice_do_while_loop_end # }while (!new_cell_value);

make_move_choice_do_while_loop_step:
	b	make_move_choice_do_while_loop_body

make_move_choice_do_while_loop_end:
	la	$a0, selected				# selected
	move	$t3, $s2				# row
	mul	$t3, MAX_WIDTH				# row * MAX_WIDTH
	add	$t3, $s3				# row * MAX_WIDTH + col
	add	$a0, $t3				# selected[row][col]
	sb	$t0, ($a0)				# selected[row][col] = new_cell_value;

make_move__epilogue:
	pop	$s3					# restores $s3 from stack
	pop	$s2					# restores $s2 from stack
	pop	$s1					# restores $s1 from stack
	pop	$s0					# restores $s0 from stack
	pop	$ra					# restores $ra from stack
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# prints the correct game state with its clues
        .text
print_game:
	# Subset:   3
	#
	# Frame:    [$ra, $s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7]   <-- FILL THESE OUT!
	# Uses:     [$s0, $s1, $s2, $s3, $s4, $s5, $s6, $s7, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $a0, $a1, $a2]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $a0, $a1, $a2]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $s0: vertical_gutter
	#   - $s1: horizontal_gutter
	#   - $s2: gutter_row
	#   - $s3: col for printing top clues
	#   - $s4: width
	#   - $s5: row
	#   - $s6: grid
	#   - $s7: gutter_col in print_row
	#   - $t0: displayed_clues
	#   - $t1: &selection_clues
	#   - $t2: temporary register for calculation
	#   - $t3: temporary register for calculation
	#   - $t4: gutter_col/ col for print top coordinate reference/ col for print grid for row
	#   - $t5: height/temporary register for calculation
	#   - $t6: selected_cell
	#   - $t7: UNMARKED/CROSSED_OUT/MARKED
	#
	# Structure:        <-- FILL THIS OUT!
	#   print_game
	#   -> [prologue]
	#     -> body
	#	-> print_game_printing_counts_for_solution
	#	-> print_game_print_vertical_gutter_for_loop_init
	#	-> print_game_print_vertical_gutter_for_loop_cond
	#	-> print_game_print_vertical_gutter_for_loop_body
	#	   -> print_game_print_space_left_of_top_clues_for_loop_init
	#	   -> print_game_print_space_left_of_top_clues_for_loop_cond
	#	   -> print_game_print_space_left_of_top_clues_for_loop_body
	#	   -> print_game_print_space_left_of_top_clues_for_loop_step
	#	   -> print_game_print_space_left_of_top_clues_for_loop_end
	#	   -> print_game_print_top_clues_for_loop_init
	#	   -> print_game_print_top_clues_for_loop_cond
	#	   -> print_game_print_top_clues_for_loop_body
	#	      -> lookup_clue
	#	   -> print_game_print_top_clues_for_loop_step
	#	   -> print_game_print_top_clues_for_loop_end
	#	-> print_game_print_vertical_gutter_for_loop_step
	#	-> print_game_print_vertical_gutter_for_loop_end
	#	-> print_game_print_top_coordinate_reference_for_loop_init
	#	-> print_game_print_top_coordinate_reference_for_loop_cond
	#	-> print_game_print_top_coordinate_reference_for_loop_body
	#	   -> print_game_print_top_coordinate_reference_for_loop_body_print_space
	#	-> print_game_print_top_coordinate_reference_for_loop_step
	#	-> print_game_print_top_coordinate_reference_for_loop_end
	#	-> print_game_print_row_for_loop_init
	#	-> print_game_print_row_for_loop_cond
	#	-> print_game_print_row_for_loop_body
	#	   -> print_game_print_horizontal_gutter_for_loop_init
	#	   -> print_game_print_horizontal_gutter_for_loop_cond
	#	   -> print_game_print_horizontal_gutter_for_loop_body
	#	      -> lookup_clue
	#	   -> print_game_print_horizontal_gutter_for_loop_step
	#	   -> print_game_print_horizontal_gutter_for_loop_end
	#	   -> print_game_print_grid_for_row_for_loop_init
	#	   -> print_game_print_grid_for_row_for_loop_cond
	#	   -> print_game_print_grid_for_row_for_loop_body
	#	      -> print_game_print_grid_for_row_for_loop_body_unmarked_selected_cell
	#	      -> print_game_print_grid_for_row_for_loop_body_crossed_out_selected_cell
	#	      -> print_game_print_grid_for_row_for_loop_body_marked_selected_cell
	#	   -> print_game_print_grid_for_row_for_loop_step
	#	   -> print_game_print_grid_for_row_for_loop_end
	#	-> print_game_print_row_for_loop_step
	#	-> print_game_print_row_for_loop_end
	#   -> [epilogue]

print_game__prologue:
	begin						# move frame pointer
	push	$ra					# stores $ra onto stack
	push	$s0					# stores $s0 onto stack
	push	$s1					# stores $s1 onto stack
	push	$s2					# stores $s2 onto stack
	push	$s3					# stores $s3 onto stack
	push	$s4					# stores $s4 onto stack
	push	$s5					# stores $s5 onto stack
	push	$s6					# stores $s6 onto stack
	push	$s7					# stores $s7 onto stack

print_game__body:
	move	$s6, $a0
	lw	$t0, displayed_clues			# displayed_clues
	la	$t1, selection_clues			# &selection_clues
	bne	$t0, $t1, print_game_printing_counts_for_solution

	li	$v0, 4					# syscall 4: print_string
	la	$a0, str__print_game__printing_selection
	syscall						# printf("[printing counts for current selection rather than
							# solution clues]\n");

print_game_printing_counts_for_solution:
	lw	$t2, height				# height
	addi	$t2, 1					# height + 1
	div	$t2, $t2, 2				# (height + 1) / 2
	move	$s0, $t2				# int vertical_gutter = (height + 1) / 2;

	lw	$s4, width				# width
	add	$t3, $s4, 1				# width + 1
	move	$s1, $t3				# int horizontal_gutter = width + 1;

print_game_print_vertical_gutter_for_loop_init:
	li	$s2, 0					# int gutter_row = 0;

print_game_print_vertical_gutter_for_loop_cond:		# while (gutter_row < vertical_gutter) {
	bge	$s2, $s0, print_game_print_vertical_gutter_for_loop_end

print_game_print_vertical_gutter_for_loop_body:
print_game_print_space_left_of_top_clues_for_loop_init:
	li	$t4, 0					# int gutter_col = 0;

print_game_print_space_left_of_top_clues_for_loop_cond:	# while (gutter_col  <= horizontal_gutter) {
	bgt	$t4, $s1, print_game_print_space_left_of_top_clues_for_loop_end

print_game_print_space_left_of_top_clues_for_loop_body:
	li	$v0, 11					# syscall 11: print_character
	la	$a0, ' '
	syscall						# putchar(' ');

print_game_print_space_left_of_top_clues_for_loop_step:
	addi	$t4, 1					# gutter_col++; }
	b	print_game_print_space_left_of_top_clues_for_loop_cond

print_game_print_space_left_of_top_clues_for_loop_end:
print_game_print_top_clues_for_loop_init:
	li	$s3, 0					# int col = 0;

print_game_print_top_clues_for_loop_cond:		# while (col < width) {
	bge	$s3, $s4, print_game_print_top_clues_for_loop_end

print_game_print_top_clues_for_loop_body:
	lw	$a0, displayed_clues			# displayed_clues
	add	$a0, $a0, CLUE_SET_VERTICAL_CLUES_OFFSET
	move	$t5, $s3				# col
	mul	$t5, $t5, SIZEOF_INT			# col * SIZEOF_INT
	mul	$t5, $t5, MAX_HEIGHT			# col * SIZEOF_INT * MAX_HEIGHT
	add	$a0, $a0, $t5				# displayed_clues->vertical_clues[col]

	move	$a1, $s2				# gutter_row

	li	$a2, 0

	jal	lookup_clue				# lookup_clue(displayed_clues->vertical_clues[col], 
							# gutter_row, 0)
	move	$a0, $v0
	li	$v0, 11					# syscall 11: print_character
	syscall						# putchar(lookup_clue(displayed_clues->vertical_clues[col], 
							# gutter_row, 0));

print_game_print_top_clues_for_loop_step:
	addi	$s3, 1					# col++; }
	b	print_game_print_top_clues_for_loop_cond

print_game_print_top_clues_for_loop_end:
	li	$v0, 11					# syscall 11: print_character
	li	$a0, '\n'
	syscall						# putchar('\n');

print_game_print_vertical_gutter_for_loop_step:
	addi	$s2, 1					# gutter_row++; }
	b	print_game_print_vertical_gutter_for_loop_cond

print_game_print_vertical_gutter_for_loop_end:
print_game_print_top_coordinate_reference_for_loop_init:
	li	$t4, 0					# int col = 0;

print_game_print_top_coordinate_reference_for_loop_cond:
	move	$t3, $s1				# horizontal_gutter
	add	$t3, $s4				# horizontal_gutter + width
	addi	$t3, 1					# col < horizontal_gutter + width + 1
	bge	$t4, $t3, print_game_print_top_coordinate_reference_for_loop_end
							# while (col < horizontal_gutter + width + 1) {

print_game_print_top_coordinate_reference_for_loop_body:
	ble	$t4, $s1, print_game_print_top_coordinate_reference_for_loop_body_print_space
	li	$a0, 'A'
	move	$t5, $t4				# col
	sub	$t5, $t5, $s1				# col - horizontal_gutter
	sub	$t5, $t5, 1				# col - horizontal_gutter - 1
	add	$a0, $a0, $t5				# 'A' + (col - horizontal_gutter - 1)
	li	$v0, 11					# syscall 11: print_character
	syscall						# putchar('A' + (col - horizontal_gutter - 1));

	b	print_game_print_top_coordinate_reference_for_loop_step

print_game_print_top_coordinate_reference_for_loop_body_print_space:
	li	$a0, ' '
	li	$v0, 11					# syscall 11: print_character
	syscall						# putchar(' ');

print_game_print_top_coordinate_reference_for_loop_step:
	addi	$t4, 1					# col++; }
	b	print_game_print_top_coordinate_reference_for_loop_cond

print_game_print_top_coordinate_reference_for_loop_end:
	li	$a0, '\n'
	li	$v0, 11					# syscall 11: print_character
	syscall						# putchar('\n');

print_game_print_row_for_loop_init:
	li	$s5, 0					# int row = 0;

print_game_print_row_for_loop_cond:			# while (row < height) {
	lw	$t5, height
	bge	$s5, $t5, print_game_print_row_for_loop_end

print_game_print_row_for_loop_body:
print_game_print_horizontal_gutter_for_loop_init:
	li	$s7, 0					# int gutter_col = 0;

print_game_print_horizontal_gutter_for_loop_cond:	# while (gutter_col < horizontal_gutter) {
	bge	$s7, $s1, print_game_print_horizontal_gutter_for_loop_end

print_game_print_horizontal_gutter_for_loop_body:
	lw	$a0, displayed_clues			# displayed_clues
	add	$a0, $a0, CLUE_SET_HORIZONTAL_CLUES_OFFSET
	move	$t5, $s5				# row
	mul	$t5, $t5, SIZEOF_INT			# row * SIZEOF_INT
	mul	$t5, $t5, MAX_WIDTH			# row * SIZEOF_INT * MAX_WIDTH
	add	$a0, $a0, $t5				# displayed_clues->horizontal_clues[row]

	move	$a1, $s7				# gutter_col

	li	$a2, 1

	jal	lookup_clue				# lookup_clue(displayed_clues->horizontal_clues[row], 
							# gutter_col, 1)
	move	$a0, $v0
	li	$v0, 11					# syscall 11: print_character
	syscall						# putchar(lookup_clue(displayed_clues->horizontal_clues[row],
							# gutter_col, 1));	

print_game_print_horizontal_gutter_for_loop_step:
	addi	$s7, 1					# gutter_col++; }
	b	print_game_print_horizontal_gutter_for_loop_cond

print_game_print_horizontal_gutter_for_loop_end:
	li	$v0, 11					# syscall 11: print_character
	li	$a0, 'a'
	add	$a0, $s5
	syscall						# putchar('a' + row);

print_game_print_grid_for_row_for_loop_init:
	li	$t4, 0					# int col = 0;

print_game_print_grid_for_row_for_loop_cond:		# while (col < width) {
	bge	$t4, $s4, print_game_print_grid_for_row_for_loop_end

print_game_print_grid_for_row_for_loop_body:
	move	$t2, $s6				# grid
	move	$t3, $s5				# row
	mul	$t3, $t3, MAX_WIDTH			# row * MAX_WIDTH
	add	$t3, $t4				# row * MAX_WIDTH + col
	add	$t2, $t2, $t3
	lb	$t6, ($t2)				# int selected_cell = grid[row][col];

	li	$t7, UNMARKED
	beq	$t6, $t7, print_game_print_grid_for_row_for_loop_body_unmarked_selected_cell
							# if (selected_cell == UNMARKED) {
	
	li	$t7, CROSSED_OUT
	beq	$t6, $t7, print_game_print_grid_for_row_for_loop_body_crossed_out_selected_cell
							# if (selected_cell == CROSSED_OUT) {

	li	$t7, MARKED
	beq	$t6, $t7, print_game_print_grid_for_row_for_loop_body_marked_selected_cell
							# if (selected_cell == MARKED) {

	li	$v0, 11					# syscall 11: print_character
	li	$a0, '?'
	syscall						# putchar('?');
	b	print_game_print_grid_for_row_for_loop_step

print_game_print_grid_for_row_for_loop_body_unmarked_selected_cell:
	li	$v0, 11					# syscall 11: print_character
	li	$a0, '.'
	syscall						# putchar('.');
	b	print_game_print_grid_for_row_for_loop_step

print_game_print_grid_for_row_for_loop_body_crossed_out_selected_cell:
	li	$v0, 11					# syscall 11: print_character
	li	$a0, 'x'
	syscall						# putchar('x');

	b	print_game_print_grid_for_row_for_loop_step

print_game_print_grid_for_row_for_loop_body_marked_selected_cell:
	li	$v0, 11					# syscall 11: print_character
	li	$a0, '#'
	syscall						# putchar('#');

print_game_print_grid_for_row_for_loop_step:
	addi	$t4, 1					# col++;
	b	print_game_print_grid_for_row_for_loop_cond

print_game_print_grid_for_row_for_loop_end:
	li	$v0, 11 				# syscall 11: print_character
	la	$a0, '\n'
	syscall						# putchar('\n');

print_game_print_row_for_loop_step:
	addi	$s5, 1					# row++; }
	b	print_game_print_row_for_loop_cond

print_game_print_row_for_loop_end:
print_game__epilogue:
	pop	$s7					# restores $s7 from stack
	pop	$s6					# restores $s6 from stack
	pop	$s5					# restores $s5 from stack
	pop	$s4					# restores $s4 from stack
	pop	$s3					# restores $s3 from stack
	pop	$s2					# restores $s2 from stack
	pop	$s1					# restores $s1 from stack
	pop	$s0					# restores $s0 from stack
	pop	$ra					# restores $ra from stack
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# Computes a row/column of a horizontal/vertical clue
        .text
compute_clue:
	# Subset:   3
	#
	# Frame:    [$s0]   <-- FILL THESE OUT!
	# Uses:     [$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $s0, $a0, $a1, $a2, $a3, $v0]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $s0, $a0, $a1, $a2, $a3, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $t0: row
	#   - $t1: col
	#   - $t2: dx
	#   - $t3: dy
	#   - $t4: clue_length
	#   - $t5: temporary register for calculation/ height/ width/ MARKED
	#   - $t6: clue_display_length/leftovers
	#   - $t7: clue_index
	#   - $t8: run_length/temporary register for calculation
	#   - $s0: grid[row][col]
	#
	# Structure:        <-- FILL THIS OUT!
	#   compute_clue
	#   -> [prologue]
	#     -> body
	#	-> compute_clue_vertical_clue_init
	#	-> compute_clue_horizontal_clue_init
	#	-> compute_clue_after_clue_direction
	#	   -> compute_clue_count_marked_while_loop_init
	#	   -> compute_clue_count_marked_while_loop_cond
	#	   -> compute_clue_count_marked_while_loop_body
	#	      -> compute_clue_count_marked_while_loop_end_of_run
	#	   -> compute_clue_count_marked_while_loop_step
	#	   -> compute_clue_count_marked_while_loop_end
	#	   -> compute_clue_final_run
	#	   -> compute_clue_continue_to_leftovers
	#	   -> compute_clue_fill_remaining_clues_with_zero_for_loop_init
	#	   -> compute_clue_fill_remaining_clues_with_zero_for_loop_cond
	#	   -> compute_clue_fill_remaining_clues_with_zero_for_loop_body
	#	   -> compute_clue_fill_remaining_clues_with_zero_for_loop_step
	#	   -> compute_clue_fill_remaining_clues_with_zero_for_loop_end
	#	   -> compute_clue_copy_clues_for_loop_init
	#	   -> compute_clue_copy_clues_for_loop_cond
	#	   -> compute_clue_copy_clues_for_loop_body
	#	   -> compute_clue_copy_clues_for_loop_body_copy_clue_value
	#	   -> compute_clue_copy_clues_for_loop_step
	#	   -> compute_clue_copy_clues_for_loop_end
	#   -> [epilogue]

compute_clue__prologue:
	begin						# move frame pointer
	push	$s0					# stores $s0 onto stack

compute_clue__body:
compute_clue_vertical_clue_init:
	li	$t0, 0					# int row = 0;
	li	$t1, 0					# int col = 0;
	li	$t2, 0					# int dx = 0;
	li	$t3, 0					# int dy = 0;

	bne	$a1, 1, compute_clue_horizontal_clue_init
							# if (is_vertical) {
	move	$t1, $a0				# col = index;
	li	$t3, 1					# dy = 1;
	li	$t4, MAX_HEIGHT				# clue_length = MAX_HEIGHT;
	lw	$t5, height				# height
	addi	$t5, 1					# height + 1
	div	$t5, $t5, 2				# (height + 1) / 2
	move	$t6, $t5				# clue_display_length = (height + 1) / 2;
	b	compute_clue_after_clue_direction	# } else {

compute_clue_horizontal_clue_init:
	move	$t0, $a0				# row = index;
	li	$t2, 1					# dx = 1;
	li	$t4, MAX_WIDTH				# clue_length = MAX_WIDTH
	lw	$t5, width				# width
	addi	$t5, 1					# width + 1
	div	$t5, $t5, 2				# (width + 1) / 2
	move	$t6, $t5				# clue_display_length = (width + 1) / 2;}

compute_clue_after_clue_direction:
	li	$t7, 0					# int clue_index = 0;
	li	$t8, 0					# int run_length = 0;

compute_clue_count_marked_while_loop_init:
compute_clue_count_marked_while_loop_cond:		# while (row < height && col < width) {
	lw	$t5, height
	bge	$t0, $t5, compute_clue_count_marked_while_loop_end 

	lw	$t5, width
	bge	$t1, $t5, compute_clue_count_marked_while_loop_end

compute_clue_count_marked_while_loop_body:
	move	$t5, $t0				# row
	mul	$t5, $t5, MAX_WIDTH			# row * MAX_WIDTH
	add	$t5, $t5, $t1				# row * MAX_WIDTH + col
	add	$t5, $a2, $t5			
	lb	$s0, ($t5)				# if (grid[row][col] == MARKED) {
	li	$t5, MARKED
	bne	$s0, $t5, compute_clue_count_marked_while_loop_end_of_run

	addi	$t8, 1					# run_length++; }
	b	compute_clue_count_marked_while_loop_step

compute_clue_count_marked_while_loop_end_of_run:	# else if (run_length != 0) {
	beqz	$t8, compute_clue_count_marked_while_loop_step
	move	$t5, $t7				# clue_index
	addi	$t7, 1					# clue_index++
	mul	$t5, $t5, SIZEOF_INT			# clue_index * SIZEOF_INT
	add	$t5, $a3, $t5
	sw	$t8, ($t5)				# clues[clue_index++] = run_length;

	li	$t8, 0					# run_length = 0;}

compute_clue_count_marked_while_loop_step:
	add	$t0, $t0, $t3				# row += dy;
	add	$t1, $t1, $t2				# col += dx;}
	b	compute_clue_count_marked_while_loop_cond

compute_clue_count_marked_while_loop_end:
compute_clue_final_run:					# if ( run_length != 0) {
	beqz	$t8, compute_clue_continue_to_leftovers

	move	$t5, $t7				# clue_index
	addi	$t7, 1					# clue_index++
	mul	$t5, $t5, SIZEOF_INT			# clue_index * SIZEOF_INT
	add	$t5, $a3, $t5
	sw	$t8, ($t5)				# clues[clue_index++] = run_length;}

compute_clue_continue_to_leftovers:
	sub	$t6, $t6, $t7				# int leftovers = clue_display_length - clue_index;

compute_clue_fill_remaining_clues_with_zero_for_loop_init:
							# int i = clue_index; $t7 is already clue_index
compute_clue_fill_remaining_clues_with_zero_for_loop_cond:	
							# while( i < clue_length) {
	bge	$t7, $t4, compute_clue_fill_remaining_clues_with_zero_for_loop_end

compute_clue_fill_remaining_clues_with_zero_for_loop_body:
	move	$t5, $t7				# i
	mul	$t5, SIZEOF_INT				# i * 4
	add	$t5, $a3, $t5				# clues[i]
	li	$t8, 0
	sw	$t8, ($t5)				# clues[i] = 0;

compute_clue_fill_remaining_clues_with_zero_for_loop_step:
	addi	$t7, 1					# i++;}
	b	compute_clue_fill_remaining_clues_with_zero_for_loop_cond

compute_clue_fill_remaining_clues_with_zero_for_loop_end:
compute_clue_copy_clues_for_loop_init:
	sub	$t4, $t4, 1				# int i = clue_length - 1;

compute_clue_copy_clues_for_loop_cond:			# while (i >= 0 ) {
	blt	$t4, 0, compute_clue_copy_clues_for_loop_end

compute_clue_copy_clues_for_loop_body:			# if (i >= leftovers) {
	bge	$t4, $t6, compute_clue_copy_clues_for_loop_body_copy_clue_value
	
	move	$t5, $t4				# i
	mul	$t5, SIZEOF_INT				# i * 4
	add	$t5, $a3, $t5				# clues[i]
	li	$t8, 0
	sw	$t8, ($t5)				# else { clues[i] = 0; }
	b	compute_clue_copy_clues_for_loop_step

compute_clue_copy_clues_for_loop_body_copy_clue_value:
	move	$t5, $t4				# i
	sub	$t5, $t5, $t6				# i - leftovers
	mul	$t5, SIZEOF_INT				# (i - leftovers) * SIZEOF_INT
	add	$t5, $a3, $t5
	lw	$t8, ($t5)				# clues[i - leftovers]

	move	$t5, $t4				# i
	mul	$t5, SIZEOF_INT				# i * 4
	add	$t5, $a3, $t5				# clues[i]
	sw	$t8, ($t5)				# clues[i] = clues[i - leftovers]; }

compute_clue_copy_clues_for_loop_step:
	sub	$t4, $t4, 1				# i--; }
	b	compute_clue_copy_clues_for_loop_cond
	
compute_clue_copy_clues_for_loop_end:

compute_clue__epilogue:
	pop	$s0					# restores $s0 from stack
	end						# move frame pointer back
	jr      $ra


################################################################################
# .TEXT <print_welcome>
# checks if the game is over which is when the user solves the puzzle.
        .text
is_game_over:
	# Subset:   3
	#
	# Frame:    [...]   <-- FILL THESE OUT!
	# Uses:     [$t0, $t1, $t2, $t3, $t4, $a0, $a1, $v0]
	# Clobbers: [$t0, $t1, $t2, $t3, $t4, $a0, $a1, $v0]
	#
	# Locals:           <-- FILL THIS OUT!
	#   - $t0: row
	#   - $t1: col
	#   - $t2: temporary register for calculation
	#   - $t3: selection_clue
	#   - $t4: solution_clue
	#   - $a0: selection_clues
	#   - $a1: solution_clues
	#
	# Structure:        <-- FILL THIS OUT!
	#   is_game_over
	#   -> [prologue]
	#     -> body
	#	-> is_game_over_row_for_loop_init
	#	-> is_game_over_row_for_loop_cond
	#	-> is_game_over_row_for_loop_body
	#	   -> is_game_over_col_for_loop_init
	#	   -> is_game_over_col_for_loop_cond
	#	   -> is_game_over_col_for_loop_body
	#	      -> is_game_over_col_for_loop_body_check_horizontal
	#	   -> is_game_over_col_for_loop_step
	#	   -> is_game_over_col_for_loop_end
	#	-> is_game_over_row_for_loop_step
	#	-> is_game_over_row_for_loop_end
	#   -> [epilogue]

is_game_over__prologue:
	begin						# move frame pointer

is_game_over__body:
is_game_over_row_for_loop_init:	
	li	$t0, 0					# int row = 0;

is_game_over_row_for_loop_cond:				# while (row < MAX_HEIGHT) {
	bge	$t0, MAX_HEIGHT, is_game_over_row_for_loop_end

is_game_over_row_for_loop_body:	
is_game_over_col_for_loop_init:
	li	$t1, 0					# int col = 0;

is_game_over_col_for_loop_cond:				# while (col < MAX_WIDTH) {
	bge	$t1, MAX_WIDTH, is_game_over_col_for_loop_end

is_game_over_col_for_loop_body:
	la	$a0, selection_clues
	add	$a0, $a0, CLUE_SET_VERTICAL_CLUES_OFFSET
	move	$t2, $t1				# col
	mul	$t2, $t2, MAX_HEIGHT			# col * MAX_HEIGHT
	add	$t2, $t2, $t0				# col * MAX_HEIGHT + row
	mul	$t2, $t2, SIZEOF_INT			# (col * MAX_HEIGHT + row) * SIZEOF_INT
	add	$a0, $a0, $t2				# selection_clues.vertical_clues[col][row]
	lw	$t3, ($a0)				# int selection_clue = selection_clues.vertical_clues[col][row];

	la	$a1, solution_clues
	add	$a1, $a1, CLUE_SET_VERTICAL_CLUES_OFFSET
	add	$a1, $a1, $t2				# solution_clues.vertical_clues[col][row]
	lw	$t4, ($a1)				# int solution_clue = solution_clues.vertical_clues[col][row];

	beq	$t3, $t4, is_game_over_col_for_loop_body_check_horizontal
	li	$v0, FALSE
	b	is_game_over__epilogue			#  if (selection_clue != solution_clue) {
							#  return FALSE;}

is_game_over_col_for_loop_body_check_horizontal:
	la	$a0, selection_clues
	add	$a0, $a0, CLUE_SET_HORIZONTAL_CLUES_OFFSET
	move	$t2, $t0				# row
	mul	$t2, $t2, MAX_WIDTH			# row * MAX_WIDTH
	add	$t2, $t2, $t1				# (row * MAX_WIDTH + col) 
	mul	$t2, $t2, SIZEOF_INT			# (row * MAX_WIDTH + col) * SIZEOF_INT
	add	$a0, $a0, $t2				# selection_clues.horizontal_clues[row][col]
	lw	$t3, ($a0)				# selection_clue = selection_clues.horizontal_clues[row][col];

	la	$a1, solution_clues
	add	$a1, $a1, CLUE_SET_HORIZONTAL_CLUES_OFFSET
	add	$a1, $a1, $t2				# solution_clues.horizontal_clues[row][col]
	lw	$t4, ($a1)				# solution_clue = solution_clues.horizontal_clues[row][col];

	beq	$t3, $t4, is_game_over_col_for_loop_step
	li	$v0, FALSE
	b	is_game_over__epilogue			#  if (selection_clue != solution_clue) {
							#  return FALSE;}

is_game_over_col_for_loop_step:
	addi	$t1, 1					# col++; }
	b	is_game_over_col_for_loop_cond

is_game_over_col_for_loop_end:
is_game_over_row_for_loop_step:	
	addi	$t0, 1					# row++; }
	b	is_game_over_row_for_loop_cond

is_game_over_row_for_loop_end:	
	li	$v0, TRUE

is_game_over__epilogue:
	end						# move frame pointer back
	jr      $ra


################################################################################
################################################################################
###                   PROVIDED FUNCTIONS — DO NOT CHANGE                     ###
################################################################################
################################################################################

################################################################################
# .TEXT <print_welcome>
        .text
get_command:
	# Provided
	#
	# Frame:    [$ra]
	# Uses:     [$a0, $v0, $t0, $t1]
	# Clobbers: [$a0, $v0, $t0, $t1]
	#
	# Locals:
	#   - $t0: command
	#   - $t1: &selection_clues or &solution_clues
	#
	# Structure:
	# Structure:
	#   dump_game_state
	#   -> [prologue]
	#   -> body
	#     -> command_m
	#     -> command_q
	#     -> command_d
	#     -> command_s
	#     -> command_S
	#     -> command_query
	#     -> bad_command
	#   -> [epilogue]

get_command__prologue:
	begin
	push	$ra

get_command__body:
	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__get_command__prompt
	syscall						# printf(" >> ");

	li	$v0, 12					# syscall 12: read_char
	syscall
	move	$t0, $v0				# scanf(" %c", &command);

	beq	$t0, 'm', get_command__command_m	# if (command == 'm') { ...
	beq	$t0, 'q', get_command__command_q	# } else if (command == 'q') { ...
	beq	$t0, 'd', get_command__command_d	# } else if (command == 'd') { ...
	beq	$t0, 's', get_command__command_s	# } else if (command == 's') { ...
	beq	$t0, 'S', get_command__command_S	# } else if (command == 'S') { ...
	beq	$t0, '?', get_command__command_query	# } else if (command == '?') { ...
	b	get_command__bad_command		# } else { ... }

get_command__command_m:					# if (command == 'm') {
	jal	make_move				#   make_move();
	b	get_command__epilgoue			# }

get_command__command_q:					# else if (command == 'q') {
	li	$v0, 10					#   syscall 10: exit
	syscall						#   exit(0);
	b	get_command__epilgoue			# }

get_command__command_d:					# if (command == 'd') {
	jal	dump_game_state				#   dump_game_state();
	b	get_command__epilgoue			# }

get_command__command_s:					# else if (command == 's') {
	la	$t1, selection_clues			#   &selection_clues
	sw	$t1, displayed_clues			#   displayed_clues = &selection_clues;
	b	get_command__epilgoue			# }

get_command__command_S:					# else if (command == 'S') {
	la	$t1, solution_clues			#   &solution_clues
	sw	$t1, displayed_clues			#   displayed_clues = &solution_clues;
	b	get_command__epilgoue			# }

get_command__command_query:				# else if (command == '?') {
	la	$a0, solution				#   solution
	jal	print_game				#   print_game(solution);
	b	get_command__epilgoue			# }

get_command__bad_command:				# else {
	li	$v0, 4					#   syscall 4: print_string
	la	$a0, str__get_command__bad_command	#   printf("Bad command");
	syscall

get_command__epilgoue:					# }
	pop	$ra
	end
	jr	$ra					# return;


################################################################################
# .TEXT <print_welcome>
        .text
dump_game_state:
	# Provided
	#
	# Frame:    []
	# Uses:     [$a0, $v0, $t0, $t1, $t2, $t3]
	# Clobbers: [$a0, $v0, $t0, $t1, $t2, $t3]
	#
	# Locals:
	#   - $t0: row
	#   - $t1: col
	#   - $t2: copy of width/height/displayed_clues
	#   - $t3: temporary address calculations
	#
	# Structure:
	#   dump_game_state
	#   -> [prologue]
	#   -> body
	#     -> loop_selected_row__init
	#     -> loop_selected_row__cond
	#     -> loop_selected_row__body
	#       -> loop_selected_col__init
	#       -> loop_selected_col__cond
	#       -> loop_selected_col__body
	#       -> loop_selected_col__step
	#       -> loop_selected_col__end
	#     -> loop_selected_row__step
	#     -> loop_selected_row__end
	#     -> loop_solution_row__init
	#     -> loop_solution_row__cond
	#     -> loop_solution_row__body
	#       -> loop_solution_col__init
	#       -> loop_solution_col__cond
	#       -> loop_solution_col__body
	#       -> loop_solution_col__step
	#       -> loop_solution_col__end
	#     -> loop_solution_row__step
	#     -> loop_solution_row__end
	#     -> loop_clues_vert_row__init
	#     -> loop_clues_vert_row__cond
	#     -> loop_clues_vert_row__body
	#       -> loop_clues_vert_col__init
	#       -> loop_clues_vert_col__cond
	#       -> loop_clues_vert_col__body
	#       -> loop_clues_vert_col__step
	#       -> loop_clues_vert_col__end
	#     -> loop_clues_vert_row__step
	#     -> loop_clues_vert_row__end
	#     -> loop_clues_horiz_row__init
	#     -> loop_clues_horiz_row__cond
	#     -> loop_clues_horiz_row__body
	#       -> loop_clues_horiz_col__init
	#       -> loop_clues_horiz_col__cond
	#       -> loop_clues_horiz_col__body
	#       -> loop_clues_horiz_col__step
	#       -> loop_clues_horiz_col__end
	#     -> loop_clues_horiz_row__step
	#     -> loop_clues_horiz_row__end
	#   -> [epilogue]


dump_game_state__prologue:
	begin

dump_game_state__body:
	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__width
	syscall						# printf("width = ");

	li	$v0, 1					# syscall 1: print_int
	lw	$a0, width				# width
	syscall						# printf("%d", width);

	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__height
	syscall						# printf("height = ");

	li	$v0, 1					# syscall 1: print_int
	lw	$a0, height				# height
	syscall						# printf("%d", height);

	li	$v0, 11					# syscall 11: print_char
	li	$a0, '\n'
	syscall						# printf("%c", '\n');

	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__selected
	syscall						# printf("selected:\n");

dump_game_state__loop_selected_row__init:
	li	$t0, 0					# int row = 0;

dump_game_state__loop_selected_row__cond:		# while (row < height) {
	lw	$t2, height
	bge	$t0, $t2, dump_game_state__loop_selected_row__end

dump_game_state__loop_selected_row__body:
dump_game_state__loop_selected_col__init:
	li	$t1, 0					#   int col = 0;

dump_game_state__loop_selected_col__cond:		#   while (col < width) {
	lw	$t2, width
	bge	$t1, $t2, dump_game_state__loop_selected_col__end

dump_game_state__loop_selected_col__body:
	mul	$t3, $t0, MAX_WIDTH			#     row * MAX_WIDTH
	add	$t3, $t3, $t1				#     row * MAX_WIDTH + col
	add	$t3, $t3, selected			#     selected + row * MAX_WIDTH + col
							#      == &selected[row][col]

	li	$v0, 1					#     syscall 1: print_int
	lb	$a0, ($t3)				#     selected[row][col]
	syscall						#     printf("%d", selected[row][col]);

	li	$v0, 11					#     syscall 11: print_char
	li	$a0, ' '
	syscall						#     printf("%c", ' ');

dump_game_state__loop_selected_col__step:
	addi	$t1, $t1, 1				#     col++;
	b	dump_game_state__loop_selected_col__cond

dump_game_state__loop_selected_col__end:		#   }

	li	$v0, 11					#   syscall 11: print_char
	li	$a0, '\n'
	syscall						#   printf("%c", '\n');

dump_game_state__loop_selected_row__step:
	addi	$t0, $t0, 1				#   row++;
	b	dump_game_state__loop_selected_row__cond

dump_game_state__loop_selected_row__end:		# }


	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__solution
	syscall						# printf("solution:\n");

dump_game_state__loop_solution_row__init:
	li	$t0, 0					# int row = 0;

dump_game_state__loop_solution_row__cond:		# while (row < height) {
	lw	$t2, height
	bge	$t0, $t2, dump_game_state__loop_solution_row__end

dump_game_state__loop_solution_row__body:
dump_game_state__loop_solution_col__init:
	li	$t1, 0					#   int col = 0;

dump_game_state__loop_solution_col__cond:		#   while (col < width) {
	lw	$t2, width
	bge	$t1, $t2, dump_game_state__loop_solution_col__end

dump_game_state__loop_solution_col__body:
	mul	$t3, $t0, MAX_WIDTH			#     row * MAX_WIDTH
	add	$t3, $t3, $t1				#     row * MAX_WIDTH + col
	add	$t3, $t3, solution			#     solution + row * MAX_WIDTH + col
							#      == &solution[row][col]

	li	$v0, 1					#     syscall 1: print_int
	lb	$a0, ($t3)				#     solution[row][col]
	syscall						#     printf("%d", solution[row][col]);

	li	$v0, 11					#     syscall 11: print_char
	li	$a0, ' '
	syscall						#     printf("%c", ' ');

dump_game_state__loop_solution_col__step:
	addi	$t1, $t1, 1				#     col++;
	b	dump_game_state__loop_solution_col__cond

dump_game_state__loop_solution_col__end:		#   }

	li	$v0, 11					#   syscall 11: print_char
	li	$a0, '\n'
	syscall						#   printf("%c", '\n');

dump_game_state__loop_solution_row__step:
	addi	$t0, $t0, 1				#   row++;
	b	dump_game_state__loop_solution_row__cond

dump_game_state__loop_solution_row__end:		# }

	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__clues_vertical
	syscall						# printf("displayed_clues vertical:\n");

dump_game_state__loop_clues_vert_row__init:
	li	$t0, 0					# int row = 0;

dump_game_state__loop_clues_vert_row__cond:		# while (row < MAX_HEIGHT) {
	bge	$t0, MAX_HEIGHT, dump_game_state__loop_clues_vert_row__end

dump_game_state__loop_clues_vert_row__body:
dump_game_state__loop_clues_vert_col__init:
	li	$t1, 0					#   int col = 0;

dump_game_state__loop_clues_vert_col__cond:		#   while (col < MAX_WIDTH) {
	bge	$t1, MAX_WIDTH, dump_game_state__loop_clues_vert_col__end

dump_game_state__loop_clues_vert_col__body:
	mul	$t3, $t1, MAX_HEIGHT			#     col * MAX_HEIGHT
	add	$t3, $t3, $t0				#     col * MAX_HEIGHT + row
	mul	$t3, $t3, SIZEOF_INT			#     4 * (col * MAX_HEIGHT + row)
	lw	$t2, displayed_clues			#     displayed_clues
	add	$t3, $t3, $t2				#     displayed_clues + row * MAX_WIDTH + col
	addi	$t3, CLUE_SET_VERTICAL_CLUES_OFFSET	#     &displayed_clues->vertical_clues[col][row]

	lw	$a0, ($t3)				#     displayed_clues->vertical_clues[col][row]
	li	$v0, 1					#     syscall 1: print_int
	syscall						#     printf("%d", displayed_clues->vertical_clues[col][row]);

	li	$v0, 11					#     syscall 11: print_char
	li	$a0, ' '
	syscall						#     printf("%c", ' ');

dump_game_state__loop_clues_vert_col__step:
	addi	$t1, $t1, 1				#     col++;
	b	dump_game_state__loop_clues_vert_col__cond

dump_game_state__loop_clues_vert_col__end:		#   }

	li	$v0, 11					#   syscall 11: print_char
	li	$a0, '\n'
	syscall						#   printf("%c", '\n');

dump_game_state__loop_clues_vert_row__step:
	addi	$t0, $t0, 1				#   row++;
	b	dump_game_state__loop_clues_vert_row__cond

dump_game_state__loop_clues_vert_row__end:		# }

	li	$v0, 4					# syscall 4: print_string
	li	$a0, str__dump_game_state__clues_horizontal
	syscall						# printf("displayed_clues horizontal:\n");

dump_game_state__loop_clues_horiz_row__init:
	li	$t0, 0					# int row = 0;

dump_game_state__loop_clues_horiz_row__cond:		# while (row < MAX_HEIGHT) {
	bge	$t0, MAX_HEIGHT, dump_game_state__loop_clues_horiz_row__end

dump_game_state__loop_clues_horiz_row__body:
dump_game_state__loop_clues_horiz_col__init:
	li	$t1, 0					#   int col = 0;

dump_game_state__loop_clues_horiz_col__cond:		#   while (col < MAX_WIDTH) {
	bge	$t1, MAX_WIDTH, dump_game_state__loop_clues_horiz_col__end

dump_game_state__loop_clues_horiz_col__body:
	mul	$t3, $t0, MAX_WIDTH			#     row * MAX_HEIGHT
	add	$t3, $t3, $t1				#     row * MAX_HEIGHT + col
	mul	$t3, $t3, SIZEOF_INT			#     4 * (row * MAX_HEIGHT + col)
	lw	$t2, displayed_clues			#     displayed_clues
	add	$t3, $t3, $t2				#     displayed_clues + row * MAX_WIDTH + col
	addi	$t3, CLUE_SET_HORIZONTAL_CLUES_OFFSET	#     &displayed_clues->horizontal_clues[row][col]

	lw	$a0, ($t3)				#     displayed_clues->horizontal_clues[row][col]
	li	$v0, 1					#     syscall 1: print_int
	syscall						#     printf("%d", displayed_clues->horizontal_clues[row][col]);

	li	$v0, 11					#     syscall 11: print_char
	li	$a0, ' '
	syscall						#     printf("%c", ' ');

dump_game_state__loop_clues_horiz_col__step:
	addi	$t1, $t1, 1				#     col++;
	b	dump_game_state__loop_clues_horiz_col__cond

dump_game_state__loop_clues_horiz_col__end:		#   }

	li	$v0, 11					#   syscall 11: print_char
	li	$a0, '\n'
	syscall						#   printf("%c", '\n');

dump_game_state__loop_clues_horiz_row__step:
	addi	$t0, $t0, 1				#   row++;
	b	dump_game_state__loop_clues_horiz_row__cond

dump_game_state__loop_clues_horiz_row__end:		# }

dump_game_state__epilogue:
	end
	jr	$ra					# return;

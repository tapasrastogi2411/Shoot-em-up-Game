#####################################################################
#
# CSCB58 Winter 2021 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Name: Tapas Rastogi, Student Number: 1005734608, UTorID: rastog32
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 256 (update this as needed)

# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4 (choose the one the applies)
#
# Which approved features have been implemented for milestone 4?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.data
obstacles_array: 

.eqv BASE_ADDRESS 0x10008000

.text

drawing_the_obstacles:
	li $t0 BASE_ADDRESS
	li $t1 0xff0000 # The color red
	li $t2, 0x00ff00 # $t2 stores the green colour code
	li $t3, 0x0000ff # $t3 stores the blue colour code
	li $t4, 0xffffff # Color white
	li $t5, 0xffff00 # The color yellow
    
	# Testing out the obstacle
	
	sw $t4, 324($t0) # Top part of the obstacle
	sw $t4, 452($t0) # Middle part of the obstacle
	sw $t4, 456($t0)  # Rightmost part of the type1 of obstacle
	sw $t4, 448($t0) # Leftmost part of the obstacle
	sw $t4, 580($t0) # Bottom most part of the obstacle
	
	sw $t4, 1732($t0)
	sw $t4, 1860($t0) #M Middle part of the obstacle
	sw $t4, 1856($t0)
	sw $t4, 1864($t0)
	sw $t4, 1988($t0)
	
	sw $t4, 3264($t0)
	sw $t4, 3268($t0)  # Middle part of the obstacle
	sw $t4, 3140($t0)
	sw $t4, 3396($t0)
	sw $t4, 3272($t0)
    
        # Drawing the ship 
        sw $t3, 20($t0)
        sw $t3, 24($t0)
        sw $t3, 148($t0)
        sw $t3, 152($t0)
        sw $t5, 144($t0)
        sw $t5, 156($t0)
        sw $t3, 276($t0)
        sw $t3, 280($t0)
        

   
        
        
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, keypress_happened

keypress_happened: lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before
		   #beq $t2, 0x61, respond_to_a # ASCII code of 'a' is 0x61 or 97 in decimal

resopond_to_a: 
	li $v0, 10
	syscall





		
    

      
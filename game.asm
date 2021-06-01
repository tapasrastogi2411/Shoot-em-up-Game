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
# - Milestone 1 and Milestone 2  only unfortunately :(
#
# Which approved features have been implemented for milestone 4?
# NONE :( Could only complete Milestone 1 and 2 completely :(
#
# Link to video demonstration for final submission:
# Link: https://youtu.be/lp3Lp8bR9k0
#
# Are you OK with us sharing the video with people outside course staff?
# - Yes, I am okay with that
# - However, I dont think it will be of much use, since I couldnt complete the project completely :(
#
# Any additional information that the TA needs to know:
# - Milestones 1 and 2 have been fully completed
# - Milestone 3 and 4 are incomplete
# - The random number generator part of the obstacle movement is incomplete - meaning that obstacles go
#   off the frame 
#####################################################################

.data
obstacles_array: .word 0:3
ship_array: .word 0:1

.eqv BASE_ADDRESS 0x10008000
.eqv WAIT_TIME 40
.eqv RED_COLOR 0xff0000
.eqv BLUE_COLOR 0x0000ff
.eqv WHITE_COLOR 0xffffff 
.eqv BLACK_COLOR 0x000000
.eqv BOUNDARY_PIXEL 29
.eqv DIVISION_MODULO_DIVIDER 28
.eqv WIDTH_OF_MAP 32
.eqv X_COORDINATE_OF_OBS 30

.text

li $t0 BASE_ADDRESS

restarting_and_redrawing_everything:
        drawing_the_ship:   
                li $t4, BLUE_COLOR   
                la $t5, ship_array
        
                # The initialisation statements
                lw $t6, 0($t5)
                add $t6, $t6, $t0
        
                # The color filling statements 
                sw $t4, 0($t6)
                sw $t4, 4($t6) 
                sw $t4, 128($t6)
                sw $t4, 132($t6) 
        
        drawing_the_obstacles:

                li $t4, WHITE_COLOR   
                li $t7, RED_COLOR
                la $t3, obstacles_array
        
                # The initialisation statements
                lw $t9, 0($t3)
                add $t9, $t9, $t0
                
                # X - 30, Y - Random, put calculation in t9
                
                # Here we go back to the right end and redraw the moving obstacles - RANDOM GENERATION
                li $v0, 42
                li $a0, 0 # s1 register contains the randomly generated number - Y coordinate
                
                li $a1, 30
                syscall 
                
                # HERE WE START CALCULATING THE ADDRESS ->
                li $s3, WIDTH_OF_MAP 
       
                mult $a0, $s3
                mflo $a0
        
                li $s3, 29 #29
                add $a0, $a0, $s3
        
                li $s3, 4
                mult $a0, $s3
                mflo $a0
        
                # We have the address at this point
         
                add $t9, $a0, $t0 # adding base address
                
                #oobstacles[0] = $a0
        	sw $a0, 0($t3)
        
                # Obstacle number 1
                sw $t7, 0($t9) # Middle part of the obstacle
	        sw $t7, -128($t9) # Top part of the obstacle
	        sw $t7, 4($t9)  # Right of the middle
	        sw $t7, -4($t9) 
	        sw $t7, 128($t9)

	        # Obstacle number 2
                #sw $t4, 0($t9) # Middle part of the obstacle
	        #sw $t4, -128($t9) # Top part of the obstacle
	        #sw $t4, 1856($t9)
	        #sw $t4, 1864($t9)
	        #sw $t4, 1988($t9)
	 
		# Obstacle number 3
		#sw $t4, 3264($t9)
		#sw $t4, 0($t9)  # Middle part of the obstacle
		#sw $t4, -128($t9)  # Top part of the obstacle
		#sw $t4, 3396($t9)	
		#sw $t4, 3272($t9)

main_loop:
       
       # Wait system call to slow the game down
        li $v0, 32
        li $a0, WAIT_TIME 
        syscall
         
        # Moving obstacle 1
	jal moving_obstacle_1
	
	# Moving obstacle 2
	#jal moving_obstacle_2
	
	# Moving obstacle_3
	#jal moving_obstacle_3
        
        # Checking for keyboard input
        li $t1, 0xffff0000
	lw $t2, 0($t1)
	beq $t2, 1, keypress_happened

	j main_loop

keypress_happened: lw $t8, 4($t1) # this assumes $t1 is set to 0xfff0000 from before
		   beq $t8, 0x61, respond_to_a # ASCII code of 'a' is 0x61 or 97 in decimal
		   beq $t8, 0x77, respond_to_w # ASCII code of 'w' is 0x77
		   beq $t8, 0x73, respond_to_s # ASCII code of 's' is 0x73
		   beq $t8, 0x64, respond_to_d # ASCII code of 'd is 0x64
		   beq $t8, 0x70, respond_to_p # ASCII code of 'p' is 0x70 - RESTARTING THE GAME
		   j main_loop
		   
respond_to_d:

        la $t9, 0($t5)
        lw $t7, 0($t9)
        li $s2, 128 
        
        div $t7, $s2
        mflo $s2             #y  coordinate
        mfhi $t9             #x coordiante
        
        beq $t9, 120, respond_to_a
        
        li $t4, BLACK_COLOR # Erasing the ship using black pixels
        
        # The initialisation statements
        lw $t6, 0($t5)
        add $t7, $t6, $t0
        
        sw $t4, 0($t7)
        sw $t4, 4($t7)
        sw $t4, 128($t7)
        sw $t4, 132($t7)
        
        # Redrawing the ship using blue color
        li $t4, BLUE_COLOR
        
        # Initialisation statement
        addi $t6, $t6, 4
        addi $t7, $t7, 4
        sw $t6, 0($t5)
        
        sw $t4, 0($t7) # Updating the ship's location here
        sw $t4, 4($t7)
        sw $t4, 128($t7)
        sw $t4, 132($t7)
    
        j main_loop
        
respond_to_a: 

        la $t9, 0($t5)
        lw $t7, 0($t9)
        li $s2, 128 
        
        div $t7, $s2
        mflo $s2             #y  coordinate
        mfhi $t9             #x coordiante
        
        beqz $t9, respond_to_d
        
        li $t4, BLACK_COLOR # Erasing the ship using black pixels     
        
        # The initialisation statements
        lw $t6, 0($t5)
        add $t7, $t6, $t0
        
        sw $t4, 0($t7)
        sw $t4, 4($t7)
        sw $t4, 128($t7)
        sw $t4, 132($t7)
        
        # Redrawing the ship using blue color
        li $t4, BLUE_COLOR
        
        # Initialisation statement
        addi $t6, $t6, -4
        addi $t7, $t7, -4
        sw $t6, 0($t5)
        
        sw $t4, 0($t7) # Updating the ship's location here
        sw $t4, 4($t7)
        sw $t4, 128($t7) 
        sw $t4, 132($t7)
        
        j main_loop
        
               
respond_to_w:

        # Need an if condition to account for ship not going off boundaries
        
        # Need to calculate the 'y' coordinate value for this ship first,
        #which will by top most pixel divided by 128
        
        la $t9, 0($t5)
        lw $t7, 0($t9)
        li $s2, 128 
        
        div $t7, $s2
        mflo $s2             #y  coordinate
        mfhi $t9             #x coordiante
        
        beqz $s2, respond_to_s
        

        # At this point 0($t7) stores the top most left pixel is in 0($t7), which we have to divide by 128 and 
        # Store the result back in 0($t7)
        
        # div $s1, $s0
        # mflo $s1

        li $t4, BLACK_COLOR # Erasing the ship using black pixels
        
        # The initialisation statements
        lw $t6, 0($t5)
        add $t7, $t6, $t0
        
        sw $t4, 0($t7)
        sw $t4, 4($t7)
        sw $t4, 128($t7)
        sw $t4, 132($t7)
        
        # Redrawing the ship using blue color
        li $t4, BLUE_COLOR
        
        # Initialisation statement
        addi $t6, $t6, -128
        addi $t7, $t7, -128  
        sw $t6, 0($t5) 
        
        sw $t4, 0($t7) # Updating the ship's location here
        sw $t4, 4($t7)
        sw $t4, 128($t7)
        sw $t4, 132($t7)
        
        j main_loop
        
respond_to_s:

        la $t9, 0($t5)
        lw $t7, 0($t9)
        li $s2, 128 
        
        div $t7, $s2 
        mflo $s2             #y  coordinate
        mfhi $t9             #x coordiante
        
        beq $s2, 29, respond_to_w
        
        li $t4, BLACK_COLOR # Erasing the ship using black pixels
        
        # The initialisation statements
        lw $t6, 0($t5)
        add $t7, $t6, $t0
        
        sw $t4, 0($t7)
        sw $t4, 4($t7)
        sw $t4, 128($t7)
        sw $t4, 132($t7)
        
        # Redrawing the ship using blue color
        li $t4, BLUE_COLOR
        
        # Initialisation statement
        addi $t6, $t6, 128
        addi $t7, $t7, 128
        sw $t6, 0($t5)
        
        sw $t4, 0($t7) # Updating the ship's location here
        sw $t4, 4($t7)
        sw $t4, 128($t7)
        sw $t4, 132($t7)
         
        j main_loop
        

respond_to_p:
        
 	li $t4, BLACK_COLOR   
        la $t5, ship_array
        
        # The initialisation statements
        lw $t6, 0($t5)
        add $t6, $t6, $t0
        
        # The color filling statements 
        sw $t4, 0($t6)
        sw $t4, 4($t6) 
        sw $t4, 128($t6)
        sw $t4, 132($t6) 
        
        

        li $t4, BLACK_COLOR   
        la $t3, obstacles_array
        
        # The initialisation statements
        lw $t9, 0($t3)
        add $t9, $t9, $t0
        
        # Obstacle number 1
        sw $t4, 452($t9) # Middle part of the obstacle
	sw $t4, 324($t9) # Top part of the obstacle
	sw $t4, 456($t9)  
	sw $t4, 448($t9) 
	sw $t4, 580($t9)

	# Obstacle number 2
        sw $t4, 1860($t9) # Middle part of the obstacle
        sw $t4, 1732($t9) # Top part of the obstacle
	sw $t4, 1856($t9)
	sw $t4, 1864($t9)
	sw $t4, 1988($t9)
	 
	# Obstacle number 3
	sw $t4, 3264($t9)
	sw $t4, 3268($t9)  # Middle part of the obstacle
	sw $t4, 3140($t9)  # Top part of the obstacle
	sw $t4, 3396($t9)	
	sw $t4, 3272($t9)

        j restarting_and_redrawing_everything
	
moving_obstacle_1:
	la $t3, obstacles_array
        lw $t7, 0($t3) #t3 is the obstacles array
        li $s2, 128 
        
        # Calculating the y-coordinate        
        div $t7, $s2
        mflo $s2             #y  coordinate

        
        beqz $t9, jump_back_to_right_and_repeat # This means x == 0 and we have go right and repeat
         
        li $t4, BLACK_COLOR # Erasing the obstacle using black pixels
        
        # The initialisation statements 
        la $t3, obstacles_array
        lw $t9, 0($t3)
        add $t8, $t9, $t0
        
        sw $t4, 0($t8) # Middle part of the obstacle
	sw $t4, -128($t8) # Top part of the obstacle
	sw $t4, 4($t8)  
	sw $t4, -4($t8) 
	sw $t4, 128($t8)
	
	li $t4, 4
	div $t7, $t4
	mflo $t9
	li $t4, 32
	div $t9, $t4
	mfhi $t9             #x coordinate
	# beqz $t9, redraw_obstacle_1
        
        # We simply draw now
        # Redrawing the obstacle using white color
        li $t4, RED_COLOR
        
        # Initialisation statement
        la $t3, obstacles_array
        lw $t9, 0($t3) #t3 is the obstacles array
        
        
        addi $t9, $t9, -4
        addi $t8, $t8, -4
        
        #obastacles[0] = $t9
        sw $t9, 0($t3)
        
        #add $t8, $t9, $t0
        sw $t4, 0($t8) # Middle part of the obstacle
	sw $t4, -128($t8) # Top part of the obstacle
	sw $t4, 4($t8)  
	sw $t4, -4($t8) 
	sw $t4, 128($t8)
	
	
	
	
	
	# Since we have moved the obstacle to the left, at every such point we need to check for collision
	# Avaailbale registers for collision - s6, s7, s0
	
	la $s0, 0($t5) # t5 is my ship array variable holder 
	lw $s6, 0($s0)
	addi $s6, $s6, 132 # Get the bottom most right pixel of ship 
	
	la $s0, 0($t3) #t3 is my obstacle array
	lw $s7, 0($s0)
	addi $s7, $s7, 448 # Get the Middle left most pixel of my obstacle shaped like a 'plus'
	
	#DEBUG
	#add $s7, $s7, $t0
	#li $t4, BLUE_COLOR
	#sw $t4, 0($s7) 
	
	#add $s6, $s6, $t0  
	#li $t4, RED_COLOR
	#sw $t4, 0($s6)
	
	#j collision 
	
	beq $s6, $s7, collision # There has been a collision and I need to update the position to the left
	
	
        jr $ra
 
 redraw_obstacle_1:
 
        la $t9, 0($t3) #t3 is the obstacles array
        lw $t7, 0($t9)
        li $s2, 128 
        
        # Calculating the y-coordinate of the obstacle
        div $t7, $s2
        mflo $s2             #y  coordinate
      
        mult $s2, $s3
        mflo $s2
        
        li $s3, 30 #30
        add $s2, $s2, $s3
        
        li $s3, 4
        mult $s2, $s3
        mflo $s2
        
         # So s2 register has the final calculated address 
         
         add $s2, $s2, $t0 # adding base address
         
         li $s3, RED_COLOR 
         li $s6, WHITE_COLOR   
         
         
         sw $s3, 0($s2) # Middle part of the obstacle
	 sw $s3, -128($s2) # Top part of the obstacle
	 sw $s3, 4($s2)  
	 sw $s3, -4($s2) 
	 sw $s3, 128($s2)
	 
	 jr $ra
         
         
                
jump_back_to_right_and_repeat:
         
        # Here we go back to the right end and redraw the moving obstacles
        li $v0, 42
        li $s1, 0 # s1 register contains the randomly generated number - Y coordinate
        li $a1, 31
        syscall 
        
        # Lower bound
        li $t1, 2
        blt $s1	, $t1, jump_back_to_right_and_repeat
        
        li $s3, X_COORDINATE_OF_OBS  # 30
        li $s4, WIDTH_OF_MAP # 32
        li $s5, 4
        
        # Using the address formula here: (y * 32 + x ) * 4
        mult $s1, $s4
        mflo $s1
        
        add $s1, $s1, $s2
        
        mult $s1, $s5
        mflo $s1
        
        # Register s1 contains this address that I wanted to calculate 
        
        li $t4, BLACK_COLOR # Erasing the obstacle using black pixels
        
        # The initialisation statements 
        la $t3, obstacles_array
        lw $t9, 0($t3)
        add $t8, $t9, $t0
        
        sw $t4, 452($t8) # Middle part of the obstacle
	sw $t4, 324($t8) # Top part of the obstacle
	sw $t4, 456($t8)  
	sw $t4, 448($t8) 
	sw $t4, 580($t8)
	
	# Redrawing the obstacle at the right end using x == 30 and y as the random generated value
	li $t4, WHITE_COLOR
	
	add $s1, $s1, $t0 # Register s1 is my new position
        sw $t4, 0($s1)
	
	addi $t9, $t9, -4
        addi $t8, $t8, -4 
        sw $t9,4($t3)
        
        jr $ra
           
moving_obstacle_2:

        li $t4, BLACK_COLOR # Erasing the obstacle using black pixels
        
        # The initialisation statements
        #add $t3, $t3, -8
        #add $t9, $t9, -8
        la $t3, obstacles_array
        lw $t9, 4($t3)
        add $t8, $t9, $t0
        
        sw $t4, 1860($t8) # Middle part of the obstacle
	sw $t4, 1732($t8) # Top part of the obstacle
	sw $t4, 1856($t8)
	sw $t4, 1864($t8)
	sw $t4, 1988($t8)  
         
        # Redrawing the obstacle using white color
        li $t4, WHITE_COLOR
        
        # Initialisation statement
        addi $t9, $t9, -4
        addi $t8, $t8, -4 
        sw $t9,4($t3)
        
        sw $t4, 1860($t8) # Middle part of the obstacle
	sw $t4, 1732($t8) # Top part of the obstacle
	sw $t4, 1856($t8)
	sw $t4, 1864($t8)
	sw $t4, 1988($t8)
	
	
	# Since we have moved the obstacle to the left, at every such point we need to check for collision
	# Avaailbale registers for collision - s6, s7, s0
	
	la $s0, 0($t5) # t5 is my ship array variable holder 
	lw $s6, 0($s0)
	addi $s6, $s6, 132 # Get the bottom most right pixel of ship 
	
	la $s0, 4($t3) #t3 is my obstacle array
	lw $s7, 0($s0)
	addi $s7, $s7, 1856 # Get the Middle left most pixel of my obstacle shaped like a 'plus'
	
	beq $s6, $s7, collision # There has been a collision and I need to update the position to the left
	
        jr $ra
        
moving_obstacle_3:
        li $t4, BLACK_COLOR # Erasing the obstacle using black pixels
        
        # The initialisation statements
        #add $t3, $t3, -8
        #add $t9, $t9, -8
        la $t3, obstacles_array
        lw $t9, 8($t3)
        add $t8, $t9, $t0
        
	sw $t4, 3264($t8)
	sw $t4, 3268($t8)  # Middle part of the obstacle
	sw $t4, 3140($t8)  # Top part of the obstacle
	sw $t4, 3396($t8)	
	sw $t4, 3272($t8)
         
        # Redrawing the obstacle using white color
        li $t4, WHITE_COLOR
        
        # Initialisation statement
        addi $t9, $t9, -4
        addi $t8, $t8, -4 
        sw $t9,8($t3)
        
        sw $t4, 3264($t8)
	sw $t4, 3268($t8)  # Middle part of the obstacle
	sw $t4, 3140($t8)  # Top part of the obstacle
	sw $t4, 3396($t8)	
	sw $t4, 3272($t8)

	la $s0, 0($t5) # t5 is my ship array variable holder 
	lw $s6, 0($s0)
	addi $s6, $s6, 132 # Get the bottom most right pixel of ship 
	
	la $s0, 8($t3) #t3 is my obstacle array
	lw $s7, 0($s0)
	addi $s7, $s7, 3264 # Get the Middle left most pixel of my obstacle shaped like a 'plus'
	
	#DEBUG
	#add $s7, $s7, $t0
	#li $t4, BLUE_COLOR
	#sw $t4, 0($s7)
	
	#add $s6, $s6, $t0
	#li $t4, RED_COLOR
	#sw $t4, 0($s6)
	
	 
	beq $s6, $s7, collision # There has been a collision and I need to update the position to the left

        jr $ra 
         
collision:
        

        li $t4, RED_COLOR       
        # Update the position of the obstacle to the left
        la $s6, 0($t5) # t5 is my ship array holder
        lw $s0, 0($s6)
        add $s0, $s0, $t0
        # add $s2, $s2, 4
        # sw $s2, 0($t5)
                 
        #The color filling statements, INDICATING A COLLISION
        sw $t4, 0($s0)
        sw $t4, 4($s0)  
        sw $t4, 128($s0)
        sw $t4, 132($s0)   
        
        li $v0, 32
        li $a0, 1000 # Wait one second (1000 milliseconds)
        syscall 
        
        li $t4, BLUE_COLOR
        sw $t4, 0($s0)
        sw $t4, 4($s0)  
        sw $t4, 128($s0)
        sw $t4, 132($s0) 
            
        
        j main_loop
        
# V4 now :)

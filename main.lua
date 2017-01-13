--[[
    Löve2D Tutorial:
    Baseline 2D Platformer
]]
local blocks = {}
blocks.platform = {}
blocks.platform2 = {}
blocks.platform3 = {}
player = {}
local found = false
local hit = false
local newy = 0
local oldy = 0
local ff = false

function love.load()
        -- This is the height and the width of the platform.
	blocks.platform.width = love.graphics.getWidth()    -- This makes the platform as wide as the whole game window.
	blocks.platform.height = love.graphics.getHeight()  -- This makes the platform as tall as the whole game window.

        -- This is the coordinates where the platform will be rendered.
	blocks.platform.x = 0                               -- This starts drawing the platform at the left edge of the game window.
	blocks.platform.y = blocks.platform.height / 2             -- This starts drawing the platform at the very middle of the game window
    -- This is the height and the width of the platform.
  blocks.platform2.width = 200    -- This makes the platform as wide as the whole game window.
  blocks.platform2.height = 10  -- This makes the platform as tall as the whole game window.

    -- This is the coordinates where the platform will be rendered.
  blocks.platform2.x = 0                               -- This starts drawing the platform at the left edge of the game window.
  blocks.platform2.y = blocks.platform.height / 2.5             -- This starts drawing the platform at the very middle of the game window

	blocks.platform3.width = 50
	blocks.platform3.height = 50
	blocks.platform3.x = 300
	blocks.platform3.y = blocks.platform.height / 2.3
  -- This is the coordinates where the player character will be rendered.
	player.x = love.graphics.getWidth() / 2   -- This sets the player at the middle of the screen based on the width of the game window.
	player.y = love.graphics.getHeight() / 2  -- This sets the player at the middle of the screen based on the height of the game window.

        -- This calls the file named "purple.png" and puts it in the variable called player.img.
	player.img = love.graphics.newImage('Assets/Sprites/Player/purple.png')
  player.speed = 200
	player.width = player.img:getWidth()
	player.height = player.img:getHeight()
  player.ground = player.y
  player.y_velocity = 0
  player.jump_height = -300
  player.gravity = -500
end

function love.update(dt)
  if love.keyboard.isDown('d') and player.x < (love.graphics.getWidth() - player.img:getWidth()) then
		for each, block in pairs(blocks) do
			if player.x+player.width < block.x and (player.x + (player.speed*dt))+player.width > block.x and player.y > block.y and player.y <= block.y+block.height then
				ff = true
			end
		end
		if not ff then
		  player.x = player.x + (player.speed * dt)
		else
			ff = false
		end
		if player.y_velocity == 0 then
			for each, block in pairs(blocks) do
	      if ((player.x >= block.x and player.x < (block.x + block.width)) or (player.x+player.width >= block.x and player.x+player.width < (block.x+block.width))) and player.y >= block.y and player.y < block.y+block.height then    -- The game checks if the player has jumped.
					found = true
					break
				else
					found = false
	      end
	    end
			if not found then
				player.y_velocity = 300
			else
				found = false
			end
		end
  end
  if love.keyboard.isDown('a') and player.x > 0 then
		for each, block in pairs(blocks) do
			if player.x > block.x+block.width and player.x - (player.speed*dt) < block.x+block.width and player.y > block.y and player.y <= block.y+block.height then
				ff = true
			end
		end
		if not ff then
		  player.x = player.x - (player.speed * dt)
		else
			ff = false
		end
		if player.x < 0 then player.x = 0 end
		if player.y_velocity == 0 then
			for each, block in pairs(blocks) do
	      if ((player.x >= block.x and player.x < (block.x + block.width)) or (player.x+player.width >= block.x and player.x+player.width < (block.x+block.width))) and player.y >= block.y and player.y < block.y+block.height then    -- The game checks if the player has jumped.
					found = true
					break
				else
					found = false
	      end
	    end
			if not found then
				player.y_velocity = 300
			else
				found = false
			end
		end
  end
  if love.keyboard.isDown('space') then
    if player.y_velocity == 0 then
      player.y_velocity = player.jump_height
      oldy = player.y
			newy = 0
			found = false
			hit = false
    end
  end

  -- This is in charge of the jump physics.

  if player.y_velocity < 0 then                                -- The game checks if player has "jumped" and left the ground.
		--check every block in the game for a collision from underneath, if it does, set the velocity to a positive value
    for each, block in pairs(blocks) do
      if player.x >= block.x and player.x < (block.x + block.width) and (player.y+player.y_velocity*dt) <= block.y+block.height+18 and not (player.y < block.y or player.y == block.y ) then
				player.y_velocity = 300
				--player.y = player.y + player.y_velocity * dt
        return
      end
    end
		--if no collision was detected
    player.y = player.y + player.y_velocity * dt                -- This makes the character ascend/jump.
  	player.y_velocity = player.y_velocity - player.gravity * dt -- This applies the gravity to the character.
	elseif player.y_velocity > 0 then
		--check every block in the game for a collision from above, if it does, set the velocity to zero and set the new position
		for each, block in pairs(blocks) do
      if ((player.x >= block.x and player.x < (block.x + block.width)) or (player.x+player.width >= block.x and player.x+player.width < (block.x+block.width))) and player.y > block.y and player.y < block.y+block.height then    -- The game checks if the player has jumped.
        player.y_velocity = 0
				player.y = block.y
        return
      end
    end
		--if no collision was detected
		player.y = player.y + player.y_velocity * dt
		player.y_velocity = player.y_velocity - player.gravity * dt
  end
end

function love.draw()
	love.graphics.setColor(255, 255, 255)        -- This sets the platform color to white. (The parameters are in RGB Color format).

        -- The platform will now be drawn as a white rectangle while taking in the variables we declared above.
	love.graphics.rectangle('fill', blocks.platform.x, blocks.platform.y, blocks.platform.width, blocks.platform.height)
  -- This draws the player.
	love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, 0, 32)

  love.graphics.setColor(100, 0, 244)
  love.graphics.rectangle('fill', blocks.platform2.x, blocks.platform2.y, blocks.platform2.width, blocks.platform2.height)
	love.graphics.rectangle('fill', blocks.platform3.x, blocks.platform3.y, blocks.platform3.width, blocks.platform3.height)
end

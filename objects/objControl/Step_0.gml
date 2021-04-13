/// @description Update Game
if (menuShow)
{
	if ((!menu && mouse_check_button_pressed(mb_any)) || (menu && (mouse_check_button_pressed(mb_middle) || mouse_check_button_pressed(mb_right))))
	{
		if (menu) minefield_create();
		menuShow = false;
		menuClosed = true;
	}
	exit
}
if (mouse_check_button_pressed(mb_middle))
{
	menu = 1;
	menuShow = true;
}
if (keyboard_check_pressed(ord("R")) && !start)
{
	minefield_create();
	audio_play_sound(sndTick, 0, false);
}
if (mouse_check_button_released(mb_left))
{
	if (menuClosed)
	{
		menuClosed = false;
		exit
	}
	if (dead)
	{
		minefield_create();
		audio_play_sound(sndTick, 0, false);
		exit
	}
	var mouseX = floor(mouse_x / 16), mouseY = floor(mouse_y / 16), getTile = minefield[# mouseX, mouseY], goodStart = true;
	if (revealed[# mouseX, mouseY] == revealTypes.flag) exit
	if (getTile == mineTypes.mine)
	{
		if (start)
		{
			while (minefield[# mouseX, mouseY] == mineTypes.mine) minefield_create();
			minefield_reveal_tile(mouseX, mouseY);
			goodStart = false;
			start = false;
		}
		if (goodStart)
		{
			audio_play_sound(sndBoom, 0, false);
			revealed[# mouseX, mouseY] = revealTypes.mine;
			for (var i = 0, j; i < width; i++) for (j = 0; j < height; j++)
			{
				var getRevealed = revealed[# i, j];
				if (minefield[# i, j] == mineTypes.mine)
				{
					if (getRevealed == revealTypes.mine || getRevealed == revealTypes.flag) continue
					revealed[# i, j] = revealTypes.open;
				}
				else if (getRevealed == revealTypes.flag) revealed[# i, j] = revealTypes.misplaced;
			}
			dead = true;
			exit
		}
	}
	else if (getTile == mineTypes.item)
	{
		start = false;
		minefield[# mouseX, mouseY] = mineTypes.empty + minefield_has_mine(mouseX - 1, mouseY - 1) + 
														minefield_has_mine(mouseX, mouseY - 1) + 
														minefield_has_mine(mouseX + 1, mouseY - 1) + 
														minefield_has_mine(mouseX - 1, mouseY) + 
														minefield_has_mine(mouseX + 1, mouseY) + 
														minefield_has_mine(mouseX - 1, mouseY + 1) + 
														minefield_has_mine(mouseX, mouseY + 1) + 
														minefield_has_mine(mouseX + 1, mouseY + 1);
		instance_create_depth(floor(mouseX) * 16, floor(mouseY) * 16, -1, objItem);
		revealed[# mouseX, mouseY] = revealTypes.open;
	}
	else
	{
		start = false;
		var getRevealed = revealed[# mouseX, mouseY];
		if (getRevealed == revealTypes.mark || (getRevealed == revealTypes.closed && getTile > 0 && getTile < 9)) revealed[# mouseX, mouseY] = revealTypes.open;
		else
		{
			minefield_reveal_tile(mouseX, mouseY);
			revealed[# mouseX, mouseY] = revealTypes.open;
		}
	}
	minefield_check_win();
}
if (mouse_check_button_pressed(mb_right) && !dead)
{
	var mouseX = floor(mouse_x / 16), mouseY = floor(mouse_y / 16), newRevealType;
	if (revealed[# mouseX, mouseY] == revealTypes.open) exit
	start = false;
	switch (revealed[# mouseX, mouseY])
	{
		case (revealTypes.closed):
			newRevealType = revealTypes.flag;
			minesLeft--;
		break
		case (revealTypes.flag):
			if (marks) newRevealType = revealTypes.mark;
			else
			{
				newRevealType = revealTypes.closed;
				minesLeft++;
			}
		break
		case (revealTypes.mark):
			newRevealType = revealTypes.closed;
			minesLeft++;
		break
	}
	revealed[# mouseX, mouseY] = newRevealType;
}
if (!start && !dead) time += delta_time;
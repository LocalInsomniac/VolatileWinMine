/// @description Draw Game
if (menuShow)
{
	draw_set_font(fntMain);
	draw_set_color(c_white);
	if (menu)
	{
		//Options
		for (var i = 0, divide = room_width / 3, xx, text; i < 3; i++)
		{
			xx = i * divide;
			draw_rectangle(xx + 2, 2, xx + divide - 2, 16, true);
			switch (i)
			{
				case (1): text = "Normal"; break
				case (2): text = "Hard"; break
				default: text = "Easy";
			}
			draw_text(xx + 4, 2, text);
			if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, xx + 2, 2, xx + divide - 2, 16)) switch (i)
			{
				case (1):
					width = 16;
					height = 16;
					mines = 40;
					items = 20;
				break
				case (2):
					width = 30;
					height = 16;
					mines = 99;
					items = 45;
				break
				default:
					width = 9;
					height = 9;
					mines = 10;
					items = 5;
			}
		}
		draw_text(4, 18, "Width: " + string(width) + " tiles\nHeight: " + string(height) + " tiles\nMines: " + string(mines) + " tiles\nMax. Item Boxes: " + string(items) + "\n\nMiddle/Right click to exit");
		draw_rectangle(2, room_height - 48, room_width - 2, room_height - 34, true);
		draw_text(4, room_height - 48, "Custom Field (Experimental)");
		if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, 2, room_height - 48, room_width - 2, room_height - 34))
		{
			width = get_integer("Width in tiles: ", width);
			height = get_integer("Width in tiles: ", height);
			mines = get_integer("Mines: ", mines);
			items = get_integer("Maximum item box amount: ", items);
		}
		draw_rectangle(2, room_height - 32, room_width - 2, room_height - 18, true);
		draw_text(4, room_height - 32, "Marks (?): " + (marks ? "On" : "Off"));
		if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, 2, room_height - 32, room_width - 2, room_height - 18))
		{
			marks = !marks;
			ini_write_real("Volatile WinMine", "Marks", marks);
		}
		draw_rectangle(2, room_height - 16, room_width - 2, room_height - 2, true);
		draw_text(4, room_height - 16, "Display Size: " + ((scale - 1) ? "2x" : "1x"));
		if (mouse_check_button_pressed(mb_left) && point_in_rectangle(mouse_x, mouse_y, 2, room_height - 16, room_width - 2, room_height - 2))
		{
			scale = 1 + !(scale - 1);
			ini_write_real("Volatile WinMine", "Scale", scale);
		}
	}
	else
	{
		//Credits
		draw_sprite_tiled(sprTile, 0, 0, 0);
		var xHalf = room_width * 0.5, yHalf = room_height * 0.5;
		draw_rectangle(xHalf - 56, yHalf - 56, xHalf + 56, yHalf + 56, false);
		draw_set_color(c_black);
		draw_rectangle(xHalf - 56, yHalf - 56, xHalf + 56, yHalf + 56, true);
		draw_sprite(sprTile, 32, xHalf - 46, yHalf - 54);
		draw_text(xHalf - 27, yHalf - 52, "Volatile WinMine");
		draw_text(xHalf - 52, yHalf - 39, "Made by Can't Sleep\nSpecial TY to FunBaseAlpha\nMinesweeper by Microsoft\n\n[MOUSE CONTROLS]\nLeft = Reveal Tile\nRight = Flag Tile\nMiddle = Options");
		draw_set_color(c_white);
	}
}
else
{
	for (var i = 0, j, xx, yy, tile, step; i < width; i++)
		for (j = 0; j < height; j++)
		{
			xx = i * 16;
			yy = j * 16;
			tile = 0;
			step = !menuClosed && !dead && point_in_rectangle(mouse_x, mouse_y, xx, yy, xx + 15, yy + 15) && mouse_check_button(mb_left);
			switch (revealed[# i, j])
			{
				case (revealTypes.mark): tile = 3;
				case (revealTypes.closed): tile += step; break
				case (revealTypes.open):
					var getTile = minefield[# i, j];
					switch (getTile)
					{
						case (mineTypes.one):
						case (mineTypes.two):
						case (mineTypes.three):
						case (mineTypes.four):
						case (mineTypes.five):
						case (mineTypes.six):
						case (mineTypes.seven):
						case (mineTypes.eight): tile = 7 + getTile; break
						case (mineTypes.mine): tile = 5; break
						case (mineTypes.item): tile = 16 + (current_time * 0.01) mod (5) + step * 5; break
						default: tile = 1;
					}
				break
				case (revealTypes.flag): tile = 2; break
				case (revealTypes.mine): tile = 6; break
				case (revealTypes.misplaced): tile = 7; break
			}
			draw_sprite(sprTile, tile, xx, yy);
		}
	draw_sprite(sprTile, 32, 0, room_height - 20);
	draw_set_color(c_white);
	draw_text(16, room_height - 20, string(minesLeft));
	draw_sprite(sprTile, 33, 64, room_height - 20);
	draw_text(80, room_height - 20, time / 1000000);
}
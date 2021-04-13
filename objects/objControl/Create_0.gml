/// @description Start Game
//Make minefield
enum mineTypes
{
	empty,
	one,
	two,
	three,
	four,
	five,
	six,
	seven,
	eight,
	mine,
	item
}
enum revealTypes
{
	closed,
	open,
	flag,
	mark,
	mine,
	misplaced
}
ini_open("VolatileWinMine.ini");
menu = 0;
menuShow = true;
menuClosed = false;
width = 9;
height = 9;
mines = 10;
items = 5;
marks = ini_read_real("Volatile WinMine", "Marks", false);
scale = ini_read_real("Volatile WinMine", "Display Scale", 1);
minefield = ds_grid_create(width, height);
revealed = ds_grid_create(width, height);
function minefield_create()
{
	start = true;
	dead = false;
	time = 0;
	minesLeft = mines;
	randomize();
	ds_grid_resize(revealed, width, height);
	ds_grid_resize(minefield, width, height);
	ds_grid_set_region(revealed, 0, 0, width - 1, height - 1, revealTypes.closed);
	ds_grid_set_region(minefield, 0, 0, width - 1, height - 1, mineTypes.empty);
	repeat (mines) minefield[# irandom(width - 1), irandom(height - 1)] = mineTypes.mine;
	var i, j, getTile, itemPos;
	for (i = 0; i < width; i++) for (j = 0; j < height; j++)
	{
		getTile = minefield[# i, j];
		if (getTile == mineTypes.mine || getTile == mineTypes.item) continue
		minefield[# i, j] = mineTypes.empty + minefield_has_mine(i - 1, j - 1) + 
											  minefield_has_mine(i, j - 1) + 
											  minefield_has_mine(i + 1, j - 1) + 
											  minefield_has_mine(i - 1, j) + 
											  minefield_has_mine(i + 1, j) + 
											  minefield_has_mine(i - 1, j + 1) + 
											  minefield_has_mine(i, j + 1) + 
											  minefield_has_mine(i + 1, j + 1);
	}
	repeat (irandom(items))
	{
		itemPos = [irandom(width - 1), irandom(height - 1)];
		while (minefield[# itemPos[0], itemPos[1]] == mineTypes.mine) itemPos = [irandom(width - 1), irandom(height - 1)];
		minefield[# itemPos[0], itemPos[1]] = mineTypes.item;
	}
	var newWidth = width * 16, newHeight = 20 + height * 16;
	room_set_width(rmMain, newWidth);
	room_set_height(rmMain, newHeight);
	room_restart();
	window_set_size(newWidth * scale, newHeight * scale);
	surface_resize(application_surface, newWidth, newHeight);
}
function minefield_has_mine(x, y)
{
	if (x < 0 || x > width - 0.5 || y < 0 || y > height - 0.5) return (false)
	return (minefield[# x, y] == mineTypes.mine)
}
function minefield_reveal_tile(x, y)
{
	if (x < 0 || x > width - 0.5 || y < 0 || y > height - 0.5) exit
	var getRevealed = revealed[# x, y], getTile = minefield[# x, y];
	if (getRevealed == revealTypes.open || getRevealed == revealTypes.flag || getRevealed == revealTypes.mark || getTile == mineTypes.mine) exit
	if (getRevealed == revealTypes.closed)
	{
		revealed[# x, y] = revealTypes.open;
		if ((getTile > 0 && getTile < 9) || getTile == mineTypes.item) exit
	}
	minefield_reveal_tile(x - 1, y - 1);
	minefield_reveal_tile(x, y - 1);
	minefield_reveal_tile(x + 1, y - 1);
	minefield_reveal_tile(x - 1, y);
	minefield_reveal_tile(x + 1, y);
	minefield_reveal_tile(x - 1, y + 1);
	minefield_reveal_tile(x, y + 1);
	minefield_reveal_tile(x + 1, y + 1);
}
function minefield_get_random_closed_tile(safe)
{
	var closedTiles, arrayIndex = 0, randomIndex;
	for (var i = 0, j; i < width; i++) for (var j = 0; j < height; j++)
	{
		var getTile = minefield[# i, j];
		if (revealed[# i, j] != revealTypes.closed || ((safe && getTile == mineTypes.mine) || (!safe && getTile != mineTypes.mine))) continue
		closedTiles[arrayIndex, 0] = i;
		closedTiles[arrayIndex, 1] = j;
		arrayIndex++;
	}
	if (arrayIndex)
	{
		randomIndex = max(0, irandom(arrayIndex) -  1);
		return ([closedTiles[randomIndex, 0], closedTiles[randomIndex, 1]])
	}
	return (undefined)
}
function minefield_check_win()
{
	if (dead) exit
	for (var i = 0, j, win = true; i < width; i++)
	{
		for (j = 0; j < height; j++)
		{
			if (revealed[# i, j] == revealTypes.open) continue
			if (minefield[# i, j] != mineTypes.mine)
			{
				win = false;
				break
			}
		}
		if !(win) break
	}
	if (win)
	{
		for (var i = 0, j, win = true; i < width; i++) for (j = 0; j < height; j++) if (minefield[# i, j] == mineTypes.mine) revealed[# i, j] = revealTypes.flag;
		audio_play_sound(sndWin, 0, false);
		dead = true;
		minesLeft = 0;
	}
}
minefield_create();
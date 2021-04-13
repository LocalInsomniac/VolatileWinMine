/// Update Item
if !(timer--)
{
	switch (image_index)
	{
		case (26):
		case (27):
		case (28): for (var i = 0; i < modifier; i++)
		{
			var randomTile = objControl.minefield_get_random_closed_tile(false);
			if !(is_undefined(randomTile))
			{
				objControl.revealed[# randomTile[0], randomTile[1]] = revealTypes.flag;
				objControl.minesLeft--;
			}
		}
		break
		case (29):
		case (30):
		case (31):
			for (var i = 0; i < modifier; i++)
			{
				var randomTile = objControl.minefield_get_random_closed_tile(true);
				if !(is_undefined(randomTile)) objControl.minefield_reveal_tile(randomTile[0], randomTile[1]);
			}
			objControl.minefield_check_win();
		break
	}
	audio_play_sound(sndTick, 0, false);
	instance_destroy();
}
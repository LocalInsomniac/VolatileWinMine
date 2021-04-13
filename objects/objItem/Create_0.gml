/// @description Create Item
image_speed = 0;
image_index = 26 + irandom(5);
switch (image_index)
{
	case (27):
	case (30): modifier = 3; break
	case (28):
	case (31): modifier = 5; break
	default: modifier = 1;
}
timer = 60;
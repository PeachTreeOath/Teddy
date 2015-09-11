package;

import flixel.*;
import flixel.util.FlxColor;
/**
 * ...
 * @author 
 */
class EnemySprite extends FlxSprite
{
	private var boundary:Int; // X value of boundary line
	private var speed:Int = 5000;
	private var row:Int;
	private var col:Int;
	private var hp:Int;
	
	public function new(X:Float=0, Y:Float=0, level:Int) 
	{
		super(X, Y);
		
		switch(level)
		{
			case 1:
				loadGraphic(AssetPaths.lizardg__png, false, 50, 50);
				hp = 2;
			case 2:
				loadGraphic(AssetPaths.lizardb__png, false, 50, 50);
				hp = 5;
			case 3:
				loadGraphic(AssetPaths.lizardp__png, false, 50, 50);
				hp = 10;
		}
		
		velocity.x = -speed;
	}
	
	override public function update():Void
	{
		checkBoundary();
		
		super.update();
	}
		
	private function checkBoundary():Void
	{
		if (x <= boundary)
		{
			velocity.x = 0;
		}
		else
		{
			velocity.x = -speed;
		}
	}

	public function setCol(newCol:Int):Void
	{
		col = newCol;
		boundary = Reg.heroBoundary + Reg.colOffset * col;
	}
		
	public function getCol():Int
	{
		return col;
	}
	
	public function setRow(newRow:Int):Void
	{
		row = newRow;
	}
		
	public function getRow():Int
	{
		return row;
	}
	
	

}
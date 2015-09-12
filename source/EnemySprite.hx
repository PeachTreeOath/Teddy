package;

import flixel.*;
import flixel.group.*;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
/**
 * ...
 * @author 
 */
class EnemySprite extends FlxSpriteGroup
{
	private var boundary:Int; // X value of boundary line
	private var speed:Int;
	private var row:Int;
	private var col:Int;
	private var hp:Int;
	private var hpText:FlxText;
	
	public function new(X:Float=0, Y:Float=0, level:Int) 
	{
		super(X, Y);
		
		switch(level)
		{
			case 1:
				add(new FlxSprite(0, 0, "assets/images/lizardg.png"));
				hp = 2;
			case 2:
				add(new FlxSprite(0, 0, "assets/images/lizardb.png"));
				hp = 5;
			case 3:
				add(new FlxSprite(0, 0, "assets/images/lizardp.png"));
				hp = 10;
		}
		
		hpText = new FlxText(30, -10, 50, cast(hp), 12, true);
		hpText.color = FlxColor.BLACK;
		add(hpText);
		
		velocity.x = -Reg.speed * 15;
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
			x = boundary;
		}
		else
		{
			velocity.x = -Reg.speed * 15;
		}
	}

	public function setCol(newCol:Int):Void
	{
		col = newCol;
		tempCol = col;
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
	
	public function takeDamage(damage:Int):Void
	{
		hp -= damage;
		hpText.text = cast(hp);
	}
	
	public function getHp():Int
	{
		return hp;
	}
	
	private var tempCol:Int;
	public function setTempCol():Void
	{
		tempCol--;
	}
	
	public function applyTempCol():Void
	{
		setCol(tempCol);
	}
}
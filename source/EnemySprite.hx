package;

import flixel.*;
import flixel.group.*;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import flixel.util.FlxRandom;

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
	private var type:Int;
	
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
		type = level;
		
		hpText = new FlxText(30, -10, 50, cast(hp), 12, true);
		hpText.color = FlxColor.BLACK;
		add(hpText);
		
		velocity.x = -Reg.speed * 12;
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
			velocity.x = -Reg.speed * 12;
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
		FlxFlicker.flicker(this, 0.5, 0.04, true, true);
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
	
	public function getGold():Int
	{
		switch(type)
		{
			case 1:
				return 1;
			case 2:
				return 4;
			case 3:
				return 10;
		}
		
		return -1;
	}
	
	public function getRune():Int
	{
		if (FlxRandom.chanceRoll(90))
		{
			var runeType:Int = FlxRandom.intRanged(1, 3);
			
			if (Reg.runeInventory.get(runeType) == null)
			{
				Reg.runeInventory.set(runeType, 1);
			}
			else
			{
				var runeCount:Int = Reg.runeInventory.get(runeType);
				Reg.runeInventory.set(runeType, runeCount++);
			}
			
			return runeType;
		}
		
		return -1;
	}
}
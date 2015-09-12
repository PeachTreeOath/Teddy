package;

import flixel.*;
import flixel.group.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class SwordSprite extends FlxSpriteGroup
{	
	private var level:Int = 1;
	private var damage:Int = 1;
	private var tip:FlxSprite;
	private var slice:FlxSprite;
	private var runeLevel:Int = 1;
	private var swordParts:Array<FlxSprite>;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y, 0);
		
		swordParts = new Array<FlxSprite>();
		
		var hilt:FlxSprite = new FlxSprite(x, y, "assets/images/swordhilt.png");
		add(hilt);
		
		var blade:FlxSprite = new FlxSprite(x, y - 25, "assets/images/swordblade.png");
		add(blade);
		
		tip = new FlxSprite(x, y - 50, "assets/images/swordtip.png");
		add(tip);
		
		slice = new FlxSprite(x + 70, y - 100, "assets/images/slice.png");
		add(slice);
		slice.visible = false;
		
		swordParts.push(hilt);
		swordParts.push(blade);
		swordParts.push(tip);
	}

	public function getLevel():Int
	{
		return level;
	}
		
	public function getDamage():Int
	{
		return damage;
	}

	public function upgradeSize():Void
	{
		level++;
		var blade:FlxSprite = new FlxSprite(0, -25*level, "assets/images/swordblade.png");
		add(blade);
		swordParts.push(blade);
		tip.y -= 25;
	}
	
	public function equipRune(runeType:Int):Void
	{
		if (runeLevel > level)
		{
			return;
		}
		
		var rune:FlxSprite = null;
		
		switch(runeType)
		{
			case 1: rune = new FlxSprite(0, -25*runeLevel, "assets/images/runeruby.png");
					
			case 2: rune = new FlxSprite(0, -25*runeLevel, "assets/images/runelightning.png");
					
			case 3: rune = new FlxSprite(0, -25*runeLevel, "assets/images/runedark.png");
					
		}
		add(rune);
		runeLevel++;	
	}
	
	public function setAttack(attack:Bool):Void
	{
		if (attack)
		{
			for (part in swordParts)
			{
				part.visible = false;
			}
			slice.visible = true;
		}
		else 
		{
			for (part in swordParts)
			{
				part.visible = true;
			}
			slice.visible = false;
		}
	}

}

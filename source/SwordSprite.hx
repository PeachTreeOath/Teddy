package;

import flixel.*;
import flixel.group.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;

/**
 * ...
 * @author 
 */
class SwordSprite extends FlxSpriteGroup
{	
	private var size:Int = 1;
	private var sharpness:Int = 1;
	private var balance:Int = 1;
	private var tip:FlxSprite;
	private var slice:FlxSprite;
	private var runes:Map<Int, Int>;
	private var spriteMap:Map<Int, FlxSprite>;
	private var swordParts:Array<FlxSprite>;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y, 0);
		
		runes = new Map<Int, Int>();
		spriteMap = new Map<Int, FlxSprite>();
		swordParts = new Array<FlxSprite>();
		
		var hilt:FlxSprite = new FlxSprite(x, y, "assets/images/swordhilt.png");
		add(hilt);
		
		var blade:FlxSprite = new FlxSprite(x, y - 25, "assets/images/swordblade.png");
		add(blade);
		
		tip = new FlxSprite(x, y - 50, "assets/images/swordtip.png");
		add(tip);
		
		slice = new FlxSprite(x + 100, y - 100, "assets/images/slice.png");
		add(slice);
		slice.visible = false;
		
		swordParts.push(hilt);
		swordParts.push(blade);
		swordParts.push(tip);
	}

	public function getSize():Int
	{
		return size;
	}
		
	public function getSharpness():Int
	{
		return sharpness;
	}
		
	public function getBalance():Int
	{
		return balance;
	}
	
	public function levelUpSize():Void
	{
		size++;
		var blade:FlxSprite = new FlxSprite(0, -25*size, "assets/images/swordblade.png");
		add(blade);
		swordParts.push(blade);
		tip.y -= 25;
		slice.x += 33;
		slice.scale.x++;
	}
	
	public function levelUpSharpness():Void
	{
		sharpness++;
	}
	
	public function levelUpBalance():Void
	{
		balance++;
	}
	
	public function getRunes():Map<Int,Int>
	{
		return runes;
	}
	
	// 1: Fire
	// 2: Dark
	// 3: Lightning
	public function equipRune(row:Int, runeType:Int):Int
	{		
		// Remove old rune
		var sprite:FlxSprite = spriteMap.get(row);
		var returnID:Int = 0;
		if (sprite != null)
		{
			returnID = sprite.ID;
			remove(sprite);
		}
		
		var rune:FlxSprite = null;
		switch(runeType)
		{
			case 1: 
				rune = new FlxSprite(25, -25*row, "assets/images/runefire.png");
				rune.ID = 1;
			case 2:
				rune = new FlxSprite(25, -25*row, "assets/images/runedark.png");
				rune.ID = 2;	
			case 3:
				rune = new FlxSprite(25, -25 * row, "assets/images/runelightning.png");
				rune.ID = 3;
		}
		runes.set(row, runeType);
		spriteMap.set(row, rune);
		
		swordParts.push(rune);
		add(rune);
		
		return returnID;
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

	public function forceReadySword():Void
	{
		for (part in swordParts)
		{
			part.visible = true;
		}
		slice.visible = false;
	}
	
	public function flicker():Void
	{
		for (part in swordParts)
		{
			FlxFlicker.flicker(part, 1, 0.04, true, false, function(flick:FlxFlicker) { this.visible = false; } );
		}
	}
	
	override public function destroy()
	{
		forceReadySword();
		
		Reg.sword = this;
	}
}

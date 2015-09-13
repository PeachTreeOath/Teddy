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
	private var runeLevel:Int = 1;
	private var map:Map<Int, Map<Int, Int>>;
	private var swordParts:Array<FlxSprite>;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y, 0);
		
		map = new Map<Int, Map<Int,Int>>();
		map.set(1, new Map<Int,Int>());
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
		map.set(size, new Map<Int,Int>());
	}
	
	public function levelUpSharpness():Void
	{
		sharpness++;
	}
	
	public function levelUpBalance():Void
	{
		balance++;
	}
	
	public function equipRune(runeType:Int):Void
	{
		if (runeLevel > size)
		{
			return;
		}
		
		var rune:FlxSprite = null;
		
		switch(runeType)
		{
			case 1: rune = new FlxSprite(0, -25*runeLevel, "assets/images/runefire.png");
					
			case 2: rune = new FlxSprite(0, -25*runeLevel, "assets/images/runedark.png");
					
			case 3: rune = new FlxSprite(0, -25*runeLevel, "assets/images/runelightning.png");
					
		}
		add(rune);
		runeLevel++;	
	}
	
	// 1: Fire
	// 2: Dark
	// 3: Lightning
	//public function equipRune(row:Int, col:Int, runeType:Int):Void
	//{
		//
	//}
	//
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

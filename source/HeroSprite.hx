package;

import flixel.*;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxTimer;
import lime.math.Rectangle;
import openfl.display.BitmapData;
/**
 * ...
 * @author 
 */
class HeroSprite extends FlxSprite
{	
	private var sword:SwordSprite;
	private var swordReadyImage:BitmapData;
	private var originX:Float;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
	
		originX = X;
		loadGraphic(AssetPaths.hero__png, true, 50, 50);
		animation.add("stand", [0,1,2,3,4,5], Std.int(Reg.speed / 10), true);
		animation.add("attack", [6], 30, false);
		animation.add("death", [7,8], 1, false);
		
		animation.play("stand");
	}
	
	public function loadSword():Void
	{
		sword = new SwordSprite();
		var i:Int;
		for (i in 1...Reg.sword.getSize())
		{
			sword.levelUpSize();
		}
		for (i in 1...Reg.sword.getSharpness())
		{
			sword.levelUpSharpness();
		}
		for (i in 1...Reg.sword.getBalance())
		{
			sword.levelUpBalance();
		}
	}
	
	override public function update():Void 
	{
		super.update();		
		animation.get("stand").frameRate = Std.int(Reg.speed / 10);
	}
	
	public function swingSword():Void
	{
		sword.setAttack(true);
		animation.play("attack");
		x = originX + 20;

		new FlxTimer(0.5, readySword, 1);
	}
	
	public function playDeathAnim():Void
	{
		animation.play("death");
	}
	
	private function readySword(timer:FlxTimer):Void
	{
		sword.setAttack(false);
		animation.play("stand");
		x = originX;
	}
	
	public function equipSword(newSword:SwordSprite):Void
	{
		sword = newSword;
	}
	
	public function checkForCombat(enemies:Array<EnemySprite>, totalTime:Float):Bool
	{
		var isAttacking:Bool = false;
		
		for (enemy in enemies)
		{
			if (enemy.x < Reg.heroBoundary + sword.getSize() * 50 && enemy.getCol() < sword.getSize())
			{
				isAttacking = true;
				swingSword();
				enemy.takeDamage(sword.getSharpness());		
			}
		}

		return isAttacking;
	}
	
}
package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.addons.display.FlxBackdrop;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var totalTime:Float = 0;
	private var nextAttackTime:Float = 0;
	private var distance:Float = 0;
	
	private var hero:HeroSprite;
	private var sword:SwordSprite;
	private var enemyLanes:Map<Int, Array<EnemySprite> >;	

	private var topRowHeight:Int = 350;
	private var rowOffset:Int = 50;
	
	private var backdropMtns:FlxBackdrop;
	private var backdropHills:FlxBackdrop;
	private var speedText:FlxText;
	private var distanceText:FlxText;
	
	private var spell1:FlxButton;
	private var spell2:FlxButton;
	private var spell3:FlxButton;
		
	private var fireSprite:FlxSprite;
	private var lightningSprite:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		Reg.speed = 100;
		
		//TODO: cleanup spells
		spell1 = new FlxButton(300, 50, "FLAME SPEAR", castFire);
		add(spell1);
		spell2 = new FlxButton(300, 80, "GRAVITY WELL", castDark);
		add(spell2);
		spell3 = new FlxButton(300, 110, "INDIGNATION", castLightning);
		add(spell3);
		fireSprite = new FlxSprite(0, 0, "assets/images/spellfire.png");
		lightningSprite = new FlxSprite(0, 0, "assets/images/spelllightning.png");
		
		FlxG.cameras.bgColor = 0xFF66FFFF;
		backdropMtns = new FlxBackdrop("assets/images/mountains.png", 100, 0, true, false);
		backdropMtns.y = 150;
		add(backdropMtns);
		
		backdropHills = new FlxBackdrop("assets/images/hills.png", 100, 0, true, false);
		backdropHills.y = 250;
		add(backdropHills);
		
		add(new FlxSprite(0, 378).makeGraphic(800, 222, FlxColor.BEIGE));
		
		speedText = new FlxText(30, 30, 200, "SPEED: " + Std.int(Reg.speed), 12, true);
		speedText.color = FlxColor.BLACK;
		add(speedText);
				
		distanceText = new FlxText(30, 80, 200, "DISTANCE: " + Std.int(distance), 12, true);
		distanceText.color = FlxColor.BLACK;
		add(distanceText);
		
		hero = new HeroSprite(Reg.heroX, 450);
		add(hero);
		
		if (Reg.sword == null)
		{
			Reg.sword = new SwordSprite();	
		}
		
		sword = Reg.sword;
		sword.x = hero.x - 5;
		sword.y = hero.y - 5;
		add(sword);

		enemyLanes = new Map <Int, Array<EnemySprite>>();
		var i:Int;
		for (i in 0...5)
		{
			enemyLanes.set(i, new Array<EnemySprite>());
		}
		
		createEnemy(null);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		hero.destroy();
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		totalTime += FlxG.elapsed;
		
		if (totalTime >= nextAttackTime)
		{
			for (row in enemyLanes)
			{
				if (hero.checkForCombat(row, totalTime) == true) // Return true if attacking
				{
					nextAttackTime = totalTime + 1; // Check if 1 second has passed since attack
				}
			}
		}
		
		// Check for dead enemies
		for (row in enemyLanes)
		{
			var toRemove:Array<EnemySprite> = new Array<EnemySprite>();
			
			for (enemy in row)
			{
				if (enemy.getHp() <= 0)
				{
					enemy.destroy();
					toRemove.push(enemy);
					Reg.speed += 10;
				}		
			}
			// Remove killed monsters		
			for (enemy in toRemove)
			{
				for (adjustEnemy in row)
				{
					if (enemy.getCol() < adjustEnemy.getCol())
					{
						adjustEnemy.setTempCol();
					}
				}
				row.remove(enemy);
			}
				
			// Adjust monster position
			if (toRemove.length > 0)
			{
				for (enemy in row)
				{
					enemy.applyTempCol();
				}
			}
		}
		
		distance += Reg.speed / 1000;
		Reg.speed -= 0.2;
		backdropMtns.velocity.x = -Reg.speed * 5;
		backdropHills.velocity.x = -Reg.speed * 10;
		speedText.text = "SPEED: " + Std.int(Reg.speed);
		distanceText.text = "DISTANCE: " + Std.int(distance);
	}	
	
	private function castFire():Void
	{
		var highestRow:Int = -1;
		var highestCount:Int = 0;
		var i:Int = 0;
		for (row in enemyLanes)
		{
			if (row.length > highestCount)
			{
				highestRow = i;
				highestCount = row.length;
			}
			i++;
		}
		
		if (highestRow != -1)
		{
			var delay:Float = 0;
			for (enemy in enemyLanes.get(highestRow))
			{
				enemy.takeDamage(3);
			}
			fireSprite.y = topRowHeight + rowOffset * highestRow;
			playFireAnim(null);
		}
	}
	
	private var fireAnimCount:Int = 0;
	private function playFireAnim(timer:FlxTimer):Void
	{
		if (fireAnimCount >= 14)
		{
			fireAnimCount = 0;
			remove(fireSprite);
			return;
		}
		remove(fireSprite);
		add(fireSprite);
		
		fireSprite.x = Reg.heroBoundary + Reg.colOffset * fireAnimCount;
		fireAnimCount++;
		new FlxTimer(0.03, playFireAnim, 1);
	}
	
	private var lightningAnimPoints:Array<FlxPoint>;
	private var lightningAnimCount:Int = 0;
	private function castLightning():Void
	{
		lightningAnimPoints = new Array<FlxPoint>();
		var i:Int = 0;
		for (i in 0...15)
		{
			var row:Int = FlxRandom.intRanged(0, 4);
			var col:Int = FlxRandom.intRanged(0, 12);
			var point:FlxPoint = new FlxPoint(col, row);
			lightningAnimPoints.push(point);
			
			var enemy:EnemySprite = getEnemyAt(row, col);
			if (enemy != null)
			{
				enemy.takeDamage(3);
			}
		}

		playLightningAnim(null);
	}
	
	private function playLightningAnim(timer:FlxTimer):Void
	{
		if (lightningAnimCount >= 15)
		{
			lightningAnimCount = 0;
			remove(lightningSprite);
			return;
		}
				
		remove(lightningSprite);
		add(lightningSprite);
		var point:FlxPoint = lightningAnimPoints[lightningAnimCount];
		lightningSprite.x = Reg.heroBoundary + Reg.colOffset * point.x;
		lightningSprite.y = (topRowHeight + rowOffset * point.y) - 50; // -50 since sprite is high
		lightningAnimCount++;
		new FlxTimer(0.02, playLightningAnim, 1);
	}
		
	private function getEnemyAt(row:Int, col:Int):EnemySprite
	{
		var row:Array<EnemySprite> = enemyLanes.get(row);
		for (enemy in row)
		{
			if (enemy.getCol() == col)
			{
				return enemy;
			}
		}
		
		return null;
	}
	
	private function castDark():Void
	{
	
	}
	
	private function createEnemy(timer:FlxTimer):Void 
	{
		// Pick lane
		var row:Int = FlxRandom.intRanged(0, 4);
		var type:Int = FlxRandom.intRanged(1, 3);
		var enemy:EnemySprite = new EnemySprite(1000, topRowHeight + rowOffset * row, type);
		enemy.setRow(row);
		enemy.setCol(enemyLanes.get(row).length);
		enemyLanes.get(row).push(enemy);
		add(enemy);
		
		// Generate new monster
		new FlxTimer(FlxRandom.floatRanged(0, .5), createEnemy, 1);
	}

}
package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.group.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.effects.FlxFlicker;
import flixel.addons.display.FlxBackdrop;
import flixel.util.FlxSpriteUtil;

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
	private var goldText:FlxText;
	private var speedText:FlxText;
	private var goldRewardText:FlxText;
	private var speedRewardText:FlxText;
	private var runeRewardText:FlxText;
	private var distanceText:FlxText;
	
	private var spell1:FlxButton;
	private var spell2:FlxButton;
	private var spell3:FlxButton;
		
	private var fireSprite:FlxSprite;
	private var lightningSprite:FlxSprite;
	private var darkSprite:FlxSprite;
	private var runeSprite:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		super.create();
		
		//TODO: cleanup spells
		spell1 = new FlxButton(300, 50, "FLAME SPEAR", castFire);
		add(spell1);
		spell2 = new FlxButton(300, 80, "GRAVITY WELL", castDark);
		add(spell2);
		spell3 = new FlxButton(300, 110, "INDIGNATION", castLightning);
		add(spell3);
		fireSprite = new FlxSprite(0, 0, "assets/images/spellfire.png");
		lightningSprite = new FlxSprite(0, 0, "assets/images/spelllightning.png");
		darkSprite = new FlxSprite(0, 0, "assets/images/spelldark.png");
		//TODO
		
		FlxG.cameras.bgColor = 0xFF66FFFF;
		backdropMtns = new FlxBackdrop("assets/images/mountains.png", 100, 0, true, false);
		backdropMtns.y = 150;
		add(backdropMtns);
		
		backdropHills = new FlxBackdrop("assets/images/hills.png", 100, 0, true, false);
		backdropHills.y = 250;
		add(backdropHills);
		
		add(new FlxSprite(0, 378).makeGraphic(800, 222, FlxColor.BEIGE));
	
		hero = new HeroSprite(Reg.heroX, 450);
		add(hero);
		
		if (Reg.sword == null)
		{
			Reg.sword = new SwordSprite();
		}
		
		loadSword();
		add(sword);
		hero.equipSword(sword);
		
		goldText = new FlxText(30, 20, 200, "GOLD: " + Std.int(Reg.gold), 12, true);
		goldText.color = FlxColor.GOLDENROD;
		add(goldText);
		
		Reg.speed = 100;
		speedText = new FlxText(30, 50, 200, "SPEED: " + Std.int(Reg.speed), 12, true);
		speedText.color = FlxColor.GREEN;
		add(speedText);
				
		distanceText = new FlxText(30, 80, 200, "DISTANCE: " + Std.int(distance), 12, true);
		distanceText.color = FlxColor.BLACK;
		add(distanceText);
		
		goldRewardText = new FlxText(105, 505, 200, null, 12, true);
		goldRewardText.color = FlxColor.GOLDENROD;
		add(goldRewardText);
		
		speedRewardText = new FlxText(105, 520, 200, null, 12, true);
		speedRewardText.color = FlxColor.GREEN;
		add(speedRewardText);
		
		runeRewardText = new FlxText(85, 545, 200, "GOT     !", 12, true);
		runeRewardText.color = FlxColor.PURPLE;
		runeRewardText.alpha = 0;
		add(runeRewardText);
		
		enemyLanes = new Map <Int, Array<EnemySprite>>();
		for (i in 0...5)
		{
			enemyLanes.set(i, new Array<EnemySprite>());
		}
		
		createEnemy(null);
	}
	
	private function loadSword():Void
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
		sword.x = hero.x - 30;
		sword.y = hero.y - 5;
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		if (dead)
		{
			return;
		}
		
		if (Reg.speed <= 0)
		{
			playDeathAnim();
			return;
		}

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
					getLoot(enemy);
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
		Reg.speed -= .2;
		backdropMtns.velocity.x = -Reg.speed * 5;
		backdropHills.velocity.x = -Reg.speed * 10;
		speedText.text = "SPEED: " + Std.int(Reg.speed);
		distanceText.text = "DISTANCE: " + Std.int(distance);
	}	
	
	private var dead:Bool = false;
	private function playDeathAnim():Void
	{
		backdropMtns.velocity.x = 0;
		backdropHills.velocity.x = 0;
		dead = true;
		Reg.speed = 0;
		sword.forceReadySword();
		sword.flicker();
		
		hero.playDeathAnim();
		
		if (distance > Reg.furthestRun)
		{
			Reg.furthestRun = distance;
		}
		
		new FlxTimer(2, showScore, 1);
	}
	
	private function showScore(timer:FlxTimer):Void
	{
		add(new FlxSprite(250, 250).makeGraphic(300, 150, FlxColor.BLACK));
		var continueButton:FlxButton = new FlxButton(360, 350, "CONTINUE", gotoShopState);
		continueButton.scale.x = 1.3;
		continueButton.scale.y = 2;
		add(continueButton);

		var text:FlxText = new FlxText(255, 255, 300, "        Your hero has died,\n   but the sword will live on!", 16, true);
		text.color = FlxColor.WHITE;
		add(text);
		
		var record:FlxText = new FlxText(300, 310, 300, "FURTHEST RUN: " + Std.int(Reg.furthestRun), 16, true);
		record.color = FlxColor.WHITE;
		add(record);
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
		FlxG.camera.shake(0.01, 0.2);
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
		FlxG.camera.shake(0.01, 0.2);
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
	
	private function castDark():Void
	{
		var row:Int;
		var col:Int;
		
		for (row in 0...5)
		{
			for (col in 0...5)
			{
				var enemy:EnemySprite = getEnemyAt(row, col);
				if (enemy != null)
				{
					enemy.takeDamage(3);
				}
			}
		}
		
		playDarkAnim(null);
		FlxG.camera.shake(0.01, 0.5);
	}
	
	private var darkAnimCount:Int = 0;
	private function playDarkAnim(timer:FlxTimer):Void
	{
		if (darkAnimCount >= 1)
		{
			darkAnimCount = 0;
			remove(darkSprite);
			return;
		}
		
		remove(darkSprite);
		add(darkSprite);
		
		darkSprite.x = Reg.heroBoundary + Reg.colOffset;
		darkSprite.y = topRowHeight + rowOffset;
		darkAnimCount++;
		new FlxTimer(0.5, playDarkAnim, 1);
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
		new FlxTimer(FlxRandom.floatRanged(0, 1), createEnemy, 1);
	}

	private function getLoot(enemy:EnemySprite):Void
	{
		var goldGain:Int = enemy.getGold();
		var speedGain:Int = 3 + sword.getBalance() * 2;
		Reg.gold += goldGain;
		Reg.speed += speedGain;
		goldRewardText.text = "+" + goldGain;
		speedRewardText.text = "+" + speedGain;
		goldRewardText.alpha = 1;
		speedRewardText.alpha = 1;
		FlxSpriteUtil.fadeOut(goldRewardText, 1, false);
		FlxSpriteUtil.fadeOut(speedRewardText, 1, false);
		
		goldText.text = "GOLD: " + Reg.gold;
		
		var rune:Int = enemy.getRune();
		if (rune != -1)
		{
			if (runeSprite != null)
			{
				remove(runeSprite);
				runeSprite.destroy();
			}
			
			switch(rune)
			{
				case 1:
					runeSprite = new FlxSprite(115, 542, "assets/images/runefire.png");
				case 2:
					runeSprite = new FlxSprite(115, 542, "assets/images/runedark.png");
				case 3:
					runeSprite = new FlxSprite(115, 542, "assets/images/runelightning.png");
			}
			add(runeSprite);
			runeRewardText.alpha = 1;
			runeSprite.alpha = 1;
			FlxSpriteUtil.fadeOut(runeRewardText, 1, false);
			FlxSpriteUtil.fadeOut(runeSprite, 1, false);
		}
	}
	
	private function gotoShopState():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,1, false,function() {
		FlxG.switchState(new ShopState());
		});
	}
}
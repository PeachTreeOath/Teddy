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
import flixel.addons.display.FlxBackdrop;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var hero:HeroSprite;
	private var sword:SwordSprite;
	private var enemyLanes:Map<Int, Array<EnemySprite> >;	
	
	private var topRowHeight:Int = 350;
	private var rowOffset:Int = 50;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.cameras.bgColor = FlxColor.WHITE;
		var backdrop:FlxBackdrop = new FlxBackdrop("assets/images/pointy_mountains.png", 100, 0, true, false);
		backdrop.y = 150;
		backdrop.velocity.x = -100;
		add(backdrop);
		
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

		for (row in enemyLanes)
		{
			hero.checkForCombat(row);
		}
		
		//TODO fix this
	}	
	
	private function createEnemy(timer:FlxTimer):Void 
	{
		// Pick lane
		var row:Int = FlxRandom.intRanged(0, 5);
		var type:Int = FlxRandom.intRanged(1, 3);
		var enemy:EnemySprite = new EnemySprite(800, topRowHeight + rowOffset * row, type);
		enemy.setRow(row);
		enemy.setCol(enemyLanes.get(row).length);
		enemyLanes.get(row).push(enemy);
		add(enemy);
		
		// Generate new monster
		new FlxTimer(FlxRandom.floatRanged(0, 1), createEnemy, 1);
	}

}
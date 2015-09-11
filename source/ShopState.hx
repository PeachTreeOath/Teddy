package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.plugin.MouseEventManager;
import flixel.FlxBasic;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class ShopState extends FlxState
{
	private var bg:FlxSprite;	
	private var sword:SwordSprite;
	private var tabOffset:Int = 110;
	private var fameText:FlxText;
	
	private var widgets:Array<FlxBasic>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		//TODO
		Reg.fame = 1500;
		
		widgets = new Array<FlxBasic>();
		
		bg = new FlxSprite(0, 0, "assets/images/shop.png");
		add(bg);
		
		if (Reg.sword == null)
		{
			Reg.sword = new SwordSprite();	
		}
		
		sword = Reg.sword;
		sword.x = 640;
		sword.y = 450;
		add(sword);
		
		var smithTab:FlxButton = new FlxButton(25, 107, "SMITH", showSmith);
		smithTab.scale.x = 1.3;
		smithTab.scale.y = 2;
		add(smithTab);
		
		var runesTab:FlxButton = new FlxButton(25 + tabOffset, 107, "RUNES", showRunes);
		runesTab.scale.x = 1.3;
		runesTab.scale.y = 2;
		add(runesTab);
		
		var shrineTab:FlxButton = new FlxButton(25 + tabOffset * 2, 107, "SHRINE", null);
		shrineTab.scale.x = 1.3;
		shrineTab.scale.y = 2;
		add(shrineTab);
		
		var petsTab:FlxButton = new FlxButton(25 + tabOffset * 3, 107, "PETS", null);
		petsTab.scale.x = 1.3;
		petsTab.scale.y = 2;
		add(petsTab);
		
		var ornamentsTab:FlxButton = new FlxButton(25 + tabOffset * 4, 107, "ORNAMENTS", null);
		ornamentsTab.scale.x = 1.3;
		ornamentsTab.scale.y = 2;
		add(ornamentsTab);	
		
		var soulsTab:FlxButton = new FlxButton(25 + tabOffset * 5, 107, "SOULS", null);
		soulsTab.scale.x = 1.3;
		soulsTab.scale.y = 2;
		add(soulsTab);		
		
		var gridsphereTab:FlxButton = new FlxButton(25 + tabOffset * 6, 107, "GRID SPHERE", null);
		gridsphereTab.scale.x = 1.3;
		gridsphereTab.scale.y = 2;
		add(gridsphereTab);	
		
		fameText = new FlxText(600, 25, 500, "GOLD: " + Reg.fame, 8, true);
		add(fameText);
		
		var fightButton:FlxButton = new FlxButton(685, 565, "FIGHT!!!", gotoPlayState);
		fightButton.scale.x = 1.3;
		fightButton.scale.y = 2;
		add(fightButton);
		
		MouseEventManager.add(sword, null, equipRune, null, null, false, true, false);
		
		showSmith();
	}
	
	private function gotoPlayState():Void
	{
		 FlxG.switchState(new PlayState());
	}
	
	private function cleanupWidgets():Void
	{
		for (widget in widgets)
		{
			remove(widget);
		}
	}
	
	private function showSmith():Void
	{
		cleanupWidgets();
		
		var button1:FlxButton = new FlxButton(50, 300, "SIZE", upgradeSize);
		button1.scale.x = 1.3;
		button1.scale.y = 2;
		add(button1);
		
		var button2:FlxButton = new FlxButton(200, 300, "SHARP", upgradeSize);
		button2.scale.x = 1.3;
		button2.scale.y = 2;
		add(button2);
		
		var button3:FlxButton = new FlxButton(350, 300, "WEIGHT", upgradeSize);
		button3.scale.x = 1.3;
		button3.scale.y = 2;
		add(button3);
		
		widgets.push(button1);
		widgets.push(button2);
		widgets.push(button3);
	}
	
	private function showRunes():Void
	{
		cleanupWidgets();

		var rune1:FlxSprite = new FlxSprite(50, 200, "assets/images/runeruby.png");
		rune1.scale.x = 2;
		rune1.scale.y = 2;
		add(rune1);
		
		var rune2:FlxSprite = new FlxSprite(150, 200, "assets/images/runelightning.png");
		rune2.scale.x = 2;
		rune2.scale.y = 2;
		add(rune2);
		
		var rune3:FlxSprite = new FlxSprite(250, 200, "assets/images/runedark.png");
		rune3.scale.x = 2;
		rune3.scale.y = 2;
		add(rune3);

		MouseEventManager.add(rune1, rune1MouseDown, null, null, null, false, true, false);
		MouseEventManager.add(rune2, rune2MouseDown, null, null, null, false, true, false);
		MouseEventManager.add(rune3, rune3MouseDown, null, null, null, false, true, false);
		
		widgets.push(rune1);
		widgets.push(rune2);
		widgets.push(rune3);
	}
	
	private var selectedRune:Int;
	
	private function rune1MouseDown(sprite:FlxSprite):Void
	{
			selectedRune = 1;
	}
	private function rune2MouseDown(sprite:FlxSprite):Void
	{
			selectedRune = 2;
	}
	
private function rune3MouseDown(sprite:FlxSprite):Void
	{
			selectedRune = 3;
	}
	
	private function equipRune(sprite:FlxSprite):Void
	{
		sword.equipRune(selectedRune);
	}
	
	private function upgradeSize():Void
	{
		sword.upgradeSize();
			Reg.fame -= 200;
			fameText.text = "GOLD: " + Reg.fame;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
	}	
}
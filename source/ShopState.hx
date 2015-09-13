package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.plugin.MouseEventManager;
import flixel.FlxBasic;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class ShopState extends FlxState
{
	private var bg:FlxSprite;	
	private var sword:SwordSprite;
	private var tabOffset:Int = 110;
	private var goldText:FlxText;
	private var upgradeCosts:Array<Int>;
	private var widgets:Array<FlxBasic>;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		super.create();
		
		setupCosts();
		
		widgets = new Array<FlxBasic>();
		
		bg = new FlxSprite(0, 0, "assets/images/shop.png");
		add(bg);

		if (Reg.sword == null)
		{
			Reg.sword = new SwordSprite();	
		}
		
		loadSword();
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
				
		goldText = new FlxText(30, 20, 200, "GOLD: " + Std.int(Reg.gold), 12, true);
		goldText.color = FlxColor.GOLDENROD;
		add(goldText);
		
		var fightButton:FlxButton = new FlxButton(685, 565, "CONTINUE", gotoPlayState);
		fightButton.scale.x = 1.3;
		fightButton.scale.y = 2;
		add(fightButton);
		
		MouseEventManager.add(sword, null, equipRune, null, null, false, true, false);
		
		showSmith();
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
				
		sword.x = 615;
		sword.y = 450;
	}
	
	private function gotoPlayState():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {
		FlxG.switchState(new PlayState());
		});
	}
	
	private function cleanupWidgets():Void
	{
		for (widget in widgets)
		{
			remove(widget);
		}
	}
	
	var button1:FlxButton;
	var rank1:FlxText;
	var button2:FlxButton;
	var rank2:FlxText;
	var button3:FlxButton;
	var rank3:FlxText;
	private function showSmith():Void
	{
		cleanupWidgets();
		
		var size:Int = sword.getSize();
		var sharpness:Int = sword.getSharpness();
		var balance:Int = sword.getBalance();
		
		/////////////////////////////////////////////////////
		var icon1:FlxSprite = new FlxSprite(15, 150, "assets/images/buttonbordersize.png");
		add(icon1);
		
		var descBg1 = new FlxSprite(100, 150).makeGraphic(385, 75, FlxColor.TAN);
		add(descBg1);
		
		button1 = new FlxButton(390, 165, cast(upgradeCosts[size]), upgradeSize);
		button1.scale.x = 1.2;
		button1.scale.y = 2;
		add(button1);
		
		var title1:FlxText = new FlxText(120, 155, 200, "SIZE", 16, true);
		title1.color = FlxColor.BLACK;
		add(title1);
		var desc1:FlxText = new FlxText(120, 185, 400, "Gain rune space and attack additional\nrows", 10, true);
		desc1.color = FlxColor.BROWN;
		add(desc1);
		rank1 = new FlxText(410, 200, 400, "Rank " + cast(size), 10, true);
		rank1.color = FlxColor.BLACK;
		add(rank1);
		/////////////////////////////////////////////////////		
		var icon2:FlxSprite = new FlxSprite(15, 285, "assets/images/buttonbordersharpness.png");
		add(icon2);
		
		var descBg2 = new FlxSprite(100, 285).makeGraphic(385, 75, FlxColor.TAN);
		add(descBg2);
		
		button2 = new FlxButton(390, 300, cast(upgradeCosts[sharpness]), upgradeSharpness);
		button2.scale.x = 1.2;
		button2.scale.y = 2;
		add(button2);
		
		var title2:FlxText = new FlxText(120, 290, 200, "SHARPNESS", 16, true);
		title2.color = FlxColor.BLACK;
		add(title2);
		var desc2:FlxText = new FlxText(120, 320, 400, "Deal more damage with auto-attack", 10, true);
		desc2.color = FlxColor.BROWN;
		add(desc2);
		rank2 = new FlxText(410, 335, 400, "Rank " + cast(sharpness), 10, true);
		rank2.color = FlxColor.BLACK;
		add(rank2);
		/////////////////////////////////////////////////////
		var icon3:FlxSprite = new FlxSprite(15, 420, "assets/images/buttonborderbalance.png");
		add(icon3);
		
		var descBg3 = new FlxSprite(100, 420).makeGraphic(385, 75, FlxColor.TAN);
		add(descBg3);
		
		button3 = new FlxButton(390, 435, cast(upgradeCosts[balance]), upgradeBalance);
		button3.scale.x = 1.2;
		button3.scale.y = 2;
		add(button3);
				
		var title3:FlxText = new FlxText(120, 425, 200, "BALANCE", 16, true);
		title3.color = FlxColor.BLACK;
		add(title3);
		var desc3:FlxText = new FlxText(120, 455, 400, "Increased speed gain per kill", 10, true);
		desc3.color = FlxColor.BROWN;
		add(desc3);
		rank3 = new FlxText(410, 470, 400, "Rank " + cast(balance), 10, true);
		rank3.color = FlxColor.BLACK;
		add(rank3);
		/////////////////////////////////////////////////////
		
		widgets.push(button1);
		widgets.push(title1);
		widgets.push(desc1);
		widgets.push(descBg1);
		widgets.push(icon1);
		widgets.push(rank1);
		widgets.push(button2);
		widgets.push(title2);
		widgets.push(desc2);
		widgets.push(descBg2);
		widgets.push(icon2);
		widgets.push(rank2);
		widgets.push(button3);
		widgets.push(title3);
		widgets.push(desc3);
		widgets.push(descBg3);
		widgets.push(icon3);
		widgets.push(rank3);
	}
	
	private function showRunes():Void
	{
		cleanupWidgets();

		var rune1:FlxSprite = new FlxSprite(50, 200, "assets/images/runefire.png");
		rune1.scale.x = 2;
		rune1.scale.y = 2;
		add(rune1);
		
		var rune2:FlxSprite = new FlxSprite(150, 200, "assets/images/runedark.png");
		rune2.scale.x = 2;
		rune2.scale.y = 2;
		add(rune2);
		
		var rune3:FlxSprite = new FlxSprite(250, 200, "assets/images/runelightning.png");
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
		var size:Int = sword.getSize();
		if (!haveEnoughGold(upgradeCosts[size]))
		{
			return;
		}
		spendGold(upgradeCosts[size]);
		sword.levelUpSize();
		size++;
		button1.text = cast(upgradeCosts[size]);
		rank1.text = "Rank " + cast(size);
	}
	
	private function upgradeSharpness():Void
	{
		var sharpness:Int = sword.getSharpness();
		if (!haveEnoughGold(upgradeCosts[sharpness]))
		{
			return;
		}
		spendGold(upgradeCosts[sharpness]);
		sword.levelUpSharpness();
		sharpness++;
		button2.text = cast(upgradeCosts[sharpness]);
		rank2.text = "Rank " + cast(sharpness);

	}
	
	private function upgradeBalance():Void
	{
		var balance:Int = sword.getBalance();
		if (!haveEnoughGold(upgradeCosts[balance]))
		{
			return;
		}
		spendGold(upgradeCosts[balance]);
		sword.levelUpBalance();
		balance++;
		button3.text = cast(upgradeCosts[balance]);
		rank3.text = "Rank " + cast(balance);
	}
	
	private function haveEnoughGold(cost:Int):Bool
	{
		if (cost > Reg.gold)
		{
			return false;
		}
		return true;
	}
	
	private function spendGold(cost:Int):Void
	{
		Reg.gold -= cost;
		goldText.text = "GOLD: " + Reg.gold;
	}
	
	private function setupCosts():Void
	{
		upgradeCosts = new Array<Int>();
		upgradeCosts.push(0); // Dummy data for lvl 0
		upgradeCosts.push(25);
		upgradeCosts.push(100);
		upgradeCosts.push(500);
		upgradeCosts.push(3000);
		upgradeCosts.push(15000);
		upgradeCosts.push(100000);
		upgradeCosts.push(1000000);
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
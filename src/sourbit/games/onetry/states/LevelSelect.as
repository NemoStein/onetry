package sourbit.games.onetry.states 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import sourbit.games.onetry.map.LevelLoader;
	import sourbit.games.onetry.ui.ingame.HUD;
	import sourbit.games.onetry.ui.Thumb;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class LevelSelect extends FlxState 
	{
		private var _buildings:Vector.<FlxSprite>;
		
		private var _buildings1:FlxSprite;
		private var _buildings2:FlxSprite;
		private var _buildings3:FlxSprite;
		private var _buildings4:FlxSprite;
		
		private var _clouds:FlxSprite;
		
		private var _credits:FlxText;
		private var _back:FlxButton;
		
		private var _leftArrow:FlxButton;
		private var _rightArrow:FlxButton;
		
		private var _blackBG:FlxSprite;
		
		private var _totalPages:int;
		private var _currentPage:int;
		
		private var _animating:Boolean;
		
		private var _navigator:Array;
		private var _selected:int;
		private var _itemsPerPage:int;
		
		public function LevelSelect() 
		{
			//:D
		}
		
		override public function create():void 
		{
			FlxG.mouse.show();
			
			_buildings = new Vector.<FlxSprite>();
			_buildings1 = new FlxSprite(0, 0, Global.assetsHolder[Assets.PARALLAX1]);
			_buildings2 = new FlxSprite(0, 0, Global.assetsHolder[Assets.PARALLAX2]);
			_buildings3 = new FlxSprite(0, 0, Global.assetsHolder[Assets.PARALLAX3]);
			_buildings4 = new FlxSprite(0, 0, Global.assetsHolder[Assets.PARALLAX4]);
			
			_buildings1.pixels = createLoopBitmapData(_buildings1.pixels);
			_buildings2.pixels = createLoopBitmapData(_buildings2.pixels);
			_buildings3.pixels = createLoopBitmapData(_buildings3.pixels);
			_buildings4.pixels = createLoopBitmapData(_buildings4.pixels);
			
			_buildings.push(_buildings1);
			_buildings.push(_buildings2);
			_buildings.push(_buildings3);
			_buildings.push(_buildings4);
			
			_buildings1.x = Home.buildingsPositions[0].x;
			_buildings2.x = Home.buildingsPositions[1].x;
			_buildings3.x = Home.buildingsPositions[2].x;
			_buildings4.x = Home.buildingsPositions[3].x;
			
			_back = new FlxButton(8, -100, null, back);
			_back.loadGraphic(Global.assetsHolder[Assets.BACK], true, false, 98, 18);
			_back.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			_leftArrow = new FlxButton(-97, 86,null,toLeft);
			_leftArrow.loadGraphic(Global.assetsHolder[Assets.LEVEL_SELECT_RIGHT_ARROW], true, false, 40, 91);
			_leftArrow.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			_rightArrow = new FlxButton(459, 86,null,toRight);
			_rightArrow.loadGraphic(Global.assetsHolder[Assets.LEVEL_SELECT_LEFT_ARROW], true, false, 40, 91);
			_rightArrow.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			_clouds = new FlxSprite(0, 10, Global.assetsHolder[Assets.CLOUDS]);
			_clouds.pixels = createLoopBitmapData(_clouds.pixels);
			
			_clouds.x = Home.buildingsPositions[4].x;
			
			_credits = new FlxText(FlxG.width / 2 - 200, FlxG.height - 17, 400, "-SourBit-");
			_credits.setFormat("Lead", 8, 0xFF4D6469, "center");
			
			_credits.alignment = "center";
			
			Global.hud = new HUD();
			
			_blackBG = new FlxSprite(0, (FlxG.height));
			_blackBG.makeGraphic(FlxG.width, FlxG.height - 27, 0x80000000);
			
			_back.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			_leftArrow.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			_rightArrow.setSounds( overSFX, 1, null, 1, PressSFX, 1);
			
			_navigator = [];
			_selected = 0;
			
			add(_clouds);
			
			add(_buildings4);
			add(_buildings3);
			add(_buildings2);
			add(_buildings1);
			
			add(_blackBG);
			
			add(_leftArrow);
			add(_rightArrow);
			
			add(_back);
			add(_credits);
			
			add(Global.hud);
			
			_itemsPerPage = 20;
			_totalPages = Math.ceil(Global.levels.length / _itemsPerPage);
			_currentPage = 0;
			
			changePage(0);
			
			TweenLite.to(_blackBG, .6, { y:27 } );
			TweenLite.to(_back, .6, { y:3 } );
			
			TweenLite.to( _leftArrow, .6, { x:3 } );
			TweenLite.to( _rightArrow, .6, { x:359 } );
			
		}
		
		private function toLeft():void
		{
			--_currentPage;
			if (_currentPage < 0)
			{
				_currentPage = _totalPages-1;
			}
			
			changePage(_currentPage);
		}
		
		private function toRight():void
		{
			++_currentPage;
			_currentPage %= _totalPages;
			
			changePage(_currentPage);
		}
		
		private function changePage(newPage:int):void
		{
			if (_animating )
			{
				TweenMax.pauseAll(false, true);
			}
			
			var i:int = -1;
			while (++i < length)
			{
				if (members[i] is Thumb)
				{
					members[i] = null;
				}
			}
			
			i = (_currentPage * _itemsPerPage) - 1;
			var c:int = -1;
			while (++c < _itemsPerPage)
			{
				if (++i >= Global.levels.length)
				{
					break;
				}
				
				var x:int = 53 + (c % 4) * (71 + 3);
				var y:int = 36 + int(c / 4) * (35 + 3);
				
				var beated:int =  Global.levelsCompleted[i];
				var unlocked:Boolean = i == 0 ? true : Global.levelsCompleted[i - 1] > 0;
				
				var button:Thumb = new Thumb(x, FlxG.height + 100, i, unlocked, beated);
				
				add(button);
				button.animating = true;
				
				TweenLite.to(button, .6, { y:y, delay: (c / 10) * 0.5 } );
			}
			
			_animating = true;
			TweenMax.delayedCall( .6 + (_itemsPerPage / 10) * 0.5, animationOver );
		}
		
		private function back():void 
		{
			FlxG.switchState( new Home());
		}
		
		private function animationOver():void 
		{
			if (!members) return;
			
			var i:int = -1;
			while (++i < members.length)
			{
				if (members[i] && members[i] is Thumb)
				{
					(members[i] as Thumb).animating = false;
				}
			}
			
			_animating = false;
		}
		
		private function refreshButtons():void 
		{
			if (!members) return;
			
			var i:int = -1;
			while (++i < members.length)
			{
				if (members[i] && members[i] is Thumb)
				{
					(members[i] as Thumb).refresh();
				}
			}
		}
		
		override public function update():void 
		{
			if (FlxG.keys.justPressed("M"))
			{
				Global.hud.toggle();
			}
			
			if (_animating)
			{
				refreshButtons();
			}
			
			var i:int = -1;
			while ( ++i < _buildings.length)
			{
				_buildings[i].x -= ( 15 / (i + 1) ) * FlxG.elapsed;
				
				if (_buildings[i].x < -500)
				{
					_buildings[i].x = 0;
				}
				
				Home.buildingsPositions[i].x = _buildings[i].x;
			}
			
			_clouds.x += 6 * FlxG.elapsed;
			if (_clouds.x > 0)
			{
				_clouds.x = -500;
			}
			
			Home.buildingsPositions[4].x = _clouds.x;
			
			super.update();
		}
		
		private function createLoopBitmapData(bitmapData:BitmapData):BitmapData
		{
			var newBitmapData:BitmapData;
			var w:int = bitmapData.width * 2;
			var h:int = bitmapData.height;
			
			newBitmapData = new BitmapData(w, h, true, 0x00000000);
			
			newBitmapData.copyPixels(bitmapData, new Rectangle(0, 0, w / 2, h), new Point(), null, null, true);
			newBitmapData.copyPixels(bitmapData, new Rectangle(0, 0, w / 2, h), new Point(w / 2, 0), null, null, true);
			
			return newBitmapData;
		}
	}
}
package sourbit.games.onetry.states
{
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxButton;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	import sourbit.games.onetry.map.LevelLoader;
	import sourbit.games.onetry.sonds.SoundSequencePlayer;
	import sourbit.games.onetry.ui.BasicButton;
	import sourbit.games.onetry.ui.ingame.HUD;
	
	public class Home extends FlxState
	{
		public static const NORMAL:String = "normal";
		public static const ERASE:String = "erase";
		
		public static var buildingsPositions:Vector.<FlxPoint>;
		
		private var _title:FlxSprite;
		private var _credits:FlxText;
		private var _soundCredits:FlxText;
		private var _soundCreditsLink:FlxButton;
		
		private var _version:FlxText;
		private var _versionCamera:FlxCamera;
		
		private var _buildings:Vector.<FlxSprite>;
		private var _buildings1:FlxSprite;
		private var _buildings2:FlxSprite;
		private var _buildings3:FlxSprite;
		private var _buildings4:FlxSprite;
		
		private var _blackBG:FlxSprite;
		
		private var _tower:FlxSprite;
		private var _clouds:FlxSprite;
		
		private var _newGame:FlxButton;
		private var _continue:FlxButton;
		
		private var _warning:FlxText;
		private var _yes:FlxButton;
		private var _no:FlxButton;
		
		private var _clickedThisFrame:Boolean;
		private var _count:int;
		
		private var _navigator:Array;
		private var _navigationType:String;
		private var _selected:int;
		
		public function Home()
		{
			//:D
		}
		
		override public function create():void
		{
			FlxG.mouse.show();
			LevelLoader.loadLevels();
			
			FlxG.bgColor = 0xFFB4CBCC;
			FlxG.flash(0xFFFFFFFF, 1.2);
			
			if (buildingsPositions == null)
			{
				buildingsPositions = new Vector.<FlxPoint>();
				
				buildingsPositions[0] = new FlxPoint(0, 0);
				buildingsPositions[1] = new FlxPoint(0, 0);
				buildingsPositions[2] = new FlxPoint(0, 0);
				buildingsPositions[3] = new FlxPoint(0, 0);
				buildingsPositions[4] = new FlxPoint(0, 0);
			}
			
			_buildings = new Vector.<FlxSprite>();
			_buildings1 = new FlxSprite(buildingsPositions[0].x, buildingsPositions[0].y, Global.assetsHolder[Assets.PARALLAX1]);
			_buildings2 = new FlxSprite(buildingsPositions[1].x, buildingsPositions[1].y, Global.assetsHolder[Assets.PARALLAX2]);
			_buildings3 = new FlxSprite(buildingsPositions[2].x, buildingsPositions[2].y, Global.assetsHolder[Assets.PARALLAX3]);
			_buildings4 = new FlxSprite(buildingsPositions[3].x, buildingsPositions[3].y, Global.assetsHolder[Assets.PARALLAX4]);
			
			_buildings1.pixels = createLoopBitmapData(_buildings1.pixels);
			_buildings2.pixels = createLoopBitmapData(_buildings2.pixels);
			_buildings3.pixels = createLoopBitmapData(_buildings3.pixels);
			_buildings4.pixels = createLoopBitmapData(_buildings4.pixels);
			
			_buildings.push(_buildings1);
			_buildings.push(_buildings2);
			_buildings.push(_buildings3);
			_buildings.push(_buildings4);
			
			_clouds = new FlxSprite(buildingsPositions[4].x, buildingsPositions[4].y, Global.assetsHolder[Assets.CLOUDS]);
			_clouds.pixels = createLoopBitmapData(_clouds.pixels);
			
			_tower = new FlxSprite(310, 32, Global.assetsHolder[Assets.TOWER]);
			
			_title = new FlxSprite(16, 16, Global.assetsHolder[Assets.LOGO]);
			_title.scrollFactor = new FlxPoint();
			_title.replaceColor(Global.TO_ALPHA, Global.assetsHolder[Global.NEW_ALPHA]);
			
			_credits = new FlxText(FlxG.width / 2 - 200, FlxG.height - 28, 400, "-SourBit-");
			_credits.setFormat("Lead", 8, 0xFF4D6469, "center");
			
			_soundCredits = new FlxText(FlxG.width / 2 - 200, FlxG.height - 17, 400, "-Tracks by Matt Schiffer-");
			_soundCredits.setFormat("Lead", 8, 0xFF4D6469, "center");
			
			_soundCreditsLink = new FlxButton(FlxG.width / 2 - 75, _soundCredits.y + 3, "", gotoMatt);
			_soundCreditsLink.makeGraphic(159, 10, 0x00000000);
			_soundCreditsLink.onOver = soundOver;
			_soundCreditsLink.onOut = soundOut;
			
			_version = new FlxText(0, (FlxG.height * 2) - 14, 48, "v" + Global.VERSION);
			_version.setFormat("Lead", 8, 0xDDDDDD, "left");
			
			_versionCamera = new FlxCamera(0, 0, FlxG.width * 2, FlxG.height * 2, 1);
			_versionCamera.bgColor = 0x00000000;
			FlxG.addCamera(_versionCamera);
			
			_newGame = new FlxButton(45, 141, null, newGame);
			_newGame.loadGraphic(Global.assetsHolder[Assets.NEW_GAME], true, false, 146, 18);
			_newGame.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			_continue = new FlxButton(45, 167, null, continueGame);
			_continue.loadGraphic(Global.assetsHolder[Assets.CONTINUE], true, false, 146, 18);
			_continue.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			_yes = new BasicButton(FlxG.width / 2 - 24, FlxG.height / 2 - 12 + 20, "yes", yes);
			_no = new BasicButton(FlxG.width / 2 - 24, FlxG.height / 2 - 12 + 60, "no", no);
			
			_warning = new FlxText(int(FlxG.width / 2 - 150), int(FlxG.height / 2 - 42), 300, null, true);
			_warning.text = "This will erase your previous save.\nAre you sure?";
			_warning.setFormat("Lead", 8, 0xFFFFFFFF, "center");
			_warning.visible = false;
			
			_blackBG = new FlxSprite();
			_blackBG.makeGraphic(FlxG.width, FlxG.height, 0xCC000000);
			
			_yes.exists = false;
			_no.exists = false;
			_blackBG.exists = false;
			
			_newGame.setSounds(overSFX, 1, null, 1, PressSFX, 1);
			_continue.setSounds(overSFX, 1, null, 1, PressSFX, 1);
			_yes.setSounds(overSFX, 1, null, 1, PressSFX, 1);
			_no.setSounds(overSFX, 1, null, 1, PressSFX, 1);
			
			if (!SaveGame.checkSave())
			{
				_continue.alpha = .5;
				_continue.update();
				_continue.active = false;
			}
			
			setNavigationType(NORMAL);
			
			if(Global.musicSequence == null)
				Global.musicSequence = new SoundSequencePlayer();
				
			Global.hud = new HUD();
			
			add(_clouds);
			
			add(_buildings4);
			add(_buildings3);
			add(_buildings2);
			add(_buildings1);
			
			add(_tower);
			
			add(_title);
			add(_credits);
			add(_soundCredits);
			add(_soundCreditsLink);
			add(_version);
			
			add(_newGame);
			add(_continue);
			
			add(_blackBG);
			
			add(_warning);
			add(_yes);
			add(_no);
			
			add(Global.hud);
			
			setAll("cameras", [FlxG.camera]);
			_version.cameras = [_versionCamera];
			
			_yes.kill();
			_no.kill();
		}
		
		private function soundOut():void
		{
			_soundCredits.color = 0x4D6469;
		}
		
		private function soundOver():void
		{
			_soundCredits.color = 0xB98A3C;
		}
		
		private function gotoMatt():void
		{
			FlxU.openURL("https://soundcloud.com/matt-schiffer");
		}
		
		private function setNavigationType(type:String):void
		{
			_navigationType = type;
			
			_navigator = [];
			
			if (type == NORMAL)
			{
				_navigator.push(_newGame);
				_selected = 0;
				
				if (SaveGame.checkSave())
				{
					_navigator.push(_continue);
					_selected = 1;
				}
			}
			else
			{
				_navigator.push(_yes);
				_navigator.push(_no);
				
				_selected = 1;
			}
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
		
		override public function update():void
		{
			if (Global.menuMute())
			{
				Global.hud.toggle();
			}
			
			if (_clickedThisFrame)
			{
				++_count;
				
				if (_count > 4)
				{
					_clickedThisFrame = false;
				}
			}
			
			var i:int = -1;
			while (++i < _buildings.length)
			{
				_buildings[i].x -= (15 / (i + 1)) * FlxG.elapsed;
				
				if (_buildings[i].x < -500)
				{
					_buildings[i].x = 0;
				}
				
				buildingsPositions[i].x = _buildings[i].x;
			}
			
			_clouds.x += 6 * FlxG.elapsed;
			if (_clouds.x > 0)
			{
				_clouds.x = -500;
			}
			
			buildingsPositions[4].x = _clouds.x;
			
			super.update();
			
			//navigation
			var currentButton:FlxButton = _navigator[_selected] as FlxButton;
			
			if (!hovering(currentButton))
			{
				currentButton.status = FlxButton.HIGHLIGHT;
				currentButton.frame = FlxButton.HIGHLIGHT;
				
				if (currentButton.onOver)
				{
					currentButton.onOver();
				}
			}
			
			if (Global.menuMoveUp())
			{
				if (currentButton.onOut)
				{
					currentButton.onOut();
				}
				else
				{
					currentButton.status = FlxButton.NORMAL;
					currentButton.frame = FlxButton.NORMAL;
				}
				
				--_selected;
				if (_selected < 0)
				{
					_selected = _navigator.length - 1;
				}
				
				FlxG.play(overSFX);
			}
			else if (Global.menuMoveDown())
			{
				if (currentButton.onOut)
				{
					currentButton.onOut();
				}
				else
				{
					currentButton.status = FlxButton.NORMAL;
					currentButton.frame = FlxButton.NORMAL;
				}
				
				++_selected;
				_selected %= _navigator.length;
				
				FlxG.play(overSFX);
			}
			
			if (Global.menuAccept())
			{
				if (currentButton.onUp)
				{
					currentButton.onUp();
				}
				
				currentButton.status = FlxButton.PRESSED;
				currentButton.frame = FlxButton.PRESSED;
				
				FlxG.play(PressSFX);
			}
			
			i = -1;
			while (++i < _navigator.length)
			{
				if (hovering(_navigator[i] as FlxButton))
				{
					_selected = i;
				}
			}
		}
		
		private function hovering(button:FlxButton):Boolean
		{
			var mouse:FlxPoint = FlxG.mouse.getScreenPosition();
			return mouse.x > button.x && mouse.x < button.x + button.width && mouse.y > button.y && mouse.y < button.y + button.height && FlxG.mouse.visible;
		}
		
		private function newGame():void
		{
			if (SaveGame.checkSave())
			{
				_newGame.active = false;
				
				_continue.alpha = .5;
				_continue.active = false;
				
				_warning.visible = true;
				_blackBG.exists = true;
				
				_yes.revive();
				_no.revive();
				
				_clickedThisFrame = true;
				
				setNavigationType(ERASE);
				
				return;
			}
			
			FlxG.switchState(new LevelSelect());
		}
		
		private function yes():void
		{
			if (!_yes.exists)
				return;
			
			SaveGame.erase();
			
			end();
		}
		
		private function no():void
		{
			if (!_no.exists || _clickedThisFrame)
				return;
			
			_newGame.exists = true;
			_newGame.active = true;
			
			_warning.visible = false;
			_blackBG.exists = false;
			
			if (SaveGame.checkSave())
			{
				_continue.alpha = 1;
				_continue.active = true;
			}
			
			_yes.kill();
			_no.kill();
			
			setNavigationType(NORMAL);
		}
		
		private function continueGame():void
		{
			if (!_continue.active)
				return;
			
			SaveGame.loadGame();
			end();
		}
		
		private function end():void
		{
			TweenLite.to(_tower, .6, {x: 425, ease: Sine.easeIn});
			TweenLite.to(_title, .6, {y: -_title.height, ease: Sine.easeIn});
			
			TweenLite.to(_newGame, .6, {x: -_newGame.width, ease: Sine.easeIn});
			TweenLite.to(_continue, .6, {x: -_continue.width, ease: Sine.easeIn, onComplete: goToLevelSelect});
			
			TweenLite.to(_credits, .2, {y: FlxG.height - 17});
			TweenLite.to(_soundCredits, .2, {y: FlxG.height});
			TweenLite.to(_versionCamera, .2, {y: _version.y + 12});
			
			if (_yes.exists)
			{
				TweenLite.to(_warning, .3, {alpha: 0});
				TweenLite.to(_blackBG, .3, {alpha: 0});
				
				TweenLite.to(_yes, .6, {x: -100});
				TweenLite.to(_no, .6, {x: FlxG.width + 100});
			}
		}
		
		private function goToLevelSelect():void
		{
			FlxG.switchState(new LevelSelect())
		}
		
		override public function destroy():void
		{
			_version.cameras = [FlxG.camera];
			_versionCamera = null;
			
			super.destroy();
		}
	}
}
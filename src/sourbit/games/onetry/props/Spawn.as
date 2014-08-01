package sourbit.games.onetry.props
{
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import sourbit.games.onetry.map.LevelLoader;
	import sourbit.games.onetry.map.ZoomCamera;
	import sourbit.games.onetry.player.Player;
	import sourbit.library.tools.Delay;
	
	public class Spawn extends FlxGroup
	{
		private var _bg:FlxSprite;
		private var _door:FlxSprite;
		private var _light:FlxSprite;
		private var _hero:FlxSprite;
		
		public var x:int;
		public var y:int;
		
		private var _timer:Number = 0;
		private var _delay:Number;
		
		private var _animating:Boolean;
		private var _intro:Boolean;
		
		private var _steps:Vector.<int>;
		private var _oldStep:int = -1;
		private var _currentStep:int = -1;
		
		private var _facing:uint;
		
		private var _showDelay:Delay;
		private var _skipText:FlxText;
		private var _skipTextCamera:FlxCamera;
		
		private var _spotsToGo:Vector.<FlxPoint>;
		private var _wait:Array;
		private var _ignoreNodes:Boolean;
		
		public function Spawn(x:int, y:int, facing:uint, nodes:Vector.<FlxPoint>, wait:String, ignoreNodes:Boolean)
		{
			super();
			
			this.x = x;
			this.y = y;
			
			_facing = facing;
			
			_spotsToGo = nodes;
			_wait = wait.split(",");
			_ignoreNodes = ignoreNodes;
			
			
			if (_wait.length == 1)
			{
				for each(var p:FlxPoint in _spotsToGo)
				{
					_wait.push(_wait[0]);
				}
				_wait.push(_wait[0]);
			}
			else
			{
				if (_wait.length != _spotsToGo.length)
				{
					trace("Level camera cannot have different wait values then nodes");
				}
				
			}
			
			initialize();
		}
		
		private function initialize():void
		{
			_bg = new FlxSprite(x, y);
			_door = new FlxSprite(x, y);
			_light = new FlxSprite(x, y);
			
			_bg.loadGraphic(Global.assetsHolder[Assets.DOOR], true, false, 27, 32);
			_door.loadGraphic(Global.assetsHolder[Assets.DOOR], true, false, 27, 32);
			_light.loadGraphic(Global.assetsHolder[Assets.DOOR], true, false, 27, 32);
			
			_bg.width = _door.width = _light.width = 26;
			
			_bg.frame = 6;
			_door.addAnimation("open", [0, 1, 2, 3, 4, 5], 24, false);
			_door.addAnimation("close", [5, 4, 3, 2, 1, 0], 24, false);
			
			_door.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			_light.addAnimation("green", [6], 1, false);
			_light.addAnimation("red", [7], 1, false);
			_light.play("red");
			
			_hero = new FlxSprite(x, y + 8);
			_hero.x += _facing == FlxObject.LEFT ? -8 : 8;
			
			_hero.loadGraphic(Global.assetsHolder[Assets.PLAYER_SPECIAL], true, true, 24, 24);
			_hero.addAnimation("getIn", [0, 1, 2, 3, 4, 5, 6, 7], 10, false);
			_hero.visible = false;
			
			_hero.facing = _facing;
			
			_bg.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			_door.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			_hero.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			add(_bg);
			add(_door);
			add(_hero);
			add(_light);
			
			_delay = 0;
		}
		
		override public function update():void
		{
			if (_showDelay)
			{
				_showDelay.update();
			}
			
			if (_intro)
			{
				_timer += FlxG.elapsed;
				
				if (_timer >= _delay)
				{
					_timer = 0;
					_currentStep = _steps.pop();
				}
			}
			
			if (_currentStep == 0)
			{
				_currentStep = -1;
				
				_light.play("green");
				_delay = .5;
				
				FlxG.play(DoorSFX);
			}
			else if (_currentStep == 1)
			{
				_currentStep = -1;
				
				_door.play("open");
				
				_hero.visible = true;
				_hero.play("getIn");
				_delay = ((1.0 / 18) * 8);
			}
			else if (_currentStep == 2)
			{
				_currentStep = -1;
				_door.play("close");
				_delay = ((1.0 / 24) * 6);
			}
			else if (_currentStep == 3)
			{
				_currentStep = -1;
				
				_intro = false;
				_light.play("red");
				
				endIntro();
			}
			
			super.update();
		}
		
		override public function draw():void
		{
			super.draw();
		}
		
		public function intro():void
		{
			showlevel();
		}
		
		private function showlevel():void
		{
			_animating = true;
			
			var dolly:FlxSprite = new FlxSprite(1, 1);
			
			_skipText = new FlxText(4, FlxG.height - 16, 100, "'x' to skip", true);
			_skipText.setFormat("lead", 8, 0xFFFFFF, "left", 0x444444);
			_skipText.scrollFactor = new FlxPoint();
			
			_skipTextCamera = new FlxCamera(0, 0, FlxG.width, FlxG.height, 2);
			_skipTextCamera.setBounds(0, 0, Global.groundMap.width, Global.groundMap.height);
			_skipTextCamera.bgColor = 0x00000000;
			FlxG.addCamera(_skipTextCamera);
			
			FlxG.state.setAll("cameras", [FlxG.camera]);
			
			//if we have no nodes, so we should see entrrace, key and exit
			if (_spotsToGo.length == 0 || _ignoreNodes)
			{
				if (_ignoreNodes)
				{
					_spotsToGo = new Vector.<FlxPoint>();
				}
				else
				{
					for (var i:int = 0; i < 3;++i)
					{
						_wait.push(_wait[0]);
					}
				}
				
				//entrance
				_spotsToGo.push(door.getMidpoint());
				
				//key
				_spotsToGo.push(LevelLoader.keyGroup.members[0].getMidpoint());
				
				//exit
				_spotsToGo.push(LevelLoader.doorGroup.members[0].door.getMidpoint());
				
				//entrance again
				_spotsToGo.push(door.getMidpoint());
			}
			else
			{
				_spotsToGo.push(door.getMidpoint());
			}
			
			dolly.x = Global.groundMap.width / 2;
			dolly.y = Global.groundMap.height / 2;
			
			_showDelay = new Delay(.5, true, function():void
				{
					_showDelay.delay = _wait.shift();
					
					Global.layer4.add(_skipText);
					
					_skipText.cameras = [_skipTextCamera];
					
					(FlxG.camera as ZoomCamera).zoomSpeed = 8;
					(FlxG.camera as ZoomCamera).targetZoom = 3;
					
					FlxG.camera.target = dolly;
					
					if (_spotsToGo.length > 0)
					{
						var target:FlxPoint = _spotsToGo.shift();
						TweenLite.to(dolly, 0.75, {x: target.x, y: target.y, ease: Sine.easeInOut});
					}
					else
					{
						_showDelay.pause();
						
						_animating = false;
						
						_intro = true;
						_steps = new Vector.<int>();
						_steps.push(3, 2, 1, 0);
					}
				});
			
			_showDelay.start();
		}
		
		public function endIntro():void
		{
			remove(_hero, true);
			
			Global.layer4.remove(_skipText);
			FlxG.state.setAll("cameras", [FlxG.camera]);
			
			if (_skipTextCamera)
			{
				_skipTextCamera.visible = false;
			}
			
			Global.player = new Player(0, 0);
			Global.player.x = x + Global.player.offset.x + (_facing == FlxObject.LEFT ? -16 : 16);
			Global.player.y = y + 8;
			
			Global.player.facing = _facing;
			Global.player.behaviors.switchBehavior("EnterLevel");
			Global.layer3.add(Global.player);
			
			(FlxG.camera as ZoomCamera).zoomSpeed = 16;
			(FlxG.camera as ZoomCamera).targetZoom = 2;
			FlxG.camera.follow(Global.player, FlxCamera.STYLE_PLATFORMER);
			
			LevelLoader.presentationGroup.callAll("show");
			
			if (LevelLoader.teleportalGroup != null)
			{
				LevelLoader.teleportalGroup.callAll("startCamera");
				
				var totalEffectCameras:Array = [];
				var totalPlayerCameras:Array = [];
				
				totalEffectCameras.push(FlxG.camera);
				
				var i:int = -1;
				while (++i < LevelLoader.teleportalGroup.length)
				{
					totalEffectCameras.push(LevelLoader.teleportalGroup.members[i].effectCamera);
					totalPlayerCameras.push(LevelLoader.teleportalGroup.members[i].playerCamera);
				}
				
				FlxG.state.setAll("cameras", totalEffectCameras);
				Global.hud.clock.setAll("cameras", [FlxG.camera]);
				
				Global.player.cameras = totalEffectCameras.concat(totalPlayerCameras);
				LevelLoader.teleportalGroup.setAll("cameras", [FlxG.camera]);
				LevelLoader.teleportalEffectsGroup.setAll("cameras", totalPlayerCameras);
			}
		}
		
		public function get door():FlxSprite
		{
			return _door;
		}
		
		public function get animating():Boolean
		{
			return _animating;
		}
	}

}
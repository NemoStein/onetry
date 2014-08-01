package sourbit.games.onetry.props.teleportal
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.map.LevelLoader;
	import sourbit.games.onetry.player.Player;
	import sourbit.games.onetry.props.switches.Wired;
	import sourbit.games.onetry.states.Play;
	
	public class Teleportal extends Entity implements Wired
	{
		private var _warpID:int;
		private var _warpTo:Teleportal;
		
		private var _justWarped:Boolean;
		
		private var _working:Boolean;
		private var _inverse:Boolean;
		
		private var _totalConnections:int;
		private var _currentConnected:int;
		
		private var _effectCamera:FlxCamera;
		private var _playerCamera:FlxCamera;
		
		private var _particleEffect:FlxSprite;
		
		public function Teleportal(id:int, x:int, y:int, warpID:int)
		{
			_warpID = warpID;
			_working = true;
			
			super(id, x, y);
		}
		
		static public function hideCameras():void
		{
			for each( var cam:FlxCamera in FlxG.cameras)
			{
				if (cam != FlxG.camera)
				{
					cam.visible = false;
				}
			}
		}
		
		static public function showCameras():void
		{
			for each(var cam:FlxCamera in FlxG.cameras)
			{
				if (cam != FlxG.camera && cam.ID != 2)
				{
					cam.visible = true;
				}
			}
		}
		
		public function getWarp():void
		{
			_warpTo = LevelLoader.getByID(_warpID) as Teleportal;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			play("open");
			
			_particleEffect = new FlxSprite(x - offset.x + 5, y - offset.y + 5);
			_particleEffect.loadGraphic(Global.assetsHolder[Assets.TELEPORTAL_EFFECT], true, false, 22, 22);
			
			_particleEffect.addAnimation("open", [0, 1, 2, 3, 7], 12, false);
			_particleEffect.addAnimation("close", [4, 5, 6, 7], 12, false);
			_particleEffect.addAnimation("idle", [7], 12, false);
			_particleEffect.addAnimationCallback(particleEffectAnimationCallback);
			
			_particleEffect.play("idle");
			
			LevelLoader.teleportalEffectsGroup.add(_particleEffect);
		}
		
		private function particleEffectAnimationCallback(name:String, frame:uint, index:uint):void
		{
			if (name != "idle" && index == 7)
			{
				_particleEffect.play("idle");
			}
			
		}
		
		public function startCamera():void
		{
			_effectCamera = new FlxCamera(-1, -1, (width + offset.x * 2) * 4, (height + offset.y * 2)  * 4);
			_effectCamera.bounds = FlxG.camera.bounds;
			_effectCamera.follow(_warpTo);
			_effectCamera.ID = 2;
			_effectCamera.visible = false;
			
			_playerCamera = new FlxCamera(-1, -1, (width + offset.x * 2), (height + offset.y * 2));
			_playerCamera.bounds = FlxG.camera.bounds;
			_playerCamera.follow(this);
			
			_playerCamera.bgColor = 0x00000000;
			
			FlxG.addCamera(_effectCamera);
			FlxG.addCamera(_playerCamera);
		}
		
		override protected function checkGraphic():void
		{
			loadGraphic(Global.assetsHolder[Assets.TELEPORTAL], true, false, 32, 32);
			replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			width = 16;
			height = 16;
			
			offset.x = 8;
			offset.y = 8;
			
			x += offset.x;
			y += offset.y;
		}
		
		override protected function checkAnimation():void
		{
			addAnimation("idle", [0], 10, false);
			addAnimation("open", [1, 2, 3, 4], 10, false);
			addAnimation("loop", [4, 5, 6, 7], 10, true);
			addAnimation("close", [8, 9, 10, 0], 10, false);
			
			addAnimationCallback(animationCallback);
		}
		
		private function animationCallback(name:String, frame:uint, index:uint):void
		{
			if (name == "open" && index == 3)
			{
				play("loop");
			}
			else if (name == "close" && finished)
			{
				play("idle");
			}
		}
		
		override public function update():void
		{
			if (_justWarped)
			{
				_justWarped = overlaps(Global.player);
			}
			
			if (_playerCamera)
			{
				var position:FlxPoint = new FlxPoint(x, y);
				getScreenXY(position);
				
				_playerCamera.x = (position.x - offset.x) * FlxCamera.defaultZoom;
				_playerCamera.y = (position.y - offset.y) * FlxCamera.defaultZoom;
				
				if (_curAnim.name != "idle" && _warpTo != null && _warpTo._working)
				{
					var matrix:Matrix = new Matrix();
					var buffer:BitmapData = _playerCamera.buffer;
					matrix.scale(.25, .25);
					
					buffer.lock();
					framePixels.lock();
					buffer.draw(_effectCamera.buffer, matrix);
					
					for (var i:int = 0; i < buffer.width ; i++)
					{
						for (var j:int = 0; j < buffer.height ; j++)
						{
							var portalPixel:uint = framePixels.getPixel(i, j);
							if (portalPixel != 0xCAD9DE)
							{
								buffer.setPixel32(i, j, 0);
							}
							else
							{
								buffer.setPixel32(i, j, 0x80000000 + buffer.getPixel(i, j));
							}
						}
					}
					
					buffer.unlock();
					framePixels.unlock();
				}
			}
			
			super.update();
		}
		
		override public function draw():void
		{
			super.draw();
		}
		
		public function warp(player:Player):void
		{
			if (_warpTo != null && !_justWarped && _working && _warpTo._working)
			{
				_particleEffect.play("open");
				_warpTo._particleEffect.play("close");
				
				if (_particleEffect.frame == 1)
				{
					var localPosition:FlxPoint = new FlxPoint( player.x - x, player.y - y );
					
					player.x = player.last.x = _warpTo.x + localPosition.x;
					player.y = player.last.y = _warpTo.y + localPosition.y;
					
					_warpTo._justWarped = true;
				}
			}
		}
		
		public function turn(on:Boolean):void
		{
			_working = on;
			
			if(_working)
			{
				play("open");
			}
			else
			{
				play("close");
			}
		}
		
		/* INTERFACE sourbit.games.onetry.props.switches.Wired */
		public function makeConnection(on:Boolean):void
		{
			++_totalConnections;
			turn(on);
		}
		
		public function getEntity():Entity
		{
			return this;
		}
		
		public function get totalConnections():int
		{
			return _totalConnections;
		}
		
		public function set totalConnections(value:int):void
		{
			_totalConnections = value;
		}
		
		public function get currentConnected():int
		{
			return _currentConnected;
		}
		
		public function set currentConnected(value:int):void
		{
			_currentConnected = value;
		}
		
		public function activate():void
		{
			++_currentConnected;
			if (_currentConnected == _totalConnections)
			{
				turn(!_inverse);
			}
		}
		
		public function deactivate():void
		{
			--_currentConnected;
			turn(_inverse);
		}
		
		public function toggle():void
		{
			turn(!_working);
		}
		
		// end interface
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		public function get effectCamera():FlxCamera
		{
			return _effectCamera;
		}
		
		public function get playerCamera():FlxCamera
		{
			return _playerCamera;
		}
	}

}
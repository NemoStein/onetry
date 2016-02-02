package sourbit.games.onetry.props.treadmill
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.props.switches.Wired;
	
	public class Treadmill extends Entity implements Wired
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		private var _width:int;
		private var _pieces:FlxGroup;
		
		private var _direction:String;
		private var _speed:int;
		
		private var _particleLeft:Entity;
		private var _particleRight:Entity;
		
		private var _working:Boolean;
		private var _inverse:Boolean;
		
		private var _totalConnections:int;
		private var _currentConnected:int;
		
		public function Treadmill(id:int,x:int,y:int,width:int,direction:String,speed:Number)
		{
			_width = width;
			_direction = direction;
			_speed = speed * Global.TILE_SIDE
			
			_working = true;
			
			_totalConnections = 0;
			_currentConnected = 0;
			
			super(id, x, y);
		}
		
		override protected function initialize():void
		{
			_pieces = new FlxGroup();
			
			immovable = true;
			
			build();
			super.initialize();
		}
		
		private function build():void
		{
			var totalPieces:int = _width / Global.TILE_SIDE;
			var i:int = -1;
			
			while(++i < totalPieces)
			{
				var piece:TreadmillPiece = new TreadmillPiece(x + (Global.TILE_SIDE * i), y, this);
				
				piece.loadGraphic(Global.assetsHolder[Assets.TREADMILL], true, false, 18, 18);
				piece.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
				
				piece.immovable = true;
				
				piece.width = 16;
				piece.height = 16;
				
				var leftFrames:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
				var middleFrames:Array = [16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31];
				var middleVariationFrames:Array = [32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47];
				var rightFrames:Array = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 61, 62];
				
				piece.addAnimation("left", _direction == RIGHT ? leftFrames :leftFrames.reverse(), speed, true);
				piece.addAnimation("middle", _direction == RIGHT ? middleFrames : middleFrames.reverse(), speed, true);
				piece.addAnimation("middleVariation", _direction == RIGHT ? middleVariationFrames : middleVariationFrames.reverse(), speed, true);
				piece.addAnimation("right", _direction == RIGHT ? rightFrames : rightFrames.reverse(), speed, true);
				
				var middle:int = totalPieces  / 2;
				var correction:int = totalPieces % 2 == 0 ? 1 : 0
				var between:int = (middle + correction) % 3;
				
				if (i == 0)
				{
					piece.play("left");
					piece.allowCollisions = FlxObject.LEFT | FlxObject.CEILING;
				}
				else if (i == totalPieces-1)
				{
					piece.play("right");
					piece.allowCollisions = FlxObject.RIGHT | FlxObject.CEILING;
				}
				else
				{
					if (totalPieces > 4 && i % 3 == between)
					{
						piece.play("middleVariation");
						piece.allowCollisions = FlxObject.CEILING;	
					}
					else
					{
						piece.play("middle");
						piece.allowCollisions = FlxObject.CEILING;	
					}
				}
				
				_pieces.add(piece);
			}
		}
		
		override protected function checkGraphic():void
		{
			makeGraphic(_width, Global.TILE_SIDE, 0x00000000);
			ignoreDrawDebug = true;
		}
		
		override public function postUpdate():void
		{
			if (_working)
			{
				for each(var entity:TreadmillPiece in _pieces.members)
				{
					entity.postUpdate();
				}
			}
			
			super.postUpdate();
		}
		
		override public function draw():void
		{
			for each(var entity:TreadmillPiece in _pieces.members)
			{
				entity.cameras = cameras;
				entity.scrollFactor = scrollFactor;
				
				entity.draw();
			}
			
			super.draw();
		}
		
		override public function destroy():void
		{
			_pieces.destroy();
			
			super.destroy();
		}
		
		/* INTERFACE game.props.switches.Wired */
		public function makeConnection(on:Boolean):void
		{
			++totalConnections;
			_working = on;
		}
		
		public function getEntity():Entity
		{
			return this as Entity;
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
				_working = !_inverse;
			}
		}
		
		public function deactivate():void
		{
			--_currentConnected;
			_working = _inverse;
		}
		
		public function toggle():void
		{
			_working = !_working;
		}
		
		public function get direction():String
		{
			return _direction;
		}
		
		public function get speed():int
		{
			return _speed;
		}
		
		public function get working():Boolean
		{
			return _working;
		}
		
		public function get pieces():FlxGroup
		{
			return _pieces;
		}
		
	}

}
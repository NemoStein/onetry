package sourbit.games.onetry.props 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxSound;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.props.switches.Wired;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	public class MovingPlatform extends Entity implements Wired
	{
		static public const CIRCUIT:String = "circuit";
		static public const PATH:String = "path";
		
		private var _width:int;
		private var _speed:Number;
		
		private var _type:String;
		
		private var _wait:Array;
		private var _timer:Number = 0;
		private var _waiting:Boolean;
		private var _firstWait:Boolean;
		
		private var _trips:int;
		private var _tripsDone:int;
		
		private var _path:FlxPath;
		private var _nodes:Array;
		private var _currentNode:int;
		
		private var _pieces:Vector.<Entity>;
		
		private var _movingSound:FlxSound;
		private var _working:Boolean;
		private var _inverse:Boolean;
		
		private var _totalConnections:int;
		private var _currentConnected:int;
		
		private var _force:Boolean;
		
		public function MovingPlatform(id:int, x:int, y:int, width:int, type:String, speed:Number, wait:String, trips:int, nodes:Array)
		{
			_width = width;
			
			_speed = speed
			_type = type;
			_nodes = nodes;
			
			var values:Array;
			var i:int = -1;
			
			values = wait.split(",");
			_wait = new Array(_nodes.length);
			
			if (_type == CIRCUIT)
			{
				if (values.length == 1)
				{
					_wait[0] = values[0];
					
					if (_wait.length > 1)
					{
						i = 0;
						while (++i < _wait.length)
						{
							_wait[i] = 0;
						}
					}
				}
				else if (values.length == 2)
				{
					_wait[0] = values[0];
					
					i = 0;
					while (++i < _wait.length)
					{
						_wait[i] = values[i];
					}
				}
				else if (values.length >= _nodes.length)
				{
					while (++i < _wait.length)
					{
						_wait[i] = values[i];
					}
				}
				else if (values.length < _nodes.length)
				{
					do
					{
						values.push(0);
					}
					while (values.length < _nodes.length)
					
					i = -1;
					while (++i < _wait.length)
					{
						_wait[i] = values[i];
					}
				}
			}
			else
			{
				if (values.length == 1)
				{
					_wait[0] = values[0];
					_wait[_wait.length - 1] = values[0];
					
					if (_wait.length > 2)
					{
						i = 0;
						while (++i < _wait.length -1)
						{
							_wait[i] = 0;
						}
					}
				}
				else if (values.length == 2)
				{
					_wait[0] = values[0];
					_wait[_wait.length - 1] = values[0];
					
					if (_wait.length > 2)
					{
						i = 0;
						while (++i < _wait.length-1)
						{
							_wait[i] = values[i];
						}
					}
				}
				else if (values.length >= _nodes.length)
				{
					while (++i < _wait.length)
					{
						_wait[i] = values[i];
					}
				}
				else if (values.length < _nodes.length)
				{
					_wait[0] = values[0];
					_wait[_wait.length - 1] = values[0];
					
					if (_wait.length > 2)
					{
						i = 0;
						while (++i < _wait.length - 1)
						{
							if (i >= values.length)
							{
								_wait[i] = 0;
							}
							else
							{
								_wait[i] = values[i];
							}
						}
					}
				}
			}
			
			if (_wait[0] > 0)
			{
				_waiting = true;
			}
			
			_firstWait = true;
			
			_trips = trips;
			_tripsDone = 0;
			
			_working = true;
			
			_totalConnections = 0;
			_currentConnected = 0;
			
			super(id, x, y);
			
			var mode:uint = _type == CIRCUIT ?FlxObject.PATH_LOOP_FORWARD : FlxObject.PATH_YOYO;
			
			_path = new FlxPath(_nodes);
			followPath(_path, _speed, mode);
		}
		
		override protected function initialize():void 
		{
			_pieces = new Vector.<Entity>();
			
			immovable = true;
			allowCollisions = CEILING;
			
			_movingSound = new FlxSound();
			_movingSound.loadEmbedded(PlatformSFX, true);
			
			FlxG.sounds.add(_movingSound);
			
			build();
			super.initialize();
			
			_movingSound.play();
		}
		
		override protected function updatePathMotion():void 
		{
			var currentIndex:int = _pathNodeIndex;
			super.updatePathMotion();
			
			if (currentIndex != _pathNodeIndex)
			{
				_currentNode = currentIndex;
				_waiting = true;
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!started || !_working)
			{
				velocity.x = velocity.y = 0;
				return;
			}
			
			if (_waiting)
			{
				_force = false;
				velocity.x = velocity.y = 0;
				
				_timer += FlxG.elapsed;
				if (_timer > _wait[_currentNode])
				{
					if (_currentNode == 0 && !_firstWait)
					{
						++_tripsDone;
					}
					
					if (_type == PATH)
					{
						if (_currentNode == _nodes.length - 1)
						{
							++_tripsDone;
						}
					}
					
					
					_firstWait = false;
					
					if (_tripsDone < _trips || _trips < 0)
					{
						_timer = 0;
						_waiting = false;
						_movingSound.resume();
					}
				}
				else
				{
					_movingSound.pause();
					return;
				}
			}
		}
		
		private function build():void 
		{
			var totalPieces:int = _width / Global.TILE_SIDE;
			var i:int = -1;
			
			while ( ++i < totalPieces)
			{
				var entity:Entity = new Entity( x + ( i * Global.TILE_SIDE), y);
				entity.loadGraphic(Global.assetsHolder[Assets.MOVING_PLATFORM], true, false, 18, 18);
				
				entity.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
				
				entity.width = 16;
				entity.height = 16;
				
				entity.addAnimation("left", [0, 1, 2], 12);
				entity.addAnimation("middle", [3], 12);
				entity.addAnimation("middleVariation", [4], 12);
				entity.addAnimation("middleDivisor", [5], 12);
				entity.addAnimation("right", [6, 7, 8], 12);
				
				var middle:int = totalPieces / 2;
				var correction:int = totalPieces / 2 % 2 == 0 ? 1 : 0;
				var between:int = (middle + correction) % 3;
				
				if (i == 0)
				{
					entity.play("left");
				}
				else if (i == totalPieces-1)
				{
					entity.play("right");
				}
				else
				{
					if (totalPieces > 4 && i % 3 == between)
					{
						entity.play("middleDivisor");
					}
					else
					{
						entity.play("middle");
					}
				}
				
				_pieces.push( entity );
			}
		}
		
		override protected function checkGraphic():void 
		{
			makeGraphic(_width, Global.TILE_SIDE, 0x00000000);
		}
		
		override public function draw():void 
		{
			for each(var entity:Entity in _pieces)
			{
				entity.cameras = cameras;
				entity.scrollFactor = scrollFactor;
				
				entity.draw();
			}
			
			super.draw();
		}
		
		override public function postUpdate():void 
		{
			var i:int = -1;
			while ( ++i < _pieces.length)
			{
				_pieces[i].y = y;
				_pieces[i].x = x + ( i * Global.TILE_SIDE);
				
				_pieces[i].postUpdate();
			}
			
			super.postUpdate();
		}
		
		/* INTERFACE sourbit.games.onetry.props.switches.Wired */
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
			++currentConnected;
			if (currentConnected == totalConnections)
			{
				_working = !_inverse;
			}
		}
		
		public function deactivate():void 
		{
			--currentConnected;
			_working = _inverse;
		}
		
		public function toggle():void 
		{
			if (_working)
			{
				deactivate();
			}
			else
			{
				activate();
			}
			
			_force = true;
		}
		
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function get waiting():Boolean 
		{
			return _waiting;
		}
		
	}

}
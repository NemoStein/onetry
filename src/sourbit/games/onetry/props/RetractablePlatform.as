package sourbit.games.onetry.props 
{
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.props.switches.Wired;
	
	public class RetractablePlatform extends Entity implements Wired
	{
		static public const RETRACTED:String = "retracted;"
		static public const OUT:String = "out";
		
		private var _state:String;
		
		private var _inverse:Boolean;
		
		private var _width:int;
		private var _pieces:Vector.<Entity>;
		
		private var _totalConnections:int;
		private var _currentConnected:int;
		
		public function RetractablePlatform(id:int, x:int, y:int, width:int, retracted:Boolean) 
		{
			_width = width;	
			_inverse = retracted;
			
			super(id, x, y);
		}
		
		override protected function initialize():void 
		{
			_pieces = new Vector.<Entity>();
			
			immovable = true;
			allowCollisions = CEILING;
			
			_totalConnections = 0;
			_currentConnected = 0;
			
			build();
			super.initialize();
			
			if (_inverse)
			{
				_state = OUT;
				retract();
			}
			else
			{
				_state = RETRACTED;
				out();
			}
		}
		
		private function build():void
		{
			var totalPieces:int = _width / Global.TILE_SIDE;
			var i:int = -1;
			
			while (++i < totalPieces)
			{
				var piece:Entity = new Entity(-1, x + ( i * 16), y - 2);
				piece.loadGraphic(Global.assetsHolder[Assets.RETRACTABLE_PLATFORM], true, false, 20, 9);
				
				piece.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
				
				if (i == 0)
				{
					piece.addAnimation("retract", [0, 1, 2, 3], 24, false);
					piece.addAnimation("out", [3, 2, 1, 0], 24, false);
					piece.frame = 0;
				}
				else if( i < totalPieces-1)
				{
					piece.addAnimation("retract", [4, 5, 6, 7], 24, false);
					piece.addAnimation("out", [7, 6, 5, 4], 24, false);
					piece.frame = 4;
				}
				else
				{
					piece.addAnimation("retract", [8, 9, 10, 11], 24, false);
					piece.addAnimation("out", [11, 10, 9, 8], 24, false);
					piece.frame = 8;
				}
				
				_pieces.push(piece);
			}
		}
		
		override protected function checkGraphic():void 
		{
			makeGraphic(_width, 2, 0x00000000);
		}
		
		private function animationCallback():void
		{
			
		}
		
		override public function postUpdate():void 
		{
			for each( var piece:Entity in _pieces)
			{
				piece.postUpdate();
			}
			
			super.postUpdate();
		}
		
		override public function draw():void 
		{
			for each( var piece:Entity in _pieces)
			{
				piece.cameras = cameras;
				piece.scrollFactor = scrollFactor;
				
				piece.draw();
			}
			
			super.draw();
		}
		
		private function retract():void
		{
			if (_state == OUT)
			{
				_state = RETRACTED;
				solid = false;
				
				alpha = .4;
				
				for each(var piece:Entity in _pieces)
				{
					piece.play("retract");
				}
			}
		}
		
		private function out():void
		{
			if (_state == RETRACTED)
			{
				_state = OUT;
				solid = true;
				
				alpha = 1;
				
				for each(var piece:Entity in _pieces)
				{
					piece.play("out");
				}
			}
		}
		
		/* INTERFACE sourbit.games.onetry.props.switches.Wired */
		public function makeConnection(on:Boolean):void 
		{
			++_totalConnections;
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
				_inverse ? out() : retract();
			}
		}
		
		public function deactivate():void 
		{
			--_currentConnected;
			_inverse ? retract() : out();
		}
		
		public function toggle():void 
		{
			if (_state == RETRACTED)
			{
				out();
			}
			else
			{
				retract();
			}
		}
		
	}

}
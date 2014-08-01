package sourbit.games.onetry.props 
{
	import sourbit.games.onetry.entities.Entity;
	import org.flixel.FlxG;
	
	public class LiftPlatform extends Entity
	{
		private var _width:int;
		private var _pieces:Vector.<Entity>;
		
		private var _timer:Number = 0;
		private var _delay:Number = .25;
		
		private var _out:Boolean;
		public var hitted:Boolean;
		
		private var _totalConnections:int;
		private var _currentConnected:int;
		
		public function LiftPlatform(id:int,x:int,y:int,width:int) 
		{
			_width = width;
			
			super(id, x, y);
		}
		
		override protected function initialize():void 
		{
			_pieces = new Vector.<Entity>();
			
			immovable = true;
			allowCollisions = CEILING;
			
			build();
			super.initialize();
		}
		
		private function build():void 
		{
			var totalPieces:int = _width / Global.TILE_SIDE;
			var i:int = -1;
			
			while (++i < totalPieces)
			{
				var piece:Entity = new Entity( -1, x + ( i * 16), y - 14);
				piece.loadGraphic(Global.assetsHolder[Assets.LIFT_PLATFORM], true, false, 20, 21);
				
				piece.addAnimation("edgeLift", [1, 2, 3, 4, 5], 24, false);
				piece.addAnimation("middleLift", [7, 8 , 9 , 10 , 11], 24, false);
				
				piece.addAnimation("edgeDrop", [4, 3, 2, 1 , 0], 24, false);
				piece.addAnimation("middleDrop", [10, 9 , 8 , 7, 6], 24, false);
				
				piece.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
				
				piece.width = 16;
				piece.height = 17;
				
				if (i == 0 || i == totalPieces - 1)
				{
					piece.frame = 0;
				}
				else
				{
					piece.frame = 6;
				}
				
				_pieces.push(piece);
			}
		}
		
		override protected function checkGraphic():void 
		{
			makeGraphic(_width, 2, 0x00008080);
		}
		
		override public function update():void 
		{
			if (hitted)
			{
				if (Global.player.velocity.y < 0 || Global.player.x > x + _width || Global.player.x + Global.player.width < x)
				{
					_out = true;
				}
				
				if (_out && solid)
				{
					_timer += FlxG.elapsed;
					if (_timer >= _delay)
					{
						_timer = 0;
						lift();
					}
				}
			}
			
			super.update();
		}
		
		private function lift():void
		{
			solid = false;
			hitted = false;
			_out = false;
			
			for each( var piece:Entity in _pieces)
			{
				if (piece.frame == 0)
				{
					piece.play("edgeLift");
				}
				else
				{
					piece.play("middleLift");
				}
			}
			
			FlxG.play(DropPlatformSFX);
		}
		
		private function drop():void
		{
			hitted = false;
			_out = false;
			
			allowCollisions = CEILING;
			
			for each( var piece:Entity in _pieces)
			{
				if (piece.frame == 5)
				{
					piece.play("edgeDrop");
				}
				else
				{
					piece.play("middleDrop");
				}
			}
			
			FlxG.play(DropPlatformSFX);
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
	}

}
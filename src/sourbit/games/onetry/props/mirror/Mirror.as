package sourbit.games.onetry.props.mirror
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.player.Player;
	
	public class Mirror extends Entity
	{
		private var _orininalPixels:BitmapData;
		private var _inside:Boolean;
		
		private var _width:int;
		private var _height:int;
		
		public function Mirror(x:int, y:int, width:int, height:int)
		{
			_width = width - 12;
			_height = height - 8;
			
			super( -1, x, y);
			
			this.width += 12;
			this.height += 12;
			
			offset.y -= 8;
		}
		
		override protected function checkGraphic():void
		{
			makeGraphic(_width, _height, 0x00CC0000);
			
			_orininalPixels = _pixels.clone();
		}
		
		override public function draw():void
		{
			super.draw();
		}
		
		override public function update():void
		{
			if (_inside)
			{
				if (!overlaps(Global.player))
				{
					_pixels.copyPixels(_orininalPixels, _pixels.rect, new Point());
					dirty = true;
				}
			}
			
			super.update();
		}
		
		public function onOverlap():void
		{
			_inside = true;
			
			var positionInsideX:int = Global.player.x - Global.player.offset.x - x;
			var positionInsideY:int = Global.player.y - Global.player.offset.y - y + offset.y;
			
			var rect:Rectangle = new Rectangle(0, 0, Global.player.frameWidth, Global.player.frameHeight);
			var pt:Point = new Point();
			
			_pixels.copyPixels(_orininalPixels, _pixels.rect, pt);
			
			pt.x = positionInsideX - 6;
			pt.y = positionInsideY + 1;
			
			Global.player.alpha = 0.35;
			
			Global.player.drawFrame(true);
			
			_pixels.copyPixels(Global.player.framePixels, rect, pt, null, null, true);
			
			Global.player.alpha = 1;
			
			dirty = true;
		}
	
	}

}
package sourbit.games.onetry.ui
{
	import org.flixel.FlxButton;
	import org.flixel.FlxPoint;
	import org.flixel.FlxText;
	
	public class BasicButton extends FlxButton
	{
		private var _text:FlxText;
		public var animating:Boolean;
		
		public function BasicButton(x:int, y:int, label:String, onClick:Function)
		{
			_text = new FlxText(x - 1, y + 2, 48, label, true);
			_text.setFormat("Lead", 8, 0x2E2716, "center", 0x938876);
			
			super(x, y, null, onClick);
			
			loadGraphic(Global.assetsHolder[Assets.BUTTON_BLANK], true, false, 52, 24);
			replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			onOut = out;
			onOver = over;
			onDown = down;
			
			scrollFactor = new FlxPoint();
		}
		
		override public function update():void 
		{
			super.update();
			
			if (status == NORMAL || status != NORMAL && animating)
			{
				out();
			}
		}
		
		override public function draw():void
		{
			super.draw();
			
			_text.cameras = cameras;
			_text.scrollFactor = scrollFactor;
			_text.draw();
		}
		
		private function down():void
		{
			if (!animating)
			{
				_text.x = x;
				_text.y = y + 3;
			}
		}
		
		private function out():void
		{
			_text.x = x - 1;
			_text.y = y + 2;
		}
		
		private function over():void
		{
			if (!animating)
			{
				_text.x = x - 2;
				_text.y = y + 1;
			}
		}
	}

}
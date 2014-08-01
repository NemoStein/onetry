package sourbit.games.onetry.ui.ingame 
{
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	public class LevelName extends FlxSprite 
	{
		private var _text:FlxText;
		public function LevelName(name:String) 
		{
			super(0,FlxG.height);
			
			makeGraphic(FlxG.width, 12, 0xFF000000);
			
			_text = new FlxText(x, y, FlxG.width, name, true);
			_text.setFormat("Lead", 8, 0xFFFFFF, "center");
			
			scrollFactor = new FlxPoint();
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		public function show():void
		{
			TweenLite.to(this, .6, { y: FlxG.height - height, delay: 1, ease:Sine.easeIn, onComplete: hide } );
		}
		
		public function hide():void
		{
			TweenLite.to(this, .6, { y: FlxG.height, delay: 3, ease:Sine.easeOut, onComplete: kill } );
		}
		
		override public function draw():void 
		{
			super.draw();
			
			_text.x = x;
			_text.y = y - 2;
			
			_text.cameras = cameras;
			_text.scrollFactor = scrollFactor;
			_text.draw();
		}
		
	}

}
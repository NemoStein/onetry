package sourbit.games.onetry.player.behaviors.custom 
{
	import sourbit.games.onetry.player.behaviors.Behavior;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	public class EnterLevel extends Behavior 
	{
		private var _timer:Number = 0;
		private var _delay:Number = .4;
		
		override public function start():void 
		{
			super.start();
			
			chainBehavior = "FreeMovement";
			
			user.wasTouching = FlxObject.FLOOR;
			user.touching = FlxObject.FLOOR;
			
			user.play("idle");
			_timer = 0;
		}
		
		override public function update():void 
		{
			_timer += FlxG.elapsed;
			if (_timer >= _delay)
			{
				finish = true;
			}
			
			super.update();
		}
		
	}

}
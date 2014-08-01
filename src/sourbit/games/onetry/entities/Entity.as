package sourbit.games.onetry.entities 
{
	import org.flixel.FlxSprite;
	import org.flixel.system.FlxAnim;
	
	public class Entity extends FlxSprite 
	{
		public var started:Boolean;
		
		public function Entity(id:int=-1, x:int = 0, y:int = 0, graphic:Class = null) 
		{
			super(x, y, graphic);
			ID = id;
			
			initialize();
		}
		
		protected function initialize():void 
		{
			checkGraphic();
			checkAnimation();
		}
		
		protected function checkGraphic():void 
		{
			
		}
		
		protected function checkAnimation():void 
		{
			
		}
		
		public function addExistingAnimation(animation:FlxAnim):void
		{
			_animations.push(animation);
		}
		
		public function start():void
		{
			started = true;
		}
		
	}

}
package sourbit.games.onetry.states
{
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	public class Initial extends FlxState
	{
		
		public function Initial()
		{
			//:D
		}
		
		override public function create():void
		{
			FlxG.switchState(new Loader(Loader.HOME, Home, null));
			
			SaveGame.initialize();
		}
	}
}
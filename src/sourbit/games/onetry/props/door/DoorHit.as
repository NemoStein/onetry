package sourbit.games.onetry.props.door 
{
	import org.flixel.FlxSprite;
	
	public class DoorHit extends FlxSprite 
	{
		public var door:Door;
		
		public function DoorHit(x:int=0,y:int=0,graphic:Class=null) 
		{
			super(x, y, graphic);
		}
		
	}

}
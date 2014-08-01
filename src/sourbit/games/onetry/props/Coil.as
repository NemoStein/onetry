package sourbit.games.onetry.props
{
	import org.flixel.FlxObject;
	import sourbit.games.onetry.entities.Entity;
	
	public class Coil extends Entity
	{
		private var _impulse:Number;
		
		public function Coil(id:int, x:int, y:int, impulse:int)
		{
			super(id, x, y);
			
			_impulse =
			[
				0, // 0
				164, // 1
				240, // 2
				297, // 3
				344, // 4
				384, // 5
				422, // 6
				455, // 7
				486, // 8
				515, // 9
				543, // 10
				569, // 11
				594, // 12
				619, // 13
				642, // 14
				663, // 15
				685, // 16
				706, // 17
				726, // 18
				745, // 19
				765, // 20
				783, // 21
				801, // 22
				819, // 23
				836, // 24
				853, // 25
			][impulse];
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			immovable = true;
			
			replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
		}
		
		override protected function checkGraphic():void
		{
			loadGraphic(Global.assetsHolder[Assets.COIL], true, false, 17, 14);
			
			width = 16;
			height = 4;
			
			offset.y = 10;
			y += offset.y + 2;
		}
		
		override protected function checkAnimation():void
		{
			addAnimation("idle", [0], 1, false);
			addAnimation("impulse", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0], 16, false);
		}
		
		public function get impulse():Number
		{
			return _impulse;
		}
	
	}

}
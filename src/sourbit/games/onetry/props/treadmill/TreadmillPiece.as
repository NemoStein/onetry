package sourbit.games.onetry.props.treadmill 
{
	import sourbit.games.onetry.entities.Entity;
	
	public class TreadmillPiece extends Entity 
	{
		private var _treadmill:Treadmill;
		
		public function TreadmillPiece(x:int, y:int, treadmill:Treadmill) 
		{
			_treadmill = treadmill;
			
			super( -1, x, y);
		}
		
		public function get treadmill():Treadmill 
		{
			return _treadmill;
		}
		
	}

}
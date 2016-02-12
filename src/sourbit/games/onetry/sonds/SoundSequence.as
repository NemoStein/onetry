package sourbit.games.onetry.sonds 
{
	/**
	 * ...
	 * @author Melon Lord
	 */
	public class SoundSequence 
	{		
		private var _sequence:Vector.<Class>;
		private var _current:Class;
		private var _name:String;
		
		public function get name():String
		{
			return _name;
		}
		
		public function get isLast():Boolean
		{
			return _current == _sequence[_sequence.length - 1];
		}
		
		public function SoundSequence(name:String) 
		{
			_name = name;
			clear();
		}
		
		public function clear():void
		{
			_sequence = new Vector.<Class>();
		}
		
		public function add(sound:Class):void
		{
			_sequence.push(sound);
		}
		
		public function next():Class
		{
			if (_current == null)
			{
				_current = _sequence[0];
				return _current;
			}
			
			var index:int = _sequence.indexOf(_current);
			
			if (index + 1 < _sequence.length)
			{
				_current + _sequence[index + 1];
				return _current;
			}
			
			return null;
		}
		
		public function reset():void 
		{
			_current = null;
		}
		
	}
}
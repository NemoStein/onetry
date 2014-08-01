package sourbit.games.onetry.sonds
{
	import flash.events.Event;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSoundUnmutable;
	
	public class SoundSequence extends FlxSoundUnmutable
	{
		private var _sequence:Vector.<Class>;
		private var _loopClass:Class;
		
		private var _sequenceName:String;
		
		private var _paused:Boolean;
		
		public function SoundSequence(name:String) 
		{
			super();
			
			_sequenceName = name;
			
			survive = true;
			autoDestroy = false;
			
			_sequence = new Vector.<Class>();
		}
		
		public function add(embedClass:Class,loop:Boolean=false):void
		{
			_sequence.push(embedClass);
			
			if (loop)
			{
				_loopClass = embedClass;
			}
		}
		
		public function start():void
		{
			if (_sequence.length > 0)
			{
				createSound();
				
				var next:Class = _sequence.shift();
				loadEmbedded(next, next == _loopClass);
				play();
				
				if (_paused)
				{
					volume = 0;
					active = false;
				}
			}
		}
		
		override public function pause():void 
		{
			volume = 0;
			
			active = false;
			_paused = true;
		}
		
		override public function resume():void 
		{
			volume = 1;
			
			active = true;
			_paused = false;
		}
		
		override protected function stopped(event:Event = null):void 
		{
			super.stopped(event);
			if (event != null)
			{
				start();
			}
		}
		
		public function get sequenceName():String 
		{
			return _sequenceName;
		}
		
	}

}
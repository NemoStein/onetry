package sourbit.games.onetry.sonds 
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.flixel.FlxSoundUnmutable;
	/**
	 * ...
	 * @author Melon Lord
	 */
	public class SoundSequencePlayer extends FlxSoundUnmutable
	{
		public function get mute():Boolean
		{
			return _mute;
		}
		
		private var _mute:Boolean;
		
		private var _soundSequnces:Vector.<SoundSequence>;
		private var _current:SoundSequence;
		
		public function SoundSequencePlayer() 
		{
			_soundSequnces = new Vector.<SoundSequence>();
		}
		
		public function isPlayingSequence(sequenceName:String):Boolean
		{
			if (_current == null)
				return false;
				
			return _current.name == sequenceName;
		}
		
		public function hasSequence(sequenceName:String):Boolean
		{
			for each(var sequence:SoundSequence in _soundSequnces)
			{
				if (sequence.name == sequenceName)
					return true;
			}
			
			return false;
		}
		
		public function getSequence(sequenceName:String):SoundSequence
		{
			for each(var sequence:SoundSequence in _soundSequnces)
			{
				if (sequence.name == sequenceName)
					return sequence;
			}
			
			return null;
		}
		
		public function addSound(sequenceName:String, sound:Class):void
		{
			if (!hasSequence(sequenceName))
			{
				_soundSequnces.push(new SoundSequence(sequenceName));
			}
			
			var sequence:SoundSequence = getSequence(sequenceName);
			sequence.add(sound);
		}
		
		public function start(sequenceName:String):void
		{
			if (_current != null)
			{
				if (_current.name != sequenceName)
				{
					_current.reset();
				}
			}
			
			createSound();
			
			_current = getSequence(sequenceName);
			
			var sound:Class = _current.next();
			
			if (sound == null)
				return;
			
			loadEmbedded(sound, _current.isLast);
			play();
			
			if (mute)
			{
				pause();
			}
		}
		
		override public function pause():void 
		{
			volume = 0;
			_mute = true;
			
			active = false;
		}
		
		override public function resume():void 
		{
			volume = 1;
			_mute = false;
			
			active = true;
		}
		
		override protected function stopped(event:Event = null):void 
		{
			super.stopped(event);
			if (event != null)
			{
				start(_current.name);
			}
		}
	}
}
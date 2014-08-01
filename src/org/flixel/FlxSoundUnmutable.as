package org.flixel
{
	// ALERT: Internal class to org.flixel to monkey patch FlxSound muting system
	
	public class FlxSoundUnmutable extends FlxSound
	{
		override internal function updateTransform():void
		{
			_transform.volume = FlxG.volume * _volume * _volumeAdjust;
			if (_channel != null)
			{
				_channel.soundTransform = _transform;
			}
		}
	}
}
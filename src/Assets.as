package
{
	
	public class Assets
	{
		//version
		[Embed(source="../assets/version",mimeType="application/octet-stream")]
		public static const VERSION:Class;
		
		//font
		[Embed(source = "../assets/font/Lead III.ttf", mimeType = "application/x-font", fontName = "Lead", embedAsCFF = "false")]
		public static const LEAD_III:String;
		
		CONFIG::debug
		{
			// cursor
			public static const CURSOR:String = "../assets/HUD/Cursor.png";
			
			//tileset
			public static const TILESET:String = "../assets/tileset/Collision.png";
			public static const TILESET_BG:String = "../assets/tileset/Background.png";
			public static const TILESET_DECALS:String = "../assets/tileset/Decals.png";
			
			//player
			public static const PLAYER:String = "../assets/player/Benjamin.png";
			public static const PLAYER_SPECIAL:String = "../assets/player/Benjamin_special.png";
			
			//bitmap font
			public static const TIMER_FONT_GREEN:String = "../assets/hud/TimerNumbersGreen.png";
			public static const TIMER_FONT_RED:String = "../assets/hud/TimerNumbersRed.png";
			
			//config
			public static const TEXTS:String = "../assets/texts.json";
			public static const LEVELS:String = "../assets/levels.json";
			
			//home
			public static const LOGO:String = "../assets/screens/home/Logo.png";
			public static const NEW_GAME:String = "../assets/screens/home/ButtonNewGame.png";
			public static const CONTINUE:String = "../assets/screens/home/ButtonContinue.png";
			public static const CLOUDS:String = "../assets/screens/home/Clouds.png";
			public static const PARALLAX1:String = "../assets/screens/home/Parallax1.png";
			public static const PARALLAX2:String = "../assets/screens/home/Parallax2.png";
			public static const PARALLAX3:String = "../assets/screens/home/Parallax3.png";
			public static const PARALLAX4:String = "../assets/screens/home/Parallax4.png";
			public static const TOWER:String = "../assets/screens/home/Tower.png";
			public static const BUTTON_BLANK:String = "../assets/screens/home/ButtonBlank.png";
			
			//levelSelect
			public static const BACK:String = "../assets/screens/levelSelect/ButtonBack.png";
			public static const LEVEL_SELECT_SLOT:String = "../assets/screens/levelSelect/LevelSlot.png";
			public static const LEVEL_SELECT_SLOT_STARS:String = "../assets/screens/levelSelect/LevelStars.png";
			public static const LEVEL_SELECT_RIGHT_ARROW:String = "../assets/screens/levelSelect/PaginationLeft.png";
			public static const LEVEL_SELECT_LEFT_ARROW:String = "../assets/screens/levelSelect/PaginationRight.png";
			
			//hud
			public static const HUD:String = "../assets/HUD/Timer.png";
			public static const BGM:String = "../assets/HUD/ButtonBGM.png";
			public static const SFX:String = "../assets/HUD/ButtonSFX.png";
			public static const BORDER:String = "../assets/HUD/GodModeBorder.png";
			
			//props
			public static const COIL:String = "../assets/props/coil/Coil.png";
			public static const DOOR:String = "../assets/props/door/Door.png";
			public static const DROP_PLATFORM:String = "../assets/props/dropPlatform/DropPlatform.png";
			public static const KEY:String = "../assets/props/key/Key.png";
			public static const LIFT_PLATFORM:String = "../assets/props/liftPlaftorm/LiftPlatform.png";
			public static const MOVING_PLATFORM:String = "../assets/props/movingPlatform/MovingPlatform.png";
			public static const TRAPDOOR:String= "../assets/props/trapdoor/Trapdoor.png";
			public static const TREADMILL:String = "../assets/props/treadmill/Treadmill.png";
			public static const TIMER:String = "../assets/props/timer/LocalTimer.png";
			public static const SWITCH:String = "../assets/props/switch/Switch.png";
			public static const JELLY:String = "../assets/props/jelly/Jelly.png";
			public static const WALL_HOOK:String = "../assets/props/wallHook/WallHook.png";
			public static const TELEPORTAL:String = "../assets/props/teleportal/teleportal.png";
			public static const TELEPORTAL_EFFECT:String = "../assets/props/teleportal/teleportalParticle.png";
			public static const RETRACTABLE_PLATFORM:String = "../assets/props/retractablePlatform/retractablePlatform.png";
			
			//particles
			public static const SMOKE_PARTICLE:String = "../assets/props/particles/Particles.png";
		}
		
		CONFIG::release
		{
			// cursor
			[Embed(source = "../assets/HUD/Cursor.png")]
			public static const CURSOR:Class;
			
			//tileset
			[Embed(source="../assets/tileset/Collision.png")]
			public static const TILESET:Class;
			[Embed(source="../assets/tileset/Background.png")]
			public static const TILESET_BG:Class;
			[Embed(source = "../assets/tileset/Decals.png")]
			public static const TILESET_DECALS:Class;
			
			//player
			[Embed(source="../assets/player/Benjamin.png")]
			public static const PLAYER:Class;
			[Embed(source="../assets/player/Benjamin_special.png")]
			public static const PLAYER_SPECIAL:Class;
			
			//bitmap font
			[Embed(source = "../assets/HUD/TimerNumbersGreen.png")]
			public static const TIMER_FONT_GREEN:Class;
			[Embed(source = "../assets/HUD/TimerNumbersRed.png")]
			public static const TIMER_FONT_RED:Class;
			
			//configs
			[Embed(source  = "../assets/texts.json",mimeType="application/octet-stream")]
			public static const TEXTS:Class;
			[Embed(source  = "../assets/levels.json",mimeType="application/octet-stream")]
			static public const LEVELS:Class;
			
			//home
			[Embed(source = "../assets/screens/home/Logo.png")]
			public static const LOGO:Class;
			[Embed(source = "../assets/screens/home/ButtonNewGame.png")]
			public static const NEW_GAME:Class;
			[Embed(source = "../assets/screens/home/ButtonContinue.png")]
			public static const CONTINUE:Class;
			[Embed(source = "../assets/screens/home/Clouds.png")]
			public static const CLOUDS:Class;
			[Embed(source = "../assets/screens/home/Parallax1.png")]
			public static const PARALLAX1:Class;
			[Embed(source = "../assets/screens/home/Parallax2.png")]
			public static const PARALLAX2:Class;
			[Embed(source = "../assets/screens/home/Parallax3.png")]
			public static const PARALLAX3:Class;
			[Embed(source = "../assets/screens/home/Parallax4.png")]
			public static const PARALLAX4:Class;
			[Embed(source = "../assets/screens/home/Tower.png")]
			public static const TOWER:Class;
			[Embed(source = "../assets/screens/home/ButtonBlank.png")]
			public static const BUTTON_BLANK:Class;
			
			//levelSelect
			[Embed(source = "../assets/screens/levelSelect/ButtonBack.png")]
			public static const BACK:Class;
			[Embed(source = "../assets/screens/levelSelect/LevelSlot.png")]
			public static const LEVEL_SELECT_SLOT:Class;
			[Embed(source = "../assets/screens/levelSelect/LevelStars.png")]
			public static const LEVEL_SELECT_SLOT_STARS:Class;
			[Embed(source = "../assets/screens/levelSelect/PaginationLeft.png")]
			public static const LEVEL_SELECT_RIGHT_ARROW:Class;
			[Embed(source = "../assets/screens/levelSelect/PaginationRight.png")]
			public static const LEVEL_SELECT_LEFT_ARROW:Class;
			
			//hud
			[Embed(source = "../assets/HUD/Timer.png")]
			public static const HUD:Class;
			[Embed(source = "../assets/HUD/ButtonBGM.png")]
			public static const BGM:Class;
			[Embed(source = "../assets/HUD/ButtonSFX.png")]
			public static const SFX:Class;
			[Embed(source = "../assets/HUD/GodModeBorder.png")]
			public static const BORDER:Class;
			
			//props
			[Embed(source="../assets/props/coil/Coil.png")]
			public static const COIL:Class;
			[Embed(source="../assets/props/door/Door.png")]
			public static const DOOR:Class;
			[Embed(source="../assets/props/dropPlatform/DropPlatform.png")]
			public static const DROP_PLATFORM:Class;
			[Embed(source="../assets/props/key/Key.png")]
			public static const KEY:Class;
			[Embed(source="../assets/props/liftPlaftorm/LiftPlatform.png")]
			public static const LIFT_PLATFORM:Class;
			[Embed(source="../assets/props/movingPlatform/MovingPlatform.png")]
			public static const MOVING_PLATFORM:Class;
			[Embed(source="../assets/props/trapdoor/Trapdoor.png")]
			public static const TRAPDOOR:Class;
			[Embed(source="../assets/props/treadmill/Treadmill.png")]
			public static const TREADMILL:Class;
			[Embed(source = "../assets/props/timer/LocalTimer.png")]
			public static const TIMER:Class;
			[Embed(source = "../assets/props/switch/Switch.png")]
			public static const SWITCH:Class;
			[Embed(source = "../assets/props/jelly/Jelly.png")]
			public static const JELLY:Class;
			[Embed(source = "../assets/props/wallHook/WallHook.png")]
			public static const WALL_HOOK:Class;
			[Embed(source = "../assets/props/teleportal/teleportal.png")]
			public static const TELEPORTAL:Class;
			[Embed(source = "../assets/props/teleportal/TeleportalParticle.png")]
			public static const TELEPORTAL_EFFECT:Class;
			[Embed(source = "../assets/props/retractablePlatform/RetractablePlatform.png")]
			public static const RETRACTABLE_PLATFORM:Class;
			
			//particles
			[Embed(source="../assets/props/particles/Particles.png")]
			public static const SMOKE_PARTICLE:Class;
			
			//!levels
			/**
			 * The following code was automatically generated
			 * Any change here WILL be lost at the next compiling
			 */
			[Embed(source="../assets/maps/lift/welcome.oel",mimeType="application/octet-stream")]
			public static const MAP_LIFT_WELCOME:Class;
			[Embed(source="../assets/maps/lift/dont.oel",mimeType="application/octet-stream")]
			public static const MAP_LIFT_DONT:Class;
			[Embed(source="../assets/maps/lift/chose.oel",mimeType="application/octet-stream")]
			public static const MAP_LIFT_CHOSE:Class;
			[Embed(source="../assets/maps/drop/dropping.oel",mimeType="application/octet-stream")]
			public static const MAP_DROP_DROPPING:Class;
			[Embed(source="../assets/maps/drop/stairway.oel",mimeType="application/octet-stream")]
			public static const MAP_DROP_STAIRWAY:Class;
			[Embed(source="../assets/maps/drop/chose.oel",mimeType="application/octet-stream")]
			public static const MAP_DROP_CHOSE:Class;
			[Embed(source="../assets/maps/moving/now.oel",mimeType="application/octet-stream")]
			public static const MAP_MOVING_NOW:Class;
			[Embed(source="../assets/maps/moving/who.oel",mimeType="application/octet-stream")]
			public static const MAP_MOVING_WHO:Class;
			[Embed(source="../assets/maps/moving/hate.oel",mimeType="application/octet-stream")]
			public static const MAP_MOVING_HATE:Class;
			[Embed(source="../assets/maps/treadmill/scrolling.oel",mimeType="application/octet-stream")]
			public static const MAP_TREADMILL_SCROLLING:Class;
			[Embed(source="../assets/maps/treadmill/up.oel",mimeType="application/octet-stream")]
			public static const MAP_TREADMILL_UP:Class;
			[Embed(source="../assets/maps/treadmill/merry.oel",mimeType="application/octet-stream")]
			public static const MAP_TREADMILL_MERRY:Class;
			[Embed(source="../assets/maps/timer/under.oel",mimeType="application/octet-stream")]
			public static const MAP_TIMER_UNDER:Class;
			[Embed(source="../assets/maps/greg/01.oel",mimeType="application/octet-stream")]
			public static const MAP_GREG_01:Class;
			[Embed(source="../assets/maps/greg/02.oel",mimeType="application/octet-stream")]
			public static const MAP_GREG_02:Class;
			[Embed(source="../assets/maps/greg/03.oel",mimeType="application/octet-stream")]
			public static const MAP_GREG_03:Class;
			[Embed(source="../assets/maps/greg/04.oel",mimeType="application/octet-stream")]
			public static const MAP_GREG_04:Class;
			[Embed(source="../assets/maps/greg/05.oel",mimeType="application/octet-stream")]
			public static const MAP_GREG_05:Class;
			[Embed(source="../assets/maps/greg/06.oel",mimeType="application/octet-stream")]
			public static const MAP_GREG_06:Class;
			[Embed(source="../assets/maps/greg/07.oel",mimeType="application/octet-stream")]
			public static const MAP_GREG_07:Class;
			[Embed(source="../assets/maps/greg/08.oel",mimeType="application/octet-stream")]
			public static const MAP_GREG_08:Class;
			[Embed(source="../assets/maps/nemo/01.oel",mimeType="application/octet-stream")]
			public static const MAP_NEMO_01:Class;
			[Embed(source="../assets/maps/nemo/02.oel",mimeType="application/octet-stream")]
			public static const MAP_NEMO_02:Class;
			[Embed(source="../assets/maps/nemo/03.oel",mimeType="application/octet-stream")]
			public static const MAP_NEMO_03:Class;
			//!
		}
	}
}
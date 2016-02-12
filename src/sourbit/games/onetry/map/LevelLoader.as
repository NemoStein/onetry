package sourbit.games.onetry.map
{
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import sourbit.games.onetry.entities.Entity;
	import sourbit.games.onetry.props.Coil;
	import sourbit.games.onetry.props.DropPlatform;
	import sourbit.games.onetry.props.door.Door;
	import sourbit.games.onetry.props.Jelly;
	import sourbit.games.onetry.props.Key;
	import sourbit.games.onetry.props.LiftPlatform;
	import sourbit.games.onetry.props.mirror.Mirror;
	import sourbit.games.onetry.props.MovingPlatform;
	import sourbit.games.onetry.props.RetractablePlatform;
	import sourbit.games.onetry.props.Spawn;
	import sourbit.games.onetry.props.switches.Switch;
	import sourbit.games.onetry.props.teleportal.Teleportal;
	import sourbit.games.onetry.props.Timer;
	import sourbit.games.onetry.props.Trapdoor;
	import sourbit.games.onetry.props.treadmill.Treadmill;
	import sourbit.games.onetry.props.WallHook;
	import sourbit.games.onetry.ui.ingame.HUD;
	import sourbit.games.onetry.ui.ingame.LevelName;
	import sourbit.library.tools.AssetLoader;
	
	public class LevelLoader
	{
		private static var _xml:XML;
		
		private static var _reference:FlxGroup;
		
		public static var spawnGroup:FlxGroup;
		public static var coilGroup:FlxGroup;
		public static var treadmillGroup:FlxGroup;
		public static var trapDoorGroup:FlxGroup;
		public static var switchGroup:FlxGroup;
		public static var dropPlatformGroup:FlxGroup;
		public static var doorGroup:FlxGroup;
		public static var keyGroup:FlxGroup;
		public static var liftPlatformGroup:FlxGroup;
		public static var retractableGroup:FlxGroup;
		public static var platformGroup:FlxGroup;
		public static var timerGroup:FlxGroup;
		public static var jellyGroup:FlxGroup;
		public static var wallHookGroup:FlxGroup;
		public static var teleportalGroup:FlxGroup;
		public static var teleportalEffectsGroup:FlxGroup;
		
		public static var presentationGroup:FlxGroup;
		
		public static var mirrorsGroup:FlxGroup;
		
		public static function load(level:Class):void
		{
			var bytes:ByteArray = new level;
			_xml = XML(bytes.readUTFBytes(bytes.length));
			
			var unsafeTilePattern:RegExp = /-1/g;
			
			var state:FlxState = FlxG.state;
			var map:String = String(_xml.Collision).replace(unsafeTilePattern, "0");
			var bg:String = String(_xml.Background).replace(unsafeTilePattern, "0");
			
			var decals1:String = String(_xml.Decals1).replace(unsafeTilePattern, "0");
			var decals2:String = String(_xml.Decals2).replace(unsafeTilePattern, "0");
			var decals3:String = String(_xml.Decals3).replace(unsafeTilePattern, "0");
			
			var regex:RegExp = /^[0,\r\n]+$/;
			
			var obj:XML;
			
			Global.times = new <int>
			[
				_xml.@timeFail,   // ):
				_xml.@timeEasy,   // **
				_xml.@timeMedium, // ***
				_xml.@timeHard,   // ****
				_xml.@timeUnfair, // *****
			]
			
			clear();
			saveReferences();
			
			Global.hasKey = false;
			
			Global.groundMap = new FlxTilemap();
			Global.groundMap.loadMap(map, Global.assetsHolder[Assets.TILESET], Global.TILE_SIDE, Global.TILE_SIDE);
			Global.groundMap.ignoreDrawDebug = true;
			
			Global.backGroundMap = new FlxTilemap();
			Global.backGroundMap.loadMap(bg, Global.assetsHolder[Assets.TILESET_BG], Global.TILE_SIDE, Global.TILE_SIDE, 0, 0, 0);
			Global.backGroundMap.ignoreDrawDebug = true;
			
			//correct decals alpha
			var delcasWithAlpha:FlxSprite = new FlxSprite(0, 0, Global.assetsHolder[Assets.TILESET_DECALS]);
			delcasWithAlpha.replaceColor(Global.TO_ALPHA, Global.NEW_ALPHA);
			
			if (!regex.test(decals1))
			{
				Global.decalsMap1 = new FlxTilemap();
				Global.decalsMap1.loadMap( decals1, Global.assetsHolder[Assets.TILESET_DECALS], Global.TILE_SIDE, Global.TILE_SIDE, 0, 0, 0);
				Global.decalsMap1.ignoreDrawDebug = true;
			}
			else
			{
				if (Global.decalsMap1)
				{
					Global.layer1.remove(Global.decalsMap1);
					Global.decalsMap1 = null;
				}
			}
			if (!regex.test(decals2))
			{
				Global.decalsMap2 = new FlxTilemap();
				Global.decalsMap2.loadMap( decals2, Global.assetsHolder[Assets.TILESET_DECALS], Global.TILE_SIDE, Global.TILE_SIDE, 0, 0, 0);
				Global.decalsMap2.ignoreDrawDebug = true;
			}
			else
			{
				if (Global.decalsMap2)
				{
					Global.layer1.remove(Global.decalsMap2);
					Global.decalsMap2 = null;
				}
			}
			if (!regex.test(decals3))
			{
				Global.decalsMap3 = new FlxTilemap();
				Global.decalsMap3.loadMap( decals3, Global.assetsHolder[Assets.TILESET_DECALS], Global.TILE_SIDE, Global.TILE_SIDE, 0, 0, 0);
				Global.decalsMap3.ignoreDrawDebug = true;
			}
			else
			{
				if (Global.decalsMap3)
				{
					Global.layer1.remove(Global.decalsMap3);
					Global.decalsMap3 = null;
				}
			}
			
			checkMirrors();
			
			for each(obj in _xml.Props.Enter)
			{
				var nodes:Vector.<FlxPoint> = new Vector.<FlxPoint>();
				var wait:String = "1.2";
				var ignore:Boolean;
				
				var cameraHelper:XML = _xml.Props.CameraHelper[0];
				
				if(cameraHelper)
				{
					wait = cameraHelper.@wait;
					ignore = cameraHelper.@timeOnly == "True";
					
					nodes.push( new FlxPoint( cameraHelper.@x, cameraHelper.@y ));
					for each(var node:XML in cameraHelper.node)
					{
						nodes.push( new FlxPoint( node.@x, node.@y ));
					}
				}
				
				spawnGroup.add(new Spawn( obj.@x, obj.@y, obj.@direction == "left" ? FlxObject.LEFT : FlxObject.RIGHT, nodes, wait, ignore ));
			}
			
			for each(obj in _xml.Props.Coil)
			{ coilGroup.add(new Coil(obj.@id, obj.@x, obj.@y, obj.@impulse)) }
			
			for each(obj in _xml.Props.Treadmill)
			{ treadmillGroup.add(new Treadmill(obj.@id, obj.@x, obj.@y, obj.@width, obj.@direction, obj.@speed)) }
			
			for each(obj in _xml.Props.TrapDoor)
			{ trapDoorGroup.add( new Trapdoor(obj.@id, obj.@x, obj.@y, obj.@opened == "True")) }
			
			for each(obj in _xml.Props.DropPlatform)
			{ dropPlatformGroup.add( new DropPlatform( obj.@id, obj.@x, obj.@y)) }
			
			for each(obj in _xml.Props.LiftPlatform)
			{ liftPlatformGroup.add( new LiftPlatform( obj.@id, obj.@x, int(obj.@y) + Global.TILE_SIDE, obj.@width)) }
			
			for each(obj in _xml.Props.WallHook)
			{ wallHookGroup.add( new WallHook(obj.@id, int(obj.@x) + 6, int(obj.@y) + 6)) }
			
			for each(obj in _xml.Props.Exit)
			{ doorGroup.add( new Door( obj.@id, obj.@x, obj.@y)) }
			
			for each(obj in _xml.Props.Key)
			{ keyGroup.add( new Key( obj.@id, obj.@x, obj.@y)) }
			
			for each(obj in _xml.Props.MovingPlatform)
			{
				var platformNodes:Array = [];
				platformNodes.push( new FlxPoint( int(obj.@x) + obj.@width * .5, int(obj.@y) + Global.TILE_SIDE * .5));
				for each( var platformNode:XML in obj.node)
				{
					platformNodes.push( new FlxPoint( int(platformNode.@x) + obj.@width * .5, int(platformNode.@y) + Global.TILE_SIDE * .5));
				}
				platformGroup.add( new MovingPlatform( obj.@id, obj.@x, obj.@y, obj.@width, obj.@type, Number(obj.@speed) * Global.TILE_SIDE, obj.@wait, obj.@trips, platformNodes))
			}
			
			for each(obj in _xml.Props.RetractablePlatform)
			{ retractableGroup.add( new RetractablePlatform(obj.@id, obj.@x, obj.@y, obj.@width, obj.@retracted == "True")) }
			
			for each(obj in _xml.Props.Teleportal)
			{ teleportalGroup.add( new Teleportal(obj.@id, obj.@x, obj.@y, obj.@warpTo)) }
			
			for each(obj in _xml.Props.Timer)
			{ timerGroup.add( new Timer(obj.@id, obj.@x, obj.@y, Number(obj.@time), obj.@wiredTo, obj.@type, Number(obj.@initial))) }
			
			for each(obj in _xml.Props.Jelly)
			{ jellyGroup.add( new Jelly(obj.@id, obj.@x, obj.@y)) }
			
			for each(obj in _xml.Props.Switches)
			{ switchGroup.add( new Switch(obj.@id, obj.@x, obj.@y, obj.@wiredTo, obj.@on == "True", obj.@reset)) }
			
			timerGroup.callAll("setUpIds");
			teleportalGroup.callAll("getWarp");
			
			Global.layer2.add(jellyGroup);
			
			Global.layer3.add(spawnGroup);
			Global.layer3.add(coilGroup);
			Global.layer3.add(treadmillGroup);
			Global.layer3.add(trapDoorGroup);
			Global.layer3.add(dropPlatformGroup);
			Global.layer3.add(doorGroup);
			Global.layer3.add(keyGroup);
			Global.layer3.add(platformGroup);
			Global.layer3.add(liftPlatformGroup);
			Global.layer3.add(retractableGroup);
			Global.layer3.add(wallHookGroup);
			Global.layer3.add(teleportalGroup);
			Global.layer3.add(teleportalEffectsGroup);
			Global.layer3.add(timerGroup);
			Global.layer3.add(switchGroup);
			
			removeEmpty();
			
			//HUD
			Global.hud = new HUD();
			Global.layer6.add(Global.hud);
			
			Global.layer1.add(Global.backGroundMap);
			Global.layer1.add(Global.groundMap);
			
			if (Global.decalsMap1)
			{
				Global.layer1.add(Global.decalsMap1);
				Global.layer1.add(mirrorsGroup);
			}
			if (Global.decalsMap2)
			{
				Global.layer1.add(Global.decalsMap2);
			}
			if (Global.decalsMap3)
			{
				Global.layer1.add(Global.decalsMap3);
			}
			
			state.add(Global.layer1);
			state.add(Global.layer2);
			state.add(Global.layer3);
			state.add(Global.layer4);
			state.add(Global.layer4);
			state.add(Global.layer5);
			state.add(Global.layer6);
			
			FlxG.resetCameras(new ZoomCamera( 0, 0 , FlxG.width, FlxG.height, 2));
			FlxG.camera.setBounds(0, 0, Global.groundMap.width, Global.groundMap.height, true);
			FlxG.camera.focusOn( new FlxPoint(Global.groundMap.width/2, Global.groundMap.height/2 ))
			
			presentationGroup = new FlxGroup(1);
			presentationGroup.add( new LevelName( (Global.currentLevel + 1) + " - " + _xml.@name) );
			Global.layer3.add( presentationGroup );
			
			Global.complete = false;
		}
		
		static private function checkMirrors():void
		{
			if (!Global.decalsMap1) return;
			
			var dict:Array = [];
			
			var bgData:Array = Global.decalsMap1.getData();
			var grid:Array = new Array();
			
			var wt:int = Global.backGroundMap.widthInTiles;
			var ht:int = Global.backGroundMap.heightInTiles;
			
			dict[7] = true;
			dict[8] = true;
			dict[9] = true;
			dict[10] = true;
			dict[23] = true;
			dict[24] = true;
			dict[25] = true;
			dict[26] = true;
			dict[39] = true;
			dict[40] = true;
			dict[41] = true;
			dict[42] = true;
			
			var i:int = -1;
			while (++i < bgData.length)
			{
				if (dict[bgData[i]] == true)
				{
					grid[i] = true;
				}
				else
				{
					grid[i] = false;
				}
			}
			
			var w:int = 1;
			var h:int = 1;
			
			var p:FlxPoint = getFisrt(grid);
			while (p.x != -1)
			{
				grid[ p.y * wt + p.x] = false;
				
				//to the right
				while ( p.x + w < wt && grid[ (p.y * wt) + (p.x + w)])
				{
					grid[ (p.y * wt) + (p.x + w)] = false;
					++w;
				}
				
				//down!
				while (p.y + h < ht)
				{
					var done:Boolean = false;
					for (var j:int = p.x; j < p.x + w;++j)
					{
						if (!grid[ (p.y + h) * wt + j])
						{
							done = true;
							break;
						}
					}
					if (done)
					{
						break;
					}
					
					for (var k:int = p.x; k < p.x + w;++k)
					{
						grid[ (p.y + h) * wt + k] = false;
					}
					++h;
				}
				
				var mirror:Mirror = new Mirror( (p.x * 16) + 4, (p.y * 16) - 4, (w * 16) + 4, (h * 16) - 3);
				LevelLoader.mirrorsGroup.add( mirror);
				
				p = getFisrt(grid);
			}
		}
		
		private static function getFisrt(grid:Array):FlxPoint
		{
			var i:int = -1;
			var p:FlxPoint = new FlxPoint();
			
			while (++i < grid.length)
			{
				if (grid[i])
				{
					p.x = (i % Global.backGroundMap.widthInTiles);
					p.y = int(i / Global.backGroundMap.widthInTiles);
					
					return p;
				}
			}
			
			p.x = -1;
			p.y = -1;
			
			return p;
		}
		
		private static function saveReferences():void
		{
			_reference = new FlxGroup();
			
			spawnGroup = new FlxGroup();
			coilGroup = new FlxGroup();
			treadmillGroup = new FlxGroup();
			trapDoorGroup = new FlxGroup();
			switchGroup = new FlxGroup();
			dropPlatformGroup = new FlxGroup();
			doorGroup = new FlxGroup();
			keyGroup = new FlxGroup();
			platformGroup = new FlxGroup();
			liftPlatformGroup = new FlxGroup();
			retractableGroup = new FlxGroup();
			wallHookGroup = new FlxGroup();
			mirrorsGroup = new FlxGroup();
			timerGroup = new FlxGroup();
			jellyGroup = new FlxGroup();
			teleportalGroup = new FlxGroup();
			teleportalEffectsGroup = new FlxGroup();
			
			_reference.add(spawnGroup);
			_reference.add(coilGroup);
			_reference.add(treadmillGroup);
			_reference.add(trapDoorGroup);
			_reference.add(switchGroup);
			_reference.add(dropPlatformGroup);
			_reference.add(doorGroup);
			_reference.add(keyGroup);
			_reference.add(platformGroup);
			_reference.add(liftPlatformGroup);
			_reference.add(retractableGroup);
			_reference.add(wallHookGroup);
			_reference.add(mirrorsGroup);
			_reference.add(timerGroup);
			_reference.add(jellyGroup);
			_reference.add(teleportalGroup);
			_reference.add(teleportalEffectsGroup);
			
			Global.layer1 = new FlxGroup();
			Global.layer2 = new FlxGroup();
			Global.layer3 = new FlxGroup();
			Global.layer4 = new FlxGroup();
			Global.layer5 = new FlxGroup();
			Global.layer6 = new FlxGroup();
		}
		
		public static function removeEmpty ():void
		{
			if (coilGroup.length == 0)
			{
				Global.layer3.remove(coilGroup,true);
				_reference.remove(coilGroup,true);
				coilGroup = null;
			}
			if (treadmillGroup.length == 0)
			{
				Global.layer3.remove(treadmillGroup,true);
				_reference.remove(treadmillGroup,true);
				treadmillGroup = null;
			}
			if (trapDoorGroup.length == 0)
			{
				Global.layer3.remove(trapDoorGroup,true);
				_reference.remove(trapDoorGroup,true);
				trapDoorGroup = null;
			}
			if (switchGroup.length == 0)
			{
				Global.layer3.remove(switchGroup,true);
				_reference.remove(switchGroup,true);
				switchGroup = null;
			}
			if (dropPlatformGroup.length == 0)
			{
				Global.layer3.remove(dropPlatformGroup,true);
				_reference.remove(dropPlatformGroup,true);
				dropPlatformGroup = null;
			}
			if (doorGroup.length == 0)
			{
				Global.layer3.remove(doorGroup,true);
				_reference.remove(doorGroup,true);
				doorGroup = null;
			}
			if (platformGroup.length == 0)
			{
				Global.layer3.remove(platformGroup,true);
				_reference.remove(platformGroup,true);
				platformGroup = null;
			}
			if (liftPlatformGroup.length == 0)
			{
				Global.layer3.remove(liftPlatformGroup,true);
				_reference.remove(liftPlatformGroup,true);
				liftPlatformGroup = null;
			}
			if (retractableGroup.length == 0)
			{
				Global.layer3.remove(retractableGroup, true);
				_reference.remove(retractableGroup, true);
				retractableGroup = null;
			}
			if (wallHookGroup.length == 0)
			{
				Global.layer3.remove(wallHookGroup, true);
				_reference.remove(wallHookGroup, true);
				wallHookGroup = null;
			}
			if (timerGroup.length == 0)
			{
				Global.layer3.remove(timerGroup,true);
				_reference.remove(timerGroup,true);
				timerGroup = null;
			}
			if (teleportalGroup.length == 0)
			{
				Global.layer3.remove(teleportalGroup, true);
				_reference.remove(teleportalGroup, true);
				teleportalGroup = null;
				
				Global.layer3.remove(teleportalEffectsGroup, true);
				_reference.remove(teleportalEffectsGroup, true);
				teleportalEffectsGroup = null;
			}
			if (mirrorsGroup.length == 0)
			{
				Global.layer1.remove(mirrorsGroup,true);
				_reference.remove(mirrorsGroup,true);
				mirrorsGroup = null;
			}
			
		}
		
		public static function clear():void
		{
			if (!_reference) return;
			
			var group:FlxGroup;
			for each(group in _reference.members)
			{
				group.destroy();
				group = null;
			}
			
			if (Global.player)
			{
				Global.player.destroy();
				Global.player = null;
			}
			if (Global.pause)
			{
				Global.pause.destroy();
				Global.pause = null;
			}
			if (Global.levelComplete)
			{
				Global.levelComplete.destroy();
				Global.levelComplete = null;
			}
			if (Global.levelFailed)
			{
				Global.levelFailed.destroy();
				Global.levelFailed = null;
			}
			
			_reference.length = 0;
		}
		
		public static function getByID(id:int):Entity
		{
			var group:FlxGroup;
			var basic:FlxBasic;
			
			for each( group in _reference.members)
			{
				for each( basic in group.members)
				{
					if (basic is FlxGroup)
					{
						continue;
					}
					
					if (basic is Entity)
					{
						if (basic.ID == id)
						{
							return basic as Entity;
						}
					}
				}
			}
			
			return null;
		}
		
		static public function initializeLevels():void
		{
			Global.levels = new Vector.<Class>();
			
			for each (var id:* in Global.levelsReferences)
			{
				var LevelMap:Class = Global.assetsHolder[id];
				
				// ALERT: Avoiding nameless or default naming of levels
				CONFIG::debug
				{
					var bytes:ByteArray = new LevelMap();
					var levelName:String = String(XML(bytes.readUTFBytes(bytes.length)).@name);
					
					if (!levelName || levelName == "" || levelName == "Unnamed")
					{
						trace("Level \"" + id.replace(/^..\/assets\/maps\/(.*)\.oel$/g, "$1") + "\" is nameless. You should name it \"" + getRandomName() + "\".");
					}
				}
				
				Global.levels.push(LevelMap);
			}
			
			Global.currentLevel = 0;
			
			Global.bestTimes = new Vector.<Number>(Global.levels.length);
			Global.levelsCompleted = new Vector.<int>(Global.levels.length);
		}
		
		static private function getRandomName():String
		{
			var first:Array =
			[
				"Ji", "Toby", "Santo", "Benton",
				"Floyd", "Bryon", "Shiela",
				"Laraine", "Idella", "Alverta",
			];
			
			var last:Array =
			[
				"North", "South", "East", "West", "Black", "White",
				"Red", "Green", "Blue", "Brown", "Purple", "Night",
				"Sky", "Sea", "Land", "Claws", "Jaws", "Pawns",
				"Buggy", "Sharp", "Hot", "Cold", "Light", "Dark",
				"Rot", "Rotten", "Messy", "Long", "Short", "Tooth",
				"Teeth", "Thumb", "Finger", "Ring", "Corn",
			];
			
			var result:String = ""
				+ first[int(Math.random() * first.length)] + " "
				+ last[int(Math.random() * last.length)]
				+ last[int(Math.random() * last.length)].toLowerCase()
			;
			
			return result;
		}
		
		static public function loadLevels():void
		{
			AssetLoader.load(function(map:Object):void
			{
				for ( var path:String in map)
				{
					Global.assetsHolder[path] = map[path];
				}
				
				var jsonString:String = String(new (Global.assetsHolder[path])()).replace(/(\/\/[^\r\n]*|\/\*[^*]*\*\/)/g, ""); // Wiping comments
				
				Global.levelsIDs = JSON.parse(jsonString) as Array;
				Global.levelsReferences = new Vector.<*>();
				
				var used:Array = [];
				
				for each (var id:String in Global.levelsIDs)
				{
					if (id != "")
					{
						var idInUse:Boolean;
						
						for (var i:int = 0; i < used.length; ++i)
						{
							if (id == used[i])
							{
								trace("Level \"" + id + "\" found multiple times in levels.json");
								idInUse = true;
								break;
							}
						}
						
						if (!idInUse)
						{
							used.push(id);
						}
						
						CONFIG::debug
						{
							Global.levelsReferences.push("../assets/maps/" + id + ".oel");
						}
						
						CONFIG::release
						{
							Global.levelsReferences.push(Assets["MAP_" + id.toUpperCase().replace(/[^0-9A-Z]+/g, "_")]);
						}
					}
				}
				
				initializeLevelsID();
				
			},Assets.LEVELS);
		}
		
		static private function initializeLevelsID():void
		{
			AssetLoader.load(function(map:Object):void
			{
				for (var s:String in map)
				{
					Global.assetsHolder[s] = map[s];
				}
				
				initializeLevels();
				
			}, Global.levelsReferences);
		}
		
		static public function reloadCurrent():void
		{
			var path:String = Global.levelsReferences[Global.currentLevel];
			
			AssetLoader.load( function(map:Object):void
			{
				Global.levels[Global.currentLevel] = Global.assetsHolder[path] = map[path];
				
			}, path);
		}
	}
}
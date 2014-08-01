package sourbit.games.onetry.states
{
	import com.greensock.TweenLite;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import sourbit.games.onetry.map.LevelLoader;
	import sourbit.games.onetry.player.behaviors.custom.CoilJump;
	import sourbit.games.onetry.player.behaviors.custom.FreeMovement;
	import sourbit.games.onetry.player.behaviors.custom.Grabbed;
	import sourbit.games.onetry.player.behaviors.custom.OnPlatform;
	import sourbit.games.onetry.player.behaviors.custom.TreadmillWalk;
	import sourbit.games.onetry.player.Player;
	import sourbit.games.onetry.props.Coil;
	import sourbit.games.onetry.props.door.DoorHit;
	import sourbit.games.onetry.props.DropPlatform;
	import sourbit.games.onetry.props.Key;
	import sourbit.games.onetry.props.LiftPlatform;
	import sourbit.games.onetry.props.mirror.Mirror;
	import sourbit.games.onetry.props.MovingPlatform;
	import sourbit.games.onetry.props.Spawn;
	import sourbit.games.onetry.props.switches.Switch;
	import sourbit.games.onetry.props.teleportal.Teleportal;
	import sourbit.games.onetry.props.treadmill.Treadmill;
	import sourbit.games.onetry.props.treadmill.TreadmillPiece;
	import sourbit.games.onetry.props.WallHook;
	import sourbit.games.onetry.scenes.LevelComplete;
	import sourbit.games.onetry.scenes.Pause;
	import sourbit.games.onetry.sonds.SoundSequence;
	
	public class Play extends FlxState
	{
		private var _level:Class;
		private var _intro:Boolean;
		
		private var _oldMousePos:FlxPoint;
		private var _curMousePos:FlxPoint;
		private var _mouseOn:int;
		
		private var _failTime:int;
		public var saturation:Number;
		
		private var _started:Boolean;
		private var _waiting:int;
		
		public function Play(... args:Array)
		{
			Global.currentLevel = args[0][0];
			_level = Global.levels[Global.currentLevel];
			
			_started = false;
			_intro = args[0][1];
			
			if (!Global.musicSequence || Global.musicSequence.sequenceName != "gameplay")
			{
				Global.musicSequence = new SoundSequence("gameplay");
				
				Global.musicSequence.add(gameplay1_intro, false);
				Global.musicSequence.add(gameplay1_loop, false);
				Global.musicSequence.add(gameply1_loop2, true);
				
				Global.musicSequence.start();
			}
		}
		
		override public function create():void
		{
			FlxG.bgColor = 0xFFCCCCCC;
			LevelLoader.load(_level);
			
			_failTime = Global.times[0];
			
			saturation = 1;
			_waiting = -1;
			FlxG.timeScale = 1;
			
			_oldMousePos = FlxG.mouse.getScreenPosition();
			_curMousePos = FlxG.mouse.getScreenPosition();
			
			if (_intro)
			{
				(LevelLoader.spawnGroup.members[0] as Spawn).intro();
			}
			else
			{
				(LevelLoader.spawnGroup.members[0] as Spawn).endIntro();
			}
		}
		
		public function start():void
		{
			if (!_started)
			{
				_started = true;
				
				Global.hud.clock.start();
				
				if (LevelLoader.timerGroup)
				{
					LevelLoader.timerGroup.callAll("start");
				}
				if (LevelLoader.platformGroup)
				{
					LevelLoader.platformGroup.callAll("start");
				}
			}
		}
		
		override public function update():void
		{
			if (LevelLoader.teleportalGroup != null)
			{
				for each( var teleportal:Teleportal in LevelLoader.teleportalGroup.members)
				{
					if (teleportal.playerCamera)
					{
						teleportal.playerCamera.fill(0x0000000, false);
					}
				}
			}
			
			if (FlxG.keys.justPressed("M"))
			{
				Global.hud.toggle();
			}
			
			CONFIG::debug
			{
				if (FlxG.keys.justPressed("G"))
				{
					Global.god = !Global.god;
				}
				
				if (FlxG.keys.justPressed("B"))
				{
					FlxG.visualDebug = !FlxG.visualDebug;
				}
				
				if (FlxG.keys.justPressed("K"))
				{
					Global.complete = true;
					Global.completeCheated = true;
				}
			}
			
			
			if (FlxG.keys.justPressed("R") && (!Global.levelComplete && !Global.lost) && !FlxG.paused)
			{
				Global.report.record("levelRestartByR", Global.levelsIDs[Global.currentLevel]).save();
				
				FlxG.switchState(new Play([Global.currentLevel, false]));
			}
			
			if (FlxG.keys.justPressed("X") && LevelLoader.spawnGroup.members[0].animating)
			{
				if (LevelLoader.spawnGroup.members[0].animating)
				{
					FlxG.switchState(new Play([Global.currentLevel, false]));
					return;
				}
			}
			
			if ((FlxG.keys.justPressed("ESCAPE") || FlxG.keys.justPressed("P")) && (!Global.levelComplete && !Global.lost))
			{
				if (LevelLoader.spawnGroup.members[0].animating)
				{
					FlxG.switchState(new Play([Global.currentLevel, false]));
					return;
				}
				
				FlxG.paused = !FlxG.paused;
				
				if (FlxG.paused)
				{
					if (!Global.pause)
					{
						Global.pause = new Pause();
						Global.layer5.add(Global.pause);
					}
					
					Global.pause.start();
				}
				else
				{
					Global.pause.resume();
				}
			}
			
			if (FlxG.paused)
			{
				Global.pause.update();
				
				return;
			}
			else if (Global.complete)
			{
				if (!Global.levelComplete)
				{
					Global.levelComplete = new LevelComplete();
				}
				
				Global.layer5.add(Global.levelComplete);
				Global.levelComplete.update();
				
				return;
			}
			else if (Global.lost)
			{
				if (!Global.levelFailed)
				{
					Global.levelFailed = new LevelFailed(Global.failedType);
				}
				
				Global.layer5.add(Global.levelFailed);
				Global.levelFailed.update();
				
				return;
				
			}
			else if (_waiting > 0)
			{
				--_waiting;
				return;
			}
			else if (_waiting == 0)
			{
				_waiting = -1;
				endLevel(true);
			}
			
			_oldMousePos.x = _curMousePos.x;
			_oldMousePos.y = _curMousePos.y;
			_curMousePos = FlxG.mouse.getScreenPosition();
			
			if (!FlxG.mouse.visible)
			{
				if (_curMousePos.x != _oldMousePos.x || _curMousePos.y != _oldMousePos.y)
				{
					FlxG.mouse.show();
					_mouseOn = 0;
				}
			}
			else
			{
				if (_curMousePos.x == _oldMousePos.x && _curMousePos.y == _oldMousePos.y)
				{
					++_mouseOn;
					
					if (_mouseOn > 90)
					{
						if (!Global.hud.hovering())
						{
							FlxG.mouse.hide();
						}
						else
						{
							_mouseOn = 0;
						}
					}
				}
			}
			
			if (Global.hud.clock.couting)
			{
				var difference:Number = _failTime - Global.hud.clock.time;
				
				if (difference < 2 && saturation == 1)
				{
					TweenLite.to(this, difference, {saturation: 0});
				}
				
				if (difference < .5)
				{
					FlxG.timeScale = .975 * (difference / .5) + .025;
					
					if (FlxG.timeScale <= .025)
					{
						Global.hud.clock.setTime(_failTime);
						Global.hud.clock.pause();
						
						FlxG.timeScale = 1;
						
						Global.failedType = LevelFailed.FAILED_BY_TIME;
						endLevel(true);
					}
				}
			}
			
			super.update();
			
			if (Global.player)
			{
				if (Global.player.velocity.y >= 515 && _waiting == -1)
				{
					endByDeath(LevelFailed.FAILED_BY_FALL);
				}
				
				FlxG.collide(Global.player, Global.groundMap);
				
				if (LevelLoader.coilGroup)
				{
					FlxG.overlap(Global.player, LevelLoader.coilGroup, coilPlayerOverlap);
				}
				
				if (LevelLoader.treadmillGroup)
				{
					var i:int = -1;
					while (++i < LevelLoader.treadmillGroup.length)
					{
						FlxG.collide(Global.player, LevelLoader.treadmillGroup.members[i].pieces, treadmillPlayerCollide);
					}
					
					FlxG.overlap(Global.player, LevelLoader.treadmillGroup, treadmillPlayerOverlap);
				}
				
				if (LevelLoader.trapDoorGroup)
				{
					FlxG.collide(Global.player, LevelLoader.trapDoorGroup);
				}
				
				if (LevelLoader.switchGroup)
				{
					FlxG.overlap(Global.player, LevelLoader.switchGroup, switchPlayerOverlap);
				}
				
				if (LevelLoader.dropPlatformGroup)
				{
					FlxG.collide(Global.player, LevelLoader.dropPlatformGroup, dropPlatformPlayerCollide);
				}
				
				if (LevelLoader.liftPlatformGroup)
				{
					FlxG.collide(Global.player, LevelLoader.liftPlatformGroup, liftPlatformPlayerCollide);
				}
				
				if (LevelLoader.retractableGroup)
				{
					FlxG.collide(Global.player, LevelLoader.retractableGroup);
				}
				
				if (LevelLoader.wallHookGroup)
				{
					FlxG.overlap(Global.player, LevelLoader.wallHookGroup, wallHookPlayerOverlap);
				}
				
				if (LevelLoader.platformGroup)
				{
					FlxG.collide(Global.player, LevelLoader.platformGroup, platformPlayerCollide);
					FlxG.overlap(Global.player, LevelLoader.platformGroup, platformPlayerOverlap);
				}
				
				if (LevelLoader.teleportalGroup)
				{
					FlxG.overlap(Global.player, LevelLoader.teleportalGroup, teleportalOverlap);
				}
				
				if (LevelLoader.mirrorsGroup)
				{
					FlxG.overlap(Global.player, LevelLoader.mirrorsGroup, onPlayerMirrorOverlap);
				}
				
				FlxG.overlap(Global.player, LevelLoader.doorGroup.members[0].door, doorPlayerOverlap);
				FlxG.overlap(Global.player, LevelLoader.keyGroup, keyPlayerOverlap);
			}
		}
		
		public function endByDeath(type:String):void
		{
			if (!Global.god)
			{
				if (type == LevelFailed.FAILED_BY_CRUSH)
				{
					Global.player.visible = false;
				}
				
				Global.failedType = type;
				
				_waiting = 120;
				FlxG.flash(0xAAFFFFFF, 0.75, function():void
				{
					saturation = 0;
				});
			}
		}
		
		public function stopEffects():void
		{
			saturation = 1;
			FlxG.timeScale = 1;
		}
		
		public function endLevel(failed:Boolean = true):void
		{
			if (failed)
			{
				FlxG.flash(0xDDFFFFFF, 0.1);
				Global.lost = true;
			}
			else
			{
				Global.complete = true;
			}
			
			saturation = 1;
			TweenLite.set(FlxG.camera.getContainerSprite(), {colorMatrixFilter: {}});
		}
		
		override public function draw():void
		{
			super.draw();
			
			if (saturation != 1)
			{
				TweenLite.set(FlxG.camera.getContainerSprite(), {colorMatrixFilter: {saturation: saturation}});
			}
		}
		
		private function onPlayerMirrorOverlap(player:Player, mirror:Mirror):void
		{
			mirror.onOverlap();
		}
		
		private function liftPlatformPlayerCollide(player:Player, liftPlatform:LiftPlatform):void
		{
			if (player.y + player.height == liftPlatform.y)
			{
				liftPlatform.hitted = true;
				(player.behaviors.getBehaviorByName("FreeMovement") as FreeMovement).onDroppable = true;
			}
		}
		
		private function platformPlayerCollide(player:Player, platform:MovingPlatform):void
		{
			if (player.y < platform.y)
			{
				(player.behaviors.getBehaviorByName("OnPlatform") as OnPlatform).platform = platform;
				(player.behaviors.getBehaviorByName("OnPlatform") as OnPlatform).grabbed = false;
				player.behaviors.switchBehavior("OnPlatform");
			}
		}
		
		private function platformPlayerOverlap(player:Player, platform:MovingPlatform):void
		{
			if (player.y > platform.y + 12 && player.grabbed)
			{
				(player.behaviors.getBehaviorByName("OnPlatform") as OnPlatform).platform = platform;
				(player.behaviors.getBehaviorByName("OnPlatform") as OnPlatform).grabbed = true;
				player.behaviors.switchBehavior("OnPlatform");
			}
		}
		
		private function keyPlayerOverlap(player:Player, key:Key):void
		{
			LevelLoader.doorGroup.members[0].readyToEnter();
			
			Global.hasKey = true;
			key.kill();
		}
		
		private function doorPlayerOverlap(player:Player, doorHit:DoorHit):void
		{
			if (Global.hasKey)
			{
				doorHit.door.hit();
			}
		}
		
		private function dropPlatformPlayerCollide(player:Player, dropPlatform:DropPlatform):void
		{
			dropPlatform.hitted = true;
			(player.behaviors.getBehaviorByName("FreeMovement") as FreeMovement).onDroppable = true;
		}
		
		private function switchPlayerOverlap(player:Player, switchButton:Switch):void
		{
			switchButton.onOverlap();
			switchButton.user = player;
		}
		
		private function treadmillPlayerCollide(player:Player, piece:TreadmillPiece):void
		{
			if (!piece.treadmill.working
				|| player.y > piece.treadmill.y
				|| player.behaviors.currentBehavior.name == "TreadmillWalk" && (player.behaviors.getBehaviorByName("TreadmillWalk") as TreadmillWalk).grabbed
				|| piece.treadmill.isTouching(FlxObject.WALL))
			{
				return;
			}
			
			(player.behaviors.getBehaviorByName("TreadmillWalk") as TreadmillWalk).treadmill = piece.treadmill;
			(player.behaviors.getBehaviorByName("TreadmillWalk") as TreadmillWalk).grabbed = false;
			player.behaviors.switchBehavior("TreadmillWalk");
		}
		
		private function treadmillPlayerOverlap(player:Player, treadmill:Treadmill):void
		{
			if (player.y > treadmill.y + 12 && player.grabbed)
			{
				(player.behaviors.getBehaviorByName("TreadmillWalk") as TreadmillWalk).treadmill = treadmill;
				(player.behaviors.getBehaviorByName("TreadmillWalk") as TreadmillWalk).grabbed = true;
				player.behaviors.switchBehavior("TreadmillWalk");
			}
		}
		
		private function coilPlayerOverlap(player:Player, coil:Coil):void
		{
			if (player.velocity.y >= 0 && int(player.y) + player.height >= coil.y && int(player.y) + player.height <= coil.y + coil.height + 3  || player.isTouching(FlxObject.FLOOR))
			{
				(player.behaviors.getBehaviorByName("CoilJump") as CoilJump).coil = coil;
				player.behaviors.switchBehavior("CoilJump");
				coil.play("impulse");
			}
		}
		
		private function wallHookPlayerOverlap(player:Player, wallHook:WallHook):void
		{
			if (player.y > wallHook.y && player.grabbed)
			{
				(player.behaviors.getBehaviorByName("Grabbed") as Grabbed).grabbedTo = wallHook;
				(player.behaviors.getBehaviorByName("Grabbed") as Grabbed).grabbedAnchor.y = wallHook.y + wallHook.height - 2;
				(player.behaviors.getBehaviorByName("Grabbed") as Grabbed).grabbedAnchor.x = wallHook.x - 1;
				player.behaviors.switchBehavior("Grabbed");
			}
		}
		
		private function teleportalOverlap(player:Player, teleportal:Teleportal):void
		{
			teleportal.warp(player);
		}
	}
}
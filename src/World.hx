package;

import haxepunk.Scene;
import haxepunk.HXP;
import haxepunk.math.Random;
import haxepunk.debug.Console;
import haxepunk.tmx.TmxEntity;
import haxepunk.tmx.TmxMap;
import haxepunk.tmx.TmxObject;
import haxepunk.tmx.TmxObjectGroup;
import haxepunk.input.Key;
import haxepunk.graphics.text.Text;
import entities.Player;

class World extends Scene
{
  public static var ME : World;
  public var players :Array<Player> = [];

  public function new() {
    ME = this;
    super(); 
  }

	override public function begin()
	{
    HXP.screen.scaleMode.integer = true;
    HXP.screen.scaleMode.setBaseSize(640, 640);
    loadMap();
	}

  function loadMap() {
    var ids : Array<Int> = [for(i in 0...3) i];
    var mapName = 'map/Map${Random.randInt(7)}.tmx';
    var map : TmxMap = TmxMap.loadFromFile(mapName); 
    var mapEntity : TmxEntity = new TmxEntity(map);
    
    mapEntity.loadGraphic("graphics/tileset.png", ["Background", "Block"]);
    mapEntity.loadMask("Block", "block");
    add(mapEntity);
    
    if(map.getObjectGroup("Spawn") == null) throw 'Map \'$mapName\' should not have an empty spawn';
    for(spawn in map.getObjectGroup("Spawn").objects) {
      if(ids.length <= 0) break;
      var id = ids[Random.randInt(ids.length)];
      ids.remove(id);
      players.push(add(new Player(spawn.x, spawn.y, id)));
    }
  }


  var gameOver : Bool = false;

  override public function update() : Void {
    super.update();
    if(Key.pressed(Key.TILDE)) {
      Console.enabled = !Console.enabled;
    }

    if(Key.check(Key.R)) {
      HXP.scene = new World();
      return;
    } 


    if(players.length > 1 || gameOver) return;
    gameOver = true;
    haxe.Timer.delay(() -> { HXP.scene = new World(); }, 3000); // new game in 3 seconds
    
    if(players.length > 0) {
      var text = new Text('PLAYER ${players[0].id + 1} WINS!!', 0, 220);
      text.size = 80;
      text.color = 0;
      addGraphic(text);
    }
  }
}

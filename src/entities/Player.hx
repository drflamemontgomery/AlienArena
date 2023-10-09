package entities;

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Spritemap;
import haxepunk.graphics.Image;
import haxepunk.input.Key;

typedef Controls = {
  var left : Int;
  var right : Int;
  var jump : Int;
  var shoot : Int;
};

class Player extends Entity {
 
  public var id : Int;
  var sprite : Spritemap;
  var reload : Int;
  var onground : Bool;

  var dx : Float;
  var dy : Float;

  var jumps : Int = 1;
  var hurt : Int;

  var health : Float;
  var dir : Int;
  var cooldown : Int;

  static var keys :Array<Controls> = [
    {left : Key.LEFT, right : Key.RIGHT, jump : Key.UP, shoot : Key.DOWN},
    {left : Key.A, right : Key.D, jump : Key.W, shoot : Key.Q},
    {left : Key.G, right : Key.J, jump : Key.Y, shoot : Key.H}
  ];

  var controls(get, never) : Controls;
  inline function get_controls() {
    return keys[id];
  }

  public function new(x : Float, y : Float, id : Int) {
    if(id > 2 || id < 0) throw "Error: id is not within the range of 0 - 2";
    super(x, y);
    this.id = id;

    reload = 8;
    dir = -1;
    health = 11;
    type = "player";
    width = 30;
    height = 30;

    sprite = new Spritemap('graphics/Aframe${id}.png', 34, 46);

    sprite.add("idle", [0, 1, 1, 0, 2, 2], 2);
    sprite.add("move", [3, 0, 4], 6);
    sprite.add("hurt", [0, 1], 8);
    graphic = sprite;
    sprite.play("idle");
    dx = 0;
    dy = 0;
    onground = false;
    originX = Std.int(width / 2);
    originY = Std.int(height / 2);
    sprite.centerOrigin();

    var tag : Image = new Image('graphics/P${id}.png');
    tag.centerOrigin();
    tag.y = -46;
    addGraphic(tag);
  }

  override public function update() : Void {
    movement();
    moveBy(dx, dy, "block", true);
    if(collide("block", x, y + 2) != null) {
      onground = true;
      jumps = 1;
    } else onground = false;

    if(reload < 8) ++reload;

    if(health <= 0) {
      World.ME.players.remove(this);
      HXP.scene.remove(this);
    }

    if(hurt < 60) {
      sprite.play("hurt");
      ++hurt;
    } else if(dx == 0) {
      sprite.play("idle");
    } else {
      sprite.play("move");
    }

    var bullets : Array<Bullet> = [];
    collideInto("bullet", x, y, bullets);
    if(bullets.length > 0) {
      for(bullet in bullets) {
        if(bullet.id == id) continue;
        bullet.destroy();
        health -= 3;
      }
    }
  }  

  public function movement() : Void {
    dx = 0;
    if(!onground) dy += 0.08;

    if(Key.check(controls.left)) {
      dx = -2;
      sprite.flipped = false;
      dir = -1;
    }
    if(Key.check(controls.right)) {
      dx = 2;
      sprite.flipped = true;
      dir = 1;
    }
    if(Key.pressed(controls.jump) && jumps > 0) {
      dy = -4;
      if(!onground) jumps--;
    }
    if(Key.pressed(controls.shoot) && reload == 8) {
      HXP.scene.add(new Bullet(x + (dir == 0 ? -10 : 10), y + 3, id, dir));
      reload = 0;
    }
  }
}

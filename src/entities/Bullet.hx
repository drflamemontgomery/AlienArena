package entities;

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.graphics.Spritemap;
import haxepunk.input.Key;

class Bullet extends Entity {
  
    public var id : Int;
    var sprite : Spritemap;
    var onground : Bool;
    var dx : Float;
    var dy : Float;
    var life : Int;

    public function new(x : Float, y : Float, id : Int, dir : Int) {
      super(x, y);
      this.id = id;

      sprite = new Spritemap('graphics/bullet${id}.png', 15, 15);
      sprite.add("fly", [0]);
      graphic = sprite;
      sprite.play("fly");
      type = "bullet";
      width = 10;
      height = 10;
      
      dx = 5 * dir; // dir is either -1 or 1
      dy = -5;
      centerOrigin();
      sprite.centerOrigin();
    }


    override public function update() : Void {
      if(life < 1200) ++life;
      else destroy();
      
      if(dx != 0) dx += dx > 0 ? -0.01 : 0.01;
      dy += 0.2;
      if(collide("bullet", x, y) != null) destroy();
      moveBy(dx, dy, "block", true);
      super.update();
    }

    override public function moveCollideY(e : Entity) : Bool {
      dy *= -1;
      if(dy != 0) dy += dy < 0 ? 1 : -1;
      return true;
    }

    override public function moveCollideX(e : Entity) : Bool {
      dx *= -1;
      return true;
    }

    public function destroy() : Void {
      _scene.remove(this);
    }


}

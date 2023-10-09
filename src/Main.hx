package;

import haxepunk.Engine;
import haxepunk.HXP;
import haxepunk.math.Random;

class Main extends Engine
{
	static function main()
	{
		new Main();
	}

	override public function init()
	{
    Random.randomizeSeed();
		HXP.scene = new World();
	}
}

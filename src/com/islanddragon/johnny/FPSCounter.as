/**
 * http://kaioa.com/node/83
 */

package com.islanddragon.johnny 
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.getTimer;

    public class FPSCounter extends Sprite{
        private var last:uint = getTimer();
        private var ticks:uint = 0;
        private var tf:TextField;
		private var f:TextFormat;

        public function FPSCounter(xPos:int=0, yPos:int=0, color:uint=0xffffff, fillBackground:Boolean=true, backgroundColor:uint=0x000000) {
            x = xPos;
            y = yPos;
            tf = new TextField();
            tf.text = "----- fps";
            tf.selectable = false;
            tf.background = fillBackground;
            tf.backgroundColor = backgroundColor;
            tf.autoSize = TextFieldAutoSize.LEFT;
			f = new TextFormat();
			f.color = color;
			f.font = 'Arial';
			f.size = 14;
			tf.setTextFormat(f);
			addChild(tf);
            width = tf.textWidth;
            height = tf.textHeight;
            addEventListener(Event.ENTER_FRAME, tick);
        }

        public function tick(evt:Event):void {
            ticks++;
            var now:uint = getTimer();
            var delta:uint = now - last;
            if (delta >= 1000) {
                //trace(ticks / delta * 1000+" ticks:"+ticks+" delta:"+delta);
                var fps:Number = ticks / delta * 1000;
                tf.text = fps.toFixed(1) + " fps";
				tf.setTextFormat(f);
                ticks = 0;
                last = now;
            }
        }
    }
}

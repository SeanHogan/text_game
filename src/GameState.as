package  
{
	import flash.net.URLRequest;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	
	public class GameState extends FlxState 
	{
		
		public var bg:FlxSprite;
		public var intro_screen:FlxSprite;
		
		public var outro_screen:FlxSprite;
		
		public var text_box:FlxBitmapFont;
		
		public var state:int;
		public const s_intro:int = 0;
		public const s_outro:int = -1;
		public const s_game:int = 1;
		
		public var cur_question:int = 0;
		public const max_questions:int = 2;
		public const answers:Array = new Array("APPLE", "BANANA");
		
		[Embed(source = "font-black-apple-7x8.png")] public var font:Class;
		
		public const letters:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
		override public function create():void 
		{
			bg = new FlxSprite(0, 0);
			bg.makeGraphic(FlxG.width, FlxG.height, 0xffffffff);
			add(bg);
			
			intro_screen = new FlxSprite(0, 0);
			outro_screen = new FlxSprite(0, 0);
			intro_screen.makeGraphic(100, 100, 0xffff0000);
			outro_screen.makeGraphic(100, 100, 0xff00ff00);
			
			add(intro_screen);
			add(outro_screen);
			outro_screen.visible = false;
			
			text_box = new FlxBitmapFont(font, 7, 8, "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ’1234567890.:,;\'\"(!?)+-*/=[]", 27,0,0,0,1);
			text_box.x = text_box.y = 1;
			add(text_box);
			text_box.text = "Press Enter\n";
			
			state = s_intro;
		}
		
		override public function update():void 
		{
			// Show Intro screen
			
			if (state == s_intro) {
				if (FlxG.keys.SPACE) {
					state = s_game;
					text_box.text = "Start typing";
					intro_screen.visible = false;
				}
				super.update();
				return;
			} else if (state == s_outro) {
				super.update();
				return;
			}
			
			for (var i:int = 0; i < letters.length; i++) {
				if (FlxG.keys.justPressed(letters.charAt(i))) {
					if (text_box.text == " ") {
						text_box.text = letters.charAt(i);
					} else {
						text_box.text += letters.charAt(i);
					}
					break;
				}
			}
			
			if (FlxG.keys.justPressed("ENTER")) {
				if (text_box.text == answers[cur_question]) {
					if (++cur_question >= max_questions) {
						state = s_outro;
						// right sfx
						text_box.text = " good one";
						text_box.visible = false;
						outro_screen.visible = true;
					}
				} else {
					//wrong sfx
				}
			}
			
			if (FlxG.keys.justPressed("BACKSPACE")) {
				if (text_box.text.length > 1) {
					text_box.text = text_box.text.slice(0, text_box.text.length - 1);
				} else {
					text_box.text = " ";
				}
			}
			
			// bg, question, text box pop up
			// enter in text. hit enter. wrong or not.
			
			// show outro screen
			
			super.update();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			intro_screen = null;
			outro_screen = null;
		}
	}

}
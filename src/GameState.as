package  
{
	import flash.net.URLRequest;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxU;
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
		public const max_questions:int = 6;
		public const answers:Array = new Array("PARENT", "ABSTINENCE", "ANTIBIOTICS", "BABY", "SILENT", "TWO");
		public var is_init:Boolean = true;
		
		// Embed sounds...
		
		public const hints:Array = new Array();
		public var hint_button:FlxSprite = new FlxSprite(100, 100);
		
		[Embed(source = "font-white-apple-7x8.png")] public var font:Class;
		
		[Embed(source = "dr_bg.png")] public static const embed_dr_bg:Class;
		[Embed(source = "text1.png")] public static const embed_text_intro:Class;
		[Embed(source = "text2.png")] public static const embed_text_1:Class; 
		[Embed(source = "text3.png")] public static const embed_text_2:Class;
		[Embed(source = "text4.png")] public static const embed_text_3:Class;
		[Embed(source = "text5.png")] public static const embed_text_4:Class;
		[Embed(source = "text6.png")] public static const embed_text_5:Class;
		[Embed(source = "text7.png")] public static const embed_text_6:Class;
		[Embed(source = "text8.png")] public static const embed_text_end:Class;
		
		
		public const letters:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		
		override public function create():void 
		{
			bg = new FlxSprite(0, 0);
			bg.loadGraphic(embed_dr_bg, false, false, 800, 522);
			add(bg);
			
			intro_screen = new FlxSprite(0, 0);
			outro_screen = new FlxSprite(0, 0);
			intro_screen.loadGraphic(embed_text_intro, false, false, 800, 522);
			outro_screen.loadGraphic(embed_text_end, false, false, 800, 522);
			
			
			add(intro_screen);
			add(outro_screen);
			outro_screen.visible = false;
			
			text_box = new FlxBitmapFont(font, 7, 8, "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ’1234567890.:,;\'\"(!?)+-*/=[]", 27,0,0,0,1);
			text_box.x = 100;
			text_box.y = 400;
			add(text_box);
			text_box.scale.x = text_box.scale.y = 2;
			text_box.text = "Press Space\n";
			
			// Make list of audio hints
			for (var i:int = 0; i < max_questions; i++) {
				var s:FlxSound = new FlxSound();
				//s.loadEmbedded(...);
				hints.push(s);
			}
			hint_button.makeGraphic(100, 100, 0xff123123);
			add(hint_button);
			hint_button.visible = false;
		
			FlxG.mouse.load();
			
			state = s_intro;
		}
		
		
		
		override public function update():void 
		{
			// Show Intro screen
			
			if (state == s_intro) {
				if (FlxG.keys.SPACE) {
					state = s_game;
					text_box.text = "Start typing";
					//intro_screen.visible = false;
					intro_screen.loadGraphic(embed_text_1, false, false, 800, 522);
					//hint_button.visible = true;
				}
				super.update();
				return;
			} else if (state == s_outro) {
				text_box.visible = true;
				text_box.text = "Press Space to Continue";
				if (FlxG.keys.justPressed("SPACE")) {
					FlxU.openURL("http://luciditygame.com/drcomic.html");
				}
				super.update();
				return;
			}
			
			if (FlxG.mouse.justPressed()) {
				var x:int = FlxG.mouse.screenX;
				var y:int = FlxG.mouse.screenY;
				
				if (x > hint_button.x && x < hint_button.x + hint_button.width) {
					if (y > hint_button.y && y < hint_button.y + hint_button.height) {
						//play audio hint
					}
				}
			}
			
			if (text_box.text.length < 15) {
				for (var i:int = 0; i < letters.length; i++) {
					if (FlxG.keys.justPressed(letters.charAt(i))) {
						if (is_init) {
							text_box.text = " ";
							is_init = false;
						} 
						if (text_box.text == " ") {
							text_box.text = letters.charAt(i);
						} else {
							text_box.text += letters.charAt(i);
						}
						break;
					}
				}
			}
			
			if (FlxG.keys.justPressed("ENTER")) {
				if (is_init) {
					is_init = false;
					text_box.text = " ";
					return;
				}
				if (text_box.text == answers[cur_question]) {
					if (++cur_question >= max_questions) {
						state = s_outro;
						// right sfx
						text_box.text = "Correct!";
						is_init = true;
						text_box.visible = false;
						intro_screen.visible = false;
						outro_screen.visible = true;
					} else {
						text_box.text = "Correct!";
						is_init = true;
						switch (cur_question) {
							case 1:
								intro_screen.loadGraphic(embed_text_2, false, false, 800, 522);
								break;
							case 2:
								intro_screen.loadGraphic(embed_text_3, false, false, 800, 522);
								break;
							case 3:
								intro_screen.loadGraphic(embed_text_4, false, false, 800, 522);
								break;
							case 4:
								intro_screen.loadGraphic(embed_text_5, false, false, 800, 522);
								break;
							case 5:
								intro_screen.loadGraphic(embed_text_6, false, false, 800, 522);
								break;
						}
					}
				} else {
					text_box.text = "Try again.";
					is_init = true;
					//wrong sfx
				}
			}
			
			if (FlxG.keys.justPressed("BACKSPACE")) {
				if (is_init) {
					is_init = false;
					text_box.text = " ";
				}
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
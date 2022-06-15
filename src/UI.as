package
{
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class UI extends MovieClip
	{
		
		[Embed(source="assets/fonts/Commodore Pixelized v1.2.ttf", fontName="COMMODORE", fontWeight="Regular", embedAsCFF="false")]
		private var COMMODORE_FONT:Class;
		
		private var _textFormat:TextFormat = new TextFormat("COMMODORE",18,0x000000,null,null,null,null,null,"left",null,null);
		private var _highlightTextFormat:TextFormat = new TextFormat("COMMODORE",18,0xFF0000,null,null,null,null,null,"left",true,null);
		private var _textString:String = "" +
			"// Enter physics variables by typing new values\n" +
			"// in the highlighted area. Press TAB to move\n" +
			"// between variables. Press ENTER when you are\n" +
			"// ready to recompile and play." +
			"\n\n\n" +
			"const GRAVITY:Number = \n" +
			"const SCALE:Number = \n" +
			"const MASS:Number = \n" +
			"const GROUND_SPEED:Number = \n" +
			"const AIR_SPEED:Number = \n" +
			"const SWIM_SPEED:Number = \n" +
			"const JUMP_SPEED:Number = \n" +
			"\n\n" +
			"// ARROW KEYS to move and SPACEBAR to jump.\n" +
			"// R to restart and M to return to the main menu.\n" +
			"\n\n" +
			"// To complete the level, exit it to the right.";
		private var _textField:TextField;
		
		private var _gravityTextField:TextField;
		private var _scaleTextField:TextField;
		private var _massTextField:TextField;
		private var _groundSpeedTextField:TextField;
		private var _airSpeedTextField:TextField;
		private var _swimSpeedTextField:TextField;
		private var _jumpSpeedTextField:TextField;
		
		private var _currentInputTextField:TextField;
		
		private var _bg:Sprite;
		
		public function UI()
		{
			super();
			
			_bg = new Sprite();
			_bg.graphics.beginFill(0xFFFFFF,0.9);
			_bg.graphics.drawRect(0,0,FlxG.width,FlxG.height);
			_bg.graphics.endFill();
			this.addChild(_bg);
			
			_textField = makeTextField(20,20,FlxG.width,FlxG.height,_textString,_textFormat);
			this.addChild(_textField);	
			
			_gravityTextField = makeInputTextField(340,126,FlxG.width,FlxG.height, Globals.GRAVITY.toString(),_highlightTextFormat);
			_gravityTextField.addEventListener(TextEvent.TEXT_INPUT, inputEventCapture);
			this.addChild(_gravityTextField);
			
			_scaleTextField = makeInputTextField(315,144,FlxG.width,FlxG.height,Globals.SCALE.toString(),_highlightTextFormat);
			_scaleTextField.addEventListener(TextEvent.TEXT_INPUT, inputEventCapture);
			this.addChild(_scaleTextField);
			
			_massTextField = makeInputTextField(300,162,FlxG.width,FlxG.height,Globals.MASS.toString(),_highlightTextFormat);
			_massTextField.addEventListener(TextEvent.TEXT_INPUT, inputEventCapture);
			this.addChild(_massTextField);
			
			_groundSpeedTextField = makeInputTextField(410,180,FlxG.width,FlxG.height,Globals.GROUND_SPEED.toString(),_highlightTextFormat);
			_groundSpeedTextField.addEventListener(TextEvent.TEXT_INPUT, inputEventCapture);
			this.addChild(_groundSpeedTextField);
			
			_airSpeedTextField = makeInputTextField(370,198,FlxG.width,FlxG.height,Globals.AIR_SPEED.toString(),_highlightTextFormat);
			_airSpeedTextField.addEventListener(TextEvent.TEXT_INPUT, inputEventCapture);
			this.addChild(_airSpeedTextField);
			
			_swimSpeedTextField = makeInputTextField(380,216,FlxG.width,FlxG.height,Globals.SWIM_SPEED.toString(),_highlightTextFormat);
			_swimSpeedTextField.addEventListener(TextEvent.TEXT_INPUT, inputEventCapture);
			this.addChild(_swimSpeedTextField);
			
			_jumpSpeedTextField = makeInputTextField(380,232,FlxG.width,FlxG.height,Globals.JUMP_SPEED.toString(),_highlightTextFormat);
			_jumpSpeedTextField.addEventListener(TextEvent.TEXT_INPUT, inputEventCapture);
			this.addChild(_jumpSpeedTextField);
			
		}
		
		
		public function activate():void
		{
			_gravityTextField.setSelection(0,_gravityTextField.length);
			FlxG.stage.focus = _gravityTextField;
			_currentInputTextField = _gravityTextField;
			FlxG.stage.addChild(this);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			FlxG.paused = true;
		}
		
		public function deactivate():void
		{
			FlxG.stage.focus = null;
			if (FlxG.stage.contains(this))
			{
				FlxG.stage.removeChild(this);
			}
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			//FlxG.paused = false;
			var playState:PlayState = FlxG.state as PlayState;
			playState.startLevel();
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{

			if (e.keyCode == Keyboard.TAB)
			{
				setAllVariables();
			}
			else if (e.keyCode == Keyboard.ENTER)
			{
				Assets._levelSelectSound.play();
				setAllVariables();
				deactivate();
			}
//			else if (e.keyCode == Keyboard.SPACE)
//			{
//				this.visible = false;
//			}
			else if (e.keyCode == Keyboard.D)
			{
				resetVariables();
			}
		}
		
		
		private function onKeyUp(e:KeyboardEvent):void
		{
//			if (e.keyCode == Keyboard.SPACE)
//			{
//				this.visible = true;
//				_currentInputTextField.setSelection(0,_currentInputTextField.length);//_jumpSpeedTextField.text.length);
//				FlxG.stage.focus = _currentInputTextField;
//			}	
		}
		
		
		private function setAllVariables():void
		{
			Globals.GRAVITY = parseField(_gravityTextField,Globals.GRAVITY);
			Globals.SCALE = parseField(_scaleTextField,Globals.SCALE);
			Globals.MASS = parseField(_massTextField,Globals.MASS);
			Globals.GROUND_SPEED = parseField(_groundSpeedTextField,Globals.GROUND_SPEED);
			Globals.AIR_SPEED = parseField(_airSpeedTextField,Globals.AIR_SPEED);
			Globals.SWIM_SPEED = parseField(_swimSpeedTextField,Globals.SWIM_SPEED);
			Globals.JUMP_SPEED = parseField(_jumpSpeedTextField,Globals.JUMP_SPEED);
			
			Globals.SCALED_AREA = (Globals.SCALE * Globals.WIDTH) * (Globals.SCALE * Globals.HEIGHT);
			Globals.DENSITY = Globals.MASS / Globals.SCALED_AREA;

		}
		
		
		private function parseField(field:TextField,defaultValue:Number):Number
		{
			var makeFloat:RegExp = /(^\-?\d*\.?\d+)$/g;

			if (field.text.search(makeFloat) != -1)
			{
				field.text = field.text.replace(makeFloat,"$1");
				return Number(field.text);
			}
			else
			{
				field.text = defaultValue.toString();
			}
			return defaultValue;
		}
		
		
		private function resetVariables():void
		{
			Globals.GRAVITY = Globals.DEFAULT_GRAVITY;
			Globals.SCALE = Globals.DEFAULT_SCALE;
			Globals.MASS = Globals.DEFAULT_MASS;
			Globals.GROUND_SPEED = Globals.DEFAULT_GROUND_SPEED;
			Globals.AIR_SPEED = Globals.DEFAULT_AIR_SPEED;
			Globals.SWIM_SPEED = Globals.DEFAULT_SWIM_SPEED;
			Globals.JUMP_SPEED = Globals.DEFAULT_JUMP_SPEED;
			
			Globals.SCALED_AREA = (Globals.SCALE * Globals.WIDTH) * (Globals.SCALE * Globals.HEIGHT);
			Globals.DENSITY = Globals.MASS / Globals.SCALED_AREA;
			
			_gravityTextField.text = Globals.GRAVITY.toString();
			_scaleTextField.text = Globals.SCALE.toString();
			_massTextField.text = Globals.MASS.toString();
			_groundSpeedTextField.text = Globals.GROUND_SPEED.toString();
			_airSpeedTextField.text = Globals.AIR_SPEED.toString();
			_swimSpeedTextField.text = Globals.SWIM_SPEED.toString();
			_jumpSpeedTextField.text = Globals.JUMP_SPEED.toString();
			
			_currentInputTextField = _gravityTextField;			
		}
		
		
		private function inputEventCapture(e:TextEvent):void
		{
			_currentInputTextField = e.target as TextField;
		}
		
		
		public static function makeTextField(x:uint, y:uint, w:uint, h:uint, s:String, tf:TextFormat):TextField {
			
			var textField:TextField = new TextField();
			textField.x = x * Globals.ZOOM;
			textField.y = y * Globals.ZOOM;
			textField.width = w * Globals.ZOOM;
			textField.height = h * Globals.ZOOM;
			textField.defaultTextFormat = tf;
			textField.text = s;
			textField.wordWrap = true;
			textField.embedFonts = true;
			textField.selectable = false;
			
			return textField;
		}
		
		
		private function makeInputTextField(x:uint, y:uint, w:uint, h:uint, s:String, tf:TextFormat):TextField {
			
			var textField:TextField = new TextField();
			textField.x = x * Globals.ZOOM;
			textField.y = y * Globals.ZOOM;
			textField.width = w * Globals.ZOOM;
			textField.height = h * Globals.ZOOM;
			textField.defaultTextFormat = tf;
			textField.text = s;
			textField.wordWrap = true;
			textField.embedFonts = true;
			textField.restrict = "0-9.\\-";
			textField.type = TextFieldType.INPUT;

			textField.selectable = false;
			
			return textField;
		}
		
		
		public function destroy():void
		{
			this.removeChild(_textField);				
			this.removeChild(_gravityTextField);
			this.removeChild(_scaleTextField);
			this.removeChild(_massTextField);
			this.removeChild(_groundSpeedTextField);
			this.removeChild(_airSpeedTextField);
			this.removeChild(_swimSpeedTextField);
			this.removeChild(_jumpSpeedTextField);
			this.removeChild(_bg);			
		}
				
	}
}
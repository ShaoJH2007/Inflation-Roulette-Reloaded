package backend;

import flixel.system.FlxAssets.FlxShader;
import shaders.ShaderObject;
import flixel.addons.display.FlxRuntimeShader;

class ShaderUtil {
	public static final fragmentHeader:String = '#pragma header\nuniform float iTime;\nuniform float iTimeDelta;\nuniform float iFrameRate;\nuniform vec4 iMouse;\n\n';
	public static var replaceMap:Array<Array<String>> = [
		['void mainImage(', 'void main('],
		['( out vec4 fragColor, in vec2 fragCoord )', '()'],
		['fragCoord', '(openfl_TextureCoordv * openfl_TextureSize)'],
		['iResolution', 'openfl_TextureSize'],
		['fragColor', 'gl_FragColor'],
		['texture(', 'texture2D('],
		['iChannel0', 'bitmap']
	];
	
	public static function initShader(path:String):FlxRuntimeShader {
		var fragmentStr = Paths.getTextFromFile('shaders/$path.frag').trim();
		try {
			if (fragmentStr == null || fragmentStr.length <= 0)
				throw 'Shader file non-existent or contents empty.';
			if (fragmentStr.startsWith('#pragma header'))
				fragmentStr = fragmentStr.replace('#pragma header', fragmentHeader);
			else
				fragmentStr = fragmentHeader + fragmentStr;
			for (string in replaceMap) {
				fragmentStr = fragmentStr.replace(string[0], string[1]);
			}
		} catch(e:Dynamic) {
			trace('Shader $path cannot be parsed: ' + e);
			return null;
		}
		var shader:FlxRuntimeShader = new FlxRuntimeShader(fragmentStr);
		trace('Loaded shader: $path\n' + shader.glFragmentSource);
		// FlxG.state.add(shader);
		return shader;
	}
}

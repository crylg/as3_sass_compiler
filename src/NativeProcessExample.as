package
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	import spark.components.Label;
	
	public class NativeProcessExample extends Sprite
	{
		public var process:NativeProcess;
		private var _label:Label;
		public function NativeProcessExample()
		{
			if(NativeProcess.isSupported)
			{
//				setupAndLaunch();
			}
			else
			{
				trace("NativeProcess not supported.");
			}
		}
		
		public function setupAndLaunch(sassFileUrl:String,cssFileUrl:String,label:Label):void
		{     
			_label=label;
			label.text="开始转换";
			var cmdFile:File=new File();
			cmdFile = cmdFile.resolvePath("C://WINDOWS//system32//cmd.exe");
			
			
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = cmdFile;
			
			var processArgs:Vector.<String> = new Vector.<String>();
			processArgs[0]="/c sass "+sassFileUrl+" "+cssFileUrl;
//			processArgs[1]="";
//			processArgs[2]="c:/s.css";
			nativeProcessStartupInfo.arguments = processArgs;
			
			process = new NativeProcess();
			
			process.start(nativeProcessStartupInfo);
//			process.standardOutput.readMultiByte(process.standardOutput.bytesAvailable,"iso-8859-01");
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
			process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			
			
		}
		public function onOutputData(event:ProgressEvent):void
		{
			
			trace("Got: ", process.standardOutput.readMultiByte(process.standardOutput.bytesAvailable,"iso-8859-01")); 
		}
		
		public function onErrorData(event:ProgressEvent):void
		{

			trace("ERROR -", process.standardError.readMultiByte(process.standardError.bytesAvailable,"iso-8859-01"));
		}
		
		public function onExit(event:NativeProcessExitEvent):void
		{
			trace("Process exited with ", event.exitCode);
			_label.text="完成";
			
		}
		
		public function onIOError(event:IOErrorEvent):void
		{
			trace(event.toString());
		}
	}
}
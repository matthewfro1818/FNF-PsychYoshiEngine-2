package;

import Sys.sleep;
#if DISCORD_ALLOWED
import discord_rpc.DiscordRpc;
#end

using StringTools;

/**
* Discord Client
*/
class DiscordClient
{
	public static var clientID:String = null;
	public static var init:Bool = false;
	public static var currentButton1Label:String = null;
	public static var currentButton1Url:String = null;
	public static var currentButton2Label:String = null;
	public static var currentButton2Url:String = null;
	/**
	* Creates a new Discord Client.
	*/
	public function new()
	{
		_create("915896776869953588");
	}

	public static function switchRPC(clientID:String) {
		if (DiscordClient.clientID != (DiscordClient.clientID = clientID)) {
            trace("doing change to " + clientID);
			DiscordRpc.shutdown();
			DiscordRpc.start({
				clientID: DiscordClient.clientID,
				onReady: onReady,
				onError: onError,
				onDisconnected: onDisconnected
			});
		}
	}
	public function _create(clientID:String) {
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: clientID,
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
		}

		DiscordRpc.shutdown();
	}

	/**
	* Shuts the Discord Client down
	*/
	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}

	static function onReady()
	{
		init = true;
		DiscordRpc.presence({
			details: "In the Menus",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "Friday Night Funkin' - YoshiCrafter Engine",
			button1Label: currentButton1Label,
			button1Url: currentButton1Url,
			button2Label: currentButton2Label,
			button2Url: currentButton2Url
		});
	}

	static function onError(_code:Int, _message:String)
	{
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord Client initialized");
	}

	/**
	* Change the presence, see the Discord Documentation [Here](https://discord.com/developers/docs/rich-presence/how-to) to get a complete knowledge of what it is
	*/
	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: "Friday Night Funkin' - YoshiCrafter Engine",
			smallImageKey : smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000),
			button1Label: currentButton1Label,
			button1Url: currentButton1Url,
			button2Label: currentButton2Label,
			button2Url: currentButton2Url
		});

		//trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
	}
}

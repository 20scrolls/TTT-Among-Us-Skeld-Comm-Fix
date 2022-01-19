#include <sourcemod>
#include <cstrike>
#include <autoexecconfig>
#include <sdkhooks>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "0.00"

public Plugin myinfo = 
{
	name = "[AMONG US TTT] Comms Fix",
	author = "20 scrolls",
	description = "A plugin for the map ttt_among_us_skeld which fixes comms",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/20scrolls/"
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	// No need for the old GetGameFolderName setup.
	EngineVersion g_engineversion = GetEngineVersion();
	if (g_engineversion != Engine_CSGO)
	{
		SetFailState("This plugin was made for use with Counter-Strike: Global Offensive only.");
	}
} 

public void OnPluginStart()
{
	HookEvent("round_start", Event_RoundStart);
}

public void OnMapStart()
{
	 
	 
}

public void Event_RoundStart(Event event, const char[] name_e, bool dontBroadcast)
{
	char sBuffer[64];
	 GetCurrentMap(sBuffer, sizeof(sBuffer));
	 // If the current map is TTT Among Us Skeld
	 if(StrContains(sBuffer, "ttt_among_us_skeld", false) != -1)
	 {
	 	//Traitor_door15
	 	//OnOpen is fired
	 	//Comms is rebooted after 5 seconds (comms_reboot_button, onpressed)
		int ent = -1;

		while((ent = FindEntityByClassname(ent, "logic_relay")) != -1)
		{
			char name[64];
			GetEntPropString(ent, Prop_Data, "m_iName", name, sizeof(name));
			//PrintToChatAll("Found door");
			//PrintToChatAll("%s", name);
			if(StrEqual(name, "mute_relay", false))
			{
				HookSingleEntityOutput(ent, "OnTrigger", OutputHook);
			}
			else if(StrEqual(name, "unmute_relay", false))
			{
				HookSingleEntityOutput(ent, "OnTrigger", RelayHook);
			}
		}
	 }
}
public void OutputHook(const char[] name, int caller, int activator, float delay)
{
	//wdPrintToChatAll("Everyone should be silenced");
	ServerCommand("sm_silence @all");
}

public void RelayHook(const char[] name, int caller, int activator, float delay)
{
	ServerCommand("sm_unsilence @all");
}

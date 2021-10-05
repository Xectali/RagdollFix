#include <sourcemod>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Ragdoll Fix",
	author = "PŠΣ™ SHUFEN",
	description = "",
	version = "0.1",
	url = "https://possession.jp"
};

Address addr = Address_Null;

public void OnPluginStart()
{
	GameData hGameConf = new GameData("RagdollFix.games");
	if (hGameConf == null) {
		SetFailState("No RagdollFix.games gamedata found.");
	}

	addr = hGameConf.GetAddress("CCSPlayer::CreateRagdollEntity");
	if (addr == Address_Null) {
		SetFailState("Can't find CCSPlayer::CreateRagdollEntity address.");
	}

	int offs = hGameConf.GetOffset("PatchOffset");
	if (offs == -1) {
		SetFailState("Can't find PatchOffset in gamedata.");
	}

	addr += view_as<Address>(offs);

	int data = LoadFromAddress(addr, NumberType_Int8);
	if (data != 0x74) {
		SetFailState("The plugin is out of date. Need to update.");
	}

	StoreToAddress(addr, 0xEB, NumberType_Int8);
	PrintToServer("\x1B[31m[RagdollFix] \x1B[91mThe patch has been successfully applied.\x1B[0m");
}

public void OnPluginEnd()
{
	StoreToAddress(addr, 0x74, NumberType_Int8);
	PrintToServer("\x1B[31m[RagdollFix] \x1B[91mSuccessfully restored memory bytes.\x1B[0m");
}

#include <a_samp>
#include <mysql>
#include <streamer>
#include <sscanf>
#include <zcmd>
#include <md5>

enum {
	DIALOG_LANGUAGE,
	DIALOG_LOGIN,
	DIALOG_REGISTER,
}


#include OpenDM\colors.inc
#include OpenDM\var.inc
#include OpenDM\cmds.inc

#define GM_NAME	"OpenDM"
#define GM_VERSION	"v0.1"
#define GM_AUTHOR "critical"

// MySQL Database
#define HOST "127.0.0.1"
#define USER "root"
#define PASSWORD "opendm"
#define DB "opendm"

main() {

}

public OnGameModeInit()
{
	mysql_init(LOG_ONLY_ERRORS, 0);
	new connection = mysql_connect(HOST, USER, PASSWORD, DB, MySQL:0, 1);
	if(!connection) {
		printf("["GM_NAME" "GM_VERSION"] Error: No MySQL connection. Exiting...");
	 	SendRconCommand("exit"); }

	SendRconCommand("hostname ..:: "GM_NAME" - Open Source SA:MP Server ::..");
	SendRconCommand("language EN/PL");
	SendRconCommand("OpenDM "GM_VERSION"");
	SendRconCommand("mapname "GM_VERSION"");
	SetGameModeText("OpenDM "GM_VERSION"");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	printf("["GM_NAME" "GM_VERSION"] Loading completed.");
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

forward SetPlayerVars(playerid);
public SetPlayerVars(playerid) {
	Player[playerid][IsPL] = false;
	Player[playerid][logged] = false;
}

forward ShowLogin(playerid);
public ShowLogin(playerid) return ShowDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, ""C_GREEN"Log in", ""C_GREEN"Logowanie", ""C_WHITE"Wpisz has³o do swojego konta, aby rozpocz¹æ grê.", ""C_WHITE"Enter your password to continue.", "Log in", "Zaloguj", "Exit", "WyjdŸ");

forward ShowRegister(playerid);
public ShowRegister(playerid) { return ShowDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""C_GREEN"Register", ""C_GREEN"Rejestracja", ""C_WHITE"Enter password to your account.", ""C_WHITE"Zarejestruj konto wpisuj¹c has³o.", "Register", "Zarejestruj", "Exit", "WyjdŸ"); }

forward ShowDialog(playerid, dialogid, style, captionen[], captionpl[], infoen[], infopl[], button1en[], button1pl[], button2en[], button2pl[]);
public ShowDialog(playerid, dialogid, style, captionen[], captionpl[], infoen[], infopl[], button1en[], button1pl[], button2en[], button2pl[]) {
	if(Player[playerid][IsPL]) return ShowPlayerDialog(playerid, dialogid, style, captionpl, infopl, button1pl, button2pl);
	else return ShowPlayerDialog(playerid, dialogid, style, captionen, infoen, button1en, button2en);
}

public OnPlayerConnect(playerid)
{
	SetPlayerVars(playerid);
	GetPlayerName(playerid, Player[playerid][Name], 20);
	new checkstr[1024], checkaccount[1024];
	format(checkstr, sizeof(checkstr), "SELECT * FROM players WHERE name = %s", Player[playerid][Name]);
	mysql_query(checkstr);
	if(mysql_num_rows() > 0) {
		Player[playerid][accountfound] = true;
		mysql_free_result();
	 	ShowLogin(playerid); }
	else Player[playerid][accountfound] = false;
	if(!Player[playerid][accountfound]) {
		ShowPlayerDialog(playerid, DIALOG_LANGUAGE, DIALOG_STYLE_LIST, ""C_WHITE"Select language", ""C_WHITE"English (EN)\nPolski (PL)", "Select", "Skip");
	}
	MultiMessage(playerid, "["C_GREEN""GM_NAME" "GM_VERSION""C_WHITE"] Gamemode compiled by "C_GREEN""GM_AUTHOR""C_WHITE".", "["C_GREEN""GM_NAME" "GM_VERSION""C_WHITE"] Gamemode skompilowany przez "C_GREEN""GM_AUTHOR""C_WHITE".");
	if(Player[playerid][accountfound]) {
		new inforegister[144];
		if(Player[playerid][IsPL]) format(inforegister, sizeof(inforegister), ""C_GREEN"To konto znajduje siê w bazie danych. Zaloguj siê, aby rozpocz¹æ grê.");
		else format(inforegister, sizeof(inforegister), ""C_GREEN"Your account are found in database. Log in to play.");
		return MultiMessage(playerid, inforegister, inforegister);
	}
	return 1;
}

forward ShowError(playerid, en[], pl[]);
public ShowError(playerid, en[], pl[]) {
	if(Player[playerid][IsPL]) SendClientMessage(playerid, RED, pl);
	else SendClientMessage(playerid, RED, en);
	return 1;
}

forward MultiMessage(playerid, en[], pl[]);
public MultiMessage(playerid, en[], pl[]) {
	if(Player[playerid][IsPL]) SendClientMessage(playerid, -1, pl);
	else SendClientMessage(playerid, -1, en);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid) {
		case DIALOG_LANGUAGE: {
			switch(listitem) {
				case 0: {
					if(!Player[playerid][IsPL] && Player[playerid][logged]) return ShowError(playerid, "You already selected this language.", "Aktualnie masz wybrany ten jêzyk.");
					SendClientMessage(playerid, -1, ""C_GREEN"Selected "C_WHITE"English (EN) "C_GREEN"language.");
					if(Player[playerid][IsPL]) Player[playerid][IsPL] = false;
					if(!Player[playerid][logged]) ShowRegister(playerid);
					if(!Player[playerid][accountfound]) {
						new inforegister[144];
						if(Player[playerid][IsPL]) format(inforegister, sizeof(inforegister), ""C_GREEN"Nie znaleŸliœmy konta z Twoim nickiem. Zarejestruj siê, aby rozpocz¹æ grê.");
						else format(inforegister, sizeof(inforegister), ""C_GREEN"Your account are not found in database. Register to play.");
						MultiMessage(playerid, inforegister, inforegister);
					} }
				case 1: {
					if(Player[playerid][IsPL]) return ShowError(playerid, "You already selected this language.", "Aktualnie masz wybrany ten jêzyk.");
					SendClientMessage(playerid, -1, ""C_GREEN"Wybra³eœ jêzyk "C_WHITE"Polski (PL)"C_GREEN".");
					if(!Player[playerid][IsPL]) Player[playerid][IsPL] = true;
					if(!Player[playerid][logged]) ShowRegister(playerid);
					if(!Player[playerid][accountfound]) {
						new inforegister[144];
						if(Player[playerid][IsPL]) format(inforegister, sizeof(inforegister), ""C_GREEN"Nie znaleŸliœmy konta z Twoim nickiem. Zarejestruj siê, aby rozpocz¹æ grê.");
						else format(inforegister, sizeof(inforegister), ""C_GREEN"Your account are not found in database. Register to play.");
						MultiMessage(playerid, inforegister, inforegister);
					} } } } }
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

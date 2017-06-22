#include <a_samp>
#include <mysql>
#include <streamer>
#include <sscanf>
#include <zcmd>
#include <md5>
#include <y_va>

#define L(%0,%1) for(new %0, __li%0 = %1; %0 != __li%0; %0++)

#define GM_NAME	"OpenDM"
#define GM_VERSION	"v0.1"
#define GM_AUTHOR "critical"
#define WEBSITE "cr.ct8.pl"

enum {
	DIALOG_LANGUAGE,
	DIALOG_LOGIN,
	DIALOG_REGISTER,
}

#include OpenDM\colors.inc
#include OpenDM\var.inc
#include OpenDM\cmds.inc
#include OpenDM\td.inc

#undef MAX_PLAYERS
#define MAX_PLAYERS 50 // slots on server, change this

// MySQL Database
#define HOST "127.0.0.1"
#define USER "opendm"
#define PASSWORD "opendm"
#define DB "opendm"

main() {

}

m_query(string[], {Float, _}:...)
{
	if(numargs() > 1)
	{
		new out[1024];
		va_format(out, sizeof out, string, va_start<1>);
		return mysql_query(out);
	}
	return mysql_query(string);
}

forward Second();
public Second() {
	L(playerid, MAX_PLAYERS) {
		new score[64];
		format(score, sizeof(score), "%d~n~~p~SCORE", Player[playerid][Score]);
		PlayerTextDrawSetString(playerid, TextdrawP[1][playerid], score);
	}
	new year, month, day, hour, minute, second;
	getdate(year, month, day);
	gettime(hour, minute, second);
	if(minute != lastminute) {
		new date[128];
		format(date, sizeof(date), "~w~~h~%02d~g~~h~:~w~~h~%02d %02d~g~~h~.~w~~h~%02d~g~~h~.~w~~h~%d", hour, minute, day, month, year);
		TextDrawSetString(Textdraw[1], date); }
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

	players = 0;
	premiums = 0;
	admins = 0;

	LoadGlobalTDs();

	SetTimer("Second", 1000, 1);

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
	firstspawn[playerid] = true;
}

forward ShowLogin(playerid);
public ShowLogin(playerid) {
	new temp = 0, sql[1024];
	m_query("SELECT lang FROM players WHERE userid = %d", Player[playerid][ID]);
	mysql_store_result();
	mysql_fetch_row(sql, " ");
	mysql_free_result();
	sscanf(sql, "i", temp);
	new inforegister[144];
	if(temp == 0) {
		Player[playerid][IsPL] = false;
	 	format(inforegister, sizeof(inforegister), ""C_GREEN"Your account are found in database. Log in to play."); }
	else {
		format(inforegister, sizeof(inforegister), ""C_GREEN"To konto znajduje siê w bazie danych. Zaloguj siê, aby rozpocz¹æ grê.");
		Player[playerid][IsPL] = true; }
	if(!informed[playerid]) {
		MultiMessage(playerid, inforegister, inforegister);
		informed[playerid] = true; }
	return ShowDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, ""C_GREEN"Log in", ""C_GREEN"Logowanie", ""C_WHITE"Enter your password to continue.", ""C_WHITE"Wpisz has³o do swojego konta, aby rozpocz¹æ grê.", "Log in", "Zaloguj", "Exit", "WyjdŸ"); }

forward ShowRegister(playerid);
public ShowRegister(playerid) { return ShowDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""C_GREEN"Register", ""C_GREEN"Rejestracja", ""C_WHITE"Enter password to your account.", ""C_WHITE"Zarejestruj konto wpisuj¹c has³o.", "Register", "Zarejestruj", "Exit", "WyjdŸ"); }

forward ShowDialog(playerid, dialogid, style, captionen[], captionpl[], infoen[], infopl[], button1en[], button1pl[], button2en[], button2pl[]);
public ShowDialog(playerid, dialogid, style, captionen[], captionpl[], infoen[], infopl[], button1en[], button1pl[], button2en[], button2pl[]) {
	if(Player[playerid][IsPL]) return ShowPlayerDialog(playerid, dialogid, style, captionpl, infopl, button1pl, button2pl);
	else return ShowPlayerDialog(playerid, dialogid, style, captionen, infoen, button1en, button2en);
}

public OnPlayerConnect(playerid)
{
	players++;
	new ptd[128];
	format(ptd, sizeof(ptd), "%d~n~~g~~h~PLAYERS", players);
	TextDrawSetString(Textdraw[5], ptd);
	SetPlayerVars(playerid);
	CreatePlayerTDs(playerid);

	new name[20], ip[16];
	GetPlayerName(playerid, name, sizeof(name));
	GetPlayerIp(playerid, ip, sizeof(ip));

	format(Player[playerid][Name], 20, "%s", name);
	format(Player[playerid][IP], 16, "%s", ip);

	new nametd[64];
	format(nametd, sizeof(nametd), "%s (%d)", Player[playerid][Name], playerid);
	PlayerTextDrawSetString(playerid, TextdrawP[0][playerid], nametd);

	new checkaccount[1024];
	m_query("SELECT userid FROM players WHERE name = '%s'", name);
	mysql_store_result();
	new konta = mysql_num_rows();
	if(konta > 0) {
		Player[playerid][accountfound] = true;
		mysql_free_result();
		m_query("SELECT userid, score, cash, pass FROM players WHERE name = '%s'", name);
		mysql_store_result();
		mysql_fetch_row(checkaccount, " ");
		mysql_free_result();
		sscanf(checkaccount, "iiis[128]", Player[playerid][ID], Player[playerid][Score], Player[playerid][Cash], Player[playerid][Pass]);
	 	ShowLogin(playerid); }
	else {
		mysql_free_result();
		Player[playerid][accountfound] = false; }
	if(!Player[playerid][accountfound]) ShowPlayerDialog(playerid, DIALOG_LANGUAGE, DIALOG_STYLE_LIST, ""C_WHITE"Select language", ""C_WHITE"English (EN)\nPolski (PL)", "Select", "Skip");
	MultiMessage(playerid, "["C_GREEN""GM_NAME" "GM_VERSION""C_WHITE"] Gamemode compiled by "C_GREEN""GM_AUTHOR""C_WHITE".", "["C_GREEN""GM_NAME" "GM_VERSION""C_WHITE"] Gamemode skompilowany przez "C_GREEN""GM_AUTHOR""C_WHITE".");
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

stock SetPlayerMoney(playerid, cash) {
  ResetPlayerMoney(playerid);
  return GivePlayerMoney(playerid, cash); }

	stock CompareEx(comp[], with[]) //By: Fl0rian
	{
		new LenghtComp = strlen(comp);
		new LenghtWith = strlen(with);
		new Character;

		if( LenghtComp != LenghtWith ) return false;

		for( new i = 0; i < LenghtComp; i++ )
		{
		    if( comp[i] == with[i] )
		    {
		        Character++;
			}
		}

		if( LenghtComp == Character ) return true;
		return false;
	}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid) {
		case DIALOG_LANGUAGE:
		{
			switch(listitem)
			{
				case 0:
				{
					if(!Player[playerid][IsPL] && Player[playerid][logged]) return ShowError(playerid, "You already selected this language.", "Aktualnie masz wybrany ten jêzyk.");
					SendClientMessage(playerid, -1, ""C_GREEN"Selected "C_WHITE"English (EN) "C_GREEN"language.");
					if(Player[playerid][IsPL]) Player[playerid][IsPL] = false;
					if(!Player[playerid][logged]) ShowRegister(playerid);
					if(!Player[playerid][accountfound]) {
						new inforegister[144];
						if(Player[playerid][IsPL]) format(inforegister, sizeof(inforegister), ""C_GREEN"Nie znaleŸliœmy konta z Twoim nickiem. Zarejestruj siê, aby rozpocz¹æ grê.");
						else format(inforegister, sizeof(inforegister), ""C_GREEN"Your account are not found in database. Register to play.");
						MultiMessage(playerid, inforegister, inforegister); }
				}
				case 1:
				{
					if(Player[playerid][IsPL]) return ShowError(playerid, "You already selected this language.", "Aktualnie masz wybrany ten jêzyk.");
					SendClientMessage(playerid, -1, ""C_GREEN"Wybra³eœ jêzyk "C_WHITE"Polski (PL)"C_GREEN".");
					if(!Player[playerid][IsPL]) Player[playerid][IsPL] = true;
					if(!Player[playerid][logged]) ShowRegister(playerid);
					if(!Player[playerid][accountfound]) {
						new inforegister[144];
						if(Player[playerid][IsPL]) format(inforegister, sizeof(inforegister), ""C_GREEN"Nie znaleŸliœmy konta z Twoim nickiem. Zarejestruj siê, aby rozpocz¹æ grê.");
						else format(inforegister, sizeof(inforegister), ""C_GREEN"Your account are not found in database. Register to play.");
						MultiMessage(playerid, inforegister, inforegister); }
				}
			}
		}
		case DIALOG_LOGIN:
		{
			if (!response) {
				Kick(playerid);
				return 1; }


			if (CompareEx(MD5_Hash(inputtext), Player[playerid][Pass])) {
				Player[playerid][logged] = true;

				SetPlayerMoney(playerid, Player[playerid][Cash]);
				SetPlayerScore(playerid, Player[playerid][Score]);

				return MultiMessage(playerid, ""C_GREEN"Succesfully logged!", ""C_GREEN"Zosta³eœ zalogowany pomyœlnie."); }
			else {
				ShowError(playerid, "Entered invalid password.", "Wprowadzone has³o jest nieprawid³owe.");
				return ShowLogin(playerid); }

			}
		case DIALOG_REGISTER:
		{
			if (!response) {
				Kick(playerid);
				return 1; }

			if (strlen(inputtext) <= 6 || strlen(inputtext) >= 32) {
				ShowError(playerid, "Password is too short or too long.", "Podane has³o jest za krótkie lub za d³ugie.");
				return ShowDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, ""C_GREEN"Register", ""C_GREEN"Rejestracja", ""C_WHITE"Enter password to your account.", ""C_WHITE"Zarejestruj konto wpisuj¹c has³o.", "Register", "Zarejestruj", "Exit", "WyjdŸ"); }
			mysql_real_escape_string(inputtext, inputtext);
			m_query("SELECT userid FROM players");
			mysql_store_result();
			new users = mysql_num_rows();
			mysql_free_result();
			format(Player[playerid][Pass], 65, "%s", MD5_Hash(inputtext));
			Player[playerid][ID] = users;
			Player[playerid][logged] = true;
			m_query("INSERT INTO players (userid, name, ip, lang, pass) VALUES (%d, '%s', '%s', %d, '%s')", users, Player[playerid][Name], Player[playerid][IP], Player[playerid][IsPL], Player[playerid][Pass]);
			return MultiMessage(playerid, ""C_GREEN"Succesfully registered!", ""C_GREEN"Zosta³eœ zarejestrowany pomyœlnie.");
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	players--;
	new ptd[128], prtd[128], atd[128];
	format(ptd, sizeof(ptd), "%d~n~~g~~h~PLAYERS", players);
	format(prtd, sizeof(prtd), "%d~n~~y~~h~PREMIUM", premiums);
	format(atd, sizeof(atd), "%d~n~~r~~h~ADMINS", admins);
	TextDrawSetString(Textdraw[5], ptd);
	TextDrawSetString(Textdraw[6], prtd);
	TextDrawSetString(Textdraw[7], atd);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(firstspawn[playerid]) {
		L(textdrawid, 9) TextDrawShowForPlayer(playerid, Textdraw[textdrawid]);
		L(textdrawid, 3) PlayerTextDrawShow(playerid, TextdrawP[textdrawid][playerid]);
		firstspawn[playerid] = false;
	}
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

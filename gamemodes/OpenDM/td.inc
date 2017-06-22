new Text:Textdraw[9];

forward LoadGlobalTDs();
public LoadGlobalTDs() {
  Textdraw[0] = TextDrawCreate(544.333435, 14.518526, "~g~~h~~h~Open~w~~h~DM");
  TextDrawLetterSize(Textdraw[0], 0.398333, 2.384000);
  TextDrawAlignment(Textdraw[0], 1);
  TextDrawColor(Textdraw[0], -1);
  TextDrawSetShadow(Textdraw[0], 0);
  TextDrawSetOutline(Textdraw[0], 1);
  TextDrawBackgroundColor(Textdraw[0], 51);
  TextDrawFont(Textdraw[0], 2);
  TextDrawSetProportional(Textdraw[0], 1);

  Textdraw[1] = TextDrawCreate(579.666442, 7.466663, "~w~~h~08~g~~h~:~w~~h~00 22~g~~h~.~w~~h~06~g~~h~.~w~~h~2017");
  TextDrawLetterSize(Textdraw[1], 0.238333, 1.251556);
  TextDrawAlignment(Textdraw[1], 2);
  TextDrawColor(Textdraw[1], -1);
  TextDrawSetShadow(Textdraw[1], 0);
  TextDrawSetOutline(Textdraw[1], 1);
  TextDrawBackgroundColor(Textdraw[1], 51);
  TextDrawFont(Textdraw[1], 1);
  TextDrawSetProportional(Textdraw[1], 1);
  new year, month, day, hour, minute, second;
  getdate(year, month, day);
  gettime(hour, minute, second);
  new date[128];
  format(date, sizeof(date), "~w~~h~%02d~g~~h~:~w~~h~%02d %02d~g~~h~.~w~~h~%02d~g~~h~.~w~~h~%d", hour, minute, day, month, year);
  TextDrawSetString(Textdraw[1], date);

  Textdraw[2] = TextDrawCreate(643.999938, 427.100036, "usebox");
  TextDrawLetterSize(Textdraw[2], 0.000000, -0.421606);
  TextDrawTextSize(Textdraw[2], -4.333334, 0.000000);
  TextDrawAlignment(Textdraw[2], 1);
  TextDrawColor(Textdraw[2], 0);
  TextDrawUseBox(Textdraw[2], true);
  TextDrawBoxColor(Textdraw[2], 16711740);
  TextDrawSetShadow(Textdraw[2], 0);
  TextDrawSetOutline(Textdraw[2], 0);
  TextDrawFont(Textdraw[2], 0);

  Textdraw[3] = TextDrawCreate(542.000244, 429.748138, "/onede [0] /rpg [0] /minigun [0]");
  TextDrawLetterSize(Textdraw[3], 0.201666, 1.122962);
  TextDrawAlignment(Textdraw[3], 2);
  TextDrawColor(Textdraw[3], -1);
  TextDrawSetShadow(Textdraw[3], 0);
  TextDrawSetOutline(Textdraw[3], 1);
  TextDrawBackgroundColor(Textdraw[3], 51);
  TextDrawFont(Textdraw[3], 2);
  TextDrawSetProportional(Textdraw[3], 1);

  Textdraw[4] = TextDrawCreate(642.333496, 428.759277, "usebox");
  TextDrawLetterSize(Textdraw[4], 0.000000, 1.757404);
  TextDrawTextSize(Textdraw[4], -3.000003, 0.000000);
  TextDrawAlignment(Textdraw[4], 1);
  TextDrawColor(Textdraw[4], 0);
  TextDrawUseBox(Textdraw[4], true);
  TextDrawBoxColor(Textdraw[4], 8388683);
  TextDrawSetShadow(Textdraw[4], 0);
  TextDrawSetOutline(Textdraw[4], 0);
  TextDrawBackgroundColor(Textdraw[4], 8388863);
  TextDrawFont(Textdraw[4], 0);

  Textdraw[5] = TextDrawCreate(244.333374, 426.014892, "3~n~~g~~h~PLAYERS");
  TextDrawLetterSize(Textdraw[5], 0.180666, 1.077333);
  TextDrawAlignment(Textdraw[5], 2);
  TextDrawColor(Textdraw[5], -1);
  TextDrawSetShadow(Textdraw[5], 0);
  TextDrawSetOutline(Textdraw[5], 1);
  TextDrawBackgroundColor(Textdraw[5], 51);
  TextDrawFont(Textdraw[5], 2);
  TextDrawSetProportional(Textdraw[5], 1);

  Textdraw[6] = TextDrawCreate(292.000030, 425.185119, "2~n~~y~~h~PREMIUM");
  TextDrawLetterSize(Textdraw[6], 0.192333, 1.189333);
  TextDrawAlignment(Textdraw[6], 2);
  TextDrawColor(Textdraw[6], -1);
  TextDrawSetShadow(Textdraw[6], 0);
  TextDrawSetOutline(Textdraw[6], 1);
  TextDrawBackgroundColor(Textdraw[6], 51);
  TextDrawFont(Textdraw[6], 2);
  TextDrawSetProportional(Textdraw[6], 1);

  Textdraw[7] = TextDrawCreate(335.333740, 426.014801, "2~n~~r~~h~ADMINS");
  TextDrawLetterSize(Textdraw[7], 0.178666, 1.081482);
  TextDrawAlignment(Textdraw[7], 2);
  TextDrawColor(Textdraw[7], -1);
  TextDrawSetShadow(Textdraw[7], 0);
  TextDrawSetOutline(Textdraw[7], 1);
  TextDrawBackgroundColor(Textdraw[7], 51);
  TextDrawFont(Textdraw[7], 2);
  TextDrawSetProportional(Textdraw[7], 1);

  Textdraw[8] = TextDrawCreate(401.333404, 430.992767, WEBSITE);
  TextDrawLetterSize(Textdraw[8], 0.248000, 1.189333);
  TextDrawAlignment(Textdraw[8], 2);
  TextDrawColor(Textdraw[8], -1);
  TextDrawSetShadow(Textdraw[8], 0);
  TextDrawSetOutline(Textdraw[8], 1);
  TextDrawBackgroundColor(Textdraw[8], 51);
  TextDrawFont(Textdraw[8], 1);
  TextDrawSetProportional(Textdraw[8], 1);
}

new PlayerText:TextdrawP[3][MAX_PLAYERS];

forward CreatePlayerTDs(playerid);
public CreatePlayerTDs(playerid) {
  TextdrawP[0][playerid] = CreatePlayerTextDraw(playerid, 4.666668, 428.918579, "critical (0)");
  PlayerTextDrawLetterSize(playerid, TextdrawP[0][playerid], 0.243333, 1.301333);
  PlayerTextDrawAlignment(playerid, TextdrawP[0][playerid], 1);
  PlayerTextDrawColor(playerid, TextdrawP[0][playerid], -1);
  PlayerTextDrawSetShadow(playerid, TextdrawP[0][playerid], 0);
  PlayerTextDrawSetOutline(playerid, TextdrawP[0][playerid], 1);
  PlayerTextDrawBackgroundColor(playerid, TextdrawP[0][playerid], 51);
  PlayerTextDrawFont(playerid, TextdrawP[0][playerid], 1);
  PlayerTextDrawSetProportional(playerid, TextdrawP[0][playerid], 1);

  TextdrawP[1][playerid] = CreatePlayerTextDraw(playerid, 120.333335, 426.429687, "0~n~~p~SCORE");
  PlayerTextDrawLetterSize(playerid, TextdrawP[1][playerid], 0.177333, 1.093925);
  PlayerTextDrawAlignment(playerid, TextdrawP[1][playerid], 2);
  PlayerTextDrawColor(playerid, TextdrawP[1][playerid], -1);
  PlayerTextDrawSetShadow(playerid, TextdrawP[1][playerid], 0);
  PlayerTextDrawSetOutline(playerid, TextdrawP[1][playerid], 1);
  PlayerTextDrawBackgroundColor(playerid, TextdrawP[1][playerid], 51);
  PlayerTextDrawFont(playerid, TextdrawP[1][playerid], 2);
  PlayerTextDrawSetProportional(playerid, TextdrawP[1][playerid], 1);

  TextdrawP[2][playerid] = CreatePlayerTextDraw(playerid, 171.999893, 425.600067, "0H 0M~n~~p~ONLINE");
  PlayerTextDrawLetterSize(playerid, TextdrawP[2][playerid], 0.176333, 1.098074);
  PlayerTextDrawAlignment(playerid, TextdrawP[2][playerid], 2);
  PlayerTextDrawColor(playerid, TextdrawP[2][playerid], -1);
  PlayerTextDrawSetShadow(playerid, TextdrawP[2][playerid], 0);
  PlayerTextDrawSetOutline(playerid, TextdrawP[2][playerid], 1);
  PlayerTextDrawBackgroundColor(playerid, TextdrawP[2][playerid], 51);
  PlayerTextDrawFont(playerid, TextdrawP[2][playerid], 2);
  PlayerTextDrawSetProportional(playerid, TextdrawP[2][playerid], 1);
}

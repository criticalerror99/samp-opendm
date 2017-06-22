enum PLAYERS {
  bool:IsPL,
  bool:accountfound,
  bool:logged,
  ID,
  IP[16],
  Score,
  Cash,
  Pass[128],
  Name[20],
}
new Player[MAX_PLAYERS][PLAYERS];

new bool:informed[MAX_PLAYERS];
new bool:firstspawn[MAX_PLAYERS];

new lastminute;
new players, premiums, admins;

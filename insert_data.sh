#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #Get winner ID
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    #If not winner ID
    if [[ -z $WINNER_ID ]]
    then
      #Insert winner
      INSERT_WINNER_STATUS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_STATUS == "INSERT 0 1" ]]
      then
        echo Inserted '$WINNER' into teams.
      fi
      #Get winner ID
      WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    fi

    #Get opponent ID
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    #If not opponent ID
    if [[ -z $OPPONENT_ID ]]
    then
      #Insert opponent
      INSERT_OPPONENT_STATUS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_STATUS == "INSERT 0 1" ]]
      then
        echo Inserted '$OPPONENT' into teams.
      fi
      #Get opponent ID
      OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    fi

    INSERT_GAME_STATUS="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
    if [[ $INSERT_GAME_STATUS == "INSERT 0 1" ]]
    then
      echo $WINNER beat $OPPONENT from $WINNER_GOALS to $OPPONENT_GOALS!
    fi
  fi
done

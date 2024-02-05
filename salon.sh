#! /bin/bash
# --- PSQL QUERY VARIABLE --- 
PSQL="psql --username=freecodecamp --dbname=salon   --tuples-only -c"
# --- GET SERVICES ---
SHOW_SERVICES=$($PSQL "SELECT service_id, name FROM services")
#  --- WELCOME MESSAGES ---
echo -e "\n • Welcome to my salon! •\n"
echo -e "What would you like to get?\n"

# --- SHOW SERVICES FUNCTION ---
# --- SHOW SERVICES FUNCTION ---
SHOW_SERVICES(){
  echo -e "Enter the number of the service you want and press Enter/Intro:" 
  echo "$SHOW_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo -e "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  # --- IF SERVICE DOESN'T EXIST ---
  if [[ -z $($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED") ]]
  then 
    echo -e "\nNot found. Please try again:\n"
    SHOW_SERVICES
  # --- IF SERVICE EXISTS ---
  else
    # --- GET SERVICE NAME ---
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

    echo -e "You selected\n $SERVICE_NAME"
  fi
  SERVICE_NAME=$SERVICE_NAME
}
# --- MAIN MENU FUNCTION ---
# --- MAIN MENU FUNCTION ---
MAIN_MENU(){
# --- CALL FUNCTION FOR SHOWING SERVICES
SHOW_SERVICES
# --- CALL FUNCTION FOR GETTING CUSTOMER INFO
  GET_CUSTOMER_INFO
  echo -e "\n$CUSTOMER_NAME, at what time would you like your appointment? Enter any hour from 08:30 to 17:00 in 30-minutes intervals using the HH:MM format"
# --- CALL FUNCTION FOR SETTING APPOINTMENT
  SET_APPOINTMENT_TIME

# --- SET FULL APPOINTMENT, 
echo $($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

# --- FINAL MESSAGE ---
echo -e "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}
# --- END OF MAIN MENU FUNCTION ---
# --- END OF MAIN MENU FUNCTION ---
# //////////////////////////////////////
# --- GET CUSTOMER INFO FUNCTION ---
# --- GET CUSTOMER INFO FUNCTION ---

GET_CUSTOMER_INFO(){
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE
  # --- LOOK FOR PHONE ON DATABASE ---
  CUSTOMER_PHONE_EXISTS=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # --- IF PHONE NUMBER NOT REGISTERED ---
  if [[ -z $CUSTOMER_PHONE_EXISTS ]]
  then
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    # --- ENTER PHONE# AND NAME ON customers TABLE ---
    echo $($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")  
  fi

  echo -e "$CUSTOMER_NAME, you selected $($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")"
}

# --- FUNCTION FOR SETTING APPOINTMENT ---
# --- FUNCTION FOR SETTING APPOINTMENT ---

SET_APPOINTMENT_TIME(){
  read SERVICE_TIME
  # --- MAKE SURE IT'S NOT TAKEN
  AVAILABLE_TIME=$($PSQL "SELECT appointment_id FROM appointments WHERE time='$SERVICE_TIME'")
  # --- IF TIME IS NOT A VALID VALUE
  
  #  /// THIS WHOLE SECTIONS DOES MORE THAN WHAT THE TESTS ASK FOR, BUT NEEDS TO BE DISABLE FOR THE TESTS TO PASS
  #  ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
  # if [[ ! $SERVICE_TIME =~ ^(08|09|1[0-7]):(00|30)$ || $SERVICE_TIME='08:00' || $SERVICE_TIME='17:30' ]]
  # then
  #   until [[ $SERVICE_TIME =~ ^(08|09|1[0-7]):(00|30)$ && $SERVICE_TIME != '08:00' && $SERVICE_TIME != '17:30' ]]
  #   do
  #   echo -e "\nPlease enter a valid time in HH:MM ending in 00 or 30"
  #   read SERVICE_TIME
  #   AVAILABLE_TIME=$($PSQL "SELECT appointment_id FROM appointments WHERE time='$SERVICE_TIME'")
  #   done
  #   # --- NOW THAT IT'S VALID, CHECK IF IT'S AVAILABLE
  #   if [[ $AVAILABLE_TIME ]]
  #   then
  #     echo -e "\nSorry, that time is taken. Please, try a different one"
  #     SET_APPOINTMENT_TIME
  #   fi  
  # SERVICE_TIME=$SERVICE_TIME
  # --- IF TIME IS VALID BUT NOT AVAILABLE
# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ 
# //// END OF THE SECTION THAT NEEDS TO BE DISABLED

# CHANGE if TO elif WHEN ENABLING PREVIOUS SECTION
# ↓↓ 
  # if [[ $AVAILABLE_TIME ]]
  # then
  #   echo -e "\nSorry, that time is taken. Please, try a different one"
  #   SET_APPOINTMENT_TIME
  # fi  
  SERVICE_TIME=$SERVICE_TIME
# --- GET CUSTOMER_ID ---
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

}

# --- EXECUTE SHOW MENU FUNCTION ---
MAIN_MENU

